local _, SM = ...
local L = SM.L

-- A chapter's journal entry. An optional quest keeps its own lines (recap),
-- which join the entry only once the player has done it, after the paragraph
-- its recapAfter names (or at the end), so the journal never tells an optional
-- quest that wasn't played.
local function GetJournalRecap(ch)
    local recap = SM.GetChapterText(ch, "recap")
    if not recap then return nil end
    local extras
    for _, q in ipairs(ch.quests or {}) do
        if q.recap and SM.IsQuestForPlayer(q) and not SM.ShouldHideQuest(q) and SM.IsQuestEntryComplete(q) then
            extras = extras or {}
            extras[#extras + 1] = q
        end
    end
    if not extras then return recap end

    local paragraphs = {}
    for paragraph in (recap .. "\n\n"):gmatch("(.-)\n\n") do
        paragraphs[#paragraphs + 1] = paragraph
    end
    local out = {}
    for p = 0, #paragraphs do
        if p > 0 then out[#out + 1] = paragraphs[p] end
        for _, q in ipairs(extras) do
            if math.min(q.recapAfter or #paragraphs, #paragraphs) == p then
                out[#out + 1] = SM.ApplyGenderTokens(q.recap)
            end
        end
    end
    return table.concat(out, "\n\n")
end

-- ── Read aloud ──────────────────────────────────────────────────────
-- The journal read in the character's own voice through the game's
-- text-to-speech: a system voice of the character's sex that speaks the
-- client's language, or the one picked from the speaker's right-click menu.
-- The speaker beside a chapter title reads from that chapter to the end of
-- the journal, a paragraph at a time; clicking it again stops.

local Voice = CreateFrame("Frame")
Voice.serial = 0

local PARAGRAPH_PAUSE = 0.35
local CHAPTER_PAUSE = 0.9
local IDLE_ALPHA = 0.55
-- The chat frame's voice button art (chatframe-button-icon-voicechat), a
-- speaker and its sound lines, without its drop shadow: Art/Icons/
-- journal_speaker, where the art fills 29 of the 32 pixels. Idle, only the
-- speaker shows (the art's left part); reading adds the lines.
local SPEAKER_TEXTURE = "Interface\\AddOns\\StoryMode\\Art\\Icons\\journal_speaker"
local SPEAKER_ART = 29 / 32
local SPEAKER_PART = 14 / 29
local SPEAKER_SIZE = 22

-- Voices whose name tells their sex: the usual Windows and macOS voices of
-- the client languages. lang is a hint for names only one language uses; a
-- full name that says its language wins. Other voices (the novelty ones
-- too) are never picked automatically, only by hand.
local KNOWN_VOICES = {}
local function KnownVoices(sex, lang, names)
    for name in names:gmatch("[^,]+") do
        KNOWN_VOICES[name] = { sex = sex, lang = lang }
    end
end
KnownVoices(2, "en", "david,mark,george,james,richard,sean,ravi,alex,tom,evan,nathan,oliver,aaron,arthur,gordon,lee,rishi")
KnownVoices(3, "en", "zira,hazel,susan,catherine,linda,heera,samantha,victoria,karen,moira,tessa,fiona,veena,ava,allison,zoe,serena,kate,joelle,noelle,matilda,nicky,isha")
KnownVoices(2, "de", "stefan,markus,yannick,viktor,martin")
KnownVoices(3, "de", "hedda,katja,anna,petra,steffi")
KnownVoices(2, "fr", "paul,thomas,nicolas,claude,jacques")
KnownVoices(3, "fr", "hortense,julie,caroline,amélie,audrey,aurélie,chantal,marie")
KnownVoices(2, "es", "pablo,raul,jorge,juan,diego,carlos")
KnownVoices(3, "es", "laura,sabina,mónica,paulina,marisol,angélica,isabela,soledad")
KnownVoices(2, "it", "cosimo,luca")
KnownVoices(3, "it", "elsa,lucia,alice,federica,paola")
KnownVoices(2, "pt", "felipe")
KnownVoices(3, "pt", "maria,luciana,fernanda,joana,catarina")
KnownVoices(2, "ru", "pavel,yuri")
KnownVoices(3, "ru", "irina,milena,katya")
KnownVoices(3, "ko", "heami,yuna,sora")
KnownVoices(2, "zh", "kangkang,zhiwei,li-mu")
KnownVoices(3, "zh", "huihui,yaoyao,hanhan,yating,tingting,ting-ting,mei-jia,sin-ji,yu-shu,lili,shan-shan,ya-ling")
KnownVoices(2, nil, "daniel")  -- English on macOS, Portuguese on Windows
KnownVoices(3, nil, "helena")  -- German on macOS, Spanish on Windows

local LANGUAGE_WORDS = {
    en = { "english" }, de = { "german", "deutsch" }, fr = { "french", "français" },
    es = { "spanish", "español" }, it = { "italian", "italiano" }, pt = { "portuguese", "português" },
    ru = { "russian", "русский" }, ko = { "korean", "한국어" }, zh = { "chinese", "中文", "taiwan" },
}

local function VoiceKey(name)
    name = name:gsub("^Microsoft%s+", "")
    return (name:match("^[^%s%(]+") or name):lower()
end

local function VoiceLanguage(name)
    local code = name:match("%f[%a](%l%l)[_%-]%u%u%f[%A]")
    if code then return code end
    local lower = name:lower()
    for lang, words in pairs(LANGUAGE_WORDS) do
        for _, word in ipairs(words) do
            if lower:find(word, 1, true) then return lang end
        end
    end
    local known = KNOWN_VOICES[VoiceKey(name)]
    return known and known.lang
end

local function ClientLanguage()
    return ((GetLocale and GetLocale()) or "enUS"):sub(1, 2)
end

local function CharacterSex()
    return UnitSex and UnitSex("player") == 3 and 3 or 2
end

local function SavedVoiceKey(sex)
    return sex == 3 and "female" or "male"
end

local function SavedVoiceName(sex)
    local saved = StoryModeDB and StoryModeDB.journalVoice
    return saved and saved[SavedVoiceKey(sex)]
end

local function SetSavedVoiceName(sex, name)
    if not StoryModeDB then return end
    StoryModeDB.journalVoice = StoryModeDB.journalVoice or {}
    StoryModeDB.journalVoice[SavedVoiceKey(sex)] = name
end

local function GetVoices()
    return (C_VoiceChat.GetTtsVoices and C_VoiceChat.GetTtsVoices()) or {}
end

local function SettingsVoiceID(kind)
    local types = Enum and Enum.TtsVoiceType
    local id = types and types[kind]
    if id == nil then id = kind == "Standard" and 0 or 1 end
    return C_TTSSettings.GetVoiceOptionID and C_TTSSettings.GetVoiceOptionID(id)
end

local function SpeechRateAndVolume()
    local rate = C_TTSSettings.GetSpeechRate and C_TTSSettings.GetSpeechRate() or 0
    local volume = C_TTSSettings.GetSpeechVolume and C_TTSSettings.GetSpeechVolume() or 100
    return rate, volume
end

-- The voice for the character: the one picked by hand, else the best known
-- voice of the character's sex in the client's language (the game's own
-- text-to-speech choices and premium voices first), else the game's
-- standard voice.
local function PickVoice()
    local voices = GetVoices()
    local sex = CharacterSex()
    local saved = SavedVoiceName(sex)
    local standard, alternate = SettingsVoiceID("Standard"), SettingsVoiceID("Alternate")
    local language = ClientLanguage()
    local best, bestScore
    for _, voice in ipairs(voices) do
        local name = voice.name or ""
        if saved and name == saved then return voice.voiceID, name end
        local known = KNOWN_VOICES[VoiceKey(name)]
        local lang = VoiceLanguage(name)
        if known and known.sex == sex and (lang == nil or lang == language) then
            local score = lang == language and 4 or 1
            if voice.voiceID == standard then score = score + 2 elseif voice.voiceID == alternate then score = score + 1 end
            local lower = name:lower()
            if lower:find("premium", 1, true) or lower:find("enhanced", 1, true) or lower:find("natural", 1, true) then
                score = score + 3
            end
            if not bestScore or score > bestScore then best, bestScore = voice, score end
        end
    end
    if best then return best.voiceID, best.name end
    for _, voice in ipairs(voices) do
        if voice.voiceID == standard then return voice.voiceID, voice.name end
    end
    local first = voices[1]
    return first and first.voiceID or 0, first and first.name
end

local function SpeechText(text)
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    text = text:gsub("|T.-|t", ""):gsub("|A.-|a", ""):gsub("|H.-|h(.-)|h", "%1")
    text = text:gsub("|n", " "):gsub("[<>]", ""):gsub("%s+", " ")
    return strtrim(text)
end

function SM.CanReadJournalAloud()
    return C_VoiceChat and C_VoiceChat.SpeakText and C_VoiceChat.GetTtsVoices and C_TTSSettings and true or false
end

local function ShowSpeakerLines(button, shown)
    local part = shown and 1 or SPEAKER_PART
    button.icon:SetWidth(SPEAKER_SIZE * part)
    button.icon:SetTexCoord(0, SPEAKER_ART * part, 0, SPEAKER_ART)
end

function Voice.UpdateButtons()
    local entries = SM.DetailUI and SM.DetailUI.sJournalEntries
    for _, entry in ipairs(entries or {}) do
        local button = entry.voice
        if button then
            local reading = Voice.segments and button.chapter and button.chapter == Voice.chapter
            ShowSpeakerLines(button, reading)
            if reading then
                if not button.pulse:IsPlaying() then button.pulse:Play() end
            else
                button.pulse:Stop()
                button.icon:SetAlpha(button:IsMouseOver() and 1 or IDLE_ALPHA)
            end
        end
    end
end

-- Resets without touching the speech: never stop speech from inside the
-- FINISHED event (that crashes the game).
function Voice:Finish()
    self.serial = self.serial + 1
    self.segments, self.pos, self.data, self.chapter = nil, nil, nil, nil
    self.speaking, self.utterance, self.utterance2 = nil, nil, nil
    self:UnregisterAllEvents()
    Voice.UpdateButtons()
end

function Voice:Stop()
    local speaking = self.speaking
    self:Finish()
    if speaking and C_VoiceChat.StopSpeakingText then C_VoiceChat.StopSpeakingText() end
end

-- On to the next line once this one is over.
function Voice:Advance()
    self.speaking, self.utterance, self.utterance2 = nil, nil, nil
    self.pos = self.pos + 1
    local nextSegment = self.segments[self.pos]
    if not nextSegment then return self:Finish() end
    self:SpeakNext(nextSegment.pause)
end

function Voice:SpeakSegment()
    local segment = self.segments and self.segments[self.pos]
    if not segment then return self:Finish() end
    self.chapter = segment.chapter
    if Voice.onSegment then Voice.onSegment(segment) end
    self.serial = self.serial + 1
    local serial = self.serial
    self.speaking, self.utterance, self.utterance2 = true, nil, nil
    self:RegisterEvent("VOICE_CHAT_TTS_PLAYBACK_STARTED")
    self:RegisterEvent("VOICE_CHAT_TTS_PLAYBACK_FINISHED")
    pcall(self.RegisterEvent, self, "VOICE_CHAT_TTS_PLAYBACK_FAILED")
    Voice.UpdateButtons()
    local rate, volume = SpeechRateAndVolume()
    if not pcall(C_VoiceChat.SpeakText, PickVoice(), segment.text, rate, volume, false) then
        return self:Finish()
    end
    -- Speech another addon stops ends without a FINISHED event: give up once
    -- the line has had far longer than it needs.
    C_Timer.After(10 + #segment.text / 4, function()
        if self.serial == serial then self:Finish() end
    end)
end

function Voice:SpeakNext(delay)
    local serial = self.serial
    C_Timer.After(math.max(delay or 0, 0.05), function()
        if self.serial == serial then self:SpeakSegment() end
    end)
end

local function SplitParagraphs(text)
    local paragraphs = {}
    for paragraph in (text .. "\n\n"):gmatch("(.-)\n\n") do
        if paragraph:find("%S") then paragraphs[#paragraphs + 1] = paragraph end
    end
    return paragraphs
end

-- shown: the journal's entries in order ({ chapter, title, recap }). Each
-- line knows its entry and paragraph (0 for the title), so the journal's
-- pages can follow the reading.
function Voice:Play(data, shown, index)
    local segments = {}
    for i = index, #shown do
        local item = shown[i]
        segments[#segments + 1] = { chapter = item.chapter, entry = i, paragraph = 0, text = SpeechText(item.title or ""), pause = CHAPTER_PAUSE }
        for p, paragraph in ipairs(SplitParagraphs(item.recap)) do
            for line in paragraph:gmatch("[^\n]+") do
                local text = SpeechText(line)
                if text ~= "" then
                    segments[#segments + 1] = { chapter = item.chapter, entry = i, paragraph = p, text = text, pause = PARAGRAPH_PAUSE }
                end
            end
        end
    end
    if #segments == 0 then return end
    local wasSpeaking = self.speaking
    self:Stop()
    self.segments, self.pos, self.data = segments, 1, data
    self.chapter = segments[1].chapter
    Voice.UpdateButtons()
    self:SpeakNext(wasSpeaking and 0.15 or 0)
end

Voice:SetScript("OnEvent", function(self, event, arg1, arg2)
    if not self.speaking then return end
    if event == "VOICE_CHAT_TTS_PLAYBACK_STARTED" then
        -- One payload (the utterance) on current clients; older ones send
        -- numConsumers first.
        if self.utterance == nil then self.utterance, self.utterance2 = arg1, arg2 end
    elseif event == "VOICE_CHAT_TTS_PLAYBACK_FAILED" then
        self:Finish()
    elseif event == "VOICE_CHAT_TTS_PLAYBACK_FINISHED" then
        if self.utterance == nil then return end
        if arg1 ~= self.utterance and (arg2 == nil or arg2 ~= self.utterance2) then return end
        self:Advance()
    end
end)

-- Styled like the minimap button's: a title, then plain lines.
local function ShowVoiceTooltip(button)
    local tooltip = SM.Tooltip
    if not tooltip then return end
    tooltip:SetOwner(button, "ANCHOR_RIGHT")
    tooltip:ClearLines()
    tooltip:AddLine(L["Journal Voice Tooltip Title"])
    local _, name = PickVoice()
    if name then tooltip:AddLine(L["Journal Voice Current"]:format(name)) end
    local reading = Voice.segments and Voice.chapter == button.chapter
    tooltip:AddLine(reading and L["Journal Stop Reading"] or L["Journal Read Aloud"])
    if MenuUtil and MenuUtil.CreateContextMenu then
        tooltip:AddLine(L["Journal Voice Hint"])
    end
    tooltip._minW = 0
    tooltip:Show()
end

local function ChooseVoice(sex, name)
    SetSavedVoiceName(sex, name)
    -- A sample in the new voice, unless the journal is being read (the next
    -- paragraph takes the new voice then).
    if Voice.segments or not TEXT_TO_SPEECH_SAMPLE_TEXT then return end
    local voiceID = PickVoice()
    local rate, volume = SpeechRateAndVolume()
    if C_VoiceChat.StopSpeakingText then C_VoiceChat.StopSpeakingText() end
    C_Timer.After(0.1, function()
        if not Voice.segments then pcall(C_VoiceChat.SpeakText, voiceID, TEXT_TO_SPEECH_SAMPLE_TEXT, rate, volume, false) end
    end)
end

-- The voices that speak the client's language (or don't say), to pick one
-- for this character's sex.
local function ShowVoiceMenu(owner)
    if not (MenuUtil and MenuUtil.CreateContextMenu) then return end
    if SM.Tooltip then SM.Tooltip:Hide() end
    local sex = CharacterSex()
    local language = ClientLanguage()
    MenuUtil.CreateContextMenu(owner, function(_, root)
        root:CreateTitle(L["Journal Voice Menu Title"])
        root:CreateRadio(L["Journal Voice Automatic"],
            function() return SavedVoiceName(sex) == nil end,
            function() ChooseVoice(sex, nil) end)
        for _, voice in ipairs(GetVoices()) do
            local name = voice.name
            local lang = name and VoiceLanguage(name)
            if name and (lang == nil or lang == language or name == SavedVoiceName(sex)) then
                root:CreateRadio(name,
                    function() return SavedVoiceName(sex) == name end,
                    function() ChooseVoice(sex, name) end)
            end
        end
        if root.SetScrollMode then root:SetScrollMode(360) end
    end)
end

local function GetVoiceButton(entry, parent)
    if entry.voice then return entry.voice end
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(SPEAKER_SIZE, SPEAKER_SIZE)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetTexture(SPEAKER_TEXTURE)
    icon:SetPoint("LEFT")
    icon:SetHeight(SPEAKER_SIZE)
    icon:SetAlpha(IDLE_ALPHA)
    button.icon = icon
    ShowSpeakerLines(button, false)
    local pulse = icon:CreateAnimationGroup()
    pulse:SetLooping("BOUNCE")
    local fade = pulse:CreateAnimation("Alpha")
    fade:SetFromAlpha(1)
    fade:SetToAlpha(0.5)
    fade:SetDuration(0.7)
    button.pulse = pulse

    button:SetScript("OnClick", function(self, mouseButton)
        if mouseButton == "RightButton" then return ShowVoiceMenu(self) end
        if Voice.segments and Voice.chapter == self.chapter then
            Voice:Stop()
        else
            Voice:Play(self.data, self.journal, self.index)
        end
        ShowVoiceTooltip(self)
    end)
    button:SetScript("OnEnter", function(self)
        self.icon:SetAlpha(1)
        ShowVoiceTooltip(self)
    end)
    button:SetScript("OnLeave", function()
        if SM.Tooltip then SM.Tooltip:Hide() end
        Voice.UpdateButtons()
    end)
    -- Leaving the journal (another tab or story, or closing the window)
    -- stops the reading.
    button:SetScript("OnHide", function(self)
        if Voice.pageTurning then return end
        if Voice.segments and Voice.chapter == self.chapter then Voice:Stop() end
    end)
    entry.voice = button
    return button
end

-- ── Pages (WoW Forever) ─────────────────────────────────────────────
-- On WoW Forever the journal is a spellbook page, and it turns its pages as
-- the spellbook does instead of scrolling, with the spellbook's paging
-- control at the bottom right (ForeverWindow.lua). Chapters flow from page to
-- page a paragraph at a time: a title never ends a page without its first
-- paragraph, and a chapter that runs on carries on at the top of the next
-- page. Read aloud, the journal turns to the page being read.

local PAGE = {
    top = 18,          -- the header's top, and the text's on later pages
    headerGap = 18,    -- from the subline to the first chapter title
    titleGap = 22,     -- from a title's top line to its text: divider and gaps
    entryGap = 20,     -- between a chapter's text and the next title
    bottom = 56,       -- kept clear above the page's bottom for the paging control
    fallbackH = 490,   -- the page's height before the window has been laid out
}

local pages = { list = {}, where = {}, current = 1 }
local pageHost = {}
local pageBodies = {}
local measureText

-- The height text takes in a body's font at width.
local function TextHeight(text, width, ref)
    if not measureText then
        measureText = SM.NoShadow(SM.GetDetailChild():CreateFontString(nil, "ARTWORK", "QuestFont"))
        measureText:SetJustifyH("LEFT")
        measureText:SetWordWrap(true)
        measureText:SetPoint("TOPLEFT", SM.GetDetailChild(), "TOPLEFT", 0, 0)
        measureText:SetAlpha(0)
    end
    local font, size, flags = ref:GetFont()
    if font then measureText:SetFont(font, size, flags) end
    measureText:SetSpacing(ref:GetSpacing() or 4)
    measureText:SetWidth(width)
    measureText:SetText(text)
    return measureText:GetStringHeight() or 0
end

local function GetPageBody(index, ref)
    local body = pageBodies[index]
    if not body then
        body = SM.NoShadow(SM.ForeverWindow.GetJournalLayer():CreateFontString(nil, "ARTWORK", "QuestFont"))
        body:SetJustifyH("LEFT")
        body:SetWordWrap(true)
        pageBodies[index] = body
    end
    local font, size, flags = ref:GetFont()
    if font then body:SetFont(font, size, flags) end
    body:SetSpacing(ref:GetSpacing() or 4)
    body:SetTextColor(ref:GetTextColor())
    return body
end

-- Splits the entries ({ titleH, paragraphs }) into pages of blocks, each
-- with its top: a chapter's title, or a run of its paragraphs. where[e][p]
-- is the page of entry e's paragraph p (0: its title).
local function BuildPages(entries, width, ref, firstTop, limit)
    local list, where = { {} }, {}
    local page, y = list[1], firstTop
    local function NewPage()
        page = {}
        list[#list + 1] = page
        y = PAGE.top
    end
    for e, entry in ipairs(entries) do
        where[e] = {}
        local paragraphs = entry.paragraphs
        local titleH = entry.titleH + PAGE.titleGap
        local firstH = paragraphs[1] and TextHeight(paragraphs[1], width, ref) or 0
        if #page > 0 and y + titleH + firstH > limit then NewPage() end
        page[#page + 1] = { entry = e, top = y }
        where[e][0] = #list
        y = y + titleH

        local run, runTop, runH = {}, y, 0
        local function EndRun()
            if #run == 0 then return end
            page[#page + 1] = { entry = e, top = runTop, text = table.concat(run, "\n\n") }
            y = runTop + runH
        end
        for p, paragraph in ipairs(paragraphs) do
            local text = #run > 0 and (table.concat(run, "\n\n") .. "\n\n" .. paragraph) or paragraph
            local h = TextHeight(text, width, ref)
            if #run > 0 and runTop + h > limit then
                EndRun()
                NewPage()
                run, runTop, runH = { paragraph }, y, TextHeight(paragraph, width, ref)
            else
                run[#run + 1] = paragraph
                runH = h
            end
            where[e][p] = #list
        end
        EndRun()
        y = y + PAGE.entryGap
    end
    return list, where
end

-- Shows page n of the journal laid out last.
local function ShowPage(n)
    local layout = pages.layout
    if not layout then return end
    n = math.max(1, math.min(n, #pages.list))
    pages.current = n
    local ui = SM.DetailUI
    local detailChild, CP, contentW = ui.detailChild, ui.CP, layout.contentW
    local foreverWindow = SM.ForeverWindow

    Voice.pageTurning = true
    for _, entry in ipairs(ui.sJournalEntries) do
        entry.title:Hide()
        entry.body:Hide()
        if entry.voice then entry.voice:Hide() end
    end
    for _, body in ipairs(pageBodies) do body:Hide() end
    foreverWindow.HideJournalDividers(1)
    Voice.pageTurning = false

    ui.sJournalHeader:SetShown(n == 1)
    ui.sJournalSubline:SetShown(n == 1)

    local bodyIndex = 0
    for _, block in ipairs(pages.list[n] or {}) do
        local item = layout.shown[block.entry]
        local entry = SM.GetJournalEntry(block.entry)
        if block.text then
            bodyIndex = bodyIndex + 1
            local body = GetPageBody(bodyIndex, entry.body)
            body:ClearAllPoints()
            body:SetPoint("TOPLEFT", detailChild, "TOPLEFT", CP, -block.top)
            body:SetWidth(contentW)
            body:SetText(block.text)
            body:Show()
        else
            entry.title:ClearAllPoints()
            entry.title:SetPoint("TOPLEFT", detailChild, "TOPLEFT", CP, -block.top)
            entry.title:SetPoint("TOPRIGHT", detailChild, "TOPRIGHT", -CP, -block.top)
            entry.title:SetText(item.title)
            entry.title:Show()
            foreverWindow.PlaceJournalDivider(block.entry, entry.title, contentW)
            local voice = layout.canReadAloud and GetVoiceButton(entry, detailChild)
            if voice then
                voice.chapter, voice.data, voice.journal, voice.index = item.chapter, layout.data, layout.shown, block.entry
                voice:ClearAllPoints()
                voice:SetPoint("RIGHT", entry.title, "RIGHT", 0, 0)
                voice.icon:SetVertexColor(entry.title:GetTextColor())
                voice:Show()
            end
        end
    end
    Voice.UpdateButtons()

    local pager = pages.pager
    if pager then
        pager:SetMaxPages(#pages.list)
        pager.currentPage = n
        pager:UpdateControls()
    end
end

function pageHost:OnPageChanged()
    if pages.pager then ShowPage(pages.pager:GetCurrentPage()) end
end

-- The reading voice turns to the page it's reading.
Voice.onSegment = function(segment)
    local layer = SM.ForeverWindow and SM.ForeverWindow.GetJournalLayer and SM.ForeverWindow.GetJournalLayer()
    if not (pages.layout and pages.layout.data == Voice.data and layer and layer:IsVisible()) then return end
    local where = pages.where[segment.entry]
    local page = where and where[segment.paragraph or 0]
    if page and page ~= pages.current then ShowPage(page) end
end

-- The mouse wheel turns the pages, and leaving the journal (another tab, no
-- story, or closing the window) stops the reading, wherever its chapter is.
local function HookPageFrames(detailScroll, layer)
    if pages.hooked then return end
    pages.hooked = true
    detailScroll:HookScript("OnMouseWheel", function(_, delta)
        local pager = pages.pager
        if not (pager and pages.layout and layer:IsVisible() and #pages.list > 1) then return end
        if delta > 0 then pager:PreviousPage() else pager:NextPage() end
    end)
    layer:HookScript("OnHide", function() Voice:Stop() end)
end

local function LayoutJournalPages(data, contentW)
    local ui = SM.DetailUI
    local detailChild, detailScroll, CP = ui.detailChild, ui.detailScroll, ui.CP
    local sJournalHeader, sJournalSubline = ui.sJournalHeader, ui.sJournalSubline
    local sJournalEmptyTitle, sJournalEmptyText = ui.sJournalEmptyTitle, ui.sJournalEmptyText
    local foreverWindow = SM.ForeverWindow
    local layer = foreverWindow.GetJournalLayer()
    pages.pager = pages.pager or foreverWindow.GetJournalPager(detailScroll, pageHost)
    HookPageFrames(detailScroll, layer)

    if Voice.data and Voice.data ~= data then Voice:Stop() end
    if contentW <= 20 then contentW = (detailChild:GetWidth() or 0) - CP * 2 end
    if contentW <= 20 then contentW = 500 end
    local viewH = detailScroll:GetHeight() or 0
    if viewH < 200 then viewH = PAGE.fallbackH end

    local quest = SM.FindNextQuest(data)
    local done = SM.GetCampaignProgress(data)
    SM.FactionUI:HideAll()
    ui.sFactionHeader:Hide()

    sJournalHeader:SetText(quest and L["Journal Header"] or L["Journal Header Complete"])
    sJournalHeader:ClearAllPoints()
    sJournalHeader:SetPoint("TOP", detailChild, "TOP", 0, -PAGE.top)
    sJournalSubline:ClearAllPoints()
    sJournalSubline:SetPoint("TOP", sJournalHeader, "BOTTOM", 0, -4)
    sJournalSubline:SetPoint("LEFT", detailChild, "LEFT", CP, 0)
    sJournalSubline:SetPoint("RIGHT", detailChild, "RIGHT", -CP, 0)
    sJournalSubline:SetWidth(contentW)

    -- The finished chapters' entries, as the scrolling journal has them.
    local shown, entries = {}, {}
    for _, ch in ipairs(SM.GetAllChapters(data)) do
        local cd, ct = SM.GetChapterProgress(ch)
        local recap = cd == ct and ct > 0 and GetJournalRecap(ch)
        if recap then
            local index = #shown + 1
            shown[index] = { chapter = ch, title = ch.chapter, recap = recap }
            local entry = SM.GetJournalEntry(index)
            entry.title:SetJustifyH("LEFT")
            entry.title:SetText(ch.chapter)
            entries[index] = { titleH = entry.title:GetStringHeight() or 16, paragraphs = SplitParagraphs(recap) }
        end
    end

    if pages.layout and pages.layout.data ~= data then pages.current = 1 end
    pages.layout = { data = data, shown = shown, contentW = contentW, canReadAloud = SM.CanReadJournalAloud() }

    if #shown == 0 then
        -- Nothing to tell yet: one page with the empty message.
        pages.list, pages.where, pages.current = { {} }, {}, 1
        ShowPage(1)
        sJournalHeader:Hide()
        sJournalSubline:Hide()
        sJournalEmptyTitle:ClearAllPoints()
        sJournalEmptyTitle:SetPoint("TOP", detailChild, "TOP", 0, -math.max(150, math.floor(viewH * 0.42)))
        sJournalEmptyTitle:SetPoint("LEFT", detailChild, "LEFT", CP, 0)
        sJournalEmptyTitle:SetPoint("RIGHT", detailChild, "RIGHT", -CP, 0)
        if done > 0 then
            sJournalEmptyTitle:SetText(L["Journal No Recaps Title"])
            sJournalEmptyText:SetText(L["Journal No Recaps Text"])
        else
            sJournalEmptyTitle:SetText(L["Journal Empty Title"])
            sJournalEmptyText:SetText(L["Journal Empty Text"])
        end
        sJournalEmptyTitle:Show()
        sJournalEmptyText:ClearAllPoints()
        sJournalEmptyText:SetPoint("TOPLEFT", sJournalEmptyTitle, "BOTTOMLEFT", 0, -8)
        sJournalEmptyText:SetPoint("TOPRIGHT", sJournalEmptyTitle, "BOTTOMRIGHT", 0, -8)
        sJournalEmptyText:SetWidth(contentW)
        sJournalEmptyText:Show()
    else
        sJournalEmptyTitle:Hide()
        sJournalEmptyText:Hide()
        local headerH = (sJournalHeader:GetStringHeight() or 16) + 4 + (sJournalSubline:GetStringHeight() or 14)
        local ref = SM.GetJournalEntry(1).body
        pages.list, pages.where = BuildPages(entries, contentW, ref, PAGE.top + headerH + PAGE.headerGap, viewH - PAGE.bottom)
        ShowPage(pages.current)
    end

    -- A page never scrolls.
    detailChild:SetHeight(viewH)
    detailScroll:SetVerticalScroll(0)
end

function SM.LayoutJournalTab(data, w, contentW, visibleContentW)
    local ui = SM.DetailUI
    local detailChild = ui.detailChild
    local detailScroll = ui.detailScroll
    local CP = ui.CP
    local sJournalHeader = ui.sJournalHeader
    local sJournalSubline = ui.sJournalSubline
    local sJournalEmptyTitle = ui.sJournalEmptyTitle
    local sJournalEmptyText = ui.sJournalEmptyText
    local sFactionHeader = ui.sFactionHeader
    local sJournalEntries = ui.sJournalEntries
    local FactionUI = SM.FactionUI
    -- On WoW Forever the journal is a spellbook page (ForeverWindow.lua): its
    -- text is the spellbook's ink, and each chapter title sits on the left
    -- above the spellbook's divider.
    local foreverWindow = SM.ForeverWindow
    local ink = foreverWindow and foreverWindow.JournalInk
    if ink then
        for _, text in ipairs({ sJournalHeader, sJournalSubline, sJournalEmptyTitle, sJournalEmptyText }) do
            text:SetTextColor(ink[1], ink[2], ink[3])
        end
        for _, entry in ipairs(sJournalEntries) do
            entry.title:SetTextColor(ink[1], ink[2], ink[3])
            entry.body:SetTextColor(ink[1], ink[2], ink[3])
        end
        if foreverWindow.GetJournalLayer and foreverWindow.GetJournalLayer() then
            for i = 1, #SM.GetAllChapters(data) do
                local entry = SM.GetJournalEntry(i)
                entry.title:SetTextColor(ink[1], ink[2], ink[3])
                entry.body:SetTextColor(ink[1], ink[2], ink[3])
            end
            return LayoutJournalPages(data, contentW)
        end
    end
        -- ── JOURNAL TAB layout ──────────────────────────────────────────
        -- Show recap for each completed chapter (no spoilers for future ones)
        local chapters = SM.GetAllChapters(data)
        local journalIdx = 0
        local hasAnyRecap = false
        local quest = SM.FindNextQuest(data)
        local done = SM.GetCampaignProgress(data)
        local lastAnchor = sJournalHeader
        local canReadAloud = SM.CanReadJournalAloud()
        local shown = {}
        if Voice.data and Voice.data ~= data then Voice:Stop() end

        -- Factions live in the contextual left panel on the Journal tab.
        FactionUI:HideAll()
        sFactionHeader:Hide()

        sJournalHeader:SetText(quest and L["Journal Header"] or L["Journal Header Complete"])
        sJournalHeader:ClearAllPoints()
        sJournalHeader:SetPoint("TOP", detailChild, "TOP", 0, -18)
        sJournalHeader:Show()

        sJournalSubline:ClearAllPoints()
        sJournalSubline:SetPoint("TOP", sJournalHeader, "BOTTOM", 0, -4)
        sJournalSubline:SetPoint("LEFT", detailChild, "LEFT", CP, 0)
        sJournalSubline:SetPoint("RIGHT", detailChild, "RIGHT", -CP, 0)
        if contentW > 20 then sJournalSubline:SetWidth(contentW) end
        sJournalSubline:Show()

        for ci, ch in ipairs(chapters) do
            local cd, ct = SM.GetChapterProgress(ch)
            local chComplete = cd == ct and ct > 0
            local recap = GetJournalRecap(ch)
            if chComplete and recap then
                journalIdx = journalIdx + 1
                hasAnyRecap = true
                local entry = SM.GetJournalEntry(journalIdx)

                -- Chapter title
                entry.title:ClearAllPoints()
                if journalIdx == 1 then
                    entry.title:SetPoint("TOP", sJournalSubline, "BOTTOM", 0, -18)
                else
                    local prev = sJournalEntries[journalIdx - 1]
                    entry.title:SetPoint("TOP", prev.body, "BOTTOM", 0, -20)
                end
                entry.title:SetPoint("LEFT", detailChild, "LEFT", CP, 0)
                entry.title:SetPoint("RIGHT", detailChild, "RIGHT", -CP, 0)
                entry.title:SetText(ch.chapter)
                entry.title:Show()
                if ink then
                    entry.title:SetJustifyH("LEFT")
                    entry.title:SetTextColor(ink[1], ink[2], ink[3])
                    entry.body:SetTextColor(ink[1], ink[2], ink[3])
                end
                local divider = ink and foreverWindow.PlaceJournalDivider(journalIdx, entry.title, contentW)

                -- Recap body
                entry.body:ClearAllPoints()
                if divider then
                    entry.body:SetPoint("TOP", divider, "BOTTOM", 0, -8)
                else
                    entry.body:SetPoint("TOP", entry.title, "BOTTOM", 0, -6)
                end
                entry.body:SetPoint("LEFT", detailChild, "LEFT", CP, 0)
                entry.body:SetPoint("RIGHT", detailChild, "RIGHT", -CP, 0)
                entry.body:SetText(recap)
                entry.body:Show()

                shown[journalIdx] = { chapter = ch, title = ch.chapter, recap = recap }
                local voice = canReadAloud and GetVoiceButton(entry, detailChild)
                if voice then
                    voice.chapter, voice.data, voice.journal, voice.index = ch, data, shown, journalIdx
                    voice:ClearAllPoints()
                    voice:SetPoint("RIGHT", entry.title, "RIGHT", 0, 0)
                    voice.icon:SetVertexColor(entry.title:GetTextColor())
                    voice:Show()
                elseif entry.voice then
                    entry.voice:Hide()
                end

                lastAnchor = entry.body
            end
        end
        if ink then foreverWindow.HideJournalDividers(journalIdx + 1) end

        if not hasAnyRecap then
            sJournalHeader:Hide()
            sJournalSubline:Hide()
            local emptyTop = -math.max(150, math.floor((detailScroll:GetHeight() or 420) * 0.42))
            sJournalEmptyTitle:ClearAllPoints()
            sJournalEmptyTitle:SetPoint("TOP", detailChild, "TOP", 0, emptyTop)
            sJournalEmptyTitle:SetPoint("LEFT", detailChild, "LEFT", CP, 0)
            sJournalEmptyTitle:SetPoint("RIGHT", detailChild, "RIGHT", -CP, 0)
            if done > 0 then
                sJournalEmptyTitle:SetText(L["Journal No Recaps Title"])
                sJournalEmptyText:SetText(L["Journal No Recaps Text"])
            else
                sJournalEmptyTitle:SetText(L["Journal Empty Title"])
                sJournalEmptyText:SetText(L["Journal Empty Text"])
            end
            sJournalEmptyTitle:Show()
            sJournalEmptyText:ClearAllPoints()
            sJournalEmptyText:SetPoint("TOPLEFT", sJournalEmptyTitle, "BOTTOMLEFT", 0, -8)
            sJournalEmptyText:SetPoint("TOPRIGHT", sJournalEmptyTitle, "BOTTOMRIGHT", 0, -8)
            if contentW > 20 then sJournalEmptyText:SetWidth(contentW) end
            sJournalEmptyText:Show()
            lastAnchor = sJournalEmptyText
        else
            sJournalHeader:Show()
            sJournalSubline:Show()
            sJournalEmptyTitle:Hide()
            sJournalEmptyText:Hide()
        end

        -- Hide unused journal entries
        for i = journalIdx + 1, #sJournalEntries do
            sJournalEntries[i].title:Hide()
            sJournalEntries[i].body:Hide()
            if sJournalEntries[i].voice then sJournalEntries[i].voice:Hide() end
        end
        Voice.UpdateButtons()

        local journalBottomEl = lastAnchor
        -- Set scroll height
        C_Timer.After(0, function()
            local bot = journalBottomEl:GetBottom()
            local top = detailChild:GetTop()
            if bot and top then
                detailChild:SetHeight(math.max(top - bot + 40, 400))
            else
                detailChild:SetHeight(500)
            end
        end)
end


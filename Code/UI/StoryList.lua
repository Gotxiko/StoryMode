local _, SM = ...
local L = SM.L
local SMTooltip = SM.Tooltip

local categories = SM.GetQuestlineCategories()
local allQuestlines = SM.GetAllQuestlines()

local storyLeftRows    = {}
local storyContentBuilt = false
local storyIndexToData = {}
local storyListFrames = {}
local activeStoriesSignature = ""
-- Cards and dividers are built once and reused whenever the list is laid out
-- again (a search keystroke, a filter change, a story becoming active): WoW
-- never frees a frame, so building new ones each time would pile them up.
local cardPool = { active = {}, list = {} }
local dividerPool = {}
local introRowPooled
local emptyText

local function RememberStoryListFrame(frame)
    storyListFrames[#storyListFrames + 1] = frame
    return frame
end

-- ── Search and status filter ─────────────────────────────────────────────
-- The Forever window has a search box and a status filter above the list,
-- as Legacy's challenge list does. The search also finds a story by its zone,
-- chapters, and the quests the player can see (all of them in Guided mode,
-- the revealed ones in Explorer mode) by title or giver; a story found by a
-- quest opens on that quest's card. The filter shows how many stories each
-- choice holds, and the list says so when nothing matches.
local STATUS_ALL, STATUS_IN_PROGRESS, STATUS_NOT_STARTED, STATUS_COMPLETE = "all", "inProgress", "notStarted", "complete"
-- Below a divider, the stories that send the player into a dungeon or a raid.
local KIND_DUNGEON, KIND_RAID = "dungeon", "raid"
local STATUS_OPTIONS = {
    { key = STATUS_ALL, label = "Story Filter All" },
    { key = STATUS_IN_PROGRESS, label = "Story Filter In Progress" },
    { key = STATUS_NOT_STARTED, label = "Story Filter Not Started" },
    { key = STATUS_COMPLETE, label = "Story Filter Complete" },
    { key = KIND_DUNGEON, label = "Story Filter Dungeons", kind = true },
    { key = KIND_RAID, label = "Story Filter Raids", kind = true },
}
local searchWords
local searchTextCache = setmetatable({}, { __mode = "k" })
-- What the current search found in a story (see SearchStory), until the
-- search or the list changes.
local searchResults = setmetatable({}, { __mode = "k" })
local filterBar, filterDropdown
local FILTER_BAR_H = 34

local function GetStatusFilter()
    local status = SM.ForeverWindow and StoryModeDB and StoryModeDB.storyListStatus
    for _, option in ipairs(STATUS_OPTIONS) do
        if option.key == status then return status end
    end
    return STATUS_ALL
end

-- Finished, under way (a quest done or in the log) or not yet begun.
function SM.GetStoryListStatus(data)
    local state = SM.GetStoryState(data)
    if state and state.isFinished then return STATUS_COMPLETE end
    if SM.IsStoryActive(data) then return STATUS_IN_PROGRESS end
    local done = SM.GetCampaignProgress(data)
    if done and done > 0 then return STATUS_IN_PROGRESS end
    return STATUS_NOT_STARTED
end

-- The words a story is named by (its title and zone), and all it always
-- shows (those and its chapter names).
local storyNameCache = setmetatable({}, { __mode = "k" })
local function StoryNameTextOf(data)
    local text = storyNameCache[data]
    if text then return text end
    text = ((data.title or "") .. "\n" .. (data.zone or "")):lower()
    storyNameCache[data] = text
    return text
end

local function StoryTextOf(data)
    local text = searchTextCache[data]
    if text then return text end
    local parts = { StoryNameTextOf(data) }
    for _, ch in ipairs(SM.GetAllChapters(data)) do
        parts[#parts + 1] = (ch.chapter or ""):lower()
    end
    text = table.concat(parts, "\n")
    searchTextCache[data] = text
    return text
end

-- A quest's words: its title and who gives it.
local function QuestTextOf(q)
    local text = searchTextCache[q]
    if text then return text end
    text = table.concat({ q.displayName or "", q.name or "", q.npc or "" }, "\n"):lower()
    searchTextCache[q] = text
    return text
end

local function HasAllWords(text, words)
    for _, word in ipairs(words) do
        if not text:find(word, 1, true) then return false end
    end
    return true
end

-- Whether the search finds a story, and the quest it found there. The
-- story's own name or zone wins; then a quest whose title or giver holds
-- every word (a chapter is often named after its quest); then one that
-- holds the words the story's name, zone and chapters lack. Only quests the
-- player can see count: every quest with a card in Guided mode, in Explorer
-- mode just the ones it has revealed.
local function SearchStory(data, words)
    if HasAllWords(StoryNameTextOf(data), words) then return true end
    local storyText = StoryTextOf(data)
    local missing = {}
    for _, word in ipairs(words) do
        if not storyText:find(word, 1, true) then missing[#missing + 1] = word end
    end
    local explorer = SM.IsExplorerMode and SM.IsExplorerMode()
    local nextQuestID
    if explorer then
        local nextQuest = SM.FindNextQuest(data)
        nextQuestID = nextQuest and nextQuest.id
    end
    local partial, partialChapter
    for chapterIndex, ch in ipairs(SM.GetAllChapters(data)) do
        if not ch.replayable then
            for questIndex, q in ipairs(ch.quests or {}) do
                local text = QuestTextOf(q)
                local full = HasAllWords(text, words)
                if (full or (not partial and #missing > 0 and HasAllWords(text, missing)))
                    and SM.IsQuestForPlayer(q) and not SM.ShouldHideQuest(q)
                    and (not explorer or SM.IsQuestDiscovered(questIndex, ch.quests, nextQuestID)) then
                    if full then return true, q, chapterIndex end
                    partial, partialChapter = q, chapterIndex
                end
            end
        end
    end
    if partial then return true, partial, partialChapter end
    return #missing == 0
end

local function MatchesSearch(data)
    if not searchWords then return true end
    local result = searchResults[data]
    if result == nil then
        result = SearchStory(data, searchWords) and true or false
        searchResults[data] = result
    end
    return result
end

-- The quest the current search found in a story, and its chapter's place
-- among the story's chapters; nil when the story itself matched (or no
-- search is on).
function SM.GetStorySearchQuest(data)
    if not (searchWords and data) then return nil end
    local _, quest, chapterIndex = SearchStory(data, searchWords)
    return quest, chapterIndex
end

-- ── Dungeon and raid stories ──────────────────────────────────────────────
-- A story holds a dungeon when one of its quests for the player is one: the
-- game's quest tag, as on the quest cards (SM.GetQuestInstanceType). Quests
-- the game hasn't loaded yet are loaded in the background, a few at a time,
-- once the player shows interest (hovers or opens the filter, or has
-- Dungeons chosen); the list follows as they arrive.
-- Raids go by the story data alone (instance = "raid"): the game also tags
-- open-world quests meant for raid groups (The Battle of Darrowshire) and
-- the quests of raids a client doesn't have open (Zul'Gurub on Forever) as
-- Raid, and those aren't raid chains.
local storyKinds = setmetatable({}, { __mode = "k" })
local kindsWanted = false
local kindLoadQueue, kindLoadQueued, kindLoader = {}, {}, nil

local function IsKindFilter(status)
    return status == KIND_DUNGEON or status == KIND_RAID
end

local function OnQuestKindsLoaded()
    wipe(storyKinds)
    if filterDropdown and filterDropdown.GenerateMenu then filterDropdown:GenerateMenu() end
    if storyContentBuilt and IsKindFilter(GetStatusFilter()) then SM.RebuildStoryWindow() end
end

local kindTicker
local function QueueQuestLoads(questIDs)
    if not (C_QuestLog and C_QuestLog.RequestLoadQuestByID) then return end
    for _, questID in ipairs(questIDs) do
        if not kindLoadQueued[questID] then
            kindLoadQueued[questID] = true
            kindLoadQueue[#kindLoadQueue + 1] = questID
        end
    end
    if kindTicker or #kindLoadQueue == 0 then return end
    if not kindLoader then
        kindLoader = CreateFrame("Frame")
        kindLoader:SetScript("OnEvent", function()
            if SM.DebounceTask then
                SM.DebounceTask("story-list-kinds", 0.5, OnQuestKindsLoaded)
            else
                OnQuestKindsLoaded()
            end
        end)
    end
    pcall(kindLoader.RegisterEvent, kindLoader, "QUEST_DATA_LOAD_RESULT")
    -- Twenty requests every tenth of a second, so the server isn't flooded.
    local ticker
    ticker = C_Timer.NewTicker(0.1, function()
        for _ = 1, 20 do
            local questID = table.remove(kindLoadQueue, 1)
            if not questID then
                ticker:Cancel()
                if kindTicker == ticker then kindTicker = nil end
                -- The last answers arrive a moment after the last request.
                C_Timer.After(3, function()
                    if not kindTicker then kindLoader:UnregisterAllEvents() end
                    OnQuestKindsLoaded()
                end)
                return
            end
            pcall(C_QuestLog.RequestLoadQuestByID, questID)
        end
    end)
    kindTicker = ticker
end

local function StoryKinds(data)
    local kinds = storyKinds[data]
    if kinds then return kinds end
    kinds = {}
    local pending
    for _, ch in ipairs(SM.GetAllChapters(data)) do
        for _, q in ipairs(ch.quests or {}) do
            if SM.IsQuestForPlayer(q) and not SM.ShouldHideQuest(q) then
                local kind, unknown = SM.GetQuestInstanceType(q)
                if kind == "raid" and q.instance ~= "raid" then
                    kind = "none"
                end
                if kind then
                    kinds[kind] = true
                elseif kindsWanted then
                    pending = pending or {}
                    for _, questID in ipairs(unknown) do pending[#pending + 1] = questID end
                end
            end
        end
    end
    if pending then QueueQuestLoads(pending) end
    storyKinds[data] = kinds
    return kinds
end

local function PassesListFilter(data)
    if not MatchesSearch(data) then return false end
    local status = GetStatusFilter()
    if status == STATUS_ALL then return true end
    if IsKindFilter(status) then return StoryKinds(data)[status] == true end
    return SM.GetStoryListStatus(data) == status
end

local function IsListFiltered()
    return searchWords ~= nil or GetStatusFilter() ~= STATUS_ALL
end

local function CountStoriesByStatus()
    local counts, seen = { [STATUS_ALL] = 0 }, {}
    for _, cat in ipairs(categories) do
        if not cat.disabled then
            for _, data in ipairs(cat.questlines) do
                if not seen[data] and MatchesSearch(data) then
                    seen[data] = true
                    local status = SM.GetStoryListStatus(data)
                    counts[status] = (counts[status] or 0) + 1
                    counts[STATUS_ALL] = counts[STATUS_ALL] + 1
                    local kinds = StoryKinds(data)
                    for _, kind in ipairs({ KIND_DUNGEON, KIND_RAID }) do
                        if kinds[kind] then counts[kind] = (counts[kind] or 0) + 1 end
                    end
                end
            end
        end
    end
    return counts
end

local function CollectActiveStorylines()
    local activeQuestlines = {}
    local activeSet = {}
    if not SM.IsStoryActive then return activeQuestlines, activeSet end
    for _, cat in ipairs(categories) do
        if not cat.disabled then
            for _, data in ipairs(cat.questlines) do
                if not activeSet[data] and SM.IsStoryActive(data) then
                    activeQuestlines[#activeQuestlines + 1] = data
                    activeSet[data] = true
                end
            end
        end
    end
    return activeQuestlines, activeSet
end

local function GetActiveStoriesSignature(activeQuestlines)
    local parts = {}
    for _, data in ipairs(activeQuestlines or {}) do
        parts[#parts + 1] = data.id or data.title or tostring(data)
    end
    return table.concat(parts, "|")
end

local function CategoryHasVisibleQuestlines(cat, activeSet)
    if not cat or not cat.questlines then return false end
    for _, data in ipairs(cat.questlines) do
        if (cat.active or not activeSet[data]) and PassesListFilter(data) then
            return true
        end
    end
    return false
end

local function BuildDisplayCategories(activeQuestlines)
    local displayCategories = {}
    if #activeQuestlines > 0 then
        displayCategories[#displayCategories + 1] = {
            name = "Active Stories",
            displayName = L["Category Active Stories"],
            active = true,
            questlines = activeQuestlines,
        }
    end
    for _, cat in ipairs(categories) do
        displayCategories[#displayCategories + 1] = cat
    end
    return displayCategories
end

function SM.GetIntroStoryRow()
    return storyLeftRows[0]
end

function SM.GetStoryRowForData(data)
    if not data then return nil end
    for _, row in pairs(storyLeftRows) do
        if row.data == data then return row end
    end
    return nil
end

function SM.GetStoryDataByIndex(index)
    return storyIndexToData[index]
end

SM.StoryCardBorderNormal   = {0.48, 0.36, 0.18, 0.56}
SM.StoryCardBorderHover    = {1.00, 0.82, 0.18, 0.95}
SM.StoryCardBorderSelected = {1.00, 0.70, 0.12, 0.90}

function SM.ApplyStoryCardBorderState(row, isHover)
    if not row or not row.btn then return end
    if row.btn.SetListCardLit then
        -- The Forever window's Group Finder cards light on hover and when selected.
        row.btn:SetListCardLit(isHover or row.isSelected)
        return
    end
    if SM.IsMainlineClient() then
        if row.isSelected then
            row.btn:LockHighlight()
        else
            row.btn:UnlockHighlight()
        end
        return
    end
    if not row.btn.SetBackdropBorderColor then return end
    local color = SM.StoryCardBorderNormal
    if isHover then
        color = SM.StoryCardBorderHover
    elseif row.isSelected then
        color = SM.StoryCardBorderSelected
    end
    row.btn:SetBackdropBorderColor(color[1], color[2], color[3], color[4])
end

local function ApplyCurrentSelectionState()
    local currentData = SM.GetCurrentStoryData and SM.GetCurrentStoryData() or nil
    local selectedID = currentData and currentData.id or StoryModeDB and StoryModeDB.selectedQuestlineID or nil
    for idx, row in pairs(storyLeftRows) do
        row.isSelected = (idx == 0 and not selectedID) or (row.data and row.data.id == selectedID) or false
        if row.btn then row.btn:UnlockHighlight() end
        if row.portBorder then row.portBorder:SetAlpha(row.isSelected and 1.0 or 0.5) end
        SM.ApplyStoryCardBorderState(row, false)
    end
end

function SM.ApplyIntroCompletionState(row)
    if not row or not row.btn then return end
    local allComplete = SM.AreAllStoriesFinished()

    if row.checkmark then
        row.checkmark:SetShown(allComplete)
    end
    if row.bg then
        row.bg:SetAlpha(1.0)
    end

    if row.nameLabel then
        row.nameLabel:ClearAllPoints()
        row.nameLabel:SetPoint("LEFT", row.icon or row.btn, row.icon and "RIGHT" or "LEFT", row.icon and 8 or 24, 0)
        row.nameLabel:SetPoint("RIGHT", row.btn, "RIGHT", -8, 0)
        row.nameLabel:SetPoint("CENTER", row.btn, "CENTER", 0, 0)
        row.nameLabel:SetJustifyV("MIDDLE")
    end
end

-- Portrait circle sizes (Delve companion style)
local PORT = 46
local ICON = 34

function SM.ClampLeftScrollOffset(offset)
    local range = SM.LeftScroll:GetVerticalScrollRange() or 0
    offset = offset or 0
    if offset < 0 then return 0 end
    if offset > range then return range end
    return offset
end

function SM.SaveLeftStoryScroll()
    if SM.LeftPanelMode == "story" then
        SM.LeftStoryScrollOffset = SM.LeftScroll:GetVerticalScroll() or SM.LeftStoryScrollOffset or 0
    end
end

function SM.RestoreLeftStoryScroll()
    local function apply()
        if SM.LeftPanelMode ~= "story" then return end
        SM.LeftScroll:SetVerticalScroll(SM.ClampLeftScrollOffset(SM.LeftStoryScrollOffset or 0))
    end
    if C_Timer and C_Timer.After then
        C_Timer.After(0, apply)
    else
        apply()
    end
end

-- quest: a quest card to mark on the Progress tab (a search found it).
function SM.SelectStory(index, chapterIndex, quest)
    if SM.HighlightQuestCard then SM.HighlightQuestCard(quest) end
    SM.SaveLeftStoryScroll()
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
    StoryModeDB.selectedQuestline = index
    local selectedData = storyIndexToData[index]
    StoryModeDB.selectedQuestlineID = selectedData and selectedData.id or nil
    StoryModeDB.selectedChapter = chapterIndex or 1  -- reset to first chapter when switching stories
    for i, row in pairs(storyLeftRows) do
        local sel = (i == index)
        if row.btn then row.btn:UnlockHighlight() end
        if row.coverTex then
            if SM.IsMainlineClient() then
                local hasCover = SM.SetAdventureCoverTexture(row.coverTex, row.data)
                row.coverTex:SetShown(hasCover)
                row.coverTex:SetAlpha(1)
            else
                local hasCover = SM.SetAdventureCoverTexture(row.coverTex, row.data)
                row.coverTex:SetShown(hasCover)
                row.coverTex:SetAlpha(0.72)
            end
        end
        row.isSelected = sel
        SM.ApplyStoryCardBorderState(row, false)
        if row.bg then row.bg:SetAlpha(1.0) end
        if row.portBorder then row.portBorder:SetAlpha(sel and 1.0 or 0.5) end
        if i == 0 then SM.ApplyIntroCompletionState(row) end
        local nameColor = row.nameColor or { 1.0, 1.0, 1.0 }
        local zoneColor = row.zoneColor or { 1.0, 0.82, 0.36 }
        if row.nameLabel then row.nameLabel:SetTextColor(nameColor[1], nameColor[2], nameColor[3]) end
        if row.zoneLabel then row.zoneLabel:SetTextColor(zoneColor[1], zoneColor[2], zoneColor[3]) end
        local state = row.data and SM.GetStoryState(row.data) or nil
        local gateReason = state and state.gateReason or nil
        if row.btn then row.btn.lockReason = gateReason end
        if row.checkmark and row.data then
            row.checkmark:SetShown(state and state.isFinished)
        elseif row.checkmark and row.isIntro then
            row.checkmark:SetShown(SM.AreAllStoriesFinished())
        end
    end
    if index == 0 or not selectedData then
        SM.UpdateStoryDetail(nil)
    else
        SM.UpdateStoryDetail(selectedData)
    end
end

function SM.GetStoryIndexByID(storyID)
    if not storyID then return nil end
    for idx, data in pairs(storyIndexToData) do
        if data and data.id == storyID then return idx end
    end
    return nil
end

local function RefreshStoryRow(row)
    if not row then return end
    if row.isIntro then
        SM.ApplyIntroCompletionState(row)
    elseif row.data then
        local state = SM.GetStoryState(row.data)
        local gateReason = state and state.gateReason or nil
        if row.btn then row.btn.lockReason = gateReason end
        if row.checkmark then
            row.checkmark:SetShown(state and state.isFinished)
        end
        if row.trackedBadge then
            local finished = state and state.isFinished
            row.trackedBadge:SetShown(not finished and SM.IsStoryTracked and SM.IsStoryTracked(row.data) or false)
        end
        if row.coverTex and SM.IsClassicClient() then
            row.coverTex:SetShown(SM.SetAdventureCoverTexture(row.coverTex, row.data))
        end
    end
    SM.ApplyStoryCardBorderState(row, false)
end

function SM.RebuildStoryWindow()
    if not storyContentBuilt then return end
    wipe(searchResults)
    wipe(storyKinds)
    SM.SaveLeftStoryScroll()
    for _, frame in ipairs(storyListFrames) do
        frame:Hide()
        frame:ClearAllPoints()
    end
    wipe(storyListFrames)
    wipe(storyLeftRows)
    wipe(storyIndexToData)
    storyContentBuilt = false
    SM.BuildStoryWindow()
    local currentData = SM.GetCurrentStoryData and SM.GetCurrentStoryData() or nil
    local selectedID = currentData and currentData.id or StoryModeDB and StoryModeDB.selectedQuestlineID or nil
    local selectedIndex = selectedID and SM.GetStoryIndexByID(selectedID) or nil
    if selectedIndex then
        StoryModeDB.selectedQuestline = selectedIndex
    elseif not selectedID then
        StoryModeDB.selectedQuestline = 0
    end
    ApplyCurrentSelectionState()
    SM.RestoreLeftStoryScroll()
end

local function RefreshActiveStorySection()
    if not storyContentBuilt then return false end
    local activeQuestlines = CollectActiveStorylines()
    local signature = GetActiveStoriesSignature(activeQuestlines)
    if signature == activeStoriesSignature then return false end
    SM.RebuildStoryWindow()
    return true
end

function SM.RefreshStoryListState(data)
    local rebuilt = RefreshActiveStorySection()
    if rebuilt then
        data = nil
    end
    if data then
        RefreshStoryRow(SM.GetStoryRowForData(data))
        RefreshStoryRow(storyLeftRows[0])
        ApplyCurrentSelectionState()
        return
    end
    for _, row in pairs(storyLeftRows) do
        RefreshStoryRow(row)
    end
    ApplyCurrentSelectionState()
end

local function CreateListCardFrame(cardHeight, cardPadding, yOffset, backgroundSublevel, classicShadeInset)
    local card = RememberStoryListFrame(CreateFrame("Button", nil, SM.LeftStoryChild, (SM.IsMainlineClient()) and nil or "BackdropTemplate"))
    card:SetHeight(cardHeight)
    card:SetPoint("TOPLEFT", SM.LeftStoryChild, "TOPLEFT", cardPadding, yOffset)
    card:SetPoint("TOPRIGHT", SM.LeftStoryChild, "TOPRIGHT", -cardPadding, yOffset)
    card:RegisterForClicks("AnyUp")
    if SM.IsClassicClient() then
        SM.ApplyClassicCardBackdrop(card, 0, 0.50)
    end

    local bg = card:CreateTexture(nil, "BACKGROUND", nil, backgroundSublevel)
    if SM.ForeverWindow then
        bg:Hide()  -- the Group Finder card (ForeverWindow.StyleListCard) replaces it
    elseif SM.IsMainlineClient() then
        bg:SetAtlas("housefinder_neighborhood-list-item-default", false)
        bg:SetAllPoints()
    else
        SM.ClearCardFillTexture(bg)
    end

    if SM.IsClassicClient() then
        card.shade = SM.CreateInsetCardShade(card, 0.38, classicShadeInset)
    end

    if SM.ForeverWindow then
        -- StyleListCard sets the Group Finder card's highlight.
    elseif SM.IsMainlineClient() then
        card:SetHighlightAtlas("housefinder_neighborhood-list-item-highlight")
        card:GetHighlightTexture():SetAllPoints()
    else
        SM.SetSubtleCardHover(card)
    end

    return card, bg
end

local function CreateMaskedIcon(parent, texture)
    local portFrame = CreateFrame("Frame", nil, parent)
    portFrame:SetSize(PORT, PORT)
    portFrame:SetPoint("LEFT", parent, "LEFT", 16, 0)

    local iconTex = portFrame:CreateTexture(nil, "ARTWORK")
    iconTex:SetSize(ICON, ICON)
    iconTex:SetPoint("CENTER")
    if texture then
        iconTex:SetTexture(texture)
    else
        iconTex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        iconTex:SetTexelSnappingBias(0)
        iconTex:SetSnapToPixelGrid(false)
    end

    local iconMask = portFrame:CreateMaskTexture()
    iconMask:SetTexture(
        "Interface/CHARACTERFRAME/TempPortraitAlphaMask",
        "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    iconMask:SetAllPoints(iconTex)
    iconTex:AddMaskTexture(iconMask)

    return portFrame, iconTex
end

local function GetAchievementIcon(data)
    if not data or not data.achievementID then return nil end
    local _, _, _, _, _, _, _, _, _, achIcon = GetAchievementInfo(data.achievementID)
    if achIcon and achIcon ~= 0 then return achIcon end
    return nil
end

local function ApplyFallbackStoryIcon(iconTex, data)
    if data and data.race and not data.class then
        local heritageIcon = SM.HeritageIconByRace[data.race]
        if heritageIcon and SM.SafeSetTexture(iconTex, heritageIcon) then return end
    end
    if data and data.race == "Pandaren" then
        SM.SafeSetTexture(iconTex, SM.PandarenTabardIcon)
    else
        SM.SafeSetTexture(iconTex, SM.HeritageIconFallback)
    end
end

local function ApplyStoryPortrait(iconTex, data)
    if data.portraitDisplayID then
        SetPortraitTextureFromCreatureDisplayID(iconTex, data.portraitDisplayID)
        if not iconTex:GetTexture() then
            local achievementIcon = GetAchievementIcon(data)
            if achievementIcon then iconTex:SetTexture(achievementIcon) end
            if not iconTex:GetTexture() and data.icon then
                SM.SafeSetTexture(iconTex, data.icon)
            end
            if not iconTex:GetTexture() and data.race and not data.class then
                ApplyFallbackStoryIcon(iconTex, data)
            end
        end
    elseif data.race and not data.class and data.icon then
        if not SM.SafeSetTexture(iconTex, data.icon) then
            ApplyFallbackStoryIcon(iconTex, data)
        end
    elseif data.achievementID and not data.icon then
        local achievementIcon = GetAchievementIcon(data)
        if achievementIcon then iconTex:SetTexture(achievementIcon) end
    elseif data.icon then
        if not SM.SafeSetTexture(iconTex, data.icon) then
            ApplyFallbackStoryIcon(iconTex, data)
        end
    elseif data.race and not data.class then
        ApplyFallbackStoryIcon(iconTex, data)
    end
    if not iconTex:GetTexture() and data.race and not data.class then
        ApplyFallbackStoryIcon(iconTex, data)
    end
end

local function CreateCardCompletionRibbon(parent)
    local checkmark = SM.CreateCompletionRibbon(parent)
    if SM.IsMainlineClient() then
        checkmark:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -15, -1)
    else
        checkmark:SetPoint("RIGHT", parent, "RIGHT", -18, 0)
    end
    return checkmark
end

local function GetStoryCardSubline(data)
    local zoneText = SM.GetQuestlineCardSubline(data)
    local parts = {}
    for part in zoneText:gmatch("[^/]+") do
        parts[#parts + 1] = part:match("^%s*(.-)%s*$")
    end
    -- Classic and WoW Forever name only the zone the story starts in.
    if (SM.IsClassicClient() or SM.Client.isForever) and #parts > 1 then
        return parts[1]
    elseif #parts > 2 then
        return parts[1] .. " / " .. parts[2]
    end
    return zoneText
end

local function PlacePooledCard(card, cardPadding, yOffset)
    card:ClearAllPoints()
    card:SetPoint("TOPLEFT", SM.LeftStoryChild, "TOPLEFT", cardPadding, yOffset)
    card:SetPoint("TOPRIGHT", SM.LeftStoryChild, "TOPRIGHT", -cardPadding, yOffset)
    card:Show()
    RememberStoryListFrame(card)
end

local function CreateIntroStoryCard(cardHeight, cardPadding, yOffset)
    if introRowPooled then
        PlacePooledCard(introRowPooled.btn, cardPadding, yOffset)
        storyLeftRows[0] = introRowPooled
        SM.ApplyIntroCompletionState(introRowPooled)
        return introRowPooled
    end
    local introCard, introBg = CreateListCardFrame(cardHeight, cardPadding, yOffset, 2, 4)
    local _, introIcon = CreateMaskedIcon(introCard, SM.StoryModeIconTexture)

    local introName = SM.NoShadow(introCard:CreateFontString(nil, "OVERLAY", "GameFontNormal"))
    introName:SetPoint("LEFT", introIcon, "RIGHT", 8, 0)
    introName:SetPoint("RIGHT", introCard, "RIGHT", -8, 0)
    introName:SetJustifyH("LEFT"); introName:SetJustifyV("MIDDLE")
    introName:SetMaxLines(1); introName:SetWordWrap(false)
    introName:SetText(L["Addon Name"])
    introName:SetTextColor(1.0, 1.0, 1.0)

    introCard.checkmark = CreateCardCompletionRibbon(introCard)
    introCard.checkmark:SetShown(SM.AreAllStoriesFinished())
    local nameColor
    if SM.ForeverWindow then
        -- A Group Finder card, still with Story Mode's icon and no picture.
        nameColor = SM.ForeverWindow.StyleListCard(introCard, SM.LeftStoryChild:GetWidth() - 2 * cardPadding,
            nil, introName, nil, introCard.checkmark)
    end

    local row = {
        btn       = introCard,
        bg        = introBg,
        icon      = introIcon,
        nameLabel = introName,
        zoneLabel = nil,
        checkmark = introCard.checkmark,
        isIntro   = true,
        nameColor = nameColor,
    }
    storyLeftRows[0] = row
    introRowPooled = row

    introCard:SetScript("OnClick", function() SM.SelectStory(0) end)
    introCard:SetScript("OnEnter", function()
        SM.ApplyStoryCardBorderState(row, true)
    end)
    introCard:SetScript("OnLeave", function()
        SM.ApplyStoryCardBorderState(row, false)
    end)
    SM.ApplyIntroCompletionState(row)

    return row
end

local function CreateStoryListCard(data, idx, cardHeight, cardPadding, yOffset, section)
    local pooled = cardPool[section][data]
    if pooled then
        PlacePooledCard(pooled.btn, cardPadding, yOffset)
        pooled.index = idx
        storyLeftRows[idx] = pooled
        RefreshStoryRow(pooled)
        return pooled
    end
    local card, bg = CreateListCardFrame(cardHeight, cardPadding, yOffset, 2, 4)

    local coverTex = card:CreateTexture(nil, "BACKGROUND", nil, (SM.IsMainlineClient()) and 0 or 2)
    if SM.IsMainlineClient() then
        coverTex:SetPoint("TOPLEFT", card, "TOPLEFT", 7, -7)
        coverTex:SetPoint("BOTTOMRIGHT", card, "BOTTOMRIGHT", -7, 7)
        coverTex:SetAlpha(0.78)
        coverTex:Hide()
    else
        coverTex:SetPoint("TOPLEFT", card, "TOPLEFT", 3, -3)
        coverTex:SetPoint("BOTTOMRIGHT", card, "BOTTOMRIGHT", -3, 3)
        coverTex:SetAlpha(0.72)
        coverTex:SetShown(SM.SetAdventureCoverTexture(coverTex, data))
    end

    local portFrame, iconTex = CreateMaskedIcon(card)
    ApplyStoryPortrait(iconTex, data)

    local portBorder = portFrame:CreateTexture(nil, "OVERLAY")
    if not SM.SafeSetAtlas(portBorder, "ui-frame-genericplayerchoice-portrait-border", false) then
        portBorder:Hide()
    end
    portBorder:SetPoint("TOPLEFT", iconTex, "TOPLEFT", -3, 3)
    portBorder:SetPoint("BOTTOMRIGHT", iconTex, "BOTTOMRIGHT", 3, -3)
    portBorder:SetVertexColor(1.0, 0.82, 0.5)
    portBorder:SetAlpha(0.85)
    portFrame:Hide()

    local nameLabel = SM.NoShadow(card:CreateFontString(nil, "OVERLAY", "GameFontNormal"))
    nameLabel:SetPoint("LEFT", card, "LEFT", 24, 0)
    nameLabel:SetPoint("RIGHT", card, "RIGHT", -42, 0)
    nameLabel:SetPoint("BOTTOM", card, "CENTER", 0, 1)
    nameLabel:SetJustifyH("LEFT"); nameLabel:SetJustifyV("BOTTOM")
    nameLabel:SetMaxLines(1); nameLabel:SetWordWrap(false)
    nameLabel:SetText(data.title)
    nameLabel:SetTextColor(1.0, 1.0, 1.0)

    local zoneLabel = SM.NoShadow(card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"))
    zoneLabel:SetPoint("TOPLEFT", nameLabel, "BOTTOMLEFT", 0, -2)
    zoneLabel:SetPoint("RIGHT", card, "RIGHT", -42, 0)
    zoneLabel:SetJustifyH("LEFT")
    zoneLabel:SetText(GetStoryCardSubline(data))
    zoneLabel:SetTextColor(1.0, 0.82, 0.36)

    local cardCheckmark = CreateCardCompletionRibbon(card)
    local nameColor, zoneColor
    if SM.ForeverWindow then
        nameColor, zoneColor = SM.ForeverWindow.StyleListCard(card, SM.LeftStoryChild:GetWidth() - 2 * cardPadding,
            coverTex, nameLabel, zoneLabel, cardCheckmark)
        coverTex:SetShown(SM.SetAdventureCoverTexture(coverTex, data))
    end
    local state = SM.GetStoryState(data)
    local gateReason = state and state.gateReason or nil
    card.lockReason = gateReason
    if gateReason then
        cardCheckmark:Hide()
    elseif state and state.isFinished then
        cardCheckmark:Show()
    else
        cardCheckmark:Hide()
    end

    -- The finished flag with the crosshair, where the finished flag hangs, while
    -- the story is the one the next-step tracker follows (and not finished).
    local trackedBadge = SM.CreateTrackedRibbon(card)
    trackedBadge:SetScale(cardCheckmark:GetScale())
    trackedBadge:SetPoint("CENTER", cardCheckmark, "CENTER", 0, 0)
    trackedBadge:SetShown(not cardCheckmark:IsShown() and SM.IsStoryTracked and SM.IsStoryTracked(data) or false)

    local row = {
        trackedBadge = trackedBadge,
        btn       = card,
        bg        = bg,
        coverTex  = coverTex,
        data      = data,
        portBorder= portBorder,
        nameLabel = nameLabel,
        zoneLabel = zoneLabel,
        checkmark = cardCheckmark,
        nameColor = nameColor,
        zoneColor = zoneColor,
        index     = idx,
    }
    storyLeftRows[idx] = row
    cardPool[section][data] = row

    card:SetScript("OnClick", function(self, button)
        -- Shift-left-click, as in the quest log: while typing in chat it
        -- links the story; otherwise it follows the story in the next-step
        -- tracker, in place of the one followed, or stops following it.
        if button == "LeftButton" and IsShiftKeyDown() then
            local typing = ChatEdit_GetActiveWindow and ChatEdit_GetActiveWindow()
            if typing and SM.InsertStoryChatLink(data) then return end
            if not self.lockReason and SM.ToggleTrackedStory then
                SM.ToggleTrackedStory(data)
                if SM.RefreshTrackNodeBadges then SM.RefreshTrackNodeBadges() end
                local onEnter = self:GetScript("OnEnter")
                if onEnter and self:IsMouseOver() then onEnter(self) end
            end
            return
        end
        -- Found by one of its quests: open that quest's chapter on the
        -- Progress tab, its card marked.
        local quest, chapterIndex = SM.GetStorySearchQuest(data)
        if quest and SM.SetActiveTab then
            SM.SetActiveTab("progress")
            SM.SelectStory(row.index, chapterIndex, quest)
            return
        end
        SM.SelectStory(row.index)
    end)
    card:SetScript("OnEnter", function(self)
        SM.ApplyStoryCardBorderState(row, true)
        SMTooltip:SetOwner(self, "ANCHOR_RIGHT")
        SMTooltip:ClearLines()
        if self.lockReason then
            SMTooltip:AddLine(L["Tooltip Story Locked"], 1, 1, 1)
            SMTooltip:AddLine(self.lockReason, 1.0, 0.82, 0.35, true)
        else
            -- What shift-right-click does here, in gold.
            local tracked = SM.IsStoryTracked and SM.IsStoryTracked(data)
            SMTooltip:AddLine(data.title, 1, 1, 1)
            SMTooltip:AddLine(SM.FormatHotkeys(tracked and L["Story Card Untrack"] or L["Story Card Track"]), 1.0, 0.82, 0)
        end
        SMTooltip:Show()
    end)
    card:SetScript("OnLeave", function()
        SM.ApplyStoryCardBorderState(row, false)
        SMTooltip:Hide()
    end)

    return row
end

local function AddCategoryDivider(text, yOffset, bottomPadding)
    local pooled = dividerPool[text]
    if pooled then
        pooled.frame:ClearAllPoints()
        pooled.frame:SetPoint("TOPLEFT", SM.LeftStoryChild, "TOPLEFT", 4, yOffset)
        pooled.frame:SetPoint("TOPRIGHT", SM.LeftStoryChild, "TOPRIGHT", -4, yOffset)
        pooled.frame:Show()
        RememberStoryListFrame(pooled.frame)
        return yOffset - pooled.height - bottomPadding
    end
    local divH, div = SM.CreateCatDivider(SM.LeftStoryChild, text, yOffset)
    dividerPool[text] = { frame = div, height = divH }
    RememberStoryListFrame(div)
    return yOffset - divH - bottomPadding
end

local function RenderStoryCategory(cat, activeSet, globalIdx, cardHeight, cardPadding, yOffset)
    if cat.disabled then
        return globalIdx, AddCategoryDivider(cat.displayName or cat.name, yOffset, 12)
    end
    if not CategoryHasVisibleQuestlines(cat, activeSet) then
        return globalIdx, yOffset
    end

    yOffset = AddCategoryDivider(cat.displayName or cat.name, yOffset, 4)
    for _, data in ipairs(cat.questlines) do
        if not (activeSet[data] and not cat.active) and PassesListFilter(data) then
            globalIdx = globalIdx + 1
            storyIndexToData[globalIdx] = data
            CreateStoryListCard(data, globalIdx, cardHeight, cardPadding, yOffset, cat.active and "active" or "list")
            yOffset = yOffset - cardHeight - 5
        end
    end
    return globalIdx, yOffset - 8
end


function SM.BuildStoryWindow()
    if storyContentBuilt then
        RefreshActiveStorySection()
        return
    end
    if SM.RegisterQuestlines then SM.RegisterQuestlines() end
    if SM.IsQuestlineRegistryReady and not SM.IsQuestlineRegistryReady() then return end
    storyContentBuilt = true
    if IsKindFilter(GetStatusFilter()) then kindsWanted = true end
    -- The saved filter is only known once the saved variables load, after
    -- the bar was made: name it on the button now.
    if filterDropdown and filterDropdown.GenerateMenu then filterDropdown:GenerateMenu() end
    for _, data in ipairs(allQuestlines) do SM.ResolveAchievementID(data) end
    wipe(storyIndexToData)
    local activeQuestlines, activeSet = CollectActiveStorylines()
    activeStoriesSignature = GetActiveStoriesSignature(activeQuestlines)
    local displayCategories = BuildDisplayCategories(activeQuestlines)

    local CARD_PAD = 4
    local CARD_H   = SM.ForeverWindow and SM.ForeverWindow.ListCardHeight()
        or (SM.IsMainlineClient()) and 78 or 70
    local yOffset  = -16
    local globalIdx = 0

    local filtered = IsListFiltered()
    if not filtered then
        local playerName = UnitName("player")
        yOffset = AddCategoryDivider(playerName and string.format(L["Greeting Format"], playerName) or L["Greeting Fallback"], yOffset, 4)
        CreateIntroStoryCard(CARD_H, CARD_PAD, yOffset)
        yOffset = yOffset - CARD_H - 4
    end

    for _, cat in ipairs(displayCategories) do
        if not (filtered and cat.disabled) then
            globalIdx, yOffset = RenderStoryCategory(cat, activeSet, globalIdx, CARD_H, CARD_PAD, yOffset)
        end
    end
    if filtered and globalIdx == 0 then
        if not emptyText then
            emptyText = SM.NoShadow(SM.LeftStoryChild:CreateFontString(nil, "OVERLAY", "GameFontNormal"))
            emptyText:SetJustifyH("CENTER")
            emptyText:SetText(L["Story Filter No Match"])
        end
        emptyText:ClearAllPoints()
        emptyText:SetPoint("TOPLEFT", SM.LeftStoryChild, "TOPLEFT", 16, yOffset - 24)
        emptyText:SetPoint("TOPRIGHT", SM.LeftStoryChild, "TOPRIGHT", -16, yOffset - 24)
        emptyText:Show()
        RememberStoryListFrame(emptyText)
        yOffset = yOffset - 60
    end
    SM.LeftStoryChild:SetHeight(math.abs(yOffset) + 16)
    ApplyCurrentSelectionState()
end

-- Lays the list out again for the current search and filter, from the top.
local function ApplyListFilter()
    wipe(searchResults)
    wipe(storyKinds)
    if filterDropdown and filterDropdown.GenerateMenu then filterDropdown:GenerateMenu() end
    if not storyContentBuilt then return end
    SM.LeftScroll:SetVerticalScroll(0)
    SM.RebuildStoryWindow()
end

-- The bar shows only while the left column lists stories (the Journal tab
-- puts factions there instead); the list moves down to make room for it.
function SM.SetStoryListFilterBarShown(shown)
    if not filterBar then return end
    filterBar:SetShown(shown)
    SM.LeftScroll:SetPoint("TOPLEFT", filterBar:GetParent(), "TOPLEFT", 12, shown and -FILTER_BAR_H or 0)
end

function SM.CreateStoryListFilterBar(parent, rightInset)
    if filterBar then return filterBar end
    -- The bar lines up with the cards below it: the list starts 12 in and
    -- each card sits CARD_PAD (4) inside it on both sides.
    filterBar = CreateFrame("Frame", nil, parent)
    filterBar:SetPoint("TOPLEFT", parent, "TOPLEFT", 12 + 4, -6)
    filterBar:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -((rightInset or 12) + 4), -6)
    filterBar:SetHeight(FILTER_BAR_H - 8)

    filterDropdown = CreateFrame("DropdownButton", nil, filterBar, "WowStyle1DropdownTemplate")
    filterDropdown:SetWidth(132)
    filterDropdown:SetPoint("RIGHT", filterBar, "RIGHT", 0, 0)
    -- The button names the choice; the menu also shows how many stories each holds.
    if filterDropdown.SetSelectionTranslator then
        filterDropdown:SetSelectionTranslator(function(selection)
            local key = selection.GetData and selection:GetData()
            for _, option in ipairs(STATUS_OPTIONS) do
                if option.key == key then return L[option.label] end
            end
            return L["Story Filter All"]
        end)
    end
    filterDropdown:SetupMenu(function(_, root)
        local counts = CountStoriesByStatus()
        local divided = false
        for _, option in ipairs(STATUS_OPTIONS) do
            if option.kind and not divided then
                root:CreateDivider()
                divided = true
            end
            root:CreateRadio(string.format(L["Story Filter Count Format"], L[option.label], counts[option.key] or 0),
                function() return GetStatusFilter() == option.key end,
                function()
                    StoryModeDB.storyListStatus = option.key
                    if option.kind then kindsWanted = true end
                    ApplyListFilter()
                end,
                option.key)
        end
    end)

    -- Dungeons and Raids need every story's quests loaded: start on the way
    -- to the menu, so its counts are ready (or nearly) when it opens.
    local function WantKinds()
        if kindsWanted then return end
        kindsWanted = true
        wipe(storyKinds)
        CountStoriesByStatus()
    end
    filterDropdown:HookScript("OnEnter", WantKinds)
    filterDropdown:HookScript("OnMouseDown", WantKinds)

    local search = CreateFrame("EditBox", nil, filterBar, "SearchBoxTemplate")
    search:SetHeight(20)
    search:SetPoint("LEFT", filterBar, "LEFT", 5, 0)  -- its border reaches 5 left of the box
    search:SetPoint("RIGHT", filterDropdown, "LEFT", -10, 0)
    search:SetAutoFocus(false)
    if search.Instructions then search.Instructions:SetText(L["Story Search Instructions"]) end
    search:HookScript("OnTextChanged", function(self)
        local text = strtrim(self:GetText() or ""):lower()
        local words = {}
        for word in text:gmatch("%S+") do words[#words + 1] = word end
        local key = table.concat(words, " ")
        if key == (searchWords and table.concat(searchWords, " ") or "") then return end
        searchWords = #words > 0 and words or nil
        if SM.DebounceTask then
            SM.DebounceTask("story-list-search", 0.15, ApplyListFilter)
        else
            ApplyListFilter()
        end
    end)
    filterBar.search = search

    SM.SetStoryListFilterBarShown(true)
    return filterBar
end

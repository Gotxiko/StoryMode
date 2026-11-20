local addonName, SM = ...
local L = SM.L

local function GetPlayerFaction()
    return UnitFactionGroup("player")
end

local function GetPlayerRace()
    return select(2, UnitRace("player"))
end

local function GetPlayerClass()
    return select(2, UnitClass("player"))
end

local function PlayerMatches(value, playerValue)
    if type(value) == "table" then
        for _, candidate in ipairs(value) do
            if candidate == playerValue then return true end
        end
        return false
    end
    return value == playerValue
end

function SM.GetQuestIDs(q)
    if type(q) ~= "table" then return { q } end
    if q._questIDs then return q._questIDs end
    local ids = {}
    if q.id then ids[#ids + 1] = q.id end
    if q.altIds then
        for _, id in ipairs(q.altIds) do
            ids[#ids + 1] = id
        end
    end
    return ids
end

local function GetQuestLinkColor(color)
    color = color or "ffd200"
    if color:match("^ff%x%x%x%x%x%x$") then
        color = color:sub(3)
    end
    return color
end

function SM.GetQuestChatLink(questOrID, questName, color)
    color = GetQuestLinkColor(color)
    -- Guidance quests carry no id, so GetQuestIDs returns an empty list. Keep
    -- questID nil in that case (the plain-text fallback below handles it)
    -- rather than letting `and/or` fall through to the quest table itself.
    local questID
    if type(questOrID) == "table" then
        questID = SM.GetQuestIDs(questOrID)[1]
    else
        questID = questOrID
    end
    if not questID then
        return questName and ("|cff" .. color .. questName .. "|r") or nil
    end

    if not questName and type(questOrID) == "table" then
        questName = questOrID.name or questOrID.displayName
    end
    questName = questName or (QuestUtils_GetQuestName and QuestUtils_GetQuestName(questID))
    if not questName or questName == "" then
        questName = string.format(SM.L["Quest ID Format"], tostring(questID))
    end

    local senderGUID = UnitGUID and UnitGUID("player") or "0"
    return "|Hstorymodequest:" .. questID .. ":" .. senderGUID .. "|h|cff" .. color .. "[" .. questName .. "]|r|h"
end

local function NewWeakKeyCache()
    return setmetatable({}, { __mode = "k" })
end

local progressCache = {
    allChapters = NewWeakKeyCache(),
    chapterProgress = NewWeakKeyCache(),
    campaignProgress = NewWeakKeyCache(),
    nextQuest = NewWeakKeyCache(),
}

function SM.InvalidateProgressCache()
    progressCache.allChapters = NewWeakKeyCache()
    progressCache.chapterProgress = NewWeakKeyCache()
    progressCache.campaignProgress = NewWeakKeyCache()
    progressCache.nextQuest = NewWeakKeyCache()
    if SM.InvalidateStoryStateCache then SM.InvalidateStoryStateCache() end
end

function SM.IsQuestComplete(questID)
    return SM.IsQuestFlaggedCompleted(questID)
end

function SM.IsQuestEntryComplete(q)
    for _, questID in ipairs(SM.GetQuestIDs(q)) do
        if SM.IsQuestComplete(questID) then return true end
    end
    -- A breadcrumb (breadcrumbFor = the quest it leads to) can't be taken once
    -- that quest is done, so it counts as done with it.
    if q.breadcrumbFor and SM.IsQuestComplete(q.breadcrumbFor) then return true end
    return false
end

function SM.IsQuestForPlayer(q)
    if not SM.IsContentAvailableForClient(q) then return false end
    if q.faction and q.faction ~= GetPlayerFaction() then return false end
    if q.class then
        local playerClass = GetPlayerClass()
        if not PlayerMatches(q.class, playerClass) then return false end
    end
    if q.race then
        local playerRace = GetPlayerRace()
        if not PlayerMatches(q.race, playerRace) then return false end
    end
    if q.excludeRace then
        local playerRace = GetPlayerRace()
        if PlayerMatches(q.excludeRace, playerRace) then return false end
    end
    return true
end

-- A branch the player didn't take (showIf / hideIf) hides, but never a
-- quest in the log: the player is on it, whichever branch it belongs to
-- (Valley of Bones players can start both clans' paths).
function SM.ShouldHideQuest(q)
    if (q.showIf or q.hideIf) and SM.IsQuestEntryInLog(q) then return false end
    if q.showIf then
        if not SM.IsQuestComplete(q.showIf) then return true end
    elseif q.hideIf then
        local ids = type(q.hideIf) == "table" and q.hideIf or { q.hideIf }
        for _, hid in ipairs(ids) do
            if SM.IsQuestComplete(hid) then return true end
        end
    end
    return false
end

-- ── Quest trees ──────────────────────────────────────────────────────────
-- A chapter's quests are listed in order, but they needn't be one chain:
--   parallel = true   runs alongside the step before it (same step);
--   after = id | {ids} opens once those quests are done, not the step
--                     before (a branch: the chapter splits into chains).
--   feeds = id | {ids} gets something those quests ask for, so it counts
--                     as passed once they're done.
--   untracked = true  the client can't report it done (no QuestV2 row on
--                     WoW Forever), so a later quest being done passes it.
-- Any other quest waits on the whole step before it, parallel quests
-- included. Optional quests and other factions' quests are never waited on.

local function CountsAsStep(q)
    return q ~= nil and not q.optional and SM.IsQuestForPlayer(q) and not SM.ShouldHideQuest(q)
end

local function QuestIndexByID(quests, id)
    for i, q in ipairs(quests) do
        for _, questID in ipairs(SM.GetQuestIDs(q)) do
            if questID == id then return i end
        end
    end
    return nil
end

-- What the quest at index waits on: indices of quests in the chapter, and
-- IDs of quests outside it.
function SM.GetQuestDependencies(quests, index)
    local q = quests and quests[index]
    if not q then return {}, {} end
    if q.after then
        local inside, outside = {}, {}
        for _, id in ipairs(type(q.after) == "table" and q.after or { q.after }) do
            local i = QuestIndexByID(quests, id)
            if i then inside[#inside + 1] = i else outside[#outside + 1] = id end
        end
        return inside, outside
    end
    if q.parallel then
        local lead = SM.GetQuestStepLead(quests, index)
        if lead ~= index then return SM.GetQuestDependencies(quests, lead) end
    end
    local prev = index - 1
    while prev >= 1 and not CountsAsStep(quests[prev]) do prev = prev - 1 end
    if prev < 1 then return {}, {} end
    local inside = {}
    for i = SM.GetQuestStepLead(quests, prev), prev do
        if CountsAsStep(quests[i]) then inside[#inside + 1] = i end
    end
    return inside, {}
end

-- Whether the quest at later waits, directly or down its chain, on the one
-- at target.
local function DependsOn(quests, later, target, depth)
    if depth > #quests then return false end
    for _, i in ipairs((SM.GetQuestDependencies(quests, later))) do
        if i == target or (i > target and DependsOn(quests, i, target, depth + 1)) then return true end
    end
    return false
end

function SM.IsQuestEffectivelyComplete(questIndex, chapterQuests)
    local q = chapterQuests[questIndex]
    -- Quests for the opposing faction, or hidden by a choice the player made
    -- (hideIf / showIf), are irrelevant.
    if not SM.IsQuestForPlayer(q) or SM.ShouldHideQuest(q) then return true end

    if SM.IsQuestEntryInLog(q) then return false end
    if SM.IsQuestEntryComplete(q) then return true end
    -- A quest that feeds another (gets an item that one asks for) is passed
    -- once that one is done: the item may have come another way.
    if q.feeds then
        for _, id in ipairs(type(q.feeds) == "table" and q.feeds or { q.feeds }) do
            if SM.IsQuestComplete(id) then return true end
        end
    end
    -- A quest the client can never report done (WoW Forever's QuestV2
    -- table has no row, so no completion bit, for it) is passed once any
    -- later quest of its chapter is done.
    if q.untracked then
        for i = questIndex + 1, #chapterQuests do
            local laterQuest = chapterQuests[i]
            if SM.IsQuestForPlayer(laterQuest) and not SM.ShouldHideQuest(laterQuest)
                and SM.IsQuestEntryComplete(laterQuest) then
                return true
            end
        end
    end

    for i = 1, questIndex - 1 do
        if SM.IsQuestForPlayer(chapterQuests[i]) and SM.IsQuestEntryInLog(chapterQuests[i]) then
            return false
        end
    end

    -- Passed: a later quest that waits on this one, down its chain, is done
    -- (a quest of another branch being done says nothing about this one).
    for i = questIndex + 1, #chapterQuests do
        local laterQuest = chapterQuests[i]
        if laterQuest and not laterQuest.parallel and SM.IsQuestForPlayer(laterQuest) and not SM.ShouldHideQuest(laterQuest)
            and SM.IsQuestEntryComplete(laterQuest) and DependsOn(chapterQuests, i, questIndex, 0) then
            return true
        end
    end

    return false
end

-- Whether everything the quest at index waits on is done; if not, the
-- first quest it's still waiting on.
function SM.IsQuestOpen(quests, index)
    local inside, outside = SM.GetQuestDependencies(quests, index)
    for _, i in ipairs(inside) do
        if not SM.IsQuestEffectivelyComplete(i, quests) then return false, quests[i] end
    end
    for _, id in ipairs(outside) do
        if not SM.IsQuestComplete(id) then return false, { id = id } end
    end
    return true
end

-- Explorer mode reveals a quest once it's done, in the log or passed, or
-- it's the one the story sends the player to next (nextQuestID, from
-- SM.FindNextQuest); its card shows nothing of the others. Passing an
-- optional quest doesn't reveal it: the player never saw it. The same rule
-- as the cards' (QuestCard.lua SetLegacyState).
function SM.IsQuestDiscovered(questIndex, chapterQuests, nextQuestID)
    local q = chapterQuests[questIndex]
    if SM.IsQuestEntryInLog(q) or SM.IsQuestEntryComplete(q) then return true end
    if not q.optional and SM.IsQuestEffectivelyComplete(questIndex, chapterQuests) then return true end
    if nextQuestID then
        for _, questID in ipairs(SM.GetQuestIDs(q)) do
            if questID == nextQuestID then return true end
        end
    end
    return false
end

-- ── Dungeon and raid quests ─────────────────────────────────────────────
-- A quest's kind comes from the game's own quest tag (Dungeon, Raid), or for
-- the few quests the game leaves untagged, the story data's instance field.
-- The game knows a tag once it has loaded the quest, and a quest's kind never
-- changes, so the answer is kept per account (StoryModeDB.questInstanceTypes).
local INSTANCE_TAG_TYPES = { [81] = "dungeon", [62] = "raid", [88] = "raid", [89] = "raid" }

local function IsQuestDataLoaded(questID)
    if C_QuestLog and C_QuestLog.IsQuestDataCached then
        local ok, cached = pcall(C_QuestLog.IsQuestDataCached, questID)
        if ok and cached ~= nil then return cached and true or false end
    end
    local title = C_QuestLog and C_QuestLog.GetTitleForQuestID and C_QuestLog.GetTitleForQuestID(questID)
    return title ~= nil and title ~= ""
end

-- "dungeon", "raid" or "none" for one quest ID; nil while the game hasn't
-- loaded the quest.
local function QuestIDInstanceType(questID)
    local known = StoryModeDB and StoryModeDB.questInstanceTypes
    if known and known[questID] then return known[questID] end
    if not (C_QuestLog and C_QuestLog.GetQuestTagInfo) then return "none" end
    local info = C_QuestLog.GetQuestTagInfo(questID)
    local kind = info and INSTANCE_TAG_TYPES[info.tagID]
    if not kind then
        if not IsQuestDataLoaded(questID) then return nil end
        kind = "none"
    end
    if StoryModeDB then
        StoryModeDB.questInstanceTypes = StoryModeDB.questInstanceTypes or {}
        StoryModeDB.questInstanceTypes[questID] = kind
    end
    return kind
end

-- "dungeon", "raid" or "none" for a story quest. nil while the game still has
-- to load some of its IDs, which come second (a list) so they can be loaded.
function SM.GetQuestInstanceType(q)
    if q.instance then return q.instance end
    local unknown
    for _, questID in ipairs(SM.GetQuestIDs(q)) do
        local kind = QuestIDInstanceType(questID)
        if kind == "dungeon" or kind == "raid" then return kind end
        if kind == nil then
            unknown = unknown or {}
            unknown[#unknown + 1] = questID
        end
    end
    if unknown then return nil, unknown end
    return "none"
end

function SM.IsQuestInLog(questID)
    return SM.GetLogIndexForQuestID(questID) ~= nil
end

function SM.IsQuestEntryInLog(q)
    for _, questID in ipairs(SM.GetQuestIDs(q)) do
        if SM.IsQuestInLog(questID) then return true, questID end
    end
    return false, nil
end

function SM.IsStoryActive(data)
    if not data then return false end
    for _, ch in ipairs(SM.GetAllChapters(data)) do
        if ch.quests then
            for _, q in ipairs(ch.quests) do
                if SM.IsQuestForPlayer(q) and not SM.ShouldHideQuest(q) and SM.IsQuestEntryInLog(q) then
                    return true
                end
            end
        end
    end
    return false
end

function SM.GetAllChapters(data)
    if progressCache.allChapters[data] then return progressCache.allChapters[data] end
    local all = {}
    local playerFaction = GetPlayerFaction()

    local function ShouldShowChapter(ch)
        if not SM.IsContentAvailableForClient(ch) then return false end
        return not ch.faction or ch.faction == playerFaction
    end

    if data.prereqs then
        for _, ch in ipairs(data.prereqs) do
            if ShouldShowChapter(ch) then
                ch._section = 1
                all[#all + 1] = ch
            end
        end
    end
    if data.chapters then
        for _, ch in ipairs(data.chapters) do
            if ShouldShowChapter(ch) then
                ch._section = 2
                all[#all + 1] = ch
            end
        end
    end
    if data.insurrection then
        for _, ch in ipairs(data.insurrection) do
            if ShouldShowChapter(ch) then
                ch._section = 3
                all[#all + 1] = ch
            end
        end
    end
    if #all == 0 and data.startQuest then
        all[#all + 1] = {
            chapter = data.title,
            summary = data.description,
            recap = data.description,
            quests = { data.startQuest },
            _section = 2,
        }
    end
    progressCache.allChapters[data] = all
    return all
end

function SM.GetStoryAchievements(data)
    local ids, seen = {}, {}
    local function add(id)
        if type(id) == "string" then
            local target = id:lower()
            for scan = 1, 50000 do
                local _, scanName = GetAchievementInfo(scan)
                if scanName and scanName:lower() == target then id = scan; break end
            end
            if type(id) ~= "number" then return end
        end
        if id and not seen[id] then
            seen[id] = true
            local _, name = GetAchievementInfo(id)
            if name then ids[#ids + 1] = id end
        end
    end

    if data.achievements then
        for _, id in ipairs(data.achievements) do add(id) end
    else
        add(data.achievementID)
    end
    for _, ch in ipairs(SM.GetAllChapters(data)) do
        add(ch.achievementID)
    end
    return ids
end

function SM.GetStoryFactions(data)
    if not data then return nil end
    if SM.IsClassicClient() then return nil end
    local faction = GetPlayerFaction()
    return (data.factionsByFaction and data.factionsByFaction[faction]) or data.factions
end

function SM.GetChapterProgress(ch)
    local cached = progressCache.chapterProgress[ch]
    if cached then return cached.done, cached.total end
    local currentStoryData = ch and ch._story or (SM.GetCurrentStoryData and SM.GetCurrentStoryData())

    if ch.loreOnly then
        if currentStoryData and SM.IsLoreChapterViewed(currentStoryData.title, ch.chapter) then
            progressCache.chapterProgress[ch] = { done = 1, total = 1 }
            return 1, 1
        end
        progressCache.chapterProgress[ch] = { done = 0, total = 0 }
        return 0, 0
    end
    if ch.replayable and currentStoryData and SM.IsChapterPlayed(currentStoryData.title, ch.chapter) then
        progressCache.chapterProgress[ch] = { done = 1, total = 1 }
        return 1, 1
    end

    local total, done = 0, 0
    local optionalTotal, optionalDone = 0, 0
    for i, q in ipairs(ch.quests or {}) do
        if SM.IsQuestForPlayer(q) and not SM.ShouldHideQuest(q) then
            if q.optional then
                optionalTotal = optionalTotal + 1
                if SM.IsQuestEntryComplete(q) then optionalDone = optionalDone + 1 end
            else
                total = total + 1
                if SM.IsQuestEffectivelyComplete(i, ch.quests) then done = done + 1 end
            end
        end
    end

    if total == 0 and optionalTotal > 0 then
        progressCache.chapterProgress[ch] = { done = optionalDone, total = optionalTotal }
        return optionalDone, optionalTotal
    end

    if total > 0 then
        progressCache.chapterProgress[ch] = { done = done, total = total }
        return done, total
    end

    if ch.achievementID then
        local _, _, _, completed = GetAchievementInfo(ch.achievementID)
        if completed then
            progressCache.chapterProgress[ch] = { done = 1, total = 1 }
            return 1, 1
        end
    end
    if ch.completionAchievementID then
        local _, _, _, completed = GetAchievementInfo(ch.completionAchievementID)
        if completed then
            progressCache.chapterProgress[ch] = { done = 1, total = 1 }
            return 1, 1
        end
    end

    progressCache.chapterProgress[ch] = { done = 0, total = 0 }
    return 0, 0
end

-- A chapter's quests done and in all for display, optional ones included, as
-- the story's count has them. Whether the chapter is finished stays
-- GetChapterProgress's call, from its required quests alone.
function SM.GetChapterQuestCount(ch)
    local done, total = SM.GetChapterProgress(ch)
    if ch.loreOnly or ch.replayable then return done, total end
    local required, optionalTotal, optionalDone = 0, 0, 0
    for _, q in ipairs(ch.quests or {}) do
        if SM.IsQuestForPlayer(q) and not SM.ShouldHideQuest(q) then
            if q.optional then
                optionalTotal = optionalTotal + 1
                if SM.IsQuestEntryComplete(q) then optionalDone = optionalDone + 1 end
            else
                required = required + 1
            end
        end
    end
    -- With no required quests, GetChapterProgress already counts the optional ones.
    if required == 0 then return done, total end
    return done + optionalDone, total + optionalTotal
end

-- The story's quests done and in all, optional ones included, so the count
-- still shows what's left after the story is finished. Whether it is
-- finished is FindNextQuest's call, which skips optional quests.
function SM.GetCampaignProgress(data)
    local cached = progressCache.campaignProgress[data]
    if cached then return cached.done, cached.total end
    local total, done = 0, 0
    for _, ch in ipairs(SM.GetAllChapters(data)) do
        for _, q in ipairs(ch.quests or {}) do
            if SM.IsQuestForPlayer(q) and not SM.ShouldHideQuest(q) then
                total = total + 1
                if SM.IsQuestEntryComplete(q) then done = done + 1 end
            end
        end
    end

    progressCache.campaignProgress[data] = { done = done, total = total }
    return done, total
end

function SM.GetFirstUnmetChapterPrerequisite(ch)
    if not ch or not ch.prerequisites then return nil end
    for _, req in ipairs(ch.prerequisites) do
        if req.id and not SM.IsQuestComplete(req.id) and not SM.IsQuestInLog(req.id) then
            return req
        end
    end
    return nil
end

function SM.GetQuestLockReason(data, ch, questIndex)
    if not data or not ch then return nil end

    local function Highlight(text)
        return "|cffffd200" .. text .. "|r"
    end

    local function QuestLink(quest)
        return SM.GetQuestChatLink(quest, quest and quest.name)
    end

    local playerLevel = UnitLevel("player") or 0
    if data.requiredLevel and playerLevel < data.requiredLevel then
        return string.format(L["Lock Required Level Format"], data.requiredLevel)
    end
    if ch.requiredLevel and playerLevel < ch.requiredLevel then
        return string.format(L["Lock Required Level Format"], ch.requiredLevel)
    end

    local unmetPrereq = SM.GetFirstUnmetChapterPrerequisite(ch)
    if unmetPrereq then
        local questName = QuestLink(unmetPrereq)
        if unmetPrereq.npc and unmetPrereq.npc ~= "" then
            return string.format(L["Lock Pick Up Quest Format"], questName, Highlight(unmetPrereq.npc))
        end
        return string.format(L["Lock Complete Quest Format"], questName)
    end

    -- Locked until what it waits on is done: the step before (all of it),
    -- or the quests it opens after (a branch).
    if questIndex and ch.quests then
        local open, waitingOn = SM.IsQuestOpen(ch.quests, questIndex)
        if not open and waitingOn then
            return string.format(L["Lock Complete Previous Quest Format"], QuestLink(waitingOn))
        end
    end

    return nil
end

function SM.GetQuestlineGateReason(data, ch)
    if not data then return nil end

    local playerLevel = UnitLevel("player") or 0
    if data.requiredLevel and playerLevel < data.requiredLevel then
        return string.format(L["Lock Required Level Format"], data.requiredLevel)
    end
    if ch and ch.requiredLevel and playerLevel < ch.requiredLevel then
        return string.format(L["Lock Required Level Format"], ch.requiredLevel)
    end

    return nil
end

-- Whether the story's prologue (data.prereqs) has been started, which opens
-- its main chapters.
local function HasPrereqProgress(data)
    if not data.prereqs then return true end
    for _, ch in ipairs(data.prereqs) do
        if SM.GetChapterProgress(ch) > 0 then return true end
    end
    return false
end

-- One chapter's next step: the quest it has in the log ("log"), or the one
-- it's ready for ("ready"), or nil when it has none right now.
local function ChapterCandidate(ch, chIdx, hasPrereqProgress)
    local unmetPrereq = SM.GetFirstUnmetChapterPrerequisite(ch)
    if unmetPrereq then
        return {
            quest = {
                id = unmetPrereq.id,
                name = unmetPrereq.name,
                npc = unmetPrereq.npc,
                _isPrerequisiteForChapter = ch.chapter,
            },
            chapter = ch.chapter,
            chapterData = ch,
            section = ch._section or 1,
            depth = 0,
            order = chIdx,
        }, "ready"
    end
    local chDone, chTotal = SM.GetChapterProgress(ch)
    if chDone >= chTotal then return nil end
    local section = ch._section or 1
    local function Candidate(q, j)
        return { quest = q, chapter = ch.chapter, chapterData = ch, section = section, depth = j, order = chIdx }
    end
    for j, q in ipairs(ch.quests or {}) do
        if not SM.IsQuestForPlayer(q) or SM.ShouldHideQuest(q) then
            -- skip the opposing faction's variant, or a branch the player didn't take
        elseif SM.IsQuestEntryInLog(q) then
            return Candidate(q, j), "log"
        elseif not SM.IsQuestEffectivelyComplete(j, ch.quests) then
            if j == 1 then
                if (section >= 2 and hasPrereqProgress)
                    or (section == 1 and chDone == 0 and not hasPrereqProgress) then
                    return Candidate(q, j), "ready"
                end
                return nil
            elseif SM.IsQuestOpen(ch.quests, j) then
                return Candidate(q, j), "ready"
            end
            -- Not open yet: a quest further down may be (another branch).
        end
    end
    return nil
end

-- Quests marked parallel run alongside the step before them (the Valor
-- family's four weapons, say): a step and the parallel quests right after
-- it are one step. The index of the step a quest belongs to.
function SM.GetQuestStepLead(quests, index)
    local i = index
    while i > 1 and quests[i] and quests[i].parallel do i = i - 1 end
    return i
end

-- The next quest of one chapter, for the next-step tracker. strict: only
-- what the story itself would offer now (a quest in the log, or one ready
-- to take), which makes the chapter "open". Otherwise a chapter the story
-- wouldn't send the player to yet still names its first unfinished quest:
-- the player chose to track it. Returns nil once the chapter is done.
function SM.FindChapterNextQuest(data, ch, strict)
    if not (data and ch) then return nil end
    local candidate = ChapterCandidate(ch, ch._chapterIndex or 1, HasPrereqProgress(data))
    if candidate then return candidate.quest end
    if strict then return nil end
    local chDone, chTotal = SM.GetChapterProgress(ch)
    if chDone >= chTotal then return nil end
    for j, q in ipairs(ch.quests or {}) do
        if SM.IsQuestForPlayer(q) and not SM.ShouldHideQuest(q) and not SM.IsQuestEffectivelyComplete(j, ch.quests) then
            return q
        end
    end
    return nil
end

function SM.FindNextQuest(data)
    local cached = progressCache.nextQuest[data]
    if cached then
        return cached.quest, cached.chapter, cached.chapterData
    end
    local chapters = SM.GetAllChapters(data)
    local hasPrereqProgress = HasPrereqProgress(data)

    local logCandidates = {}
    local readyCandidates = {}

    for chIdx, ch in ipairs(chapters) do
        -- Optional chapters remain visible in the track, but they do not keep
        -- the main story CTA from reaching "Story Finished".
        if not ch.optional then
            local candidate, kind = ChapterCandidate(ch, chIdx, hasPrereqProgress)
            if kind == "log" then
                logCandidates[#logCandidates + 1] = candidate
            elseif kind == "ready" then
                readyCandidates[#readyCandidates + 1] = candidate
            end
        end
    end

    table.sort(logCandidates, function(a, b)
        if a.section ~= b.section then return a.section < b.section end
        if a.order ~= b.order then return a.order < b.order end
        return a.depth < b.depth
    end)

    table.sort(readyCandidates, function(a, b)
        if a.section ~= b.section then return a.section < b.section end
        if a.order ~= b.order then return a.order < b.order end
        return a.depth < b.depth
    end)

    if #logCandidates > 0 then
        local best = logCandidates[1]
        progressCache.nextQuest[data] = { quest = best.quest, chapter = best.chapter, chapterData = best.chapterData }
        return best.quest, best.chapter, best.chapterData
    end
    if #readyCandidates > 0 then
        local best = readyCandidates[1]
        progressCache.nextQuest[data] = { quest = best.quest, chapter = best.chapter, chapterData = best.chapterData }
        return best.quest, best.chapter, best.chapterData
    end

    progressCache.nextQuest[data] = { quest = nil, chapter = nil, chapterData = nil }
    return nil, nil
end

-- Whether the player has reached a chapter: it's done or under way (a quest
-- turned in or in the log), or it's where the story sends them next. Chapters
-- you watch or replay instead of quest through always count, since their
-- summary says what to do.
function SM.IsChapterReached(data, ch)
    if not (data and ch) then return false end
    if ch.loreOnly or ch.replayable then return true end
    if SM.GetChapterProgress(ch) > 0 then return true end
    for _, q in ipairs(ch.quests or {}) do
        if SM.IsQuestForPlayer(q) and SM.IsQuestEntryInLog(q) then return true end
    end
    local _, _, nextChapter = SM.FindNextQuest(data)
    if nextChapter then return nextChapter == ch end
    return SM.GetAllChapters(data)[1] == ch
end

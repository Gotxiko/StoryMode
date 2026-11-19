local addonName, SM = ...
local L = SM.L

local function EnsureTrivialQuestsVisible()
    for i = 1, SM.GetNumTrackingTypes() do
        local info = SM.GetTrackingInfo(i)
        if info and not info.active then
            local isTrivial = (MINIMAP_TRACKING_TRIVIAL_QUESTS and info.name == MINIMAP_TRACKING_TRIVIAL_QUESTS)
                or info.name == "Trivial Quests"
                or info.name == "Low Level Quests"
            if isTrivial then
                local idx, name = i, info.name
                C_Timer.After(0, function()
                    SM.SetTracking(idx, true)
                    print(L["Addon Prefix"] .. string.format(L["Tracking Enabled Trivial Format"], name))
                end)
                return
            end
        end
    end
end

-- On WoW Forever the player decides whether Story Mode marks the map: it
-- adds a waypoint, makes a quest the tracked one or turns on trivial quest
-- tracking only while the world map's Quest Objectives filter is on.
-- Track Quest still watches the quest and opens the map at the spot.
local function MapPinsWanted()
    if not (SM.Client and SM.Client.isForever) then return true end
    local value = GetCVar and GetCVar("questPOI")
    return value == nil or value == "1"
end

-- Map data provider for the "begin tracking" ping. We can't parent an insecure
-- frame to WorldMapFrame.ScrollContainer.Child directly — that taints the secure
-- canvas and propagates into AreaPOI tooltip widgets. Going through a proper
-- MapCanvasDataProvider with a pin template is the supported path.

local hasMapCanvasPins = CreateFromMixins and MapCanvasPinMixin and MapCanvasDataProviderMixin
local GetPingProvider

if hasMapCanvasPins then
    StoryModePingPinMixin = CreateFromMixins(MapCanvasPinMixin)

function StoryModePingPinMixin:OnLoad()
    self:UseFrameLevelType("PIN_FRAME_LEVEL_AREA_POI")
    self:SetIgnoreGlobalPinScale(true)
    self.anim:SetScript("OnFinished", function()
        local map = self:GetMap()
        if map then map:RemovePin(self) end
    end)
end

function StoryModePingPinMixin:OnAcquired(x, y)
    self:SetPosition(x, y)
    self:SetAlpha(1)
    self.anim:Stop()
    self.anim:Play()
end

function StoryModePingPinMixin:OnReleased()
    self.anim:Stop()
end

local PingDataProviderMixin = CreateFromMixins(MapCanvasDataProviderMixin)

function PingDataProviderMixin:GetPinTemplate()
    return "StoryModePingPinTemplate"
end

function PingDataProviderMixin:RemoveAllData()
    self:GetMap():RemoveAllPinsByTemplate(self:GetPinTemplate())
end

function PingDataProviderMixin:RefreshAllData(fromOnShow)
    self:RemoveAllData()
    if self.pendingX and self.pendingY then
        self:GetMap():AcquirePin(self:GetPinTemplate(), self.pendingX, self.pendingY)
        self.pendingX, self.pendingY = nil, nil
    end
end

function PingDataProviderMixin:Ping(x, y)
    self.pendingX, self.pendingY = x, y
    self:RefreshAllData()
end

local pingProvider
GetPingProvider = function()
    if pingProvider then return pingProvider end
    if not WorldMapFrame then return nil end
    pingProvider = CreateFromMixins(PingDataProviderMixin)
    WorldMapFrame:AddDataProvider(pingProvider)
    return pingProvider
end
end

local function OpenStoryMap(mapID)
    if WorldMapFrame then
        if not WorldMapFrame:IsShown() then
            if ToggleWorldMap then
                ToggleWorldMap()
            elseif ShowUIPanel then
                ShowUIPanel(WorldMapFrame)
            else
                WorldMapFrame:Show()
            end
        end

        if mapID and WorldMapFrame.SetMapID then
            WorldMapFrame:SetMapID(mapID)
        elseif mapID and C_Map and C_Map.OpenWorldMap then
            C_Map.OpenWorldMap(mapID)
        end
        return true
    end

    if OpenWorldMap then
        OpenWorldMap(mapID)
        return true
    elseif ToggleWorldMap then
        ToggleWorldMap()
        return true
    end
    return false
end

local function PingOnWorldMap(mapID, x, y)
    if not WorldMapFrame then return end
    OpenStoryMap(mapID)
    PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_SUPER_TRACK_ON or 167425)

    -- Explorer mode opens the map without the gold ping on the spot.
    if SM.IsExplorerMode and SM.IsExplorerMode() then return end
    if not hasMapCanvasPins then return end
    local provider = GetPingProvider()
    if not provider then return end

    -- Defer so the canvas has finished switching to mapID before we acquire a pin.
    C_Timer.After(0.15, function()
        if not WorldMapFrame:IsShown() then return end
        provider:Ping(x, y)
    end)
end

-- Ask Blizzard where the quest's icon actually sits on the map. Works for
-- accepted quests (next-waypoint API) and for offered quests visible on the
-- given map (GetQuestsOnMap). Returns nil if the engine doesn't know.
local function GetLiveQuestLocation(qid, mapHint)
    if not qid then return nil end

    if C_QuestLog and C_QuestLog.GetQuestUiMapID then
        local mapID = C_QuestLog.GetQuestUiMapID(qid)
        if mapID and mapID > 0 and C_QuestLog.GetNextWaypointForMap then
            local x, y = C_QuestLog.GetNextWaypointForMap(qid, mapID)
            if x and y then return { mapID = mapID, x = x, y = y } end
        end
    end

    if mapHint and C_QuestLog and C_QuestLog.GetQuestsOnMap then
        local quests = C_QuestLog.GetQuestsOnMap(mapHint)
        if quests then
            for _, q in ipairs(quests) do
                if q.questID == qid and q.x and q.y then
                    return { mapID = mapHint, x = q.x, y = q.y }
                end
            end
        end
    end

    return nil
end

local function GetTrackedQuestID(quest)
    if not quest then return nil end
    local _, activeID = SM.IsQuestEntryInLog(quest)
    return activeID or quest.id
end

-- Explorer mode: a step with no giver starts from something found in the
-- world (an item, a body, a ghost's drop). Until it's picked up, the story
-- names only its zone and sets no waypoint, so finding it is the player's.
function SM.IsExplorerHiddenStart(quest)
    if not (quest and SM.IsExplorerMode and SM.IsExplorerMode()) then return false end
    if quest.npc and quest.npc ~= "" then return false end
    if SM.IsQuestEntryInLog(quest) or SM.IsQuestEntryComplete(quest) then return false end
    return true
end

local function LastPart(location)
    local area = location and location:match(".*,%s*(.-)%s*$")
    if area and area ~= "" then return area end
    return nil
end

local function MapName(mapID)
    local info = mapID and C_Map and C_Map.GetMapInfo
        and C_Map.GetMapInfo(SM.GetClientMapID and SM.GetClientMapID(mapID) or mapID)
    return info and info.name or nil
end

-- Roughly where a step happens, for Explorer mode: the zone part of its
-- location (the text after the last comma, "..., Bosque del Ocaso"), its
-- map's zone, its giver's map's zone or place, else the story's zone.
function SM.GetExplorerStartArea(data, quest)
    if not quest then return data and data.zone or nil end
    local npc = data and data.npcLocations and quest.npc and data.npcLocations[quest.npc]
    return LastPart(quest.location) or MapName(quest.mapID)
        or (npc and (MapName(npc.mapID) or LastPart(npc.location)))
        or (data and data.zone) or nil
end

-- What the tracker says under a step in Explorer mode when the step has no
-- hint: the chapter's description (the tracker only lists chapters the
-- player has reached there), else roughly where to look, never who or
-- exactly where.
function SM.GetExplorerFallbackHint(data, quest, chapter)
    local summary = chapter and SM.GetChapterText and SM.GetChapterText(chapter, "summary")
    if summary and summary ~= "" then return summary end
    local area = SM.GetExplorerStartArea(data, quest)
    local hasGiver = quest and quest.npc and quest.npc ~= ""
    if area and area ~= "" then
        return string.format(hasGiver and L["Explorer Hint Giver Format"] or L["Explorer Hint Search Format"], area)
    end
    return L["Explorer Hint Explore"]
end

local function GetQuestLocation(data, quest)
    local hidden = SM.IsExplorerHiddenStart(quest)
    local questLocation = not hidden and quest.mapID and quest.x and quest.y
        and SM.GetClientLocation({ mapID = quest.mapID, x = quest.x, y = quest.y }) or nil
    local npcLocation = data.npcLocations and SM.GetClientLocation(data.npcLocations[quest.npc]) or nil
    local mapHint = (questLocation and questLocation.mapID)
        or (npcLocation and npcLocation.mapID)
        or SM.GetClientMapID(data.startMapID)
    local qid = GetTrackedQuestID(quest)
    local live = GetLiveQuestLocation(qid, mapHint)
    if live then return live end

    if questLocation then return questLocation end

    if npcLocation then return npcLocation end

    if data.startQuest and quest.id == data.startQuest.id and data.startMapID and data.startX and data.startY then
        return SM.GetClientLocation({ mapID = data.startMapID, x = data.startX, y = data.startY })
    end

    return nil
end

local function IsGuidanceQuestPending(guidanceQuest)
    if type(guidanceQuest) ~= "table" then return false end
    if guidanceQuest.id and SM.IsQuestComplete(guidanceQuest.id) then return false end
    return true
end

local function GetQuestGuidanceOverride(quest)
    if type(quest) ~= "table" then return nil end
    if SM.IsQuestEntryInLog(quest) then return nil end
    if quest.id and SM.IsQuestComplete(quest.id) then return nil end

    if type(quest.guidanceQuests) == "table" then
        for _, guidanceQuest in ipairs(quest.guidanceQuests) do
            if IsGuidanceQuestPending(guidanceQuest) then
                return guidanceQuest
            end
        end
    end

    local guidanceQuest = quest.guidanceQuest
    if IsGuidanceQuestPending(guidanceQuest) then return guidanceQuest end
    return nil
end

local function TrackResult(kind, questID, loc, openedQuestLog, questOverride)
    return {
        kind = kind,
        questID = questID,
        mapID = loc and loc.mapID or nil,
        location = loc,
        openedQuestLog = openedQuestLog == true,
        quest = questOverride,
    }
end

-- quiet: set the waypoint and focus the quest, but open no map or quest log
-- (the next-step tracker's click, made while playing).
function SM.SetWaypointForQuest(data, quest, quiet)
    if not quest then return TrackResult("no_location") end
    local function Ping(mapID, x, y)
        if not quiet then PingOnWorldMap(mapID, x, y) end
    end
    -- Begin/Continue Story and /sm track all come through here, so this is
    -- where the next-step tracker learns which story to follow.
    if data and data.id and SM.SetFollowedStoryID then
        SM.SetFollowedStoryID(data.id)
        -- A chapter the player untracked comes back when they continue it.
        if quest._chapter and SM.GetChapterTrackState and SM.GetChapterTrackState(data, quest._chapter) == false then
            SM.SetChapterTrackState(data, quest._chapter, nil)
        end
        if SM.RefreshNextStepTracker then SM.RefreshNextStepTracker() end
        if SM.RefreshStoryListState then SM.RefreshStoryListState() end
        if SM.RefreshTrackNodeBadges then SM.RefreshTrackNodeBadges() end
    end

    if SM.IsClassicClient() then
        local inLog, activeQuestID = SM.IsQuestEntryInLog(quest)
        if inLog then
            if activeQuestID and SM.OpenQuestLogToQuest(activeQuestID) then
                return TrackResult("classic_in_log_opened", activeQuestID, nil, true)
            end
            return TrackResult("classic_in_log", activeQuestID)
        end
        local guidanceQuest = GetQuestGuidanceOverride(quest)
        if guidanceQuest then
            return TrackResult("classic_guidance", nil, GetQuestLocation(data, guidanceQuest), false, guidanceQuest)
        end
        return TrackResult("classic_guidance", GetTrackedQuestID(quest))
    end

    local pinsWanted = MapPinsWanted()
    if pinsWanted then EnsureTrivialQuestsVisible() end

    local inLog, logQuestID = SM.IsQuestEntryInLog(quest)
    if inLog then
        local qid = GetTrackedQuestID(quest)
        SM.AddQuestWatch(qid)
        if pinsWanted and C_SuperTrack and C_SuperTrack.SetSuperTrackedQuestID then
            C_SuperTrack.SetSuperTrackedQuestID(qid)
        end
        -- On WoW Forever the quest opens in the quest log beside the map, as
        -- it does on Classic. Its details turn the map to the quest's zone and
        -- close when the map moves on, so the ping only goes on that map.
        local opened = not quiet and SM.Client.isForever and SM.OpenQuestLogToQuest(logQuestID or qid) or false
        local loc = GetQuestLocation(data, quest)
        local shownMapID = opened and WorldMapFrame and WorldMapFrame.GetMapID and WorldMapFrame:GetMapID()
        if loc and (not opened or shownMapID == loc.mapID) then
            Ping(loc.mapID, loc.x, loc.y)
        end
        -- Not followed without map pins, so it points to the quest log.
        return TrackResult(pinsWanted and "supertracked" or "classic_in_log", qid, loc, opened)
    end

    local guidanceQuest = GetQuestGuidanceOverride(quest)
    local trackQuest = guidanceQuest or quest
    local loc = GetQuestLocation(data, trackQuest)
    local qid = GetTrackedQuestID(trackQuest)

    if pinsWanted and qid and C_SuperTrack and C_SuperTrack.SetSuperTrackedMapPin
        and Enum and Enum.SuperTrackingMapPinType and Enum.SuperTrackingMapPinType.QuestOffer then
        C_SuperTrack.SetSuperTrackedMapPin(Enum.SuperTrackingMapPinType.QuestOffer, qid)
    end

    if pinsWanted and loc and C_Map and C_Map.CanSetUserWaypointOnMap and C_Map.CanSetUserWaypointOnMap(loc.mapID)
        and UiMapPoint and C_Map.SetUserWaypoint then
        local point = UiMapPoint.CreateFromCoordinates(loc.mapID, loc.x, loc.y)
        C_Map.SetUserWaypoint(point)
        if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
            C_SuperTrack.SetSuperTrackedUserWaypoint(true)
        end
        Ping(loc.mapID, loc.x, loc.y)
        return TrackResult("waypoint", qid, loc, false, guidanceQuest)
    end

    if loc then
        Ping(loc.mapID, loc.x, loc.y)
        return TrackResult("waypoint_approx", qid, loc, false, guidanceQuest)
    end

    local startMapID = not quiet and SM.GetClientMapID(data.startMapID)
    if startMapID then
        OpenStoryMap(startMapID)
    end
    return TrackResult("no_location", qid, nil, false, guidanceQuest)
end

local function GetZoneName(mapID)
    local info = mapID and C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
    return info and info.name or nil
end

local TRACK_LOCATION_COLOR = "|cffffffff"
local TRACK_NPC_COLOR = "|cffffd200"

local function ColorTrackingNPC(text)
    return text and (TRACK_NPC_COLOR .. text .. "|r") or nil
end

local function ColorTrackingLocation(text)
    return text and (TRACK_LOCATION_COLOR .. text .. "|r") or nil
end

local function GetLocationText(data, quest, loc)
    if SM.IsExplorerHiddenStart(quest) then
        return ColorTrackingLocation(SM.GetExplorerStartArea(data, quest))
    end
    if quest and quest.location then
        return ColorTrackingLocation(quest.location)
    end

    if loc and loc.location then
        return ColorTrackingLocation(L[loc.location] or loc.location)
    end

    local zone = loc and GetZoneName(loc.mapID) or nil
    if zone then
        return ColorTrackingLocation(zone)
    end

    if data and data.startQuest and quest and quest.id == data.startQuest.id and data.startQuest.location then
        return ColorTrackingLocation(data.startQuest.location)
    end

    return nil
end

local function GetTrackingHintText(quest, printQuest)
    if not printQuest then return nil end
    if printQuest.trackingHintFormat then
        local linkedQuest = printQuest.trackingHintQuestID or printQuest or quest
        local linkedQuestName = printQuest.trackingHintQuestName or printQuest.name or (quest and quest.name)
        local Q = SM.GetQuestChatLink(linkedQuest, linkedQuestName)
        local place = ColorTrackingLocation(printQuest.trackingHintPlace)
        local npc = ColorTrackingNPC(printQuest.trackingHintNPC)
        local destination = ColorTrackingLocation(printQuest.trackingHintDestination)
        return string.format(L[printQuest.trackingHintFormat] or printQuest.trackingHintFormat, Q or "", place or "", npc or "", destination or "")
    end
    return printQuest.trackingHint
end

function SM.PrintTrackResult(result, quest, data)
    local resultKind = type(result) == "table" and result.kind or result
    local printQuest = type(result) == "table" and result.quest or nil
    printQuest = printQuest or quest
    local P = L["Addon Prefix"]
    local trackingHint = GetTrackingHintText(quest, printQuest)
    if trackingHint then
        print(P .. trackingHint)
        return
    end
    local loc = type(result) == "table" and result.location or GetQuestLocation(data, printQuest)
    local zone = loc and GetZoneName(loc.mapID) or nil
    local place = GetLocationText(data, printQuest, loc)
    local Q = SM.GetQuestChatLink(printQuest, printQuest.name)
    local NPC = ColorTrackingNPC(printQuest.npc)
    local Z = zone and ("|cff64b5f6" .. zone .. "|r") or nil
    local CH = printQuest._isPrerequisiteForChapter and ("|cffffd200" .. printQuest._isPrerequisiteForChapter .. "|r") or nil

    if resultKind == "classic_in_log" or resultKind == "classic_in_log_opened" then
        print(P .. string.format(L["Tracking Classic In Log Format"], Q))
    elseif resultKind == "classic_guidance" then
        if CH then
            if place then
                print(P .. string.format(L["Tracking Classic Prereq Place Format"], CH, Q, place))
            else
                print(P .. string.format(L["Tracking Prereq Format"], CH, Q))
            end
            return
        elseif NPC and place then
            print(P .. string.format(L["Tracking Classic Find NPC Place Format"], NPC, place, Q))
        elseif NPC then
            print(P .. string.format(L["Tracking Classic Find NPC Format"], NPC, Q))
        elseif place then
            print(P .. string.format(L["Tracking Classic Find Place Format"], place, Q))
        else
            print(P .. string.format(L["Tracking Classic Begin Format"], Q))
        end
    elseif resultKind == "supertracked" then
        if NPC and place then
            print(P .. string.format(L["Tracking Now Following NPC Place Format"], Q, NPC, place))
        elseif NPC and Z then
            print(P .. string.format(L["Tracking Now Following NPC Zone Format"], Q, NPC, Z))
        else
            print(P .. string.format(L["Tracking Now Following Format"], Q))
        end
    elseif resultKind == "waypoint" or resultKind == "waypoint_approx" then
        if CH then
            if place then
                print(P .. string.format(L["Tracking Classic Prereq Place Format"], CH, Q, place))
            elseif Z then
                print(P .. string.format(L["Tracking Prereq Zone Format"], CH, Q, Z))
            else
                print(P .. string.format(L["Tracking Prereq Format"], CH, Q))
            end
            return
        end
        if NPC and place then
            print(P .. string.format(L["Tracking Classic Find NPC Place Format"], NPC, place, Q))
        elseif NPC and Z then
            print(P .. string.format(L["Tracking Seek NPC Zone Format"], NPC, Z, Q))
        elseif NPC then
            print(P .. string.format(L["Tracking Seek NPC Format"], NPC, Q))
        elseif place then
            print(P .. string.format(L["Tracking Classic Find Place Format"], place, Q))
        else
            print(P .. string.format(L["Tracking Begin Format"], Q))
        end
    elseif resultKind == "no_location" then
        if CH then
            if place then
                print(P .. string.format(L["Tracking Classic Prereq Place Format"], CH, Q, place))
            else
                print(P .. string.format(L["Tracking Prereq Format"], CH, Q))
            end
            return
        end
        if NPC and place then
            print(P .. string.format(L["Tracking Classic Find NPC Place Format"], NPC, place, Q))
        elseif NPC then
            print(P .. string.format(L["Tracking Seek NPC Format"], NPC, Q))
        elseif place then
            print(P .. string.format(L["Tracking Classic Find Place Format"], place, Q))
        else
            print(P .. string.format(L["Tracking Begin Format"], Q))
        end
    else
        if CH then
            if place then
                print(P .. string.format(L["Tracking Classic Prereq Place Format"], CH, Q, place))
            elseif Z then
                print(P .. string.format(L["Tracking Prereq Zone Format"], CH, Q, Z))
            else
                print(P .. string.format(L["Tracking Prereq Format"], CH, Q))
            end
            return
        end
        if NPC and place then
            print(P .. string.format(L["Tracking Classic Find NPC Place Format"], NPC, place, Q))
        elseif NPC and Z then
            print(P .. string.format(L["Tracking Next NPC Zone Format"], Q, NPC, Z))
        elseif NPC then
            print(P .. string.format(L["Tracking Next NPC Format"], Q, NPC))
        elseif place then
            print(P .. string.format(L["Tracking Classic Find Place Format"], place, Q))
        else
            print(P .. string.format(L["Tracking Next Format"], Q))
        end
    end
end

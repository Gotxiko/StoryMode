local addonName, SM = ...
local L = SM.L

-- Exposed for Code/Core/Progress.lua so lore/replayable chapter progress can read
-- the selected story without coupling that module to the UI implementation.
local currentStoryData = nil  -- assigned by UpdateStoryDetail
function SM.GetCurrentStoryData()
    return currentStoryData
end
function SM.SetCurrentStoryData(data)
    currentStoryData = data
end

local allQuestlines = SM.GetAllQuestlines()

function SM.AreAllStoriesFinished()
    if #allQuestlines == 0 then return false end
    for _, data in ipairs(allQuestlines) do
        if not SM.IsStoryFinished(data) then
            return false
        end
    end
    return true
end


-- ============================================================================
-- Story Mode Window  —  Trading-Post-style clean dark panels
-- ============================================================================

local SMTooltip = SM.Tooltip
local C_BODY = SM.UIColors.body
local C_GOLD = SM.UIColors.gold
local C_DIM = SM.UIColors.dim
local C_DIVIDER = SM.UIColors.divider
local SOLID = SM.SOLID_TEXTURE
local STORYMODE_BG_TEXTURE = SM.StoryModeBgTexture
local STORYMODE_LAYOUT_TEXTURE = SM.StoryModeLayoutTexture
local COVER_FADE_MASK_TEXTURE = SM.CoverFadeMaskTexture
local HERITAGE_ICON_BY_RACE = SM.HeritageIconByRace
local HERITAGE_ICON_FALLBACK = SM.HeritageIconFallback

-- Node ring colors — module-scoped so both the track builder and
-- LayoutSelectedChapter can restore per-state colors after selection changes.
local RING_GREEN_R, RING_GREEN_G, RING_GREEN_B = 0.35, 0.78, 0.28
local RING_GOLD_R,  RING_GOLD_G,  RING_GOLD_B  = 1.0,  0.82, 0.35

local FRAME_W  = 1012
local FRAME_H  = 550
local LEFT_W   = 274
local GAP      = 6
local RIGHT_W  = 732   -- FRAME_W - LEFT_W - GAP
local HEADER_H = 68

-- ════════════════════════════════════════════════════════════════════════════
-- Outer container  (invisible, handles dragging + ESC close)
-- ════════════════════════════════════════════════════════════════════════════

-- On WoW Forever the window is built like Forever's own windows
-- (ForeverWindow.lua); the sections below go where its layout says.
local storyFrame, skinLayout
if SM.ForeverWindow then
    storyFrame, skinLayout = SM.ForeverWindow.Create("StoryModeFrame")
end
if skinLayout then
    LEFT_W, RIGHT_W, FRAME_H, GAP, HEADER_H = skinLayout.listW, skinLayout.detailW, skinLayout.detailH, 0, skinLayout.headerH
else
    storyFrame = CreateFrame("Frame", "StoryModeFrame", UIParent)
    storyFrame:SetSize(FRAME_W, FRAME_H)
end
storyFrame:SetPoint("CENTER")
storyFrame:SetMovable(true); storyFrame:EnableMouse(true)
storyFrame:RegisterForDrag("LeftButton")
storyFrame:SetScript("OnDragStart", storyFrame.StartMoving)
storyFrame:SetScript("OnDragStop",  storyFrame.StopMovingOrSizing)
storyFrame:SetFrameStrata("HIGH")
storyFrame:Hide()
function SM.GetStoryModeFrame() return storyFrame end
tinsert(UISpecialFrames, "StoryModeFrame")

-- ════════════════════════════════════════════════════════════════════════════
-- Left section  (274 × 550, card list)
-- ════════════════════════════════════════════════════════════════════════════

local leftSection = CreateFrame("Frame", nil, storyFrame)
if skinLayout then
    leftSection:SetSize(LEFT_W, skinLayout.listH)
    leftSection:SetPoint("TOPLEFT", skinLayout.anchor, "TOPLEFT", skinLayout.listX, -skinLayout.listTop)
else
    leftSection:SetSize(LEFT_W, FRAME_H)
    leftSection:SetPoint("TOPLEFT", storyFrame, "TOPLEFT", 0, 0)
end
SM.CreateStoryPanel(leftSection)

-- Scrollable card list (no scrollbar — mousewheel only). On the Forever
-- window it fills its column, which ForeverWindow.lua fits to the frame.
local leftScrollTopInset = skinLayout and 0 or SM.PanelScrollTopInset - (SM.IsMainlineClient() and 2 or 0)
local leftScrollBottomInset = skinLayout and 0 or SM.PanelScrollBottomInset - (SM.IsMainlineClient() and 2 or 0)
-- The Forever window shows a scroll bar right of the list, as Legacy's
-- category list does; elsewhere the list scrolls with the mouse wheel only.
local leftScrollRight = skinLayout and 20 or 12
local leftScroll = CreateFrame("ScrollFrame", nil, leftSection, "ScrollFrameTemplate")
leftScroll:SetPoint("TOPLEFT",     leftSection, "TOPLEFT",     12, -leftScrollTopInset)
leftScroll:SetPoint("BOTTOMRIGHT", leftSection, "BOTTOMRIGHT", -leftScrollRight, leftScrollBottomInset)
if leftScroll.ScrollBar then
    if skinLayout then
        -- Same spacing as the detail's scroll bar: 8 below the gold line, 6
        -- above the frame's bottom border.
        leftScroll.ScrollBar:ClearAllPoints()
        leftScroll.ScrollBar:SetPoint("TOPLEFT", leftScroll, "TOPRIGHT", 2, -8)
        leftScroll.ScrollBar:SetPoint("BOTTOMLEFT", leftScroll, "BOTTOMRIGHT", 2, 6)
        leftScroll:HookScript("OnScrollRangeChanged", function(self)
            C_Timer.After(0, function() SM.UpdateScrollbarVisibility(self) end)
        end)
    else
        leftScroll.ScrollBar:Hide()
    end
end
local leftChild = CreateFrame("Frame", nil, leftScroll)
leftChild:SetWidth(LEFT_W - 12 - leftScrollRight)
leftScroll:SetScrollChild(leftChild)
SM.LeftScroll = leftScroll
SM.LeftStoryChild = leftChild
-- The Forever window searches and filters the list from a bar above it, as
-- Legacy's challenge list does (StoryList.lua).
if skinLayout and SM.CreateStoryListFilterBar then
    SM.CreateStoryListFilterBar(leftSection, leftScrollRight)
end
SM.LeftWidth = LEFT_W - (leftScrollRight - 12)  -- LeftContextPanel takes 24 off for the insets
SM.LeftPanelMode = "story"
SM.LeftStoryScrollOffset = 0
SM.EnableMouseWheelScroll(leftScroll)
SM.LeftContextChild = CreateFrame("Frame", nil, leftScroll)
SM.LeftContextChild:SetWidth(LEFT_W - 12 - leftScrollRight)
SM.LeftContextChild:Hide()
SM.InitializeLeftContextPanel()

-- ════════════════════════════════════════════════════════════════════════════
-- Right section  (732 × 550, header + detail)
-- ════════════════════════════════════════════════════════════════════════════

local rightSection = CreateFrame("Frame", nil, storyFrame)
rightSection:SetSize(RIGHT_W, FRAME_H)
if skinLayout then
    rightSection:SetPoint("TOPLEFT", skinLayout.anchor, "TOPLEFT", skinLayout.detailX, -skinLayout.detailTop)
else
    rightSection:SetPoint("TOPLEFT", leftSection, "TOPRIGHT", GAP, 0)
end
SM.CreateStoryPanel(rightSection)

-- ── Close button (standard Blizzard X) ──────────────────────────────────────
local closeBtn = CreateFrame("Button", nil, rightSection, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", rightSection, "TOPRIGHT", -4, -4)
closeBtn:SetScript("OnClick", function() storyFrame:Hide() end)
if skinLayout then closeBtn:Hide() end  -- the portrait frame has its own

-- ── Right header  (68px, title + selected story name) ────────────────────────
local rightHeader = CreateFrame("Frame", nil, rightSection)
rightHeader:SetPoint("TOPLEFT",  rightSection, "TOPLEFT",  0, 0)
rightHeader:SetPoint("TOPRIGHT", rightSection, "TOPRIGHT", 0, 0)
rightHeader:SetHeight(HEADER_H)

-- Tab labels
local tabStoryLabel = SM.NoShadow(rightHeader:CreateFontString(nil, "OVERLAY", "QuestFont_Large"))
tabStoryLabel:SetPoint("LEFT", rightHeader, "LEFT", 56, 0)
tabStoryLabel:SetPoint("BOTTOM", rightHeader, "BOTTOM", 0, 18)
tabStoryLabel:SetText(L["Tab Adventure"])
tabStoryLabel:SetTextColor(1, 1, 1)

local tabProgressLabel = SM.NoShadow(rightHeader:CreateFontString(nil, "OVERLAY", "QuestFont_Large"))
tabProgressLabel:SetPoint("LEFT", tabStoryLabel, "RIGHT", 24, 0)
tabProgressLabel:SetPoint("BOTTOM", rightHeader, "BOTTOM", 0, 18)
tabProgressLabel:SetText(L["Tab Progress"])
tabProgressLabel:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])

-- Clickable hit areas over tab labels
local tabStoryHit = CreateFrame("Button", nil, rightHeader)
tabStoryHit:SetPoint("TOPLEFT", tabStoryLabel, "TOPLEFT", -4, 4)
tabStoryHit:SetPoint("BOTTOMRIGHT", tabStoryLabel, "BOTTOMRIGHT", 4, -4)

local tabProgressHit = CreateFrame("Button", nil, rightHeader)
tabProgressHit:SetPoint("TOPLEFT", tabProgressLabel, "TOPLEFT", -4, 4)
tabProgressHit:SetPoint("BOTTOMRIGHT", tabProgressLabel, "BOTTOMRIGHT", 4, -4)

local tabJournalLabel = SM.NoShadow(rightHeader:CreateFontString(nil, "OVERLAY", "QuestFont_Large"))
tabJournalLabel:SetPoint("LEFT", tabProgressLabel, "RIGHT", 24, 0)
tabJournalLabel:SetPoint("BOTTOM", rightHeader, "BOTTOM", 0, 18)
tabJournalLabel:SetText(L["Tab Journal"])
tabJournalLabel:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])

local tabJournalHit = CreateFrame("Button", nil, rightHeader)
tabJournalHit:SetPoint("TOPLEFT", tabJournalLabel, "TOPLEFT", -4, 4)
tabJournalHit:SetPoint("BOTTOMRIGHT", tabJournalLabel, "BOTTOMRIGHT", 4, -4)

-- Secret tab: only shown for stories with data.secretTab once the player's
-- Scarlet kill tally has revealed it (see Events.lua).
local C_SCARLET = { 0.90, 0.16, 0.16 }
local tabScarletLabel = SM.NoShadow(rightHeader:CreateFontString(nil, "OVERLAY", "QuestFont_Large"))
tabScarletLabel:SetPoint("LEFT", tabJournalLabel, "RIGHT", 24, 0)
tabScarletLabel:SetPoint("BOTTOM", rightHeader, "BOTTOM", 0, 18)
tabScarletLabel:SetText(L["Tab Scarlet Crusader"])
tabScarletLabel:SetTextColor(C_SCARLET[1], C_SCARLET[2], C_SCARLET[3])
tabScarletLabel:Hide()

local tabScarletHit = CreateFrame("Button", nil, rightHeader)
tabScarletHit:SetPoint("TOPLEFT", tabScarletLabel, "TOPLEFT", -4, 4)
tabScarletHit:SetPoint("BOTTOMRIGHT", tabScarletLabel, "BOTTOMRIGHT", 4, -4)
tabScarletHit:Hide()

local activeTab = "story"

-- Kept for backward compat in UpdateStoryDetail
local smHeaderSub = SM.NoShadow(rightHeader:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"))
smHeaderSub:SetPoint("RIGHT", rightHeader, "RIGHT", -56, 0)
smHeaderSub:SetPoint("BOTTOM", rightHeader, "BOTTOM", 0, 18)
smHeaderSub:SetTextColor(C_DIM[1], C_DIM[2], C_DIM[3])
smHeaderSub:SetJustifyH("RIGHT")

-- Divider at bottom of header
local headerDiv = SM.CreateMajorDivider(rightSection)
headerDiv:SetPoint("LEFT",  rightHeader, "BOTTOMLEFT",  28, 0)
headerDiv:SetPoint("RIGHT", rightHeader, "BOTTOMRIGHT", -36, 0)
if skinLayout then
    -- The Forever window has side tabs and a progress bar in the header band
    -- instead (ForeverWindow.lua); the band keeps its height above the detail.
    headerDiv:Hide()
    rightHeader:Hide()
end

-- ── Tab container  (fills right section below header) ────────────────────────
-- Anchored to the section, not to the header's bottom: the Forever window's
-- header is 0 high, and WoW treats a 0 height as no size, so a frame hung
-- from its bottom never gets placed and the whole detail pane disappears.
local tabContainer = CreateFrame("Frame", nil, rightSection)
tabContainer:SetPoint("TOPLEFT",     rightSection, "TOPLEFT",     0, -HEADER_H)
tabContainer:SetPoint("BOTTOMRIGHT", rightSection, "BOTTOMRIGHT", 0,  0)

-- ════════════════════════════════════════════════════════════════════════════
-- Detail pane  (scrollable, lives inside tabContainer)
-- ════════════════════════════════════════════════════════════════════════════

local detailScrollTemplate = (SM.IsMainlineClient()) and "ScrollFrameTemplate" or "UIPanelScrollFrameTemplate"
local detailScrollName = (SM.IsMainlineClient()) and nil or "StoryModeDetailScrollFrame"
local detailScrollBottomInset = skinLayout and 0 or SM.PanelScrollBottomInset - (SM.IsMainlineClient() and 2 or 0)
local detailScroll = CreateFrame("ScrollFrame", detailScrollName, tabContainer, detailScrollTemplate)
detailScroll:SetPoint("TOPLEFT",     tabContainer, "TOPLEFT",      2,  -2)
detailScroll:SetPoint("BOTTOMRIGHT", tabContainer, "BOTTOMRIGHT", -2, detailScrollBottomInset)
local detailChild = CreateFrame("Frame", nil, detailScroll)
detailChild:SetWidth(RIGHT_W)
detailScroll:SetScrollChild(detailChild)
function SM.GetDetailChild() return detailChild end
SM.EnableMouseWheelScroll(detailScroll)

-- The start page and the Story tab are as tall as it takes to reach their
-- last element. Text there can settle a moment after the page is laid out,
-- most of all on the first open after a reload, so the page is measured again
-- a few times; a measure taken before the page is laid out is thrown away.
local pageEnd = { serial = 0 }
local PAGE_END_REMEASURE = { 0, 0.1, 0.5, 1.5 }
local function FitPageToEnd(serial)
    if serial ~= pageEnd.serial or not pageEnd.target then return end
    local top, bottom = detailChild:GetTop(), pageEnd.target:GetBottom()
    if not (top and bottom) then return end
    local height = top - bottom
    if height ~= height or height <= 0 or height > 20000 then return end
    detailChild:SetHeight(math.max(height + pageEnd.padding, pageEnd.minHeight))
end

-- Makes the page end padding below target, at least minHeight tall. nil
-- stops it, for pages that set their own height.
function SM.FitDetailPageTo(target, padding, minHeight)
    pageEnd.serial = pageEnd.serial + 1
    pageEnd.target, pageEnd.padding, pageEnd.minHeight = target, padding or 0, minHeight or 0
    if not target then return end
    -- On a fresh load the page has no height yet, and nothing on a page with
    -- no height has a position to measure, so it would stay blank. Give it
    -- its least height first; the measures below then fit it.
    if (detailChild:GetHeight() or 0) < pageEnd.minHeight then
        detailChild:SetHeight(math.max(pageEnd.minHeight, 1))
    end
    local serial = pageEnd.serial
    FitPageToEnd(serial)
    for _, delay in ipairs(PAGE_END_REMEASURE) do
        C_Timer.After(delay, function() FitPageToEnd(serial) end)
    end
end

-- Move scrollbar inside the panel. Classic uses the options/settings scroll art.
local detailScrollbar = SM.GetScrollBar(detailScroll)
if detailScrollbar then
    if skinLayout then
        -- Just outside the detail pane, where the Legacy page puts its scroll
        -- bar, level with the list's (the pane starts 1 lower than the list).
        detailScrollbar:ClearAllPoints()
        detailScrollbar:SetPoint("TOPLEFT",    detailScroll, "TOPRIGHT",    6, -7)
        detailScrollbar:SetPoint("BOTTOMLEFT", detailScroll, "BOTTOMRIGHT", 6,  6)
    elseif SM.IsMainlineClient() then
        detailScrollbar:ClearAllPoints()
        detailScrollbar:SetPoint("TOPRIGHT",    detailScroll, "TOPRIGHT",    -10, -16)
        detailScrollbar:SetPoint("BOTTOMRIGHT", detailScroll, "BOTTOMRIGHT", -10,  16)
    else
        detailScrollbar:Hide()
    end
    detailScroll:HookScript("OnScrollRangeChanged", function(self)
        C_Timer.After(0, function() SM.UpdateScrollbarVisibility(self) end)
    end)
    SM.UpdateScrollbarVisibility(detailScroll)
end

local DP  = 32   -- divider padding (left/right)
local CP  = SM.ForeverWindow and 40 or 80   -- content padding (left/right); the Forever window's detail is narrower

-- ── Intro (visible when no story is selected) ──────────────────────────────
local INTRO = {
    top = -18,
    textGap = 40,
    coverMaxW = 1200,
    coverAspectW = 0.67,
    coverAspectH = 0.17,
    bgAspectW = 1774,
    bgAspectH = 887,
    layoutAspectW = 1536,
    layoutAspectH = 1024,
    layoutScale = 0.5,
    coverMaskVisibleX = 432 / 512,
}

function SM.SetCenteredCoverTexCoord(texture, sourceW, sourceH, targetW, targetH)
    if not texture or not sourceW or not sourceH or not targetW or not targetH
        or sourceW <= 0 or sourceH <= 0 or targetW <= 0 or targetH <= 0 then
        return
    end

    local sourceAspect = sourceW / sourceH
    local targetAspect = targetW / targetH
    if targetAspect < sourceAspect then
        local visibleW = targetAspect / sourceAspect
        local left = (1 - visibleW) / 2
        texture:SetTexCoord(left, 1 - left, 0, 1)
    else
        local visibleH = sourceAspect / targetAspect
        local top = (1 - visibleH) / 2
        texture:SetTexCoord(0, 1, top, 1 - top)
    end
end

local function AddCoverFadeMask(parent, texture, maskAnchor)
    if not parent or not texture then return nil end
    local mask = parent:CreateMaskTexture()
    mask:SetTexture(COVER_FADE_MASK_TEXTURE, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints(maskAnchor or texture)
    texture:AddMaskTexture(mask)
    return mask
end

local introCoverFrame = CreateFrame("Frame", nil, detailChild)
introCoverFrame:Hide()

local introCoverTexture = introCoverFrame:CreateTexture(nil, "ARTWORK")
introCoverTexture:SetPoint("CENTER")
introCoverTexture:SetTexture(STORYMODE_BG_TEXTURE)
introCoverTexture:SetTexCoord(0, 1, 0, 1)
introCoverTexture:SetVertexColor(0.8, 0.8, 0.8)  -- dimmed a little, so the logo stands out
AddCoverFadeMask(introCoverFrame, introCoverTexture, introCoverFrame)

local introCoverLayout = introCoverFrame:CreateTexture(nil, "OVERLAY")
introCoverLayout:SetPoint("CENTER")
introCoverLayout:SetTexture(STORYMODE_LAYOUT_TEXTURE)
introCoverLayout:SetTexCoord(0, 1, 0, 1)

-- The logo's file is 1536 pixels wide but shows far smaller, and the game
-- shrinks it by skipping pixels, which leaves jagged edges. Copies shrunk
-- ahead of time with an area filter (storymode_layout_<width>) are used
-- instead: the smallest one at least as wide as the logo is on screen.
local LOGO_WIDTHS = { 512, 768, 1024 }
local function LogoTextureFor(width)
    local _, screenH = GetPhysicalScreenSize and GetPhysicalScreenSize()
    local pixels = width * introCoverFrame:GetEffectiveScale() * ((screenH or 768) / 768)
    for _, size in ipairs(LOGO_WIDTHS) do
        if size >= pixels then return STORYMODE_LAYOUT_TEXTURE .. "_" .. size end
    end
    return STORYMODE_LAYOUT_TEXTURE
end

local introText = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont"))
introText:SetJustifyH("LEFT"); introText:SetSpacing(5)
introText:SetTextColor(C_BODY[1], C_BODY[2], C_BODY[3])
introText:SetText(L["Intro Text"])
introText:Hide()

local function SetIntroVisible(show)
    if show then
        introCoverFrame:Show()
        introText:Show()
    else
        introCoverFrame:Hide()
        introText:Hide()
        SM.FitDetailPageTo(nil)
    end
    if SM.ForeverWindow then SM.ForeverWindow.ShowQuestModeChoice(show) end
end

SetIntroVisible(false)

local function LayoutIntro()
    local w = detailChild:GetWidth()
    local contentW = w - CP * 2
    local visibleTargetW = math.min(INTRO.coverMaxW, contentW)
    if visibleTargetW < 360 then visibleTargetW = 360 end
    local coverW = visibleTargetW / INTRO.coverMaskVisibleX
    local coverH = coverW * (INTRO.coverAspectH / INTRO.coverAspectW)
    local hBleed = (coverW - visibleTargetW) / 2

    introCoverFrame:ClearAllPoints()
    introCoverFrame:SetPoint("TOPLEFT", detailChild, "TOPLEFT", CP - hBleed, INTRO.top)
    introCoverFrame:SetSize(coverW, coverH)
    introCoverTexture:SetSize(coverW, coverH)
    SM.SetCenteredCoverTexCoord(introCoverTexture, INTRO.bgAspectW, INTRO.bgAspectH, coverW, coverH)
    local layoutW = coverW * INTRO.layoutScale
    introCoverLayout:SetTexture(LogoTextureFor(layoutW))
    introCoverLayout:SetSize(layoutW, layoutW * (INTRO.layoutAspectH / INTRO.layoutAspectW))
    introCoverLayout:SetTexCoord(0, 1, 0, 1)

    introText:ClearAllPoints()
    introText:SetPoint("TOPLEFT",  detailChild, "TOPLEFT",  CP, -(coverH + INTRO.textGap))
    introText:SetPoint("TOPRIGHT", detailChild, "TOPRIGHT", -CP, -(coverH + INTRO.textGap))
    if contentW > 20 then introText:SetWidth(contentW) end

    -- The Forever window puts its Guided/Explorer choice under the text.
    local pageBottom = SM.ForeverWindow and SM.ForeverWindow.PlaceQuestModeChoice(introText) or introText
    SM.FitDetailPageTo(pageBottom, 40, 400)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- Detail view — centered portrait hero + clean sections
-- ══════════════════════════════════════════════════════════════════════════════

local HERO_ICON = 96

-- ── Hero: centered circular portrait + title below (shared across tabs) ─────
local heroFrame = CreateFrame("Frame", nil, detailChild)
heroFrame:SetPoint("TOPLEFT",  detailChild, "TOPLEFT",  0, 0)
heroFrame:SetPoint("TOPRIGHT", detailChild, "TOPRIGHT", 0, 0)
heroFrame:SetHeight(HERO_ICON + 60)  -- icon + gap + title

local heroPort = CreateFrame("Frame", nil, heroFrame)
heroPort:SetSize(HERO_ICON, HERO_ICON)
heroPort:SetPoint("TOP", heroFrame, "TOP", 0, -30)

local heroIcon = heroPort:CreateTexture(nil, "ARTWORK")
heroIcon:SetSize(HERO_ICON - 8, HERO_ICON - 8)
heroIcon:SetPoint("CENTER")
heroIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
heroIcon:SetTexelSnappingBias(0)
heroIcon:SetSnapToPixelGrid(false)

local heroMask = heroPort:CreateMaskTexture()
heroMask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask",
    "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
heroMask:SetAllPoints(heroIcon)
heroIcon:AddMaskTexture(heroMask)

local heroRing = heroPort:CreateTexture(nil, "OVERLAY")
if not SM.SafeSetAtlas(heroRing, "ui-frame-genericplayerchoice-portrait-border", false) then
    heroRing:Hide()
end
heroRing:SetPoint("TOPLEFT",     heroIcon, "TOPLEFT",     -3,  3)
heroRing:SetPoint("BOTTOMRIGHT", heroIcon, "BOTTOMRIGHT",  3, -3)
heroRing:SetVertexColor(1.0, 0.82, 0.5)
heroRing:SetAlpha(0.85)

local dTitle = SM.NoShadow(heroFrame:CreateFontString(nil, "OVERLAY", "QuestFont_Huge"))
dTitle:SetPoint("TOP", heroPort, "BOTTOM", 0, -12)
dTitle:SetJustifyH("CENTER"); dTitle:SetWordWrap(false)
dTitle:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])

local ADVENTURE_COVER = SM.AdventureCover
-- The Adventure tab's cover (AdventureCover.lua builds and fills it).
local adventureCoverFrame = SM.CreateAdventureCover(detailChild)
local aCoverFrame = adventureCoverFrame.frame

-- ════════════════════════════════════════════════════════════════════════════
-- STORY TAB elements
-- ════════════════════════════════════════════════════════════════════════════

-- Story intro paragraph
local sIntro = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont"))
sIntro:SetJustifyH("LEFT"); sIntro:SetSpacing(4); sIntro:SetWordWrap(true)
sIntro:SetTextColor(C_BODY[1], C_BODY[2], C_BODY[3])

-- CTA button on story tab (big red Trading Post style)
-- The visible button is a standard (non-secure) Button so it can anchor
-- freely to FontStrings during layout. A separate invisible secure overlay
-- (sTrackBtnSecure, created further below) is anchored on top of it with
-- SetAllPoints — that overlay is what actually receives clicks and fires
-- the macro in a secure execution context, keeping the tainting calls
-- (OpenWorldMap / AddQuestWatch / SetSuperTracked* / SetUserWaypoint)
-- out of Blizzard's quest-reward money-frame path.
local sTrackBtnTemplate = C_XMLUtil and C_XMLUtil.GetTemplateInfo
    and C_XMLUtil.GetTemplateInfo("SharedButtonLargeTemplate")
    and "SharedButtonLargeTemplate" or "UIPanelButtonTemplate"
local sTrackBtn = CreateFrame("Button", nil, detailChild, sTrackBtnTemplate)
sTrackBtn:SetSize(240, 40)
sTrackBtn:SetText(L["Button Begin Story"])
sTrackBtn:RegisterForClicks("AnyUp")
sTrackBtn.lockReason = nil

-- Pending action queued by PreClick; consumed by the secure macro.
local pendingSecureTrack = nil
function SM.QueueSecureTrack(data, quest)
    pendingSecureTrack = { data = data, quest = quest }
end

-- Called from the macro via /run — runs in secure context, so its calls to
-- OpenWorldMap / AddQuestWatch / SetSuperTrackedQuestID / SetUserWaypoint
-- don't taint the execution path. SM.ExecuteTrackButton resolves at call time.
function StoryMode_ExecuteSecureTrack()
    local pending = pendingSecureTrack
    pendingSecureTrack = nil
    if not pending then return end
    SM.ExecuteTrackButton(pending.data, pending.quest)
end

-- Invisible SecureActionButtonTemplate overlay. Parented to detailChild, and
-- its anchor points are computed manually from sTrackBtn's rect so there is
-- NO anchor dependency in either direction. (If the overlay anchored to
-- sTrackBtn, sTrackBtn would inherit the protected-frame anchor rules and
-- could no longer be anchored to FontStrings during layout — raising
-- "Cannot anchor protected frames to regions". If sTrackBtn anchored to
-- the overlay, the same thing would happen.) SM.SyncSecureOverlay() keeps it
-- positioned on top of sTrackBtn; it's called after every layout pass and
-- is a no-op during combat (SetPoint on protected frames is combat-
-- restricted — minor cosmetic drift is acceptable).
local sTrackBtnSecure = CreateFrame("Button", "StoryModeTrackButton", detailChild, "SecureActionButtonTemplate")
sTrackBtnSecure:SetSize(240, 40)
sTrackBtnSecure:SetPoint("TOPLEFT", detailChild, "TOPLEFT", 0, 0)
sTrackBtnSecure:RegisterForClicks("AnyUp")
sTrackBtnSecure:SetAttribute("type", "macro")
sTrackBtnSecure:SetAttribute("macrotext", "/run StoryMode_ExecuteSecureTrack()")
sTrackBtnSecure:SetFrameLevel((sTrackBtn:GetFrameLevel() or 0) + 5)
sTrackBtnSecure:Hide()

function SM.SyncSecureOverlay()
    if InCombatLockdown() then return end
    if not sTrackBtnSecure.isActive or not sTrackBtn:IsShown() then
        sTrackBtnSecure:Hide()
        return
    end
    local btnLeft, btnTop = sTrackBtn:GetLeft(), sTrackBtn:GetTop()
    local parLeft, parTop = detailChild:GetLeft(), detailChild:GetTop()
    if not (btnLeft and btnTop and parLeft and parTop) then return end
    sTrackBtnSecure:ClearAllPoints()
    sTrackBtnSecure:SetPoint("TOPLEFT", detailChild, "TOPLEFT",
        btnLeft - parLeft, btnTop - parTop)
    sTrackBtnSecure:SetSize(sTrackBtn:GetWidth(), sTrackBtn:GetHeight())
    sTrackBtnSecure:Show()
end

function SM.SetSecureOverlayActive(active)
    pendingSecureTrack = nil
    sTrackBtnSecure.isActive = active == true
    -- The overlay is protected: in combat even setting its scripts is
    -- blocked ("Interface action failed because of an AddOn"). The window
    -- closes when combat starts and can't open during it, so layouts then
    -- only run in the background; the first one after combat sets it right.
    if InCombatLockdown() then return end
    if not active then
        sTrackBtnSecure:SetScript("PreClick", nil)
        sTrackBtnSecure:Hide()
    else
        SM.SyncSecureOverlay()
    end
end

-- Re-sync when sTrackBtn resizes (content fonts reflowing, etc.).
-- Layout code calls SM.SyncSecureOverlay() explicitly after re-anchoring.
sTrackBtn:HookScript("OnSizeChanged", SM.SyncSecureOverlay)
sTrackBtn:HookScript("OnShow", SM.SyncSecureOverlay)

-- Forward hover events to the visible button so its template highlight and
-- lock-reason tooltip keep working while the overlay sits on top.
sTrackBtnSecure:SetScript("OnEnter", function()
    sTrackBtn:LockHighlight()
    local fn = sTrackBtn:GetScript("OnEnter")
    if fn then fn(sTrackBtn) end
end)
sTrackBtnSecure:SetScript("OnLeave", function()
    sTrackBtn:UnlockHighlight()
    local fn = sTrackBtn:GetScript("OnLeave")
    if fn then fn(sTrackBtn) end
end)
sTrackBtn:SetScript("OnEnter", function(self)
    if self.lockReason then
        SMTooltip:SetOwner(self, "ANCHOR_RIGHT")
        SMTooltip:ClearLines()
        SMTooltip:AddLine(L["Tooltip Story Locked"], 1, 1, 1)
        SMTooltip:AddLine(self.lockReason, 1.0, 0.82, 0.35, true)
        SMTooltip:Show()
    end
end)
sTrackBtn:SetScript("OnLeave", function() SMTooltip:Hide() end)

local sCompleteText = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont_Huge"))
sCompleteText:SetTextColor(0.40, 0.82, 0.35)
sCompleteText:SetText(L["Campaign Complete"])

-- Progressive story journal entries (chapter recaps, revealed as quests are completed)
local sJournalHeader = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont_Huge"))
sJournalHeader:SetJustifyH("CENTER")
sJournalHeader:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
sJournalHeader:SetText(L["Journal Header"])

local sJournalSubline = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont"))
sJournalSubline:SetJustifyH("CENTER"); sJournalSubline:SetWordWrap(true)
sJournalSubline:SetTextColor(C_BODY[1], C_BODY[2], C_BODY[3])
sJournalSubline:SetText(L["Journal Subline"])

local sJournalEmptyTitle = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont_Huge"))
sJournalEmptyTitle:SetJustifyH("CENTER")
sJournalEmptyTitle:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
sJournalEmptyTitle:SetText(L["Journal Empty Title"])
sJournalEmptyTitle:Hide()

local sJournalEmptyText = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont"))
sJournalEmptyText:SetJustifyH("CENTER"); sJournalEmptyText:SetSpacing(4); sJournalEmptyText:SetWordWrap(true)
sJournalEmptyText:SetTextColor(C_BODY[1], C_BODY[2], C_BODY[3])
sJournalEmptyText:SetText(L["Journal Empty Text"])

local sFactionHeader = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont_Large"))
sFactionHeader:SetJustifyH("CENTER")
sFactionHeader:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
sFactionHeader:SetText(L["Section Factions"])
sFactionHeader:Hide()

local sJournalEntries = {}  -- pool of { title = FontString, body = FontString }

function SM.GetJournalEntry(idx)
    if sJournalEntries[idx] then return sJournalEntries[idx] end
    local title = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont_Large"))
    title:SetJustifyH("CENTER")
    title:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
    local body = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont"))
    body:SetJustifyH("LEFT"); body:SetSpacing(4); body:SetWordWrap(true)
    body:SetTextColor(C_BODY[1], C_BODY[2], C_BODY[3])
    sJournalEntries[idx] = { title = title, body = body }
    return sJournalEntries[idx]
end

-- SCARLET CRUSADER TAB elements (secret page, see Events.lua kill counter)
local sScarletTitle = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont_Huge"))
sScarletTitle:SetJustifyH("CENTER")
sScarletTitle:SetTextColor(0.90, 0.16, 0.16)
sScarletTitle:SetText(L["Tab Scarlet Crusader"])
sScarletTitle:Hide()

local sScarletCount = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont"))
sScarletCount:SetJustifyH("CENTER")
sScarletCount:SetTextColor(C_BODY[1], C_BODY[2], C_BODY[3])
sScarletCount:Hide()

local sScarletCountBtn = CreateFrame("Button", nil, detailChild)
sScarletCountBtn:Hide()
sScarletCountBtn:RegisterForClicks("AnyUp")
sScarletCountBtn:SetScript("OnClick", function()
    if not (IsShiftKeyDown() and SM.InsertScarletLedgerChatLink) then return end
    if not SM.InsertScarletLedgerChatLink() then
        print(L["Addon Debug Prefix"] .. "Ledger share could not open a chat input")
    end
end)
sScarletCountBtn:SetScript("OnEnter", function(self)
    sScarletCount:SetTextColor(1, 1, 1)
    if not SM.Tooltip then return end
    SM.Tooltip:SetOwner(self, "ANCHOR_RIGHT")
    SM.Tooltip:ClearLines()
    SM.Tooltip:AddLine(L["Scarlet Share Hint"], 0.5, 0.5, 0.5)
    SM.Tooltip:Show()
end)
sScarletCountBtn:SetScript("OnLeave", function()
    sScarletCount:SetTextColor(C_BODY[1], C_BODY[2], C_BODY[3])
    if SM.Tooltip then SM.Tooltip:Hide() end
end)

-- Scarlet ledger sections mirror the Journal's entry pool: gold chapter-style
-- title above a prose body, created on demand as pages unlock.
local sScarletSections = {}

function SM.GetScarletSection(idx)
    if sScarletSections[idx] then return sScarletSections[idx] end
    local title = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont_Large"))
    title:SetJustifyH("CENTER")
    title:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
    local body = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont"))
    body:SetJustifyH("LEFT"); body:SetSpacing(4); body:SetWordWrap(true)
    body:SetTextColor(C_BODY[1], C_BODY[2], C_BODY[3])
    sScarletSections[idx] = { title = title, body = body }
    return sScarletSections[idx]
end

-- Scarlet hunt list: one centered name per row, struck through once felled.
local sScarletHuntRows = {}

function SM.GetScarletHuntRow(idx)
    if sScarletHuntRows[idx] then return sScarletHuntRows[idx] end
    local text = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont"))
    text:SetJustifyH("CENTER")
    text:SetMaxLines(1); text:SetWordWrap(false)
    local strike = detailChild:CreateTexture(nil, "OVERLAY")
    SM.SetSolidTexture(strike, 0.90, 0.16, 0.16, 0.85)
    strike:SetHeight(1.2)
    sScarletHuntRows[idx] = { text = text, strike = strike }
    return sScarletHuntRows[idx]
end

local storyElements = { sIntro, sTrackBtn, sCompleteText }
local journalElements = { sJournalHeader, sJournalSubline, sJournalEmptyTitle, sJournalEmptyText, sFactionHeader }
local scarletElements = { sScarletTitle, sScarletCount, sScarletCountBtn }

local FactionUI = SM.FactionUI

-- ════════════════════════════════════════════════════════════════════════════
-- PROGRESS TAB elements
-- ════════════════════════════════════════════════════════════════════════════

local dCompleteText = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont_Huge"))
dCompleteText:SetTextColor(0.40, 0.82, 0.35)
dCompleteText:SetText(L["Campaign Complete"])

-- Progress summary (shown at top of progress tab, under hero)
local dProgSummary = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont"))
dProgSummary:SetJustifyH("CENTER")
dProgSummary:SetTextColor(C_BODY[1], C_BODY[2], C_BODY[3])

-- ══ Renown-Track Style Chapter Selector + Quest Cards ══════════════════
-- Horizontal chapter track with quest detail cards below

local TRACK_NODE_SIZE = 48      -- portrait circle diameter
local TRACK_ARROW_GAP = SM.ForeverWindow and SM.ForeverWindow.ChapterArrowGap or 24  -- space between nodes (contains arrow); wider for Legacy's arrow
local TRACK_STEP = TRACK_NODE_SIZE + TRACK_ARROW_GAP  -- 72px per step
local TRACK_H = 72              -- track container height
SM.TrackArrowSize = (SM.IsMainlineClient()) and 14 or 18

local QCARD_GAP = 3            -- gap between cards

-- State
local dSelectedChapter = 1
local dTrackChapterCount = 0
function SM.SetProgressSelectedChapter(index)
    dSelectedChapter = index or 1
end
function SM.GetProgressSelectedChapter()
    return dSelectedChapter
end
function SM.SetProgressChapterCount(count)
    dTrackChapterCount = count or 0
end

-- Forward-declare pools (used by CenterTrackOnSelected)
local dTrackNodes = {}
local dTrackArrows = {}

-- ── Track container (persistent, created once) ──────────────────────
local dTrackContainer = CreateFrame("Frame", nil, detailChild)
dTrackContainer:SetHeight(TRACK_H)
dTrackContainer:Hide()

-- Clip frame — full width, fades are done via node alpha instead of overlays
local dTrackClip = CreateFrame("Frame", nil, dTrackContainer)
dTrackClip:SetClipsChildren(true)
dTrackClip:SetPoint("TOPLEFT", dTrackContainer, "TOPLEFT", 0, 0)
dTrackClip:SetPoint("BOTTOMRIGHT", dTrackContainer, "BOTTOMRIGHT", 0, 0)

-- Inner frame that slides left/right
local dTrackInner = CreateFrame("Frame", nil, dTrackClip)
dTrackInner:SetPoint("LEFT", dTrackClip, "LEFT", 0, 0)
dTrackInner:SetHeight(TRACK_H)

-- Centers the track so selected chapter is in the middle of the clip
-- Also applies distance-based alpha fade to each node
function SM.CenterTrackOnSelected(clipW)
    if clipW <= 0 then clipW = 350 end
    local selCenterX = (dSelectedChapter - 1) * TRACK_STEP + TRACK_NODE_SIZE / 2
    local offset = selCenterX - clipW / 2
    dTrackInner:ClearAllPoints()
    dTrackInner:SetPoint("LEFT", dTrackClip, "LEFT", -offset, 0)
    -- Apply distance-based alpha fade to nodes
    local center = clipW / 2
    local fadeStart = center - TRACK_NODE_SIZE  -- start fading past this distance
    local fadeEnd = clipW / 2 + 10             -- fully faded at edge
    for i, node in ipairs(dTrackNodes) do
        if not node:IsShown() then break end
        local nodeCenter = (i - 1) * TRACK_STEP + TRACK_NODE_SIZE / 2 - offset
        local dist = math.abs(nodeCenter - center)
        if dist <= fadeStart then
            node:SetAlpha(1.0)
        elseif dist >= fadeEnd then
            node:SetAlpha(0.0)
        else
            node:SetAlpha(1.0 - (dist - fadeStart) / (fadeEnd - fadeStart))
        end
    end
    -- Same for between-node arrows
    for i, arrow in ipairs(dTrackArrows) do
        if not arrow:IsShown() then break end
        local arrowX = (i - 1) * TRACK_STEP + TRACK_NODE_SIZE + TRACK_ARROW_GAP / 2 - offset
        local dist = math.abs(arrowX - center)
        if dist <= fadeStart then
            arrow:SetAlpha(1.0)
        elseif dist >= fadeEnd then
            arrow:SetAlpha(0.0)
        else
            arrow:SetAlpha(1.0 - (dist - fadeStart) / (fadeEnd - fadeStart))
        end
    end
end

-- Navigation arrows — always visible, navigate between chapters
local LayoutSelectedChapter  -- forward declare for arrow callbacks

local NAV_ARROW_SIZE = 26
local NAV_ARROW_INSET = 12

-- Left arrow
local dTrackLeftBtn = CreateFrame("Button", nil, dTrackContainer)
dTrackLeftBtn:SetSize(NAV_ARROW_SIZE + 16, NAV_ARROW_SIZE + 16)
dTrackLeftBtn:SetPoint("LEFT", dTrackContainer, "LEFT", NAV_ARROW_INSET, 5)
dTrackLeftBtn:SetFrameLevel(dTrackClip:GetFrameLevel() + 20)
local dTrackLeftTex = dTrackLeftBtn:CreateTexture(nil, "ARTWORK")
SM.SetStoryArrowTexture(dTrackLeftTex, "left", true)
dTrackLeftTex:SetSize(NAV_ARROW_SIZE, NAV_ARROW_SIZE)
dTrackLeftTex:SetPoint("CENTER")
dTrackLeftTex:SetVertexColor(0.85, 0.75, 0.55)
dTrackLeftBtn:SetScript("OnEnter", function() dTrackLeftTex:SetVertexColor(1, 0.90, 0.65) end)
dTrackLeftBtn:SetScript("OnLeave", function() dTrackLeftTex:SetVertexColor(0.85, 0.75, 0.55) end)
dTrackLeftBtn:SetScript("OnClick", function()
    if dSelectedChapter > 1 then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        dSelectedChapter = dSelectedChapter - 1
        LayoutSelectedChapter()
        C_Timer.After(0, function() SM.CenterTrackOnSelected(dTrackClip:GetWidth()) end)
    end
end)

-- Right arrow
local dTrackRightBtn = CreateFrame("Button", nil, dTrackContainer)
dTrackRightBtn:SetSize(NAV_ARROW_SIZE + 16, NAV_ARROW_SIZE + 16)
dTrackRightBtn:SetPoint("RIGHT", dTrackContainer, "RIGHT", -NAV_ARROW_INSET, 5)
dTrackRightBtn:SetFrameLevel(dTrackClip:GetFrameLevel() + 20)
local dTrackRightTex = dTrackRightBtn:CreateTexture(nil, "ARTWORK")
SM.SetStoryArrowTexture(dTrackRightTex, "right", true)
dTrackRightTex:SetSize(NAV_ARROW_SIZE, NAV_ARROW_SIZE)
dTrackRightTex:SetPoint("CENTER")
dTrackRightTex:SetVertexColor(0.85, 0.75, 0.55)
dTrackRightBtn:SetScript("OnEnter", function() dTrackRightTex:SetVertexColor(1, 0.90, 0.65) end)
dTrackRightBtn:SetScript("OnLeave", function() dTrackRightTex:SetVertexColor(0.85, 0.75, 0.55) end)
dTrackRightBtn:SetScript("OnClick", function()
    if dSelectedChapter < dTrackChapterCount then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        dSelectedChapter = dSelectedChapter + 1
        LayoutSelectedChapter()
        C_Timer.After(0, function() SM.CenterTrackOnSelected(dTrackClip:GetWidth()) end)
    end
end)

-- Mousewheel on track changes selection
dTrackContainer:EnableMouseWheel(true)
dTrackContainer:SetScript("OnMouseWheel", function(_, delta)
    if delta > 0 and dSelectedChapter > 1 then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        dSelectedChapter = dSelectedChapter - 1
        LayoutSelectedChapter()
        C_Timer.After(0, function() SM.CenterTrackOnSelected(dTrackClip:GetWidth()) end)
    elseif delta < 0 and dSelectedChapter < dTrackChapterCount then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        dSelectedChapter = dSelectedChapter + 1
        LayoutSelectedChapter()
        C_Timer.After(0, function() SM.CenterTrackOnSelected(dTrackClip:GetWidth()) end)
    end
end)

-- Chapter title + summary below track
local dChapterTitle = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont_Huge"))
dChapterTitle:SetJustifyH("CENTER")
dChapterTitle:Hide()

local dChapterSummary = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont"))
dChapterSummary:SetJustifyH("LEFT"); dChapterSummary:SetSpacing(4); dChapterSummary:SetWordWrap(true)
dChapterSummary:SetTextColor(C_BODY[1], C_BODY[2], C_BODY[3])
dChapterSummary:Hide()

-- Chapter note — shown for prerequisite, gated, and manual viewed/played guidance.
local dChapterNote = SM.NoShadow(detailChild:CreateFontString(nil, "ARTWORK", "QuestFont_Shadow_Small"))
dChapterNote:SetJustifyH("LEFT"); dChapterNote:SetSpacing(3); dChapterNote:SetWordWrap(true)
dChapterNote:SetTextColor(1.0, 0.82, 0.35)
dChapterNote:Hide()

-- Mark as Viewed button — shown for loreOnly chapters (same template as story CTA)
local dMarkViewedBtn = CreateFrame("Button", nil, detailChild, sTrackBtnTemplate)
dMarkViewedBtn:SetSize(240, 40)
dMarkViewedBtn:SetText(L["Button Mark Viewed"])
dMarkViewedBtn:Hide()

-- Achievement reward line — clickable, shown when a chapter has an achievementID
local dChapterAchievement = CreateFrame("Button", nil, detailChild)
dChapterAchievement:SetHeight(18)
dChapterAchievement:Hide()
do
    local icon = dChapterAchievement:CreateTexture(nil, "ARTWORK")
    icon:SetSize(16, 16)
    icon:SetPoint("LEFT", dChapterAchievement, "LEFT", 0, -1)
    dChapterAchievement.icon = icon

    local label = SM.NoShadow(dChapterAchievement:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"))
    label:SetPoint("LEFT", icon, "RIGHT", 5, 0)
    label:SetJustifyH("LEFT")
    dChapterAchievement.label = label

    dChapterAchievement:SetScript("OnClick", function(self)
        if self.achID then
            if AchievementFrame_ShowAchievement then
                AchievementFrame_ShowAchievement(self.achID)
            elseif AchievementFrame then
                ShowUIPanel(AchievementFrame)
            else
                ToggleAchievementFrame()
            end
        end
    end)
    dChapterAchievement:SetScript("OnEnter", function(self)
        self.label:SetTextColor(1, 1, 0.6)
    end)
    dChapterAchievement:SetScript("OnLeave", function(self)
        if self.achieved then
            self.label:SetTextColor(0.45, 0.90, 0.35)
        else
            self.label:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
        end
    end)
end

-- Full-size achievement card for chapters that have no quest list.
-- Reuses SM.CreateAchievementRow(defined later) — forward-created after that function.
local dChapterAchievementCard  -- assigned after CreateAchievementRow is defined

-- ── Track node pool ─────────────────────────────────────────────────
-- The tracking crosshair that says "in the next-step tracker", on chapter
-- nodes. Hidden until shown.
function SM.CreateTrackedBadge(parent, size)
    local badge = CreateFrame("Frame", nil, parent)
    badge:SetSize(size, size)
    badge:SetFrameLevel(parent:GetFrameLevel() + 10)
    local icon = badge:CreateTexture(nil, "OVERLAY")
    icon:SetAllPoints()
    SM.SetTrackedIconTexture(icon)
    badge:Hide()
    return badge
end

function SM.CreateTrackNode(parent)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(TRACK_NODE_SIZE, TRACK_NODE_SIZE)
    -- Shift-click tracks the chapter in the next-step tracker (WoW Forever).
    btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    -- Portrait
    local portrait = btn:CreateTexture(nil, "ARTWORK")
    portrait:SetSize(TRACK_NODE_SIZE - 4, TRACK_NODE_SIZE - 4)
    portrait:SetPoint("TOP", btn, "TOP", 0, 0)
    portrait:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    portrait:SetTexelSnappingBias(0)
    portrait:SetSnapToPixelGrid(false)

    local mask = btn:CreateMaskTexture()
    mask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask",
        "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints(portrait)
    portrait:AddMaskTexture(mask)
    btn.portrait = portrait
    btn.portraitMask = mask

    -- Ring (circle border, shown for normal chapters)
    local ring = btn:CreateTexture(nil, "OVERLAY")
    local hasRingAtlas = SM.SafeSetAtlas(ring, "ui-frame-genericplayerchoice-portrait-border", false)
    if not hasRingAtlas then
        hasRingAtlas = SM.SafeSetTexture(ring, SM.ClassicPortraitRing)
            or SM.SafeSetTexture(ring, SM.ClassicPortraitRingFallback)
            or SM.SafeSetTexture(ring, "Interface\\Buttons\\UI-ActionButton-Border")
    end
    if hasRingAtlas then
        if SM.IsMainlineClient() then
            ring:SetPoint("TOPLEFT", portrait, "TOPLEFT", -3, 3)
            ring:SetPoint("BOTTOMRIGHT", portrait, "BOTTOMRIGHT", 3, -3)
        else
            ring:SetPoint("CENTER", portrait, "CENTER", 0, 0)
            ring:SetSize(TRACK_NODE_SIZE + 64, TRACK_NODE_SIZE + 64)
            ring:SetBlendMode("ADD")
            ring:SetVertexColor(1, 1, 1)
        end
    else
        ring:Hide()
    end
    btn.ring = ring
    btn.hasRingAtlas = hasRingAtlas

    local portraitBorder = SM.CreateSimpleBorder(btn, 2, "OVERLAY")
    portraitBorder.top:ClearAllPoints()
    portraitBorder.top:SetPoint("TOPLEFT", portrait, "TOPLEFT", -2, 2)
    portraitBorder.top:SetPoint("TOPRIGHT", portrait, "TOPRIGHT", 2, 2)
    portraitBorder.bottom:ClearAllPoints()
    portraitBorder.bottom:SetPoint("BOTTOMLEFT", portrait, "BOTTOMLEFT", -2, -2)
    portraitBorder.bottom:SetPoint("BOTTOMRIGHT", portrait, "BOTTOMRIGHT", 2, -2)
    portraitBorder.left:ClearAllPoints()
    portraitBorder.left:SetPoint("TOPLEFT", portrait, "TOPLEFT", -2, 2)
    portraitBorder.left:SetPoint("BOTTOMLEFT", portrait, "BOTTOMLEFT", -2, -2)
    portraitBorder.right:ClearAllPoints()
    portraitBorder.right:SetPoint("TOPRIGHT", portrait, "TOPRIGHT", 2, 2)
    portraitBorder.right:SetPoint("BOTTOMRIGHT", portrait, "BOTTOMRIGHT", 2, -2)
    SM.SetSimpleBorder(portraitBorder, 0.55, 0.48, 0.38, hasRingAtlas and 0 or 0.65)
    btn.portraitBorder = portraitBorder

    -- Square border (shown instead of ring for gated/prerequisite chapters).
    -- OVERLAY sublevel 5 places it above hl (sublevel -1) and ring (sublevel 0)
    -- within the same frame, so sublevel ordering is always guaranteed.
    local squareBorder = btn:CreateTexture(nil, "OVERLAY", nil, 5)
    if not SM.SafeSetAtlas(squareBorder, "talents-node-square-gray", false) then
        squareBorder:Hide()
    end
    squareBorder:SetPoint("TOPLEFT", portrait, "TOPLEFT", -3, 3)
    squareBorder:SetPoint("BOTTOMRIGHT", portrait, "BOTTOMRIGHT", 3, -3)
    squareBorder:Hide()
    btn.squareBorder = squareBorder

    -- Checkmark badge (top-right), sublevel 6 so it sits above squareBorder
    local checkmark = btn:CreateTexture(nil, "OVERLAY", nil, 6)
    if not SM.SafeSetAtlas(checkmark, "common-icon-checkmark", false) then
        SM.SafeSetTexture(checkmark, "Interface\\Buttons\\UI-CheckBox-Check")
    end
    checkmark:SetSize(18, 18)
    checkmark:SetPoint("BOTTOMRIGHT", portrait, "BOTTOMRIGHT", 5, -5)
    checkmark:Hide()
    btn.checkmark = checkmark

    -- Tracked badge (top-left): the tracking crosshair while the chapter is
    -- in the next-step tracker. Its own frame, above any frame art on the node.
    btn.trackedBadge = SM.CreateTrackedBadge(btn, 24)
    btn.trackedBadge:SetPoint("TOPLEFT", portrait, "TOPLEFT", -6, 6)

    -- Active glow (same as hover but always-on for selected node)
    local activeGlow = btn:CreateTexture(nil, "ARTWORK", nil, 3)
    activeGlow:SetTexture("Interface/Buttons/WHITE8x8")
    activeGlow:SetAllPoints(portrait)
    activeGlow:SetVertexColor(1, 0.82, 0.50, 0.25)
    local glowMask = btn:CreateMaskTexture()
    glowMask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask",
        "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    glowMask:SetAllPoints(portrait)
    activeGlow:AddMaskTexture(glowMask)
    activeGlow:Hide()
    btn.activeGlow = activeGlow
    btn.glowMask = glowMask

    -- Hover glow mirrors the selected-node treatment without altering selection.
    local hoverGlow = btn:CreateTexture(nil, "ARTWORK", nil, 4)
    hoverGlow:SetTexture("Interface/Buttons/WHITE8x8")
    hoverGlow:SetAllPoints(portrait)
    hoverGlow:SetVertexColor(1, 0.82, 0.50, 0.25)
    local hoverGlowMask = btn:CreateMaskTexture()
    hoverGlowMask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask",
        "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    hoverGlowMask:SetAllPoints(portrait)
    hoverGlow:AddMaskTexture(hoverGlowMask)
    hoverGlow:Hide()
    btn.hoverGlow = hoverGlow
    btn.hoverGlowMask = hoverGlowMask

    -- Down-arrow indicator (below node, points to quest cards)
    local downArrow = btn:CreateTexture(nil, "OVERLAY", nil, 3)
    SM.SetStoryArrowTexture(downArrow, "down", false)
    local downArrowSize = (SM.IsMainlineClient()) and 16 or 22
    local downArrowOffsetY = (SM.IsMainlineClient()) and 3 or 6
    downArrow:SetSize(downArrowSize, downArrowSize)
    downArrow:SetPoint("TOP", portrait, "BOTTOM", 0, downArrowOffsetY)
    downArrow:SetVertexColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
    downArrow:Hide()
    btn.downArrow = downArrow

    -- Tooltip
    btn:SetScript("OnEnter", function(self)
        self.hoverGlow:SetVertexColor(1, 0.82, 0.50, self.isDimmed and 0.36 or 0.25)
        self.hoverGlow:Show()
        if self.isGated then
            self.squareBorder:SetVertexColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
            self.squareBorder:SetAlpha(1.0)
            SM.SetSimpleBorder(self.portraitBorder, C_GOLD[1], C_GOLD[2], C_GOLD[3], self.hasRingAtlas and 0 or 1.0)
        else
            self.ring:SetVertexColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
            self.ring:SetAlpha(1.0)
            SM.SetSimpleBorder(self.portraitBorder, C_GOLD[1], C_GOLD[2], C_GOLD[3], self.hasRingAtlas and 0 or 1.0)
        end
        if self.tooltipTitle then
            SMTooltip:SetOwner(self, "ANCHOR_RIGHT")
            SMTooltip:ClearLines()
            SMTooltip:AddLine(self.tooltipTitle, 1, 1, 1)
            if self.tooltipBody then
                SMTooltip:AddLine(self.tooltipBody, C_BODY[1], C_BODY[2], C_BODY[3], true)
            end
            if self.tooltipProgress then
                SMTooltip:AddLine(" ")
                SMTooltip:AddLine(self.tooltipProgress, C_DIM[1], C_DIM[2], C_DIM[3])
            end
            if self.trackHint then
                SMTooltip:AddLine(" ")
                SMTooltip:AddLine(self.trackHint, C_GOLD[1], C_GOLD[2], C_GOLD[3], true)
            end
            if self.tooltipAchievementID then
                local _, achName, _, achDone = GetAchievementInfo(self.tooltipAchievementID)
                if achName then
                    SMTooltip:AddLine(" ")
                    if achDone then
                        SMTooltip:AddLine(achName, 0.45, 0.90, 0.35)
                    else
                        SMTooltip:AddLine(achName, C_GOLD[1], C_GOLD[2], C_GOLD[3])
                    end
                end
            end
            SMTooltip:Show()
        end
    end)
    btn:SetScript("OnLeave", function(self)
        self.hoverGlow:Hide()
        if self.borderA then
            if self.isGated then
                self.squareBorder:SetVertexColor(self.borderR, self.borderG, self.borderB)
                self.squareBorder:SetAlpha(self.borderA)
                SM.SetSimpleBorder(self.portraitBorder, self.borderR, self.borderG, self.borderB, self.hasRingAtlas and 0 or self.borderA)
            else
                self.ring:SetVertexColor(self.borderR, self.borderG, self.borderB)
                self.ring:SetAlpha(self.borderA)
                SM.SetSimpleBorder(self.portraitBorder, self.borderR, self.borderG, self.borderB, self.hasRingAtlas and 0 or self.borderA)
            end
        end
        SMTooltip:Hide()
    end)

    if SM.ForeverWindow then SM.ForeverWindow.DecorateChapterNode(btn) end
    return btn
end

-- ── Quest card pool ─────────────────────────────────────────────────
local dQuestCards = {}
function SM.OpenStoryModeToSelection(storyID, chapterIndex, tab)
    if not storyID then return false end

    StoryModeDB.selectedQuestlineID = storyID
    StoryModeDB.selectedChapter = chapterIndex or StoryModeDB.selectedChapter or 1
    if tab and SM.SetActiveTab then
        SM.SetActiveTab(tab)
    end

    -- Draws the tab as a tab click does, with the chapter selected (on the
    -- Progress tab, selecting the chapter alone left the page blank).
    local function drawTab()
        if not storyFrame:IsShown() or activeTab ~= tab then return end
        if not (currentStoryData and currentStoryData.id == storyID) then return end
        local w = detailScroll:GetWidth()
        if w > 20 then detailChild:SetWidth(w) end
        if tab == "progress" then
            SM.SetProgressSelectedChapter(StoryModeDB.selectedChapter or 1)
            if SM.LayoutDetailTab then SM.LayoutDetailTab() end
            if SM.LayoutSelectedChapter then SM.LayoutSelectedChapter() end
            if SM.CenterTrackOnSelected and dTrackClip then
                SM.CenterTrackOnSelected(dTrackClip:GetWidth())
            end
        elseif SM.LayoutDetailTab then
            SM.LayoutDetailTab()
        end
    end

    -- The window open: select the story now.
    local function applySelection()
        if SM.BuildStoryWindow then SM.BuildStoryWindow() end
        local storyIndex = SM.GetStoryIndexByID and SM.GetStoryIndexByID(storyID) or nil
        if not storyIndex then return end
        StoryModeDB.selectedQuestline = storyIndex
        if tab and SM.SetActiveTab then SM.SetActiveTab(tab) end
        if SM.SelectStory then SM.SelectStory(storyIndex, StoryModeDB.selectedChapter) end
        detailScroll:SetVerticalScroll(0)
        C_Timer.After(0, drawTab)
    end

    if storyFrame:IsShown() then
        applySelection()
        return true
    end

    -- The window closed: open it the usual way. Its OnShow builds the list,
    -- sizes the panel and selects the saved story (set above) on the tab set
    -- above, as when the player opens it. Selecting the story ourselves
    -- alongside that left the page blank on the window's first show. Once
    -- OnShow has selected it, draw the tab with the chapter.
    if SM.ShowStoryModeFrame then
        SM.ShowStoryModeFrame()
    elseif SM.ToggleStoryModeFrame then
        SM.ToggleStoryModeFrame()
    end
    local waits = 0
    local function afterShow()
        waits = waits + 1
        if not (storyFrame:IsShown() and currentStoryData and currentStoryData.id == storyID) then
            if waits < 40 then C_Timer.After(0.05, afterShow) end
            return
        end
        C_Timer.After(0, drawTab)
    end
    C_Timer.After(0, afterShow)

    return true
end

-- ── Achievement row ──────────────────────────────────────────────────
local AROW_H     = 44    -- row height
local AROW_MAX_W = 300   -- max row width, centered in the panel
local AICON_SZ   = 32    -- icon size
local AROW_PAD   = 16    -- inner left/right padding

function SM.CreateAchievementRow(parent)
    local row = CreateFrame("Button", nil, parent)
    row:SetHeight(AROW_H)
    row:EnableMouse(true)

    -- Hover: fading gradient tint (transparent → tint → transparent), shown/hidden manually
    local hlL = row:CreateTexture(nil, "BACKGROUND")
    hlL:SetTexture(SOLID)
    hlL:SetPoint("LEFT",  row, "LEFT",   0, 0)
    hlL:SetPoint("RIGHT", row, "CENTER", 0, 0)
    hlL:SetHeight(AROW_H)
    hlL:SetGradient("HORIZONTAL",
        CreateColor(C_BODY[1], C_BODY[2], C_BODY[3], 0),
        CreateColor(C_BODY[1], C_BODY[2], C_BODY[3], 0.12))
    hlL:Hide()
    local hlR = row:CreateTexture(nil, "BACKGROUND")
    hlR:SetTexture(SOLID)
    hlR:SetPoint("LEFT",  row, "CENTER", 0, 0)
    hlR:SetPoint("RIGHT", row, "RIGHT",  0, 0)
    hlR:SetHeight(AROW_H)
    hlR:SetGradient("HORIZONTAL",
        CreateColor(C_BODY[1], C_BODY[2], C_BODY[3], 0.12),
        CreateColor(C_BODY[1], C_BODY[2], C_BODY[3], 0))
    hlR:Hide()
    row.hlL, row.hlR = hlL, hlR

    -- Icon
    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(AICON_SZ, AICON_SZ)
    icon:SetPoint("LEFT", row, "LEFT", AROW_PAD, 0)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    row.icon = icon

    -- Talent node square border, tinted gold
    local iconBorder = row:CreateTexture(nil, "OVERLAY", nil, 2)
    if not SM.SafeSetAtlas(iconBorder, "talents-node-square-gray", false) then
        iconBorder:Hide()
    end
    iconBorder:SetSize(AICON_SZ + 8, AICON_SZ + 8)
    iconBorder:SetPoint("CENTER", icon, "CENTER", 0, 0)
    iconBorder:SetVertexColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
    row.iconBorder = iconBorder

    -- Achievement name
    local title = SM.NoShadow(row:CreateFontString(nil, "ARTWORK", "GameFontNormal"))
    title:SetPoint("LEFT",  icon, "RIGHT",  10,        0)
    title:SetPoint("RIGHT", row,  "RIGHT",  -AROW_PAD, 0)
    title:SetJustifyH("LEFT")
    title:SetWordWrap(false)
    row.title = title

    -- Tooltip + hover
    row:SetScript("OnEnter", function(self)
        hlL:Show(); hlR:Show()
        if not self.achievementID then return end
        local _, achName, _, completed, month, day, year, description, _, _, _, rewardText =
            GetAchievementInfo(self.achievementID)
        SMTooltip:SetOwner(self, "ANCHOR_RIGHT")
        SMTooltip:ClearLines()
        SMTooltip:AddLine(achName or "", 1, 1, 1)
        -- Completion status
        if completed then
            local dateStr = (month and month > 0)
                and (" — " .. month .. "/" .. day .. "/" .. year) or ""
            SMTooltip:AddLine(L["Achievement Earned"] .. dateStr, 0.2, 0.83, 0.2)
        else
            SMTooltip:AddLine(L["Achievement Not Yet Earned"], C_DIM[1], C_DIM[2], C_DIM[3])
        end
        -- Description
        if description and description ~= "" then
            SMTooltip:AddLine(" ")
            SMTooltip:AddLine(description, C_BODY[1], C_BODY[2], C_BODY[3], true)
        end
        -- Criteria
        local numCriteria = GetAchievementNumCriteria(self.achievementID)
        if numCriteria and numCriteria > 0 then
            SMTooltip:AddLine(" ")
            SMTooltip:AddLine(L["Achievement Criteria"], C_GOLD[1], C_GOLD[2], C_GOLD[3])
            for i = 1, numCriteria do
                local criteriaName, _, critCompleted = GetAchievementCriteriaInfo(self.achievementID, i)
                if criteriaName and criteriaName ~= "" then
                    local check = critCompleted and "|TInterface\\RaidFrame\\ReadyCheck-Ready:12:12|t" or "|TInterface\\RaidFrame\\ReadyCheck-NotReady:12:12|t"
                    local r, g, b = critCompleted and 0.2 or C_BODY[1], critCompleted and 0.83 or C_BODY[2], critCompleted and 0.2 or C_BODY[3]
                    SMTooltip:AddLine(check .. " " .. criteriaName, r, g, b, true)
                end
            end
        end
        -- Reward
        if type(rewardText) == "string" and rewardText ~= "" then
            SMTooltip:AddLine(" ")
            SMTooltip:AddLine(string.format(L["Achievement Reward Format"], rewardText), C_GOLD[1], C_GOLD[2], C_GOLD[3], true)
        end
        SMTooltip:AddLine(" ")
        SMTooltip:AddLine(L["Achievement Open Log"], 0.5, 0.5, 0.5)
        SMTooltip:Show()
    end)
    row:SetScript("OnLeave", function()
        hlL:Hide(); hlR:Hide()
        SMTooltip:Hide()
    end)
    row:SetScript("OnClick", function(self)
        if not self.achievementID then return end
        SMTooltip:Hide()
        storyFrame:Hide()
        if not AchievementFrame then SM.LoadAddOn("Blizzard_AchievementUI") end
        if AchievementFrame and ShowUIPanel and AchievementFrame_SelectAchievement then
            ShowUIPanel(AchievementFrame)
            AchievementFrame_SelectAchievement(self.achievementID)
        end
    end)

    return row
end

-- Assign the forward-declared chapter achievement card now that CreateAchievementRow exists.
dChapterAchievementCard = SM.CreateAchievementRow(detailChild)
dChapterAchievementCard:Hide()

SM.DetailUI = {
    detailChild = detailChild,
    detailScroll = detailScroll,
    CP = CP,
    C_BODY = C_BODY,
    C_GOLD = C_GOLD,
    C_DIM = C_DIM,
    RING_GREEN = { RING_GREEN_R, RING_GREEN_G, RING_GREEN_B },
    RING_GOLD = { RING_GOLD_R, RING_GOLD_G, RING_GOLD_B },
    ADVENTURE_COVER_W = ADVENTURE_COVER.width,
    ADVENTURE_COVER_TEX_LEFT = ADVENTURE_COVER.texLeft,
    ADVENTURE_COVER_TEX_RIGHT = ADVENTURE_COVER.texRight,
    ADVENTURE_COVER_TEX_TOP = ADVENTURE_COVER.texTop,
    ADVENTURE_COVER_TEX_BOTTOM = ADVENTURE_COVER.texBottom,
    aCoverFrame = aCoverFrame,
    aCoverTexture = adventureCoverFrame.texture,
    aCoverTitle = adventureCoverFrame.title,
    aCoverDivider = adventureCoverFrame.divider,
    aCoverLevel = adventureCoverFrame.level,
    sIntro = sIntro,
    sTrackBtn = sTrackBtn,
    sTrackBtnSecure = sTrackBtnSecure,
    sCompleteText = sCompleteText,
    sJournalHeader = sJournalHeader,
    sJournalSubline = sJournalSubline,
    sJournalEmptyTitle = sJournalEmptyTitle,
    sJournalEmptyText = sJournalEmptyText,
    sFactionHeader = sFactionHeader,
    sJournalEntries = sJournalEntries,
    sScarletTitle = sScarletTitle,
    sScarletCount = sScarletCount,
    sScarletCountBtn = sScarletCountBtn,
    sScarletSections = sScarletSections,
    sScarletHuntRows = sScarletHuntRows,
    dTitle = dTitle,
    dProgSummary = dProgSummary,
    dTrackContainer = dTrackContainer,
    dTrackClip = dTrackClip,
    dTrackInner = dTrackInner,
    dTrackNodes = dTrackNodes,
    dTrackArrows = dTrackArrows,
    dTrackLeftBtn = dTrackLeftBtn,
    dTrackRightBtn = dTrackRightBtn,
    dChapterTitle = dChapterTitle,
    dChapterSummary = dChapterSummary,
    dChapterNote = dChapterNote,
    dChapterAchievement = dChapterAchievement,
    dChapterAchievementCard = dChapterAchievementCard,
    dMarkViewedBtn = dMarkViewedBtn,
    dQuestCards = dQuestCards,
    TRACK_NODE_SIZE = TRACK_NODE_SIZE,
    TRACK_ARROW_GAP = TRACK_ARROW_GAP,
    TRACK_STEP = TRACK_STEP,
    TRACK_H = TRACK_H,
    QCARD_GAP = QCARD_GAP,
}

-- ── Render quest cards for selected chapter ─────────────────────────
LayoutSelectedChapter = function()
    local data = currentStoryData
    if not data then return end
    local chapters = SM.GetAllChapters(data)
    local ch = chapters[dSelectedChapter]
    if not ch then return end

    -- Update nav arrow enabled state
    local canGoLeft = dSelectedChapter > 1
    local canGoRight = dSelectedChapter < dTrackChapterCount
    dTrackLeftBtn:SetEnabled(canGoLeft)
    dTrackLeftTex:SetVertexColor(canGoLeft and 0.85 or 0.3, canGoLeft and 0.75 or 0.25, canGoLeft and 0.55 or 0.2)
    dTrackLeftTex:SetAlpha(canGoLeft and 1.0 or 0.3)
    dTrackRightBtn:SetEnabled(canGoRight)
    dTrackRightTex:SetVertexColor(canGoRight and 0.85 or 0.3, canGoRight and 0.75 or 0.25, canGoRight and 0.55 or 0.2)
    dTrackRightTex:SetAlpha(canGoRight and 1.0 or 0.3)

    -- Update track selection visuals: selected node gets gold ring + glow.
    -- Deselected nodes get their completion-state ring color restored.
    -- Retail gated nodes (with prerequisites) use squareBorder instead of ring.
    local function SetNodeBorder(node, r, g, b, a)
        if SM.IsMainlineClient() then
            node.ring:SetVertexColor(r, g, b)
        else
            node.ring:SetVertexColor(1, 1, 1)
        end
        local ringAlpha = (SM.IsMainlineClient()) and a or 1.0
        node.ring:SetAlpha(ringAlpha)
        node.borderR, node.borderG, node.borderB, node.borderA = r, g, b, ringAlpha
        if node.isGated then
            node.squareBorder:SetVertexColor(r, g, b)
            node.squareBorder:SetAlpha(a)
        end
    end
    for i, node in ipairs(dTrackNodes) do
        if not node:IsShown() then break end
        local thCh = chapters[i]
        local cd, ct = 0, 0
        local isComp, isAct = false, false
        if thCh then
            cd, ct = SM.GetChapterProgress(thCh)
            isComp = cd == ct and ct > 0
            isAct = cd > 0 and not isComp
            local qDone, qTotal = SM.GetChapterQuestCount(thCh)
            node.tooltipProgress = qDone .. " / " .. qTotal .. " quests"
        end

        if i == dSelectedChapter then
            SetNodeBorder(node, C_GOLD[1], C_GOLD[2], C_GOLD[3], 1.0)
            if isComp then
                node.checkmark:Show()
            else
                node.checkmark:Hide()
            end
            node.activeGlow:Show()
            node.downArrow:Show()
        else
            node.activeGlow:Hide()
            node.downArrow:Hide()
            -- Restore completion-state border color so it doesn't stay gold.
            if thCh then
                if thCh.loreOnly then
                    if isComp then
                        SetNodeBorder(node, RING_GREEN_R, RING_GREEN_G, RING_GREEN_B, 0.8)
                        node.checkmark:Show()
                    else
                        SetNodeBorder(node, 0.55, 0.48, 0.38, 0.55)
                        node.checkmark:Hide()
                    end
                else
                    if isComp then
                        SetNodeBorder(node, RING_GREEN_R, RING_GREEN_G, RING_GREEN_B, 0.8)
                    elseif isAct then
                        SetNodeBorder(node, RING_GOLD_R, RING_GOLD_G, RING_GOLD_B, 0.9)
                    else
                        SetNodeBorder(node, 0.4, 0.35, 0.30, 0.5)
                    end
                end
            end
        end
        if node.isLegacyNode then
            -- The chapter the story sends the player to next is marked selected.
            SM.ForeverWindow.StyleChapterNode(node, isComp, isAct, i == dSelectedChapter,
                thCh ~= nil and select(3, SM.FindNextQuest(data)) == thCh)
        end
    end

    -- Chapter title + summary
    dChapterTitle:SetText(ch.chapter)
    dChapterTitle:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
    dChapterTitle:SetShown(not SM.ForeverWindow)  -- Forever names it on its node only

    -- Forever keeps the summary of a chapter the player hasn't reached yet
    -- to itself, so it doesn't give the story away.
    local summary = SM.GetChapterText(ch, "summary")
    if summary and not (SM.ForeverWindow and not SM.IsChapterReached(data, ch)) then
        dChapterSummary:SetText(summary)
        dChapterSummary:Show()
    else
        dChapterSummary:Hide()
    end

    local chapterRequiredLevel = ch.requiredLevel
    local playerLevel = UnitLevel("player") or 0
    if chapterRequiredLevel and playerLevel < chapterRequiredLevel then
        dChapterNote:SetText(string.format(L["Lock Required Level Format"], chapterRequiredLevel))
        dChapterNote:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
        dChapterNote:Show()
    elseif SM.ForeverWindow then
        -- The Forever window keeps only the level lock above the quests.
        dChapterNote:Hide()
    elseif ch.note then
        dChapterNote:SetText(ch.note)
        dChapterNote:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
        dChapterNote:Show()
    elseif ch.prerequisites then
        local req = SM.GetFirstUnmetChapterPrerequisite(ch)
        if req then
            local reqQuest = "|cffffd200" .. (req.name or string.format(L["Quest ID Format"], tostring(req.id))) .. "|r"
            if req.npc then
                dChapterNote:SetText(string.format(L["Lock Speak Pick Up Quest Format"], "|cffffd200" .. req.npc .. "|r", reqQuest))
            else
                dChapterNote:SetText(string.format(L["Lock Complete Quest Format"], reqQuest))
            end
            dChapterNote:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
            dChapterNote:Show()
        else
            dChapterNote:Hide()
        end
    else
        dChapterNote:Hide()
    end

    if SM.ForeverWindow then
        -- The level lock sits under the summary, or right under the track
        -- when the summary is hidden (the hidden title marks the track's foot).
        dChapterNote:ClearAllPoints()
        dChapterNote:SetPoint("TOPLEFT", dChapterSummary:IsShown() and dChapterSummary or dChapterTitle, "BOTTOMLEFT", 0, -8)
        dChapterNote:SetPoint("TOPRIGHT", dChapterSummary:IsShown() and dChapterSummary or dChapterTitle, "BOTTOMRIGHT", 0, -8)
    end

    local cdNote, ctNote = SM.GetChapterProgress(ch)
    local chIsComplete = cdNote == ctNote and ctNote > 0

    -- Mark as Viewed / Mark as Played button
    if ch.loreOnly or ch.replayable then
        local btnAnchor = dChapterNote:IsShown() and dChapterNote
                       or dChapterSummary:IsShown() and dChapterSummary
                       or dChapterTitle
        dMarkViewedBtn:ClearAllPoints()
        dMarkViewedBtn:SetPoint("TOP", btnAnchor, "BOTTOM", 0, -14)
        if chIsComplete then
            dMarkViewedBtn:SetText(ch.loreOnly and L["Button Watched"] or L["Button Played"])
            dMarkViewedBtn:SetScript("OnClick", nil)
            dMarkViewedBtn:Disable()
            dMarkViewedBtn:SetAlpha(0.5)
        elseif ch.loreOnly then
            dMarkViewedBtn:SetText(L["Button Mark Viewed"])
            dMarkViewedBtn:SetScript("OnClick", function()
                SM.SetLoreChapterViewed(data.title, ch.chapter)
                LayoutSelectedChapter()
            end)
            dMarkViewedBtn:Enable()
            dMarkViewedBtn:SetAlpha(1.0)
        else
            dMarkViewedBtn:SetText(L["Button Mark Played"])
            dMarkViewedBtn:SetScript("OnClick", function()
                SM.SetChapterPlayed(data.title, ch.chapter)
                LayoutSelectedChapter()
            end)
            dMarkViewedBtn:Enable()
            dMarkViewedBtn:SetAlpha(1.0)
        end
        dMarkViewedBtn:Show()
    else
        dMarkViewedBtn:Hide()
    end

    -- Achievement reward line — only shown for chapters that also have quest cards.
    -- Quest-less chapters (achievementID, no quests) use the full card below instead.
    -- Replayable chapters suppress this row; the button is the sole interaction.
    local achID = ch.achievementID
    if achID and #ch.quests > 0 and not ch.replayable then
        local _, achName, _, achDone, _,_,_,_, _, achIcon = GetAchievementInfo(achID)
        if achName then
            dChapterAchievement.achID = achID
            dChapterAchievement.achieved = achDone
            if achIcon then
                dChapterAchievement.icon:SetTexture(achIcon)
                dChapterAchievement.icon:Show()
            else
                dChapterAchievement.icon:Hide()
            end
            dChapterAchievement.label:SetText(achName)
            if achDone then
                dChapterAchievement.label:SetTextColor(0.45, 0.90, 0.35)
            else
                dChapterAchievement.label:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
            end
            local achHeaderAnchor = dChapterNote:IsShown() and dChapterNote
                                 or dChapterSummary:IsShown() and dChapterSummary
                                 or dChapterTitle
            dChapterAchievement:ClearAllPoints()
            dChapterAchievement:SetPoint("TOPLEFT", achHeaderAnchor, "BOTTOMLEFT", 0, -8)
            dChapterAchievement:SetPoint("TOPRIGHT", detailChild, "RIGHT", -CP, 0)
            dChapterAchievement:Show()
        else
            dChapterAchievement:Hide()
        end
    else
        dChapterAchievement:Hide()
    end

    -- Quest cards — skipped for replayable chapters (button is the sole interaction point)
    local nextQuest = SM.FindNextQuest(data)
    local nextQuestID = nextQuest and nextQuest.id
    local stepNumber = 0

    for i, q in ipairs(ch.quests) do
        if not dQuestCards[i] then
            dQuestCards[i] = SM.CreateQuestCard(detailChild)
        end
        local card = dQuestCards[i]
        if ch.replayable or not SM.IsQuestForPlayer(q) or SM.ShouldHideQuest(q) then
            card:Hide()
        else
            local qOptional = q.optional == true
            local qInLog = SM.IsQuestEntryInLog(q)
            local qDoneDisplay = (not qInLog) and SM.IsQuestEntryComplete(q)
            local qPassed = (not qInLog) and SM.IsQuestEffectivelyComplete(i, ch.quests)
            local qIsNextRecommended = false
            if nextQuestID then
                for _, questID in ipairs(SM.GetQuestIDs(q)) do
                    if questID == nextQuestID then
                        qIsNextRecommended = true
                        break
                    end
                end
            end
            local lockReason = (not qDoneDisplay and not qInLog and not qOptional and not qPassed) and SM.GetQuestLockReason(data, ch, i) or nil

            card.title:SetText(q.displayName or q.name)
            card.npcLabel:SetText(q.npc or "")
            card.questID = q.id
            card.questEntry = q
            card.questCompleteForClick = qDoneDisplay
            card.storyData = data
            card.tooltipTitle = q.name
            card.tooltipNPC = q.npc
            if qDoneDisplay then
                card.tooltipStatus = "|cff59c746" .. L["Quest Status Completed"] .. "|r"
            elseif qInLog then
                card.tooltipStatus = "|cffffd223" .. L["Quest Status In Progress"] .. "|r"
            elseif qOptional then
                card.tooltipStatus = "|cff808080" .. L["Quest Status Optional"] .. "|r"
            elseif lockReason then
                card.tooltipStatus = "|cff808080" .. L["Quest Status Not Available"] .. "|r"
            else
                card.tooltipStatus = nil
            end
            card.tooltipRequirement = lockReason
            -- Finished steps need no nudge.
            card.tooltipHint = (not qDoneDisplay and not qPassed) and SM.GetQuestHint(q) or nil

            if card.SetLegacyState then
                -- WoW Forever's Legacy cards draw their state themselves.
                stepNumber = stepNumber + 1
                card:SetLegacyState((qDoneDisplay and "done") or (qInLog and "active")
                    or (qPassed and "passed")
                    or (qIsNextRecommended and "next") or (qOptional and "optional")
                    or (lockReason and "locked") or "later", stepNumber, data, ch, q)
                card:Show()
            else
            card.icon:SetSize(14, 14)
            card.icon:SetDesaturation(0)
            if qDoneDisplay then
                if not SM.SafeSetAtlas(card.icon, "common-icon-checkmark", false) then
                    SM.SafeSetTexture(card.icon, "Interface\\Buttons\\UI-CheckBox-Check")
                end
                card.icon:SetVertexColor(0.45, 0.90, 0.35)
                card.icon:Show()
                card.title:SetTextColor(C_BODY[1], C_BODY[2], C_BODY[3], 0.8)
                card.npcLabel:SetTextColor(C_BODY[1] * 0.8, C_BODY[2] * 0.8, C_BODY[3] * 0.8, 0.6)
                card:SetAlpha(1.0)
            elseif qInLog or qIsNextRecommended then
                SM.SetStoryArrowTexture(card.icon, "right", "money")
                card.icon:SetVertexColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
                card.icon:Show()
                card.title:SetTextColor(C_BODY[1], C_BODY[2], C_BODY[3])
                card.npcLabel:SetTextColor(C_BODY[1] * 0.8, C_BODY[2] * 0.8, C_BODY[3] * 0.8, 0.7)
                card:SetAlpha(1.0)
            elseif qOptional then
                card.icon:Hide()
                card.title:SetTextColor(C_BODY[1], C_BODY[2], C_BODY[3], 0.4)
                card.npcLabel:SetTextColor(C_BODY[1] * 0.8, C_BODY[2] * 0.8, C_BODY[3] * 0.8, 0.3)
                card:SetAlpha(0.55)
            else
                card.icon:Hide()
                card.title:SetTextColor(C_BODY[1], C_BODY[2], C_BODY[3], 0.6)
                card.npcLabel:SetTextColor(C_BODY[1] * 0.8, C_BODY[2] * 0.8, C_BODY[3] * 0.8, 0.4)
                card:SetAlpha(0.8)
            end
            card:Show()
            end
        end
    end
    for i = #ch.quests + 1, #dQuestCards do dQuestCards[i]:Hide() end

    -- For chapters with no quests, show a full achievement card instead.
    local CARD_W = SM.ForeverWindow and SM.LegacyQuestCardWidth or 280
    local cardGap = SM.ForeverWindow and SM.LegacyQuestCardGap or QCARD_GAP
    if #ch.quests == 0 and ch.achievementID then
        local _, achName, _, achDone, _,_,_,_,_, achIcon = GetAchievementInfo(ch.achievementID)
        if achName then
            dChapterAchievementCard.achievementID = ch.achievementID
            dChapterAchievementCard.icon:SetTexture(achIcon)
            dChapterAchievementCard.icon:SetDesaturated(not achDone)
            dChapterAchievementCard.title:SetText(achName)
            dChapterAchievementCard.title:SetTextColor(
                achDone and C_BODY[1] or C_DIM[1],
                achDone and C_BODY[2] or C_DIM[2],
                achDone and C_BODY[3] or C_DIM[3])
            local anchor = dChapterNote:IsShown() and dChapterNote
                        or dChapterSummary:IsShown() and dChapterSummary
                        or dChapterTitle
            dChapterAchievementCard:ClearAllPoints()
            dChapterAchievementCard:SetWidth(CARD_W)
            dChapterAchievementCard:SetPoint("TOP",  anchor,      "BOTTOM", 0,         -20)
            dChapterAchievementCard:SetPoint("LEFT", detailChild, "CENTER", -CARD_W/2,   0)
            dChapterAchievementCard:Show()
        else
            dChapterAchievementCard:Hide()
        end
    else
        dChapterAchievementCard:Hide()
    end

    -- Position visible quest cards below the header area
    local prevCard = nil
    for i = 1, #ch.quests do
        local card = dQuestCards[i]
        if card and card:IsShown() then
            card:ClearAllPoints()
            card:SetWidth(CARD_W)
            if not prevCard then
                local anchor = dChapterAchievement:IsShown() and dChapterAchievement
                            or dChapterNote:IsShown() and dChapterNote
                            or dChapterSummary:IsShown() and dChapterSummary
                            or dChapterTitle
                card:SetPoint("TOP", anchor, "BOTTOM", 0, -20)
            else
                card:SetPoint("TOP", prevCard, "BOTTOM", 0, -cardGap)
            end
            -- Center horizontally: anchor LEFT relative to detailChild center
            card:SetPoint("LEFT", detailChild, "CENTER", -CARD_W / 2, 0)
            prevCard = card
        end
    end

    -- Update scroll height.
    -- For achievement-card-only chapters (no quest cards), the card sits below a
    -- word-wrapped FontString whose height may not be resolved on the zero-delay tick.
    -- A second pass at 0.1 s gives fonts time to finish layout so GetBottom() is accurate
    -- and the card lands within the scroll child's interactive region.
    -- NOTE: no SetHeight pre-sizing here — quest cards anchor their LEFT edge to
    -- detailChild CENTER, so changing detailChild's height shifts their Y position.
    local scrollAnchor = prevCard
                      or (dChapterAchievementCard:IsShown() and dChapterAchievementCard)
                      or (dMarkViewedBtn:IsShown() and dMarkViewedBtn)

    local function UpdateScrollHeight()
        if not scrollAnchor then return end
        local bot = scrollAnchor:GetBottom()
        local top = detailChild:GetTop()
        if bot and top then
            detailChild:SetHeight(math.max(top - bot + 30, 400))
        end
    end

    C_Timer.After(0, UpdateScrollHeight)

    -- Second pass only needed for achievement-card-only chapters.
    if not prevCard and dChapterAchievementCard:IsShown() then
        C_Timer.After(0.1, function()
            if dChapterAchievementCard:IsShown() then
                UpdateScrollHeight()
            end
        end)
    end
end
SM.LayoutSelectedChapter = LayoutSelectedChapter

local progressElements = { dProgSummary, dTrackContainer, dChapterTitle, dChapterSummary, dChapterNote, dChapterAchievement, dChapterAchievementCard, dMarkViewedBtn }

function SM.ShowDetail(show)
    -- Always hide both frames here. When opening a new story, the hero icon
    -- and adventure cover both still hold the previous story's content, and
    -- ShowTab (which runs from the deferred LayoutDetailTab) is what reveals
    -- the correct frame once the new texture/title have been assigned. Showing
    -- heroFrame eagerly here caused a 1–2 frame flicker of the old content.
    heroFrame:Hide()
    aCoverFrame:Hide()
end

function SM.ShowTab(tab)
    -- Each tab sets the page's height; the Story tab fits it to its button.
    SM.FitDetailPageTo(nil)
    -- Hide all tab-specific elements
    for _, el in ipairs(storyElements) do el:Hide() end
    for _, el in ipairs(journalElements) do el:Hide() end
    for _, entry in ipairs(sJournalEntries) do entry.title:Hide(); entry.body:Hide(); if entry.voice then entry.voice:Hide() end end
    for _, el in ipairs(progressElements) do el:Hide() end
    for _, el in ipairs(scarletElements) do el:Hide() end
    for _, entry in ipairs(sScarletSections) do entry.title:Hide(); entry.body:Hide() end
    for _, row in ipairs(sScarletHuntRows) do row.text:Hide(); row.strike:Hide() end
    for _, node in ipairs(dTrackNodes) do node:Hide() end
    for _, arrow in ipairs(dTrackArrows) do arrow:Hide() end
    for _, card in ipairs(dQuestCards) do card:Hide() end
    sTrackBtn:Hide(); sCompleteText:Hide()
    dCompleteText:Hide()
    aCoverFrame:Hide()
    FactionUI:HideAll()
    heroFrame:Hide()
    heroPort:Show()
    heroFrame:SetHeight(HERO_ICON + 60)
    dTitle:ClearAllPoints()
    dTitle:SetPoint("TOP", heroPort, "BOTTOM", 0, -12)
    if tab ~= "story" then
        SM.SetSecureOverlayActive(false)
    end

    if tab == "story" then
        heroFrame:Hide()
        aCoverFrame:Show()
        for _, el in ipairs(storyElements) do el:Show() end
    elseif tab == "journal" then
        for _, el in ipairs(journalElements) do el:Show() end
    elseif tab == "scarlet" then
        for _, el in ipairs(scarletElements) do el:Show() end
    elseif tab == "progress" then
        heroPort:Hide()
        heroFrame:SetHeight(50)
        dTitle:ClearAllPoints()
        dTitle:SetPoint("TOP", heroFrame, "TOP", 0, -18)
        heroFrame:Show()
        for _, el in ipairs(progressElements) do el:Show() end
    end
end

function SM.SetActiveTab(tab)
    activeTab = tab
    if SM.ForeverWindow then SM.ForeverWindow.SetDetailTab(tab) end
    tabStoryLabel:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
    tabProgressLabel:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
    tabJournalLabel:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3])
    tabScarletLabel:SetTextColor(C_SCARLET[1], C_SCARLET[2], C_SCARLET[3])
    if tab == "story" then
        tabStoryLabel:SetTextColor(1, 1, 1)
    elseif tab == "journal" then
        tabJournalLabel:SetTextColor(1, 1, 1)
    elseif tab == "scarlet" then
        tabScarletLabel:SetTextColor(1, 1, 1)
    else
        tabProgressLabel:SetTextColor(1, 1, 1)
    end
end

SM.ShowDetail(false)
function SM.HideInitialDetailElements()
    for _, el in ipairs(storyElements) do el:Hide() end
    for _, el in ipairs(journalElements) do el:Hide() end
    for _, el in ipairs(progressElements) do el:Hide() end
    for _, el in ipairs(scarletElements) do el:Hide() end
end

SM.HideInitialDetailElements()

-- ════════════════════════════════════════════════════════════════════════════
-- UpdateStoryDetail  +  LayoutDetailTab
-- ════════════════════════════════════════════════════════════════════════════

-- ── Layout the currently active tab ─────────────────────────────────────────
-- The per-tab branches each live in their own local function so that the
-- dispatcher does not exceed Lua's 60-upvalue limit.

function SM.LayoutDetailTab()
    local data = currentStoryData
    if not data then return end

    local w = detailChild:GetWidth()
    local contentW = w - CP * 2
    local visibleContentW = w - 34

    SM.ShowTab(activeTab)
    if SM.UpdateLeftPanelForTab then
        SM.UpdateLeftPanelForTab(activeTab, data)
    end

    local divW = w - DP * 2
    if divW < 20 then divW = 400 end

    if activeTab == "story" then
        SM.LayoutStoryTab(data, w, contentW, visibleContentW)
    elseif activeTab == "journal" then
        SM.LayoutJournalTab(data, w, contentW, visibleContentW)
    elseif activeTab == "scarlet" then
        SM.LayoutScarletTab(data, w, contentW, visibleContentW)
    elseif activeTab == "progress" then
        SM.LayoutProgressTab(data, w, contentW, visibleContentW)
    end
end

-- ── Tab hover + click handlers ──────────────────────────────────────────────
-- silent: the caller already played the tab sound (the Forever side tabs do).
function SM.SelectDetailTab(tab, silent)
    if activeTab == tab or not currentStoryData then return end
    if not silent then PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB) end
    SM.SetActiveTab(tab)
    detailScroll:SetVerticalScroll(0)
    SM.LayoutDetailTab()
end

if skinLayout then
    SM.ForeverWindow.AddDetailTabs(storyFrame, function(tab) SM.SelectDetailTab(tab, true) end)
end

tabStoryHit:SetScript("OnEnter", function()
    if activeTab ~= "story" then tabStoryLabel:SetTextColor(1, 1, 1) end
end)
tabStoryHit:SetScript("OnLeave", function()
    if activeTab ~= "story" then tabStoryLabel:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3]) end
end)
tabStoryHit:SetScript("OnClick", function() SM.SelectDetailTab("story") end)

tabProgressHit:SetScript("OnEnter", function()
    if activeTab ~= "progress" then tabProgressLabel:SetTextColor(1, 1, 1) end
end)
tabProgressHit:SetScript("OnLeave", function()
    if activeTab ~= "progress" then tabProgressLabel:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3]) end
end)
tabProgressHit:SetScript("OnClick", function() SM.SelectDetailTab("progress") end)

tabJournalHit:SetScript("OnEnter", function()
    if activeTab ~= "journal" then tabJournalLabel:SetTextColor(1, 1, 1) end
end)
tabJournalHit:SetScript("OnLeave", function()
    if activeTab ~= "journal" then tabJournalLabel:SetTextColor(C_GOLD[1], C_GOLD[2], C_GOLD[3]) end
end)
tabJournalHit:SetScript("OnClick", function() SM.SelectDetailTab("journal") end)

tabScarletHit:SetScript("OnEnter", function()
    if activeTab ~= "scarlet" then tabScarletLabel:SetTextColor(1, 1, 1) end
end)
tabScarletHit:SetScript("OnLeave", function()
    if activeTab ~= "scarlet" then tabScarletLabel:SetTextColor(C_SCARLET[1], C_SCARLET[2], C_SCARLET[3]) end
end)
tabScarletHit:SetScript("OnClick", function() SM.SelectDetailTab("scarlet") end)

-- ── Main entry point ────────────────────────────────────────────────────────
function SM.UpdateStoryDetail(data)
    if not data then
        currentStoryData = nil
        SM.ShowDetail(false)
        -- Hide all tab elements
        for _, el in ipairs(storyElements) do el:Hide() end
        for _, el in ipairs(journalElements) do el:Hide() end
        for _, entry in ipairs(sJournalEntries) do entry.title:Hide(); entry.body:Hide(); if entry.voice then entry.voice:Hide() end end
        for _, el in ipairs(progressElements) do el:Hide() end
        for _, el in ipairs(scarletElements) do el:Hide() end
        for _, entry in ipairs(sScarletSections) do entry.title:Hide(); entry.body:Hide() end
        for _, row in ipairs(sScarletHuntRows) do row.text:Hide(); row.strike:Hide() end
        for _, node in ipairs(dTrackNodes) do node:Hide() end
        for _, arrow in ipairs(dTrackArrows) do arrow:Hide() end
        for _, card in ipairs(dQuestCards) do card:Hide() end
        sTrackBtn:Hide(); sCompleteText:Hide()
        SM.SetSecureOverlayActive(false)
        dCompleteText:Hide()
        introText:SetText(SM.AreAllStoriesFinished() and L["Intro Text Complete"] or L["Intro Text"])
        SetIntroVisible(true)
        heroIcon:SetTexture(nil)
        smHeaderSub:SetText("")
        SM.SetActiveTab("story")
        -- Hide tabs on intro page
        tabStoryLabel:Hide(); tabProgressLabel:Hide(); tabJournalLabel:Hide()
        tabStoryHit:Hide(); tabProgressHit:Hide(); tabJournalHit:Hide()
        tabScarletLabel:Hide(); tabScarletHit:Hide()
        if SM.ForeverWindow then SM.ForeverWindow.ShowStory(nil) end
        LayoutIntro()
        C_Timer.After(0, function()
            local w = detailScroll:GetWidth()
            if w > 20 then
                detailChild:SetWidth(w)
            end
            C_Timer.After(0, function()
                LayoutIntro()
            end)
        end)
        return
    end

    currentStoryData = data
    SetIntroVisible(false); SM.ShowDetail(true)
    tabStoryLabel:Show(); tabProgressLabel:Show(); tabJournalLabel:Show()
    tabStoryHit:Show(); tabProgressHit:Show(); tabJournalHit:Show()

    local showScarletTab = data.secretTab == true
        and SM.IsScarletCrusaderRevealed and SM.IsScarletCrusaderRevealed()
    tabScarletLabel:SetShown(showScarletTab)
    tabScarletHit:SetShown(showScarletTab)
    if activeTab == "scarlet" and not showScarletTab then
        SM.SetActiveTab("story")
    end
    if SM.ForeverWindow then SM.ForeverWindow.ShowStory(data, showScarletTab) end

    -- Portrait icon (creature portrait or texture)
    heroIcon:SetTexture(nil)
    if data.portraitDisplayID then
        heroIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        SetPortraitTextureFromCreatureDisplayID(heroIcon, data.portraitDisplayID)
        if not heroIcon:GetTexture() then
            local fallback = data.race and HERITAGE_ICON_BY_RACE[data.race]
            heroIcon:SetTexCoord(0.16, 0.84, 0.12, 0.88)
            if not (fallback and SM.SafeSetTexture(heroIcon, fallback)) then
                SM.SafeSetTexture(heroIcon, HERITAGE_ICON_FALLBACK)
            end
        end
    else
        local iconID
        if data.achievementID then
            local _,_,_,_,_,_,_,_,_,achIcon = GetAchievementInfo(data.achievementID)
            if achIcon and achIcon ~= 0 then iconID = achIcon end
        end
        iconID = data.icon or iconID
        if iconID and iconID ~= 0 then
            heroIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
            if not SM.SafeSetTexture(heroIcon, iconID) then
                local fallback = data.race and HERITAGE_ICON_BY_RACE[data.race]
                heroIcon:SetTexCoord(0.16, 0.84, 0.12, 0.88)
                if not (fallback and SM.SafeSetTexture(heroIcon, fallback)) then
                    SM.SafeSetTexture(heroIcon, HERITAGE_ICON_FALLBACK)
                end
            end
        else
            local fallback = data.race and HERITAGE_ICON_BY_RACE[data.race]
            heroIcon:SetTexCoord(0.16, 0.84, 0.12, 0.88)
            if not (fallback and SM.SafeSetTexture(heroIcon, fallback)) then
                SM.SafeSetTexture(heroIcon, HERITAGE_ICON_FALLBACK)
            end
        end
    end

    local displayTitle = data.title
    if (not displayTitle or displayTitle == "") and data.achievementID then
        local _, achName = GetAchievementInfo(data.achievementID)
        if achName then displayTitle = achName end
    end

    smHeaderSub:SetText("")
    dTitle:SetText(displayTitle)
    SM.ApplyAdventureCoverFrame(adventureCoverFrame, data, displayTitle)
    sIntro:SetText(SM.GetStoryIntroText(data))

    -- Layout the active tab
    SM.ScheduleLayout(function()
        local w = detailChild:GetWidth()
        if w > 20 then sIntro:SetWidth(w - CP * 2) end
        SM.LayoutDetailTab()
    end)
end

-- ════════════════════════════════════════════════════════════════════════════
-- Left panel: category dividers + card building
-- ════════════════════════════════════════════════════════════════════════════

function SM.RefreshCurrentStoryDetail(data)
    if storyFrame:IsShown() and currentStoryData and (not data or currentStoryData == data) then
        SM.UpdateStoryDetail(currentStoryData)
    end
end

storyFrame:SetScript("OnShow", function()
    PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
    SM.BuildStoryWindow()
    -- Frame 1: let layout settle so detailScroll has a real width
    C_Timer.After(0, function()
        local w = detailScroll:GetWidth()
        if w > 20 then detailChild:SetWidth(w) end
        -- Frame 2: now word-wrap can measure properly
        C_Timer.After(0, function()
            -- Restore last selected questline, or default to intro
            local savedID = StoryModeDB.selectedQuestlineID
            local savedIdx = StoryModeDB.selectedQuestline or 0
            if savedID then
                savedIdx = SM.GetStoryIndexByID(savedID) or savedIdx
            end
            -- Validate saved index exists
            if savedIdx > 0 and SM.GetStoryDataByIndex(savedIdx) then
                SM.SelectStory(savedIdx, StoryModeDB.selectedChapter)
            else
                SM.SelectStory(0)  -- default to Introduction card
            end
        end)
    end)
end)

storyFrame:SetScript("OnHide", function()
    PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE)
end)


function SM.ToggleStoryModeFrame()
    if InCombatLockdown() then
        UIErrorsFrame:AddMessage(L["Error In Combat"], 1, 0.1, 0.1)
        return
    end

    C_Timer.After(0, function()
        if storyFrame:IsShown() then
            storyFrame:Hide()
        else
            storyFrame:Show()
        end
    end)
end

function SM.ShowStoryModeFrame()
    if InCombatLockdown() then
        UIErrorsFrame:AddMessage(L["Error In Combat"], 1, 0.1, 0.1)
        return
    end

    C_Timer.After(0, function()
        if not storyFrame:IsShown() then
            storyFrame:Show()
        end
    end)
end

-- The game's Key Bindings settings list Story Mode in its own section, with
-- one key to open or close the window (Bindings.xml).
BINDING_HEADER_STORYMODE = L["Addon Name"]
BINDING_NAME_STORYMODE_TOGGLE = L["Binding Toggle Story Mode"]

function StoryMode_ToggleFrame()
    SM.ToggleStoryModeFrame()
end

function StoryMode_AddonCompartment_OnClick(_, button)
    if button and button ~= "LeftButton" then return end
    SM.ToggleStoryModeFrame()
end

function StoryMode_AddonCompartment_OnEnter(nameOrButton, maybeButton)
    local menuButton = maybeButton or nameOrButton
    if not menuButton or not menuButton.GetObjectType then return end

    SMTooltip:SetOwner(menuButton, "ANCHOR_LEFT")
    SMTooltip:ClearLines()
    SMTooltip:AddLine(L["Minimap Tooltip Title"])
    SMTooltip:AddLine(L["Minimap Tooltip Open"])
    SMTooltip._minW = 0
    SMTooltip:Show()
end

function StoryMode_AddonCompartment_OnLeave()
    SMTooltip:Hide()
end

SM.MinimapButton_Init = SM.CreateMinimapButton(storyFrame, SMTooltip, C_BODY)
SM.ShowStoryBanner, SM.ShowStoryComplete = SM.CreateBanners()
SM.InitializeSlashCommands()
SM.InitializeCoreEvents(storyFrame)
if skinLayout then SM.ForeverWindow.Attach(storyFrame) end

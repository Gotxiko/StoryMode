local addonName, SM = ...
local L = SM.L

-- =============================================================================
-- WoW Forever window
--
-- On WoW Forever the Story Mode window is the Legacy window's challenge page:
-- Blizzard's PortraitFrameTemplate shell at the Legacy window's size, opened
-- where the Legacy window opens, with the Legacy background, divider, points
-- shield and bar, side tabs, and cards for quests. Every size and offset is
-- copied from Forever's own Blizzard_LegacySystem XML (1.60.1), and every
-- atlas is named by its element name, which is what SetAtlas resolves.
--
-- StoryMode.lua asks SM.ForeverWindow to build the shell and lays its story
-- list and detail sections where the layout it returns says. The window only
-- exists where the art does; every other client keeps the usual window.
-- =============================================================================

local ATLAS = {
    background = "Legacy-Challenge-BG",                 -- 813 x 510, gold line at row 57
    divider = "Legacy-Tree-Frame-divider-Vertical",
    barBackground = "Legacy-Progressbar-BG",
    barFill = "Legacy-Progressbar-Fill",
    barFrame = "Legacy-Progressbar-Frame",
    shield = "UI-Legacy-Points-icon-c60",
}

local function HasArt()
    if not (C_Texture and C_Texture.GetAtlasInfo) then return false end
    for _, name in pairs(ATLAS) do
        if not C_Texture.GetAtlasInfo(name) then return false end
    end
    return true
end

if not (SM.Client and SM.Client.isForever) or not HasArt() then return end

-- LegacySystemFrame and its LegacyChallengesPageTemplate. The story list and
-- the detail reach down to the frame's bottom border, and the list up to just
-- under the header's gold line, so their scroll views fill the columns;
-- Legacy stops them a few pixels short.
local WINDOW_W, WINDOW_H = 920, 575
local BACKGROUND_INSETS = { left = 1, top = 10, right = 2, bottom = 4 }
local LIST = { x = 6, top = 78, w = 330, bottom = 4 }          -- CategoryList (Legacy: top 80, bottom 8)
local DETAIL = { right = 24, bottom = 4, w = 560, h = 494 }      -- DetailPane (Legacy: bottom 8, h 490)
local DIVIDER = { x = 328, top = 72, w = 12, h = 503 }           -- VerticalDivider
local SUMMARY = { top = 25, w = 520, h = 36, shield = 32 }       -- LegacyChallengePointSummary
-- Legacy puts its summary at x 280. Ours centres the shield and bar as one
-- under the window title, which sits between the portrait and the close
-- button (PortraitFrameTemplate's title runs from 58 to 24 short of the
-- edges); the shield hangs 32 left of the bar.
SUMMARY.x = math.floor(WINDOW_W / 2 + (58 - 24) / 2 - (SUMMARY.w + SUMMARY.shield) / 2 + SUMMARY.shield + 0.5)
local OVER_FRAME_LEVEL = 800                                     -- the divider and shield sit over the frame's border
local TOP_OFFSET = -116                                          -- Blizzard's UI panel TOP_OFFSET
local LEFT_OFFSET = 16                                           -- its LEFT_OFFSET
local BOTTOM_CLAMP = 140                                         -- and its bottom clamp
local LEGACY_XOFFSET = 35                                        -- Blizzard_LegacySystemRegistration.lua

local window = {}
SM.ForeverWindow = window

-- Sets an atlas by its element name. Returns whether this client has it.
function window.SetAtlas(tex, name, useAtlasSize)
    if not (name and C_Texture.GetAtlasInfo(name)) then return false end
    tex:SetAtlas(name, useAtlasSize)
    return true
end

-- Sets an atlas so it covers w x h without stretching: it scales evenly and
-- crops the overflow from the bottom, so the header band at the top of the
-- art stays where it is.
local function SetAtlasCover(tex, atlas, w, h)
    local info = C_Texture.GetAtlasInfo(atlas)
    local file = info and (info.file or info.filename)
    local atlasW, atlasH = info and info.width, info and info.height
    if not (file and atlasW and atlasH and atlasW > 0 and atlasH > 0) then
        tex:SetAtlas(atlas)
        return
    end
    tex:SetTexture(file)
    local left, right = info.leftTexCoord, info.rightTexCoord
    local top, bottom = info.topTexCoord, info.bottomTexCoord
    local scale = math.max(w / atlasW, h / atlasH)
    local keepW = (w / scale) / atlasW
    local keepH = (h / scale) / atlasH
    local cropX = (right - left) * (1 - keepW) / 2
    tex:SetTexCoord(left + cropX, right - cropX, top, top + (bottom - top) * keepH)
end

local function PanelLayoutAttribute(name, fallback)
    if GetUIPanelLayoutAttribute then
        local ok, value = pcall(GetUIPanelLayoutAttribute, name)
        if ok and type(value) == "number" then return value end
    end
    return fallback
end

-- The Legacy window opens as a left-side UI panel 35 right of the panel
-- area's left edge, 116 below the top of the screen, and moves up when its
-- bottom would come within 140 of the screen's bottom.
local function PlaceLikeLegacyWindow(frame)
    local yOffset = PanelLayoutAttribute("TOP_OFFSET", TOP_OFFSET)
    local xOffset = PanelLayoutAttribute("LEFT_OFFSET", LEFT_OFFSET) + LEGACY_XOFFSET
    local top = UIParent:GetTop()
    if top then
        local bottom = top + yOffset - frame:GetHeight() * frame:GetScale()
        if bottom < BOTTOM_CLAMP then yOffset = yOffset + (BOTTOM_CLAMP - bottom) end
        if yOffset > -10 then yOffset = -10 end
    end
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", xOffset / frame:GetScale(), yOffset / frame:GetScale())
end

-- ── Journal page ────────────────────────────────────────────────────────────
-- The Journal tab is the right-hand page of Forever's open spellbook. It
-- covers the detail side, from the vertical divider to the frame's right
-- border and from under the header's gold line to the bottom border, scaled
-- to fit its whole height, never stretched. A sliver of the book's dark cover
-- shows above, below and right of it, so its top, bottom and right edges read
-- as they do in the spellbook. On the left is the book's binding: the page's
-- own inner edge with its gutter shadow. The page is wider than the space, so
-- the rest of it starts further in, and the gutter's last stretch fades into
-- it so no step shows.
-- Each chapter title gets the spellbook's divider, and the text the
-- spellbook's ink. The journal turns its pages with the spellbook's paging
-- control (JournalTab.lua).

local JOURNAL = {
    page = "spellbook-Page-Right-C60",              -- 810 x 682, the book's cover around the parchment
    crop = { right = 810, top = 54, bottom = 682 }, -- the parchment and its edges (top 61, bottom 668, right 790), with a sliver of cover
    binding = { gutter = 40, fade = 40 },           -- in the art: the page's inner edge, and its fade into the rest of the page
    pager = { right = 40, bottom = 12 },            -- the paging control, from the page's bottom right
    left = 338, top = 78,                           -- right of the vertical divider, under the gold line
    divider = "spellbook-divider",                  -- 657 x 11: a curl on the left, fading out on the right
    dividerJoin = 120,                              -- a shorter divider leaves out a piece of its solid line from here
    dividerIndent = 20,                             -- the curl starts this far left of the title
    ink = { 0.180, 0.106, 0.059 },                  -- SPELLBOOK_FONT_COLOR
}

local journal = { dividers = {}, pieces = {} }

-- The page shows while a story is open on its Journal tab.
local function UpdateJournalPage()
    local shown = journal.tab == "journal" and journal.story == true
    if journal.page then journal.page:SetShown(shown) end
    for _, piece in ipairs(journal.pieces) do piece:SetShown(shown) end
    if journal.layer then journal.layer:SetShown(shown) end
    if journal.pager then journal.pager:SetShown(shown) end
end

local function GetAtlasFile(atlas)
    local info = C_Texture.GetAtlasInfo(atlas)
    local file = info and (info.file or info.filename)
    if not (file and info.width and info.height and info.width > 0 and info.height > 0) then return nil end
    return info, file
end

-- A texture on frame showing columns from x1 to x2 of the atlas (in its own
-- pixels, rows crop.top to crop.bottom), x pixels right of the page's left
-- edge and w wide; w nil runs it to the frame's right border.
local function JournalPiece(frame, sublevel, info, file, x1, x2, x, w)
    local crop = JOURNAL.crop
    local u = (info.rightTexCoord - info.leftTexCoord) / info.width
    local v = (info.bottomTexCoord - info.topTexCoord) / info.height
    local piece = frame:CreateTexture(nil, "BACKGROUND", nil, sublevel)
    piece:SetPoint("TOPLEFT", frame, "TOPLEFT", JOURNAL.left + x, -JOURNAL.top)
    if w then
        piece:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", JOURNAL.left + x, BACKGROUND_INSETS.bottom)
        piece:SetWidth(w)
    else
        piece:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -BACKGROUND_INSETS.right, BACKGROUND_INSETS.bottom)
    end
    piece:SetTexture(file)
    piece:SetTexCoord(info.leftTexCoord + x1 * u, info.leftTexCoord + x2 * u,
        info.topTexCoord + crop.top * v, info.topTexCoord + crop.bottom * v)
    piece:Hide()
    return piece
end

-- Draws the page on frame. Without the art the journal keeps its usual look.
local function BuildJournalPage(frame)
    local info, file = GetAtlasFile(JOURNAL.page)
    if not info then return end
    local crop, binding = JOURNAL.crop, JOURNAL.binding
    local w = WINDOW_W - JOURNAL.left - BACKGROUND_INSETS.right
    local h = WINDOW_H - JOURNAL.top - BACKGROUND_INSETS.bottom
    local scale = h / (crop.bottom - crop.top)     -- screen pixels to one of the art's
    local right = math.min(crop.right, info.width)

    local gutterW = math.floor(binding.gutter * scale + 0.5)
    local fadeW = math.floor(binding.fade * scale + 0.5)
    local x = gutterW                              -- where the rest of the page starts
    local restLeft = right - (w - x) / scale
    if restLeft < binding.gutter + binding.fade then return end

    -- The rest of the page, to its right edge. The paging control anchors to it.
    journal.page = JournalPiece(frame, 2, info, file, restLeft, right, x)
    table.insert(journal.pieces, JournalPiece(frame, 2, info, file, 0, binding.gutter, 0, gutterW))
    -- The gutter's last stretch over the page's start, fading out.
    if CreateColor then
        local fade = JournalPiece(frame, 3, info, file, binding.gutter, binding.gutter + binding.fade, x, fadeW)
        fade:SetGradient("HORIZONTAL", CreateColor(1, 1, 1, 1), CreateColor(1, 1, 1, 0))
        table.insert(journal.pieces, fade)
    end

    local color = SPELLBOOK_FONT_COLOR
    window.JournalInk = (color and color.GetRGB) and { color:GetRGB() } or JOURNAL.ink
end

-- The frame over the journal's text that shows and hides with the page: the
-- dividers and the text of a chapter that runs on to the next page live on
-- it. nil where there's no journal page.
function window.GetJournalLayer()
    if not journal.page then return nil end
    if not journal.layer then
        local child = SM.GetDetailChild()
        journal.layer = CreateFrame("Frame", nil, child)
        journal.layer:SetAllPoints(child)
        UpdateJournalPage()
    end
    return journal.layer
end

-- The spellbook's paging control ("Page 1/2" and its arrows) at the page's
-- bottom right, made once on parent; host:OnPageChanged() runs when it
-- turns. nil where there's no journal page or no paging control.
function window.GetJournalPager(parent, host)
    if not journal.page then return nil end
    if journal.pager then return journal.pager end
    if not (C_XMLUtil and C_XMLUtil.GetTemplateInfo and C_XMLUtil.GetTemplateInfo("PagingControlsHorizontalTemplate")) then
        return nil
    end
    local pager = CreateFrame("Frame", nil, parent, "PagingControlsHorizontalTemplate")
    pager:SetPoint("BOTTOMRIGHT", journal.page, "BOTTOMRIGHT", -JOURNAL.pager.right, JOURNAL.pager.bottom)
    pager:SetFrameLevel(parent:GetFrameLevel() + 20)
    -- As the spellbook sets it up (Blizzard_SpellBookFrame.xml).
    pager.spacing = 8
    pager.hideWhenSinglePage = true
    if SOUNDKIT then
        pager.prevPageSound = SOUNDKIT.IG_ABILITY_PAGE_TURN
        pager.nextPageSound = SOUNDKIT.IG_ABILITY_PAGE_TURN
    end
    pager.PageText:SetFontObject(SystemFont_Med3 or GameFontHighlight)
    local ink = window.JournalInk or JOURNAL.ink
    pager.PageText:SetTextColor(ink[1], ink[2], ink[3])
    pager:SetOverridePagedContentFrame(host)
    pager:UpdateControls()
    journal.pager = pager
    UpdateJournalPage()
    return pager
end

-- Puts divider number index under a chapter title, as wide as the title's
-- line plus the curl's indent (at most the art's own width): the curl and the
-- fading end keep their size and the solid line between them gets shorter.
-- Returns nil where there's no journal page.
function window.PlaceJournalDivider(index, title, width)
    if not journal.page then return nil end
    local divider = journal.dividers[index]
    if not divider then
        local info, file = GetAtlasFile(JOURNAL.divider)
        if not info then return nil end
        -- Dividers move with the text and hide with the page.
        divider = CreateFrame("Frame", nil, window.GetJournalLayer())
        divider:SetHeight(info.height)
        divider.info = info
        divider.head = divider:CreateTexture(nil, "ARTWORK")
        divider.head:SetPoint("TOPLEFT")
        divider.head:SetPoint("BOTTOMLEFT")
        divider.head:SetTexture(file)
        divider.tail = divider:CreateTexture(nil, "ARTWORK")
        divider.tail:SetPoint("TOPRIGHT")
        divider.tail:SetPoint("BOTTOMRIGHT")
        divider.tail:SetTexture(file)
        journal.dividers[index] = divider
    end

    local info = divider.info
    width = math.min(width + JOURNAL.dividerIndent, info.width)
    local join = math.min(JOURNAL.dividerJoin, width / 2)
    local u = (info.rightTexCoord - info.leftTexCoord) / info.width
    divider:SetWidth(width)
    divider.head:SetWidth(join)
    divider.head:SetTexCoord(info.leftTexCoord, info.leftTexCoord + join * u, info.topTexCoord, info.bottomTexCoord)
    divider.tail:SetWidth(width - join)
    divider.tail:SetTexCoord(info.rightTexCoord - (width - join) * u, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord)
    divider:ClearAllPoints()
    divider:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -JOURNAL.dividerIndent, -3)
    divider:Show()
    return divider
end

-- Hides the dividers from number first on.
function window.HideJournalDividers(first)
    for i = first, #journal.dividers do journal.dividers[i]:Hide() end
end

-- ── Guided or Explorer ──────────────────────────────────────────────────────
-- The start page ends with the choice of how quest cards show a story:
-- Guided shows every quest, Explorer only the ones the player has reached
-- (QuestCard.lua). Two buttons under the intro text, the chosen one lit;
-- each says what it does in its tooltip.

-- Buttons look like the Friends window's Add New Friend button: Forever draws
-- that with the red three-slice button art (128-RedButton, its c60 brass
-- frame), which SharedButtonSmallTemplate uses, at the size it shows.
local RED_BUTTON = { template = "SharedButtonSmallTemplate", fallback = "UIPanelButtonTemplate", height = 26 }

function window.CreateRedButton(parent, width)
    local template = C_XMLUtil and C_XMLUtil.GetTemplateInfo and C_XMLUtil.GetTemplateInfo(RED_BUTTON.template)
        and RED_BUTTON.template or RED_BUTTON.fallback
    local button = CreateFrame("Button", nil, parent, template)
    button:SetSize(width, RED_BUTTON.height)
    return button
end
window.RedButtonHeight = RED_BUTTON.height

local MODE_CHOICE = { gap = 24, buttonW = 156, buttonH = RED_BUTTON.height, spacing = 12 }
local MODES = {
    { key = "guided", label = "Quest Mode Guided", text = "Quest Mode Guided Text" },
    { key = "explorer", label = "Quest Mode Explorer", text = "Quest Mode Explorer Text" },
}
local modeChoice = { shown = false, buttons = {} }

local function RefreshModeChoice()
    local current = SM.GetQuestCardMode()
    for _, mode in ipairs(MODES) do
        local button = modeChoice.buttons[mode.key]
        if mode.key == current then button:LockHighlight() else button:UnlockHighlight() end
    end
end

local function ShowModeTooltip(button)
    local tooltip = SM.Tooltip or GameTooltip
    local body = SM.UIColors.body
    -- Guided's opens to the left, Explorer's to the right: off the other button.
    tooltip:SetOwner(button, button.mode.key == "guided" and "ANCHOR_LEFT" or "ANCHOR_RIGHT")
    tooltip:ClearLines()
    tooltip:AddLine(L[button.mode.label], 1, 1, 1)
    tooltip:AddLine(L[button.mode.text], body[1], body[2], body[3], true)
    tooltip:Show()
end

local function CreateModeChoice(parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetHeight(MODE_CHOICE.buttonH)
    for i, mode in ipairs(MODES) do
        local button = window.CreateRedButton(frame, MODE_CHOICE.buttonW)
        button:SetText(L[mode.label])
        button.mode = mode
        if i == 1 then
            button:SetPoint("TOPRIGHT", frame, "TOP", -MODE_CHOICE.spacing / 2, 0)
        else
            button:SetPoint("TOPLEFT", frame, "TOP", MODE_CHOICE.spacing / 2, 0)
        end
        button:SetScript("OnClick", function()
            if SM.GetQuestCardMode() == mode.key then return end
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            SM.SetQuestCardMode(mode.key)
            RefreshModeChoice()
        end)
        button:SetScript("OnEnter", ShowModeTooltip)
        button:SetScript("OnLeave", function() (SM.Tooltip or GameTooltip):Hide() end)
        modeChoice.buttons[mode.key] = button
    end
    modeChoice.frame = frame
end

-- Puts the choice under anchor (the intro text) and returns it, the page's
-- last element.
function window.PlaceQuestModeChoice(anchor)
    if not modeChoice.frame then CreateModeChoice(anchor:GetParent()) end
    local frame = modeChoice.frame
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -MODE_CHOICE.gap)
    frame:SetPoint("TOPRIGHT", anchor, "BOTTOMRIGHT", 0, -MODE_CHOICE.gap)
    RefreshModeChoice()
    frame:SetShown(modeChoice.shown)
    return frame
end

-- Shows the choice with the start page and hides it with it.
function window.ShowQuestModeChoice(shown)
    modeChoice.shown = shown
    if modeChoice.frame then modeChoice.frame:SetShown(shown) end
end

-- ── Story list cards ────────────────────────────────────────────────────────
-- The story list uses the Group Finder's category cards
-- (LFGListingCategoryTemplate in Blizzard_GroupFinder_VanillaStyle, drawn with
-- Forever's c60 art): the card frame over the story's art, its pressed and
-- hover frames, the selected card lit, and the name on the left in gold.
-- The frame is 418 x 67 and the list is narrower, so a card shows the frame at
-- its own size: its left end (the dark fade behind the name) and its right
-- end, meeting in the plain middle, which nothing is missing from. Nothing is
-- scaled or stretched, and the story art fills the frame's window, cropped.

local LIST_CARD = {
    frame = "groupfinder-button-cover",
    pressed = "groupfinder-button-cover-down",
    hover = "groupfinder-button-cover-hover",
    leftEnd = 190,                                       -- the frame is plain from here to 380
    art = { left = 5, top = 7, right = 5, bottom = 5 },  -- the frame's window
    textLeft = 20,                                       -- the Group Finder's label inset
    artShade = 0.6,                                      -- its pictures are dimmed a little
    ribbonScale = 0.85, ribbonRight = 14, ribbonTop = 2, -- the finished flag, hung from the top edge
}
local GOLD = { 1, 0.82, 0 }
local WHITE = { 1, 1, 1 }

function window.ListCardHeight()
    local info = C_Texture.GetAtlasInfo(LIST_CARD.frame)
    return info and info.height or 67
end

-- Draws atlas across width at its own size, as two pieces on layer: its left
-- end and as much of its right end as the rest of the width needs.
local function DrawFrame(card, layer, sublevel, atlas, width)
    local info, file = GetAtlasFile(atlas)
    if not info then return nil end
    local leftW = math.min(LIST_CARD.leftEnd, width)
    local rightW = width - leftW
    local u = (info.rightTexCoord - info.leftTexCoord) / info.width
    local pieces = {}
    for i, piece in ipairs({ { 0, leftW, "TOPLEFT" }, { info.width - rightW, rightW, "TOPRIGHT" } }) do
        local tex = card:CreateTexture(nil, layer, nil, sublevel)
        tex:SetTexture(file)
        tex:SetSize(piece[2], info.height)
        tex:SetPoint(piece[3])
        tex:SetTexCoord(info.leftTexCoord + piece[1] * u, info.leftTexCoord + (piece[1] + piece[2]) * u,
            info.topTexCoord, info.bottomTexCoord)
        pieces[i] = tex
    end
    return pieces
end

local function ShowPieces(pieces, shown)
    for _, tex in ipairs(pieces or {}) do tex:SetShown(shown) end
end

-- Gives card (a list Button, width wide) the Group Finder card's look. art is
-- the story's art texture, nameLabel and subLabel its two lines, ribbon the
-- finished flag; any of them may be nil. Returns the colours for the lines.
-- card:SetListCardLit(lit) shows the hover frame, for the selected card too.
function window.StyleListCard(card, width, art, nameLabel, subLabel, ribbon)
    local inset = LIST_CARD.art
    if art then
        art:ClearAllPoints()
        art:SetPoint("TOPLEFT", card, "TOPLEFT", inset.left, -inset.top)
        art:SetPoint("BOTTOMRIGHT", card, "BOTTOMRIGHT", -inset.right, inset.bottom)
        art:SetAlpha(1)
        art:SetVertexColor(LIST_CARD.artShade, LIST_CARD.artShade, LIST_CARD.artShade)
    end
    DrawFrame(card, "ARTWORK", 0, LIST_CARD.frame, width)
    local pressed = DrawFrame(card, "ARTWORK", 1, LIST_CARD.pressed, width)
    local hover = DrawFrame(card, "ARTWORK", 2, LIST_CARD.hover, width)
    ShowPieces(pressed, false)
    ShowPieces(hover, false)
    card:HookScript("OnMouseDown", function() ShowPieces(pressed, true) end)
    card:HookScript("OnMouseUp", function() ShowPieces(pressed, false) end)
    function card:SetListCardLit(lit) ShowPieces(hover, lit) end

    if nameLabel then
        nameLabel:SetFontObject(GameFontNormalMed3 or GameFontNormal)
        nameLabel:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
        -- A hard shadow keeps the name readable on bright pictures.
        nameLabel:SetShadowColor(0, 0, 0, 1)
        nameLabel:SetShadowOffset(1, -1)
        if art then nameLabel:SetPoint("LEFT", card, "LEFT", LIST_CARD.textLeft, 0) end
    end
    if subLabel then
        subLabel:SetFontObject(GameFontHighlightSmall)
        subLabel:SetTextColor(WHITE[1], WHITE[2], WHITE[3])
        subLabel:SetShadowColor(0, 0, 0, 1)
        subLabel:SetShadowOffset(1, -1)
    end
    if ribbon then
        ribbon:SetScale(LIST_CARD.ribbonScale)
        ribbon:ClearAllPoints()
        ribbon:SetPoint("TOPRIGHT", card, "TOPRIGHT",
            -LIST_CARD.ribbonRight / LIST_CARD.ribbonScale, -LIST_CARD.ribbonTop / LIST_CARD.ribbonScale)
    end
    return GOLD, WHITE
end

local BuildProgressSummary  -- defined with the story progress below

-- Builds the shell on frame (created with PortraitFrameTemplate) and returns
-- where Story Mode's sections go, relative to layout.anchor (the window).
function window.Build(frame)
    frame:SetSize(WINDOW_W, WINDOW_H)
    frame:SetTitle(L["Addon Name"])
    frame:SetPortraitToAsset(SM.StoryModeAvatarTexture)
    if frame.CloseButton then
        frame.CloseButton:SetScript("OnClick", function() frame:Hide() end)
    end

    -- The art is drawn on the window itself, so the story sections (child
    -- frames) always sit on top of it. The sections anchor to the window,
    -- never to a texture: the Begin Story button has a secure overlay, and
    -- WoW refuses to anchor a protected frame through a texture.
    local background = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
    background:SetPoint("TOPLEFT", frame, "TOPLEFT", BACKGROUND_INSETS.left, -BACKGROUND_INSETS.top)
    background:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -BACKGROUND_INSETS.right, BACKGROUND_INSETS.bottom)
    SetAtlasCover(background, ATLAS.background,
        WINDOW_W - BACKGROUND_INSETS.left - BACKGROUND_INSETS.right,
        WINDOW_H - BACKGROUND_INSETS.top - BACKGROUND_INSETS.bottom)

    local divider = CreateFrame("Frame", nil, frame)
    divider:SetSize(DIVIDER.w, DIVIDER.h)
    divider:SetPoint("TOPLEFT", frame, "TOPLEFT", DIVIDER.x, -DIVIDER.top)
    divider:SetFrameLevel(OVER_FRAME_LEVEL)
    local dividerArt = divider:CreateTexture(nil, "BACKGROUND")
    dividerArt:SetAllPoints()
    dividerArt:SetAtlas(ATLAS.divider)

    BuildProgressSummary(frame)
    BuildJournalPage(frame)

    local detailX = WINDOW_W - DETAIL.right - DETAIL.w
    local detailTop = WINDOW_H - DETAIL.bottom - DETAIL.h
    return {
        anchor = frame,
        listX = LIST.x,
        listTop = LIST.top,
        listW = DIVIDER.x - LIST.x,
        listH = WINDOW_H - LIST.top - LIST.bottom,
        detailX = detailX,
        detailTop = detailTop,
        detailW = DETAIL.w,
        detailH = DETAIL.h,
        headerH = 0,
    }
end

-- ── Detail tabs ─────────────────────────────────────────────────────────────
-- Adventure, Progress and Journal are side tabs on the window's right edge,
-- like the Legacy window's tabs (LegacySystemTabTemplate): Forever's own
-- side-tab icons for Adventure (the map) and Progress (the quest log's "!"),
-- and a quill for the Journal.

local DETAIL_TABS = {
    { key = "story", label = "Tab Adventure", icon = "Interface/ICONS/INV_SideTab_FullMap_c60" },
    { key = "progress", label = "Tab Progress", icon = "Interface/ICONS/INV_SideTab_QuestLog_c60" },
    { key = "journal", label = "Tab Journal", icon = "Interface/ICONS/INV_Feather_07" },
    { key = "scarlet", label = "Tab Scarlet Crusader", icon = "Interface\\Icons\\Spell_Holy_SealOfWrath" },
}

local function SetTabIcon(tab, icon)
    tab.Icon:SetTexture(icon)
end
local detailTabs = {}

function window.AddDetailTabs(frame, onSelect)
    local previous
    for _, info in ipairs(DETAIL_TABS) do
        local tab = CreateFrame("Frame", nil, frame, "LargeSideTabButtonTemplate")
        tab:EnableMouse(true)
        tab.tooltipText = L[info.label]
        SetTabIcon(tab, info.icon)
        tab:SetFillToInterior(true)
        tab:SetCustomOnMouseUpHandler(function(_, button, upInside)
            if button == "LeftButton" and upInside then onSelect(info.key) end
        end)
        if previous then
            tab:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -2)
        else
            tab:SetPoint("TOPLEFT", frame, "TOPRIGHT", 0, -60)
        end
        tab:SetChecked(false)
        tab:Hide()
        detailTabs[info.key] = tab
        previous = tab
    end
end

function window.SetDetailTab(key)
    for tabKey, tab in pairs(detailTabs) do
        tab:SetChecked(tabKey == key)
    end
    journal.tab = key
    UpdateJournalPage()
end

-- ── Chapter track ───────────────────────────────────────────────────────────
-- Chapters are square portraits in the Legacy icon frame instead of circles:
-- green when the chapter is done, brown while it's under way, grey before.
-- The selected chapter is always in full colour, with no arrow under it, and
-- the chapter the story sends the player to next looks the same, even before
-- any of its quests are done.
-- Between chapters sits the Legacy tree's arrow, so the track spaces its
-- chapters wider than usual to fit it.

window.ChapterArrowGap = 40

local CHAPTER_FRAME = {
    done = "Legacy-Tree-Frame-icon-frame-Green",
    open = "Legacy-Tree-Frame-icon-frame",
    later = "Legacy-Tree-Frame-icon-frame-disable",
}
local ICON_MASK = "UI-Frame-IconMask"

function window.DecorateChapterNode(node)
    node.isLegacyNode = true
    -- The frame is drawn 60 around a 50 icon in Legacy; keep that ratio.
    local inset = math.floor((node.portrait:GetWidth() * 60 / 50 - node.portrait:GetWidth()) / 2 + 0.5)
    node.legacyFrame = node:CreateTexture(nil, "OVERLAY", nil, 4)
    node.legacyFrame:SetPoint("TOPLEFT", node.portrait, "TOPLEFT", -inset, inset)
    node.legacyFrame:SetPoint("BOTTOMRIGHT", node.portrait, "BOTTOMRIGHT", inset, -inset)
end

function window.StyleChapterNode(node, complete, active, selected, current)
    node.ring:Hide()
    node.squareBorder:Hide()
    SM.SetSimpleBorder(node.portraitBorder, 0, 0, 0, 0)
    node.checkmark:Hide()
    for _, mask in ipairs({ node.portraitMask, node.glowMask, node.hoverGlowMask }) do
        if mask then mask:SetAtlas(ICON_MASK) end
    end

    local open = active or selected or current
    local frameKey = complete and "done" or (open and "open") or "later"
    node.legacyFrame:SetAtlas(CHAPTER_FRAME[frameKey])
    local colored = complete or open
    node.isDimmed = not colored
    node.portrait:SetDesaturation(colored and 0 or 0.8)
    local shade = colored and 1 or 0.7
    node.portrait:SetVertexColor(shade, shade, shade)
    if node.downArrow then node.downArrow:Hide() end
    -- The selected chapter's warm tint over the portrait, on the current one too.
    if node.activeGlow then node.activeGlow:SetShown((selected or current) == true) end
    node.isCurrentChapter = current == true
end

-- The Legacy tree's arrow (LegacyTreeTraitEdgeArrowTemplate: the talent
-- tree's edge at 1.25 scale): a line from one chapter to the next and a head
-- pointing at it, yellow once the chapter before is done and grey before.
-- The head's art points down, so it turns a quarter to point right, and it
-- sits just outside the next chapter's frame, as on the tree.
local ARROW = {
    line = { done = "talents-arrow-line-yellow", open = "talents-arrow-line-gray" },
    head = { done = "talents-arrow-head-yellow", open = "talents-arrow-head-gray" },
    scale = 1.25,
    thickness = 6,
    headW = 28, headH = 24,
    tip = 5.5,   -- the head's point, from the art's centre
    tuck = 2,    -- how far the line starts under the chapter's frame
}

function window.CreateChapterArrow(parent)
    local arrow = CreateFrame("Frame", nil, parent)
    arrow:SetAllPoints(parent)
    -- Under the chapters, so the line's start tucks under the frame.
    arrow:SetFrameLevel(parent:GetFrameLevel())
    arrow.isLegacyArrow = true
    arrow.line = arrow:CreateLine(nil, "OVERLAY", nil, -2)
    arrow.line:SetThickness(ARROW.thickness * ARROW.scale)
    arrow.head = arrow:CreateTexture(nil, "OVERLAY", nil, 1)
    arrow.head:SetSize(ARROW.headW * ARROW.scale, ARROW.headH * ARROW.scale)
    arrow.head:SetRotation(math.pi / 2)
    return arrow
end

function window.PlaceChapterArrow(arrow, fromNode, toNode, done)
    local key = done and "done" or "open"
    window.SetAtlas(arrow.line, ARROW.line[key])
    window.SetAtlas(arrow.head, ARROW.head[key])
    local frameHalf = toNode.portrait:GetWidth() * 60 / 50 / 2
    local headX = -(frameHalf + ARROW.tip * ARROW.scale + 1)
    -- From the edge of the chapter's frame, not its middle: a chapter at the
    -- track's edge fades out, and the line would show through its portrait.
    local startX = fromNode.portrait:GetWidth() * 60 / 50 / 2 - ARROW.tuck
    arrow.line:SetStartPoint("CENTER", fromNode.portrait, startX, 0)
    arrow.line:SetEndPoint("CENTER", toNode.portrait, headX, 0)
    arrow.head:ClearAllPoints()
    arrow.head:SetPoint("CENTER", toNode.portrait, "CENTER", headX, 0)
    arrow:Show()
end

-- ── Story progress ──────────────────────────────────────────────────────────
-- The header shows the selected story's progress the way the Legacy challenge
-- page shows its points: the shield counts finished chapters, the bar fills
-- with finished quests.

local progress

function BuildProgressSummary(frame)
    local summary = CreateFrame("Frame", nil, frame)
    summary:SetSize(SUMMARY.w, SUMMARY.h)
    summary:SetPoint("TOPLEFT", frame, "TOPLEFT", SUMMARY.x, -SUMMARY.top)

    local barBackground = summary:CreateTexture(nil, "ARTWORK")
    barBackground:SetAtlas(ATLAS.barBackground)
    barBackground:SetHeight(16)
    barBackground:SetPoint("LEFT", summary, "LEFT", -6, -3)
    barBackground:SetPoint("RIGHT", summary, "RIGHT", 0, -3)

    local bar = CreateFrame("StatusBar", nil, summary)
    bar:SetPoint("TOPLEFT", barBackground, "TOPLEFT", 0, 0)
    bar:SetPoint("BOTTOMRIGHT", barBackground, "BOTTOMRIGHT", 0, 3)
    local fill = bar:CreateTexture(nil, "ARTWORK")
    fill:SetAtlas(ATLAS.barFill)
    bar:SetStatusBarTexture(fill)
    bar:SetMinMaxValues(0, 1)
    local barFrame = bar:CreateTexture(nil, "OVERLAY")
    barFrame:SetAtlas(ATLAS.barFrame)
    barFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", -8, 7)
    barFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 8, -10)
    local text = bar:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    text:SetPoint("CENTER")

    -- Over the title bar's border, as in Legacy (LegacyPointShield, level 800).
    local shield = CreateFrame("Frame", nil, summary)
    shield:SetSize(46, 64)
    shield:SetFrameLevel(OVER_FRAME_LEVEL)
    shield:SetPoint("RIGHT", summary, "LEFT", 14, 4)
    local shieldIcon = shield:CreateTexture(nil, "BACKGROUND")
    shieldIcon:SetAtlas(ATLAS.shield)
    shieldIcon:SetSize(46, 66)
    shieldIcon:SetPoint("TOPRIGHT")
    local points = shield:CreateFontString(nil, "OVERLAY", "GameFontNormalMed3")
    points:SetSize(42, 16)
    points:SetPoint("TOPRIGHT", shield, "TOPRIGHT", -2, -31)
    points:SetTextColor(1, 1, 1)

    summary:Hide()
    progress = { frame = summary, bar = bar, text = text, points = points }
end

local function ShowProgress(data)
    if not progress then return end
    if not data then
        progress.frame:Hide()
        return
    end
    local chapters = SM.GetAllChapters(data)
    local chaptersDone = 0
    for _, chapter in ipairs(chapters) do
        local done, total = SM.GetChapterProgress(chapter)
        if total > 0 and done == total then chaptersDone = chaptersDone + 1 end
    end
    local questsDone, questsTotal = SM.GetCampaignProgress(data)
    progress.points:SetText(chaptersDone)
    progress.bar:SetValue(questsTotal > 0 and questsDone / questsTotal or 0)
    progress.text:SetText(string.format(L["Progress Summary Format"], chaptersDone, #chapters, questsDone, questsTotal))
    progress.frame:Show()
end

-- Shows the tabs and progress for a story, or hides them on the start page.
function window.ShowStory(data, showScarletTab)
    for key, tab in pairs(detailTabs) do
        tab:SetShown(data ~= nil and (key ~= "scarlet" or showScarletTab == true))
    end
    ShowProgress(data)
    journal.story = data ~= nil
    UpdateJournalPage()
end

-- Opens the window where the Legacy window opens, until it's dragged
-- somewhere else. Called once StoryMode.lua has set the window's scripts,
-- since SetScript drops earlier hooks.
function window.Attach(frame)
    local moved = false
    frame:HookScript("OnDragStop", function() moved = true end)
    frame:HookScript("OnShow", function(self)
        if not moved then PlaceLikeLegacyWindow(self) end
    end)
    PlaceLikeLegacyWindow(frame)
end

-- Creates the window. If anything in it fails, the Forever window turns
-- itself off, Story Mode builds its usual window instead, and the error goes
-- to chat so it can be fixed.
function window.Create(name)
    local created, frame = pcall(CreateFrame, "Frame", name, UIParent, "PortraitFrameTemplate")
    local built, layout = false, frame
    if created then
        built, layout = pcall(window.Build, frame)
        if not built then frame:Hide() end
    end
    if created and built then return frame, layout end

    SM.ForeverWindow = nil
    C_Timer.After(3, function()
        print("|cffffd200Story Mode:|r the WoW Forever window failed, using the usual one. " .. tostring(layout))
    end)
    return nil
end

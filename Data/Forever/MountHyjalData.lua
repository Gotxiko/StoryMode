local addonName, SM = ...

-- =============================================================================
-- WoW Forever: The Dying God
-- A dying Wild God, a corrupted branch of Nordrassil and the druid who stole a god's power.
-- =============================================================================

SM.ForeverMountHyjalData = {
    title = "The Dying God",
    description = "Years after Archimonde fell, Mount Hyjal is still scarred. Fel ash poisons its slopes, warlocks pick through the ruins of the war, and the Wild Gods who watch over the mountain have begun to falter.\n\nWhen a dying god presses a corrupted branch of the World Tree into your hands, a hermit druid, a meddling crow and the wild spirits of the mountain all have questions about it, and none of them are simple.",
    zone = "Mount Hyjal / Moonglade",
    expansion = "Classic",
    recommendedLevel = { min = 55, max = 60 },
    requiredLevel = 55,
    gameVersions = { forever = true },
    achievements = {},
    color = { 0.38, 0.60, 0.36 },
    icon = "Interface\\Icons\\Spell_Nature_Tranquility",
    adventureCoverTexture = 7963779,  -- Kalimdor's loading screen: Hyjal has none of its own
    adventureCoverTexCoords = { 0, 1, 0.1592, 0.8408 },  -- the picture, between its transparent bands
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 91952, name = "The Source of the Corruption", npc = "Greta Mosshoof", location = "Emerald Sanctuary, Felwood" },
    startMapID = 1448, startX = 0.5120, startY = 0.8220,

    npcLocations = {
        ["Greta Mosshoof"] = { mapID = 1448, x = 0.5120, y = 0.8220, location = "Emerald Sanctuary, Felwood" },
        ["Ketharas"] = { mapID = 2482, x = 0.7320, y = 0.8180, location = "the hermit's cave, Mount Hyjal" },
        ["Fraxinus"] = { mapID = 2482, x = 0.5360, y = 0.8440, location = "the ancients' outpost, Mount Hyjal" },
        ["Curious Crow"] = { mapID = 2482, x = 0.4820, y = 0.8580, location = "the road below the Felblood Scar, Mount Hyjal" },
        ["Felflick"] = { mapID = 2482, x = 0.4940, y = 0.7720, location = "the entrance to the Felblood Scar, Mount Hyjal" },
        ["Velician"] = { mapID = 2482, x = 0.3660, y = 0.7820, location = "west of the Felblood Scar, Mount Hyjal" },
        ["Dendrite Starblaze"] = { mapID = 1450, x = 0.5620, y = 0.3040, location = "Nighthaven, Moonglade" },
        ["Orokai"] = { mapID = 1450, x = 0.4100, y = 0.4360, location = "southwest of Nighthaven, Moonglade" },
        ["Jereman"] = { mapID = 2482, x = 0.4160, y = 0.4560, location = "Cradle of Tranquility, Mount Hyjal" },
        ["Renalard"] = { mapID = 2482, x = 0.6000, y = 0.4920, location = "Dae'gun, Mount Hyjal" },
        ["Marrosis"] = { mapID = 2482, x = 0.2700, y = 0.5020, location = "Mourning's Rest, Mount Hyjal" },
        ["Skylord Omnuron"] = { mapID = 2482, x = 0.5420, y = 0.6380, location = "Shrine of Aviana, Mount Hyjal" },
        ["Tiala Whitemane"] = { mapID = 2482, x = 0.6880, y = 0.5040, location = "Summit of Eternity, Mount Hyjal" },
    },

    npcDisplayIDs = {
        -- Quest givers' models from the cmangos Classic database.
        ["Dendrite Starblaze"] = 11769,
        -- Quest givers' models from Wowhead's WoW Forever data.
        ["Ketharas"] = 139519,
        ["Fraxinus"] = 131608,
        ["Curious Crow"] = 140365,
        ["Felflick"] = 143840,
        ["Velician"] = 146374,
        ["Orokai"] = 1460,
        ["Jereman"] = 142089,
        ["Renalard"] = 141717,
        ["Marrosis"] = 144961,
        ["Skylord Omnuron"] = 32245,
        ["Tiala Whitemane"] = 32086,
    },

    chapters = {
        {
            chapter = "The Hermit of the Foothills",
            summary = "Fel taint keeps washing down off Mount Hyjal into Felwood, and Greta Mosshoof at the Emerald Sanctuary wants to know where it starts. Up on the mountain's lower slopes lives a hermit druid called Ketharas. Start with him.",
            recap = "Up on the lower slopes of Hyjal lives a hermit druid called Ketharas, in a cave, by choice. I liked him right away. Anyone who picks a cave over company has given it some thought.\n\nHe eased me in with seeds and owl eggs, then sent me west to the ancients and dryads still nursing their wounds from the war. That's where it got hard. One of their own, an ancient named Sunderbark, was too far gone in the corruption to come back, and somebody had to put him down.\n\nI did. Then I planted a seed in what was left of him.\n\nAfter that they sent me looking for a bird. A small one, I was told, with a great deal of power.",
            quests = {
                { id = 91952, name = "The Source of the Corruption", npc = "Greta Mosshoof", gameVersions = { forever = true } },
                { id = 95568, name = "Seeds for a New Season", npc = "Ketharas", gameVersions = { forever = true } },
                { id = 95569, name = "Hope for Hatchlings", npc = "Ketharas", gameVersions = { forever = true } },
                { id = 90487, name = "Ancient Allies", hint = "Head west from the hermit's cave. The ancients and dryads gather on the lower slopes.", hintExplorer = "The ancients are not far from the hermit's cave.", location = "the hermit's cave, Mount Hyjal", mapID = 2482, x = 0.7320, y = 0.8180, gameVersions = { forever = true } },
                { id = 92959, name = "The Dying Ancients", location = "the ancients' outpost, Mount Hyjal", mapID = 2482, x = 0.5360, y = 0.8440, gameVersions = { forever = true } },
                { id = 95766, name = "Fine Feathered Friend", npc = "Fraxinus", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "The Curious Crow",
            summary = "The bird the ancients sent you after is a crow, perched by the road below the Felblood Scar. It has strong opinions about the Ashen Reign, the warlocks working fel ash nearby. It also has a plan, and the plan starts with pinecones.",
            recap = "The bird was a crow, and the crow was trouble, the good kind. A warlock outfit was cooking things up out of fel ash below the Felblood Scar, and she wanted it stopped. Her plan started with pinecones.\n\nPrickly ones. Turns out a prickly pinecone, delivered with feeling, ruins a warlock's workstation. I ruined four.\n\nThen she got bold. The warlocks kept a demon in a cage, Felflick, and she dangled an iron key where Felflick could see it. For a shot at freedom, Felflick told me whose bones to fetch and whose soulstone to take. The bones went onto the warlocks' own heap, and something big and foul crawled back out. I put it back down.\n\nAfter all that, Felflick wanted paying. What I did about that stays between me and the crow.",
            quests = {
                { id = 96262, name = "Prickly Pinecones", npc = "Curious Crow", gameVersions = { forever = true } },
                { id = 95317, name = "Notation, Notation, Notation", npc = "Curious Crow", gameVersions = { forever = true } },
                { id = 95380, name = "A Prolific Source", npc = "Curious Crow", gameVersions = { forever = true } },
                { id = 95316, name = "The Experimental Method", npc = "Curious Crow", gameVersions = { forever = true } },
                { id = 95320, name = "A Curious Question", npc = "Curious Crow", gameVersions = { forever = true } },
                { id = 95318, name = "Taste of Ash", npc = "Felflick", gameVersions = { forever = true } },
                { id = 95319, name = "Crystalline Collection", npc = "Felflick", gameVersions = { forever = true } },
                { id = 95378, name = "The Hydra's Head", npc = "Felflick", gameVersions = { forever = true } },
                { id = 95379, name = "A Revenge So Sweet", npc = "Felflick", gameVersions = { forever = true } },
                { id = 96435, name = "A Fitting End", npc = "Felflick", gameVersions = { forever = true } },
                { id = 96255, name = "Amalgamated Marrow", location = "the bone pile west of the Felblood Scar, Mount Hyjal", mapID = 2482, x = 0.4070, y = 0.8020, gameVersions = { forever = true } },
                { id = 96322, name = "A Revenge Now Bitter", npc = "Felflick", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "A Branch of the World Tree",
            summary = "West of the Felblood Scar, out in the ash, a Wild God named Velician lies dying, with a faintly glowing branch close at hand. Velician has one last errand, and you're the only one near enough to hear it.",
            recap = "In the ash west of the warlock camp I found a Wild God dying. Velician. You don't forget a thing like that. Velician pressed a branch of the World Tree into my hands, gone bad, with a sickly green crystal grown out of it, and begged that it reach the crow.\n\nNobody on the mountain could read it, so it went down to Moonglade, to an ancient called Orokai. Orokai sat with the branch a while and then showed me what it remembered. A druid named Ve'han Talongrasp had stolen part of a Wild God's power. And he'd talked about a Pact.\n\nNobody ever forms a Pact to plant flowers.\n\nI carried that back up the mountain.",
            quests = {
                { id = 96321, name = "The Dying God", npc = "Velician", gameVersions = { forever = true } },
                { id = 96131, name = "An Oldstone But An Old Friend", npc = "Curious Crow", gameVersions = { forever = true } },
                { id = 92612, name = "Aid from Moonglade", npc = "Ketharas", gameVersions = { forever = true } },
                { id = 96209, name = "The Ancient, Orokai", npc = "Dendrite Starblaze", gameVersions = { forever = true } },
                { id = 95006, name = "Stolen Power", npc = "Orokai", gameVersions = { forever = true } },
                { id = 93773, name = "The Pact", npc = "Dendrite Starblaze", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Gifts of the Wild Gods",
            summary = "Ketharas has an idea for turning Ve'han Talongrasp's stolen power back on him, but a hermit's magic won't stretch that far. It will take gifts from the Wild Gods themselves. Ketharas sends you back to the crow, who knows how to ask.",
            recap = "Ketharas had a plan to turn the stolen power back on the thief, and it needed gifts from the gods themselves. So I went shopping among the Wild Gods.\n\nThere's an effigy on a bridge above the Cradle of Tranquility. Touch it and Jereman comes, cleverest of the lot, they say, and Jereman knew exactly who to ask. A fox in the ruins of Dae'gun said the spell could feed on the ashes of Azgalor, one of the Legion's lieutenants, so I took a pinch of a demon lord. Another god wanted a drop of the life the Scourge had stolen, so I took that back off the Scourge. And a jewel from the harpies' nests. The harpies were not consulted.\n\nI came away with a much higher opinion of foxes.",
            quests = {
                { id = 96930, name = "The Capricious Corvid", npc = "Ketharas", gameVersions = { forever = true } },
                { id = 96931, name = "Heading Up the Mountain", npc = "Curious Crow", gameVersions = { forever = true } },
                { id = 96964, name = "A Clever Creature", npc = "Jereman", gameVersions = { forever = true } },
                { id = 92335, name = "Ashes of the Legion Ascent", npc = "Renalard", gameVersions = { forever = true } },
                { id = 96939, name = "The Balance of Life and Death", npc = "Jereman", gameVersions = { forever = true } },
                { id = 92317, name = "Stolen Life", npc = "Marrosis", gameVersions = { forever = true } },
                { id = 92171, name = "Taking to New Heights", npc = "Ketharas", gameVersions = { forever = true } },
                { id = 92500, name = "A Bit of the Sky", npc = "Skylord Omnuron", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Ve'han's Fall",
            summary = "Ketharas has bound the Wild Gods' gifts into the branch and made something new of it: the Staff of the Mountain. Carry it up to Tiala Whitemane at the Summit of Eternity. Ve'han Talongrasp has had his stolen power long enough.",
            recap = "Ketharas bound the gods' gifts into the branch, and out came the Staff of the Mountain. Up at the Summit of Eternity the druids put a name to the enemy: the Blackthorne Pact. Druids who'd lost their immortality, blamed Malfurion for it, and swore they'd take that power back.\n\nThe staff did what it was made for. Point it at one of them and the wards came off, and then it was a plain fight, which suited me. Ve'han's wards came off too, in the lodge under the great tree, and without his stolen power he went down like anybody else.\n\nThe Wild God he'd been trying to devour went home free. The druids thanked me, and offered the hermit a standing welcome, should Ketharas ever want company.\n\nI wouldn't hold my breath.",
            quests = {
                { id = 90647, name = "The Staff of the Mountain", npc = "Ketharas", gameVersions = { forever = true } },
                { id = 92169, name = "Paying Back the Pact", npc = "Tiala Whitemane", gameVersions = { forever = true } },
                { id = 92833, name = "Ve'han's Fall", npc = "Tiala Whitemane", gameVersions = { forever = true } },
                { id = 93521, name = "Challenger of the Gods", location = "Nordrassil Lodge, Mount Hyjal", mapID = 2482, x = 0.7690, y = 0.3540, gameVersions = { forever = true } },
                { id = 99670, name = "Return to Jereman", npc = "Tiala Whitemane", gameVersions = { forever = true } },
                { id = 93848, name = "Work Well Done", npc = "Tiala Whitemane", gameVersions = { forever = true } },
            },
        },
    },
}

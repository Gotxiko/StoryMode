local addonName, SM = ...

-- =============================================================================
-- WoW Forever: Unfinished Business (paladin)
-- Two dead men with oaths still to keep: Orthas, a dwarf thane's spirit in
-- the Eastern Plaguelands (Season of Discovery), and the Knight of Mourning
-- in Tirisfal Glades (Forever's own, 93030 and 99187). Quest IDs, order and
-- text: /sm scan and the client's enUS quest cache (build 1.60.1.70959).
-- The cache doesn't say who gives a quest or where they stand, so the
-- quests carry the place as text.
--
-- Not yet confirmed:
-- - The Knight of Mourning is Horde only. He tells you "Then, I died. It
--   seems that we both have that much in common", so he speaks to Forsaken
--   paladins.
-- - Orthas is open to both factions.
-- =============================================================================

SM.ForeverUnfinishedBusinessData = {
    title = "Unfinished Business",
    description = "Not every soul the Light should have laid to rest has gone quietly. Some are waiting on a promise they never kept, and they've noticed you're the sort who keeps them.\n\nA dwarf thane in the Eastern Plaguelands and a dead knight in Tirisfal Glades both have one last errand.",
    zone = "Eastern Plaguelands / Tirisfal Glades",
    zoneByFaction = {
        Alliance = "Eastern Plaguelands",
        Horde = "Eastern Plaguelands / Tirisfal Glades / Kalimdor",
    },
    expansion = "Classic",
    class = "PALADIN",
    recommendedLevel = { min = 57, max = 59 },
    requiredLevel = 50,
    gameVersions = { forever = true },
    achievements = {},
    color = { 0.62, 0.66, 0.78 },
    icon = "Interface\\Icons\\INV_Hammer_04",
    adventureCoverTexture = 131871,  -- Stratholme loading screen: Maleki the Pallid and the Plaguelands
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 84318, name = "Oi!", npc = "Orthas", location = "the spirit of Orthas, Eastern Plaguelands", gameVersions = { forever = true } },
    startMapID = 1423,

    npcLocations = {
        ["Orthas"] = { location = "the spirit of Orthas, Eastern Plaguelands" },
        ["The Knight of Mourning"] = { location = "Tirisfal Glades" },
    },

    chapters = {
        {
            chapter = "A Thane's Last Wishes",
            requiredLevel = 54,
            summary = "In the Eastern Plaguelands, a dead dwarf has taken an interest in you. Orthas was a mighty thane under the mountain once, and he isn't ready to move on. He has decided you're going to help.",
            recap = "So there's this dwarf. Dead, a thane once, and grateful I'd smashed the rotting body he'd been stuck in all those years. Grateful enough to conscript me, anyway.\n\nOrthas had unfinished business. First his hammer, somewhere in Corrin's Crossing. Then his clan's armor, which was inside an abomination in Plaguewood. I'll spare you that part. Then a wee bit of necromancy, all perfectly normal, he assured me, for which we needed a runestone off Maleki the Pallid in Stratholme and a suitable dwarf corpse by the Undercroft.\n\nThen he went on his way, and left me a chest and a warning: if I ever see a giant floating necropolis, run.\n\nA paladin helping with necromancy. I've decided it counts as a burial.",
            quests = {
                { id = 84318, name = "Oi!", npc = "Orthas", gameVersions = { forever = true } },
                { id = 84319, name = "Oh No Ye Don't!", npc = "Orthas", gameVersions = { forever = true } },
                { id = 84330, name = "A Wee Bit O' Necromancy", npc = "Orthas", gameVersions = { forever = true } },
                { id = 84414, name = "Send Me On Me Way", npc = "Orthas", gameVersions = { forever = true } },
                { id = 84332, name = "A Thane's Gratitude", location = "a small chest, Eastern Plaguelands", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "The Knight of Mourning",
            requiredLevel = 50,
            faction = "Horde",
            summary = "In Tirisfal Glades, a dead knight keeps a vigil nobody asked him to keep. The Knight of Mourning swore an oath once, and he'd like to tell you how he failed it. You may recognize a few things about him.",
            recap = "The Knight of Mourning served the Light once, and then died. We had that much in common, he said. Unlike me, he couldn't rest. He had sworn to bring the Reliquary of Tyr home to Tirisfal, and he'd failed.\n\nThe Blackmaw had it, at Blackmaw Hold, all the way across the sea in Kalimdor. They're powerful totemics and knew exactly what they were holding. They held it less well after I arrived.\n\nSo I carried it home to Tirisfal. I'm no Knight of Lordaeron, he'd told me. Though perhaps I am, in a way.\n\nI'll take that.",
            quests = {
                { id = 93030, name = "The Knight of Mourning", npc = "The Knight of Mourning", faction = "Horde", gameVersions = { forever = true } },
                { id = 99187, name = "The Reliquary of Tyr", npc = "The Knight of Mourning", faction = "Horde", gameVersions = { forever = true } },
            },
        },
    },
}

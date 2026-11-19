local addonName, SM = ...

-- =============================================================================
-- Classic: Maraudon
-- Vyle corruption, the Scepter of Celebras, Theradras, and Zaetar's seed.
-- =============================================================================

SM.MaraudonData = {
    id = "maraudon",  -- from its earlier title, "Maraudon": saved progress and share links use it
    title = "Legends of Maraudon",
    description = "The crystal caverns beneath Desolace are holy ground, burial ground, and wound all at once. Satyrs, centaur spirits and corrupted plants all pull at the same buried story.\n\nEnter Maraudon from the orange and purple passages and follow its old stories as far down as they go.",
    zone = "Desolace / Maraudon / Moonglade",
    expansion = "Classic",
    recommendedLevel = { min = 39, max = 52 },
    gameVersions = { classicEra = true, tbc = true },
    achievements = {},
    color = { 0.46, 0.66, 0.42 },
    icon = 134186,
    adventureGuideInstanceName = "Maraudon",
    adventureCoverTexture = 131850, -- Maraudon loading screen
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 7067, name = "The Pariah's Instructions", npc = "Centaur Pariah", location = "southern Desolace" },
    startMapID = 66,
    startX = 0.4700,
    startY = 0.8700,

    npcLocations = {
        ["Centaur Pariah"] = { mapID = 66, x = 0.4700, y = 0.8700, location = "southern Desolace, near the Valley of Spears" },
        ["Willow"] = { mapID = 66, x = 0.6200, y = 0.3900, location = "Kormek's Hut, Desolace" },
        ["Talendria"] = { mapID = 66, x = 0.6800, y = 0.0800, location = "Nijel's Point, Desolace" },
        ["Vark Battlescar"] = { mapID = 66, x = 0.2300, y = 0.7000, location = "Shadowprey Village, Desolace" },
        ["Cavindra"] = { mapID = 280, x = 0.3000, y = 0.4300, location = "the orange crystal passage, Maraudon" },
        ["Celebras the Redeemed"] = { mapID = 280, x = 0.5200, y = 0.4800, location = "Maraudon" },
        ["Keeper Marandis"] = { mapID = 66, x = 0.6300, y = 0.1000, location = "Nijel's Point, Desolace" },
        ["Selendra"] = { mapID = 66, x = 0.2600, y = 0.7700, location = "south of Shadowprey Village, Desolace" },
        ["Zaetar's Spirit"] = { mapID = 280, x = 0.5000, y = 0.7600, location = "Earth Song Falls, Maraudon" },
        ["Keeper Remulos"] = { mapID = 80, x = 0.3600, y = 0.4100, location = "Nighthaven, Moonglade" },
        ["Olana Brighthoof"] = { mapID = 7, x = 0.3260, y = 0.2400, location = "near Thunder Bluff, Mulgore" },
    },

    chapterDisplayIDs = {
        ["The Pariah and the Prophet"] = 11797,
        ["Vyle Corruption"] = 11790,
        ["The Scepter of Celebras"] = 11789,
        ["Corruption of Earth and Seed"] = 12201,
    },

    chapterIcons = {
        ["The Pariah and the Prophet"] = 134123,
        ["Vyle Corruption"] = 134186,
        ["The Scepter of Celebras"] = 135139,
        ["Corruption of Earth and Seed"] = 136025,
    },

    npcDisplayIDs = {
        -- Quest givers' models from the cmangos Classic database.
        ["Centaur Pariah"] = 9419,
        ["Willow"] = 13909,
        ["Talendria"] = 11683,
        ["Archmage Tervosh"] = 2969,
        ["Celebras the Redeemed"] = 13715,
        ["Keeper Marandis"] = 150,
        ["Selendra"] = 13672,
        ["Zaetar's Spirit"] = 12369,
        -- Quest givers' models from Wowhead's WoW Forever data.
        ["Olana Brighthoof"] = 145507,
    },

    chapters = {
        {
            chapter = "The Pariah and the Prophet",
            requiredLevel = 39,
            summary = "The Centaur Pariah, an outcast camped in southern Desolace, has a job for you in Maraudon, written out in full. Up near Kormek's Hut, Willow wants something from the same caves: crystal carvings, and plenty of them.",
            recap = "Desolace has two kinds of people who'll give you advice about Maraudon, and neither kind tells you why.\n\nThe first was the Centaur Pariah, out in southern Desolace. The Pariah's instructions came written down, and they read like the guest list for a funeral: the Nameless Prophet, the dead khans, and at the end of it all, the Amulet of Union. I went down and collected. Long-dead centaur are no friendlier than the living ones, I can tell you that.\n\nThe second was somebody called Willow, who just wanted carvings. Twenty-five Theradric crystal carvings out of Maraudon. The caves were not short of them, and neither were the things guarding them.\n\nI never did find out what either of them wanted it all for. In Desolace, that counts as a warm welcome.",
            quests = {
                { id = 7067, name = "The Pariah's Instructions", npc = "Centaur Pariah", optional = true },
                { id = 7028, name = "Twisted Evils", npc = "Willow", optional = true },
            },
        },
        {
            chapter = "Vyle Corruption",
            follows = false,
            requiredLevel = 41,
            summaryAlliance = "Something is corrupting the plants of Maraudon. Talendria at Nijel's Point has a remedy to try, a coated vial to fill at the caverns' orange crystal pool. Archmage Tervosh in Theramore wants shadowshards from the purple side, too.",
            summaryHorde = "Something is corrupting the plants of Maraudon. Vark Battlescar at Shadowprey Village has a remedy to try, a coated vial to fill at the caverns' orange crystal pool. Uthel'nay in Orgrimmar wants shadowshards from the purple side, too.",
            recapAlliance = "Talendria at Nijel's Point had a cure for what was eating Maraudon, or the start of one. A coated cerulean vial, filled at the orange crystal pool down in the caverns, then splashed on the Vylestem vines. The vines don't care for it. Out comes a Noxxious Scion, all rot and temper, and once you've killed it the plant is clean again. Eight plants.\n\nGardening, but with more killing than usual.\n\nMaraudon was sick, and the rot had Lord Vyletongue's name on it. He was somewhere further down.",
            recapHorde = "Vark Battlescar at Shadowprey Village had a remedy for the rot in Maraudon, or the start of one. Take a coated cerulean vial down into the caverns, fill it at the orange crystal pool, and splash it on the Vylestem vines. The vines cough up something called a Noxxious Scion. Put the Scion down and the plant comes back clean. Eight of those and you've healed a garden.\n\nWeeding, the hard way.\n\nMaraudon was sick, and the rot had Lord Vyletongue's name on it. He was somewhere further down, waiting.",
            quests = {
                { id = 7041, name = "Vyletongue Corruption", npc = "Talendria", faction = "Alliance" },
                { id = 7029, name = "Vyletongue Corruption", npc = "Vark Battlescar", faction = "Horde" },
                { id = 7070, name = "Shadowshard Fragments", npc = "Archmage Tervosh", faction = "Alliance", optional = true, mapID = 70, x = 0.6600, y = 0.4900, location = "Theramore, Dustwallow Marsh", recapAfter = 2, recap = "On the side, Archmage Tervosh in Theramore wanted ten shadowshard fragments from the purple end of the caves. Pretty things, if you like your crystals a little sickly. I didn't ask what an archmage wants with them. Archmages get touchy." },
                { id = 7068, name = "Shadowshard Fragments", npc = "Uthel'nay", faction = "Horde", optional = true, mapID = 85, x = 0.3900, y = 0.8600, location = "Valley of Spirits, Orgrimmar", recapAfter = 2, recap = "Uthel'nay in Orgrimmar wanted ten shadowshard fragments from the purple side of the caves, so I hauled those all the way up to the Valley of Spirits. Heavy, sharp, and apparently worth it." },
            },
        },
        {
            chapter = "The Scepter of Celebras",
            follows = false,
            requiredLevel = 41,
            summary = "Just inside Maraudon's orange passage, Cavindra tells a legend of the caves: Celebras, and his scepter, now in two pieces. Find the rod and the diamond, then find a way to speak with Celebras himself.",
            recap = "Cavindra had a story about Maraudon, and the story was about Celebras, a keeper the caverns had twisted. Fixing him meant the Scepter of Celebras, which had come apart into a rod and a diamond, and two of the nastiest things in Maraudon were holding a piece each. Neither was in a sharing mood, so I didn't ask nicely.\n\nThen there was Celebras himself, cursed and wild, who had to be beaten before he could be talked to. Not a sentence I expected to say about a keeper.\n\nAfterward he was Celebras the Redeemed, calm and himself again, and I helped him put the scepter back together. Handy thing. Opens a shortcut into the deeper caves.\n\nI've had worse rewards than a door I don't have to fight my way through.",
            quests = {
                { id = 7044, name = "Legends of Maraudon", npc = "Cavindra" },
                { id = 7046, name = "The Scepter of Celebras", npc = "Celebras the Redeemed" },
            },
        },
        {
            chapter = "Corruption of Earth and Seed",
            follows = false,
            requiredLevel = 45,
            summaryAlliance = "Keeper Marandis at Nijel's Point wants Princess Theradras dead. The princess waits at the very bottom of Maraudon, and everything between here and there would rather you stayed home.",
            summaryHorde = "Selendra, camped near Shadowprey Village, wants Princess Theradras dead. The princess waits at the very bottom of Maraudon, and everything between here and there would rather you stayed home.",
            recap = "At the very bottom of Maraudon lives Princess Theradras. She is a great deal of angry rock, more or less, and she did not want company. I'd been sent down to kill her, so that worked out for everyone but her.\n\nWhen she fell, a spirit came to talk. Zaetar. Brother of Remulos, and, with Theradras, father of the centaur, which explains a lot about Desolace. He'd been down there a long time. He didn't ask for revenge. He asked me to take something to his brother, and gave me the Seed of Life for Remulos in Moonglade.\n\nSo I carried a seed out of the deepest hole in Desolace, all the way to Moonglade.\n\nEverything in Maraudon had tried to kill me on the way down. The last thing it did was hand me a gift. Odd place.",
            quests = {
                { id = 7065, name = "Corruption of Earth and Seed", npc = "Keeper Marandis", faction = "Alliance" },
                { id = 7064, name = "Corruption of Earth and Seed", npc = "Selendra", faction = "Horde" },
                { id = 7066, name = "Seed of Life", npc = "Zaetar's Spirit" },
                { id = 96776, name = "An'she's Radiance", npc = "Olana Brighthoof", faction = "Horde", optional = true, gameVersions = { forever = true }, recap = "Olana Brighthoof, a sun priest near Thunder Bluff, had seen it in a vision: past Earth Song Falls, a chamber of white crystals with giants on guard, and at the very top, the right eye of the Earthmother. The vision was right about everything, giants included. I carried it back to Mulgore, where it belongs, under the open sky." },
            },
        },
    },
}

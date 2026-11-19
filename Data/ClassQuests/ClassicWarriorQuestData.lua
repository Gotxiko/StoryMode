local addonName, SM = ...

-- =============================================================================
-- Classic warrior quests
-- Curated identity chains: iconic abilities, tools, weapons, and mounts.
-- =============================================================================

SM.ClassicWarriorQuestData = {
    id = "whirlwind-weapon",  -- from its earlier title, "Whirlwind Weapon": saved progress and share links use it
    title = "The Warrior's Trials",
    description = "Your warrior trainer has a practical lesson first: learn to stand, endure, and fight with discipline. After that, older tests wait beyond the starting grounds.\n\nSeek the instructors who send warriors to brawls, islands, charms, and a windwatcher's summons. The reward is a weapon, but the road is the real trial.",
    zone = "The Barrens / Stranglethorn Vale / Arathi Highlands",
    expansion = "Classic",
    class = "WARRIOR",
    gameVersions = { classicEra = true, tbc = true },
    color = { 0.78, 0.61, 0.43 },
    icon = 132355,
    adventureCoverTexture = 131824, -- Blackrock Depths: martial arena imagery closest to the warrior weapon trial
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 1638, name = "A Warrior's Training", npc = "Lyria Du Lac", faction = "Alliance", mapID = 37, x = 0.4109, y = 0.6577, location = "Lyria Du Lac, Elwynn Forest" },
    startMapID = 10,
    startX = 0.6800,
    startY = 0.3600,

    chapterIcons = {
        ["Defensive Stance"] = 132341,
        ["Whirlwind Weapon"] = 132408,
    },

    npcDisplayIDs = {
        -- Quest givers' models from the cmangos Classic database.
        ["Lyria Du Lac"] = 1300,
        ["Harry Burlguard"] = 4996,
        ["Bartleby"] = 5000,
        ["Kyra Windblade"] = 1707,
        ["Elanaria"] = 2197,
        ["Granis Swiftaxe"] = 3431,
        ["Muren Stormpike"] = 4995,
        ["Tormus Deepforge"] = 4950,
        ["Deathguard Dillinger"] = 2855,
        ["Uzzek"] = 4391,
        ["Thun'grim Firegaze"] = 4521,
        ["Wu Shen"] = 3280,
        ["Klannoc Macleod"] = 4955,
        ["Bath'rah the Windwatcher"] = 4954,
    },

    chapters = {
        {
            chapter = "Defensive Stance",
            requiredLevel = 10,
            summary = "Your trainer says you swing well enough. Time for your first real trial. Your trainer will tell you who to see, and like most warrior business, it ends with somebody on the ground. Make sure it isn't you.",
            recap = "Warriors learn to hit first. Then they learn to get hit. The second one keeps you alive.\n\nMy first trial was a job, and the job was a fight. It always is. I won, and I brought back what they'd asked for. Nothing clever. Hit the thing, carry the thing, come home.\n\nThen the lesson. Feet set. Shield up. Weight low. Let the blow land where you can take it. You hit softer standing like that. Doesn't matter. The other side tires first.\n\nI hated it at first. Standing still feels like losing. Then I took a few hits in that stance that would have dropped me flat a week before, and I was still up. I came round fast after that.\n\nPeople think a warrior is all swing. The good ones are mostly stand.",
            quests = {
                { id = 94003, name = "The Skybreaker Bulwark", race = "Skyborne", location = "Zephras Isle", gameVersions = { forever = true } },
                { id = 1638, name = "A Warrior's Training", npc = "Lyria Du Lac", race = "Human", faction = "Alliance", mapID = 37, x = 0.4109, y = 0.6577, location = "Lyria Du Lac, Elwynn Forest" },
                { id = 1639, name = "Bartleby the Drunk", npc = "Harry Burlguard", race = "Human", faction = "Alliance", mapID = 84, x = 0.7426, y = 0.3725, location = "Harry Burlguard, Stormwind" },
                { id = 1640, name = "Beat Bartleby", npc = "Bartleby", race = "Human", faction = "Alliance", mapID = 84, x = 0.7378, y = 0.3633, location = "Bartleby, Stormwind" },
                { id = 1665, name = "Bartleby's Mug", npc = "Bartleby", race = "Human", faction = "Alliance", mapID = 84, x = 0.7378, y = 0.3633, location = "Bartleby, Stormwind" },
                { id = 1684, name = "Elanaria", npc = "Kyra Windblade", race = "NightElf", faction = "Alliance", mapID = 57, x = 0.5622, y = 0.5920, location = "Kyra Windblade, Teldrassil" },
                { id = 1683, name = "Vorlus Vilehoof", npc = "Elanaria", race = "NightElf", faction = "Alliance", mapID = 89, x = 0.5730, y = 0.3460, location = "Elanaria, Darnassus" },
                { id = 1679, name = "Muren Stormpike", npc = "Granis Swiftaxe", race = { "Dwarf", "Gnome" }, faction = "Alliance", mapID = 27, x = 0.4736, y = 0.5265, location = "Granis Swiftaxe, Dun Morogh" },
                { id = 1678, name = "Vejrek", npc = "Muren Stormpike", race = { "Dwarf", "Gnome" }, faction = "Alliance", mapID = 87, x = 0.7077, y = 0.9027, location = "Muren Stormpike, Ironforge" },
                { id = 1680, name = "Tormus Deepforge", npc = "Muren Stormpike", race = { "Dwarf", "Gnome" }, faction = "Alliance", mapID = 87, x = 0.7077, y = 0.9027, location = "Muren Stormpike, Ironforge" },
                { id = 1681, name = "Ironband's Compound", npc = "Tormus Deepforge", race = { "Dwarf", "Gnome" }, faction = "Alliance", mapID = 87, x = 0.4840, y = 0.4300, location = "Tormus Deepforge, Ironforge" },
                { id = 1818, name = "Speak with Dillinger", npc = "Austil de Mon", race = "Scourge", faction = "Horde", mapID = 18, x = 0.6185, y = 0.5254, location = "Austil de Mon, Tirisfal Glades" },
                { id = 1819, name = "Ulag the Cleaver", npc = "Deathguard Dillinger", race = "Scourge", faction = "Horde", mapID = 18, x = 0.5820, y = 0.5145, location = "Deathguard Dillinger, Tirisfal Glades" },
                { id = 1820, name = "Speak with Coleman", npc = "Deathguard Dillinger", race = "Scourge", faction = "Horde", mapID = 18, x = 0.5820, y = 0.5145, location = "Deathguard Dillinger, Tirisfal Glades" },
                { id = 1821, name = "Agamand Heirlooms", npc = "Coleman Farthing", race = "Scourge", faction = "Horde", mapID = 18, x = 0.6172, y = 0.5229, location = "Gallows' End Tavern, Brill" },
                { id = 1505, name = "Veteran Uzzek", npc = "Krang Stonehoof", race = { "Orc", "Troll", "Tauren" }, faction = "Horde", mapID = 7, x = 0.4952, y = 0.6059, location = "Krang Stonehoof, Mulgore" },
                { id = 1498, name = "Path of Defense", npc = "Uzzek", race = { "Orc", "Troll", "Tauren" }, faction = "Horde", mapID = 10, x = 0.6138, y = 0.2112, location = "Uzzek, The Barrens" },
                { id = 1502, name = "Thun'grim Firegaze", npc = "Uzzek", race = { "Orc", "Troll", "Tauren" }, faction = "Horde", mapID = 10, x = 0.6138, y = 0.2112, location = "Uzzek, The Barrens" },
                { id = 1503, name = "Forged Steel", npc = "Thun'grim Firegaze", race = { "Orc", "Troll", "Tauren" }, faction = "Horde", mapID = 10, x = 0.5720, y = 0.3020, location = "Thun'grim Firegaze, The Barrens" },
            },
        },
        {
            chapter = "Whirlwind Weapon",
            follows = false,
            requiredLevel = 30,
            summary = "Your trainer sends you to Klannoc Macleod, the Islander, who runs a fighting pit on Fray Island in the Barrens. Warriors go there to find out what they're made of. Bring a good weapon and a thick skull.",
            recap = "Here's how I got this.\n\nThe Islander runs a fighting pit on Fray Island, out in the Barrens. You step on the grate and they come at you, one after another, and then Big Will comes. Big Will is well named. I put Big Will on the ground.\n\nThat got me sent to Bath'rah the Windwatcher, up in the Alterac hills. Bath'rah wanted charms and tusks and roots, a cauldron's worth, all to call up an air elemental named Cyclonian.\n\nCyclonian came. Cyclonian is a storm with a temper. I hit it until it stopped being a storm, and I took its heart.\n\nBath'rah set the heart into the weapon I chose. Now it spins. So does anybody standing too close.",
            quests = {
                { id = 1718, name = "The Islander", npc = "Wu Shen", faction = "Alliance", mapID = 84, x = 0.7868, y = 0.4579, location = "Wu Shen, Stormwind, then Fray Island, The Barrens" },
                { id = 1718, name = "The Islander", npc = "Sorek", faction = "Horde", mapID = 85, x = 0.8039, y = 0.3238, location = "Sorek, Orgrimmar, then Fray Island, The Barrens" },
                { id = 1719, name = "The Affray", npc = "Klannoc Macleod", mapID = 10, x = 0.6861, y = 0.4916, location = "Klannoc Macleod, The Barrens" },
                { id = 1791, name = "The Windwatcher", npc = "Klannoc Macleod", mapID = 10, x = 0.6861, y = 0.4916, location = "Klannoc Macleod, The Barrens" },
                { id = 1712, name = "Cyclonian", npc = "Bath'rah the Windwatcher", mapID = 25, x = 0.8050, y = 0.6692, location = "Bath'rah the Windwatcher, Ravenholdt Manor, Hillsbrad Foothills" },
                { id = 1714, name = "Essence of the Exile", untracked = true, parallel = true, npc = "Bath'rah's Cauldron", mapID = 25, x = 0.7826, y = 0.0689, location = "Bath'rah's Cauldron, Alterac Mountains" },
                { id = 1713, name = "The Summoning", after = 1712, npc = "Bath'rah the Windwatcher", mapID = 25, x = 0.8050, y = 0.6692, location = "Bath'rah the Windwatcher, Ravenholdt Manor, Hillsbrad Foothills" },
                { id = 1792, name = "Whirlwind Weapon", npc = "Bath'rah the Windwatcher", mapID = 25, x = 0.8050, y = 0.6692, location = "Bath'rah the Windwatcher, Ravenholdt Manor, Hillsbrad Foothills" },
            },
        },
    },
}

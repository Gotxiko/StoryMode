local addonName, SM = ...

-- =============================================================================
-- Classic hunter quests
-- Curated identity chains: iconic abilities, tools, weapons, and mounts.
-- =============================================================================

SM.ClassicHunterQuestData = {
    title = "The Hunter's Path",
    description = "When your hunter trainer turns from weapons to trust, learn how to tame and train a beast. Later, if an ancient leaf ever finds its way into your hands, answer the stranger calling from Felwood.",
    zone = "Teldrassil / Dun Morogh / Mulgore / Durotar / Felwood / Molten Core",
    expansion = "Classic",
    class = "HUNTER",
    gameVersions = { classicEra = true, tbc = true },
    color = { 0.67, 0.83, 0.45 },
    icon = 132164,
    adventureCoverTexture = 131851, -- Molten Core: source of the Ancient Petrified Leaf for Rhok'delar
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 6074, name = "The Hunter's Path", npc = "Thorgas Grimson", faction = "Alliance", race = "Dwarf", mapID = 27, x = 0.2918, y = 0.6745, location = "Thorgas Grimson, Dun Morogh" },
    startMapID = 1,
    startX = 0.4600,
    startY = 0.5300,

    chapterIcons = {
        ["Taming the Beast"] = 132164,
        ["Rhok'delar"] = 135489,
    },

    npcDisplayIDs = {
        -- Quest givers' models from the cmangos Classic database.
        ["Jocaste"] = 2206,
        ["Dazalar"] = 1703,
        ["Thorgas Grimson"] = 3395,
        ["Grif Wildheart"] = 3558,
        ["Jen'shan"] = 1882,
        ["Sian'dur"] = 4241,
        ["Thotar"] = 3744,
        -- Quest givers' models from Wowhead's WoW Forever data.
        ["Josephine Carson"] = 137105,
        ["Quel'ana Quickgale"] = 140075,
        ["Vartrus the Ancient"] = 14567,
        ["Stoma the Ancient"] = 14567,
        ["Hastat the Ancient"] = 14567,
    },

    chapters = {
        {
            chapter = "Taming the Beast",
            requiredLevel = 10,
            summary = "Your trainer says a hunter shouldn't hunt alone, and knows who has a taming rod for you. There are beasts to try it on, and none of them asked to be tamed. Whether any of them follows you home is up to you.",
            recap = "Every hunter starts the same way. Your trainer hands you a rod, points at something with teeth and tells you to go and make friends.\n\nThe Taming Rod does half the talking. You get close, you hold steady, and if you've got it right the beast stops trying to eat you and starts following you about instead. Then you work together a while, so you both learn the job. I did that three times, with three different beasts, and handed the rod back each time with all my fingers.\n\nAfter that I was sent to a proper trainer to learn how to keep a beast of my own. I've had a partner at my side ever since. Finds the trail, takes the first bite, holds them still while I shoot. I get paid. It gets fed. Best bargain either of us ever made.",
            quests = {
                { id = 94792, name = "Taming the Beast", npc = "Josephine Carson", race = "Human", faction = "Alliance", location = "Josephine Carson, Elwynn Forest", gameVersions = { forever = true } },
                { id = 94863, name = "Taming the Beast", npc = "Josephine Carson", race = "Human", faction = "Alliance", location = "Josephine Carson, Elwynn Forest", gameVersions = { forever = true } },
                { id = 94864, name = "Taming the Beast", npc = "Josephine Carson", race = "Human", faction = "Alliance", location = "Josephine Carson, Elwynn Forest", gameVersions = { forever = true } },
                { id = 94793, name = "Training the Beast", npc = "Josephine Carson", race = "Human", faction = "Alliance", location = "Josephine Carson, Elwynn Forest", gameVersions = { forever = true } },
                { id = 94007, name = "Taming the Beast", race = "Skyborne", location = "Zephras Isle", gameVersions = { forever = true } },
                { id = 94978, name = "Taming the Beast", npc = "Quel'ana Quickgale", race = "Skyborne", location = "Quel'ana Quickgale, Valanaar, Zephras Isle", gameVersions = { forever = true } },
                { id = 94979, name = "Taming the Beast", npc = "Quel'ana Quickgale", race = "Skyborne", location = "Quel'ana Quickgale, Valanaar, Zephras Isle", gameVersions = { forever = true } },
                { id = 94013, name = "Taming the Beast", npc = "Quel'ana Quickgale", race = "Skyborne", location = "Quel'ana Quickgale, Valanaar, Zephras Isle", gameVersions = { forever = true } },
                { id = 94050, name = "Training the Beast", npc = "Quel'ana Quickgale", race = "Skyborne", location = "Quel'ana Quickgale, Valanaar, Zephras Isle", gameVersions = { forever = true } },
                { id = 6071, altIds = { 6073, 6722, 6721, 6072 }, name = "The Hunter's Path", npc = "Jocaste", race = "NightElf", faction = "Alliance", mapID = 89, x = 0.4038, y = 0.0854, location = "Jocaste, Darnassus" },
                { id = 6063, name = "Taming the Beast", npc = "Dazalar", race = "NightElf", mapID = 57, x = 0.5668, y = 0.5949, location = "Dazalar, Teldrassil" },
                { id = 6101, name = "Taming the Beast", npc = "Dazalar", race = "NightElf", mapID = 57, x = 0.5668, y = 0.5949, location = "Dazalar, Teldrassil" },
                { id = 6102, name = "Taming the Beast", npc = "Dazalar", race = "NightElf", mapID = 57, x = 0.5668, y = 0.5949, location = "Dazalar, Teldrassil" },
                { id = 6103, name = "Training the Beast", npc = "Dazalar", race = "NightElf", mapID = 57, x = 0.5668, y = 0.5949, location = "Dazalar, Teldrassil" },
                { id = 6074, altIds = { 6076, 6075 }, name = "The Hunter's Path", npc = "Thorgas Grimson", race = "Dwarf", faction = "Alliance", mapID = 27, x = 0.2918, y = 0.6745, location = "Thorgas Grimson, Dun Morogh" },
                { id = 6064, name = "Taming the Beast", npc = "Grif Wildheart", race = "Dwarf", mapID = 27, x = 0.4581, y = 0.5304, location = "Grif Wildheart, Dun Morogh" },
                { id = 6084, name = "Taming the Beast", npc = "Grif Wildheart", race = "Dwarf", mapID = 27, x = 0.4581, y = 0.5304, location = "Grif Wildheart, Dun Morogh" },
                { id = 6085, name = "Taming the Beast", npc = "Grif Wildheart", race = "Dwarf", mapID = 27, x = 0.4581, y = 0.5304, location = "Grif Wildheart, Dun Morogh" },
                { id = 6086, name = "Training the Beast", npc = "Grif Wildheart", race = "Dwarf", mapID = 27, x = 0.4581, y = 0.5304, location = "Grif Wildheart, Dun Morogh" },
                { id = 6065, altIds = { 6067, 6066 }, name = "The Hunter's Path", npc = "Kary Thunderhorn", race = "Tauren", faction = "Horde", mapID = 88, x = 0.5849, y = 0.8833, location = "Kary Thunderhorn, Thunder Bluff" },
                { id = 6061, name = "Taming the Beast", npc = "Yaw Sharpmane", race = "Tauren", mapID = 7, x = 0.4782, y = 0.5569, location = "Yaw Sharpmane, Mulgore" },
                { id = 6087, name = "Taming the Beast", npc = "Yaw Sharpmane", race = "Tauren", mapID = 7, x = 0.4782, y = 0.5569, location = "Yaw Sharpmane, Mulgore" },
                { id = 6088, name = "Taming the Beast", npc = "Yaw Sharpmane", race = "Tauren", mapID = 7, x = 0.4782, y = 0.5569, location = "Yaw Sharpmane, Mulgore" },
                { id = 6089, name = "Training the Beast", npc = "Yaw Sharpmane", race = "Tauren", mapID = 7, x = 0.4782, y = 0.5569, location = "Yaw Sharpmane, Mulgore" },
                { id = 6068, altIds = { 6070 }, name = "The Hunter's Path", npc = "Jen'shan", race = "Orc", faction = "Horde", mapID = 1, x = 0.4284, y = 0.6933, location = "Valley of Trials, Durotar" },
                { id = 6069, altIds = { 6070 }, name = "The Hunter's Path", npc = "Sian'dur", race = "Troll", faction = "Horde", mapID = 85, x = 0.6796, y = 0.1780, location = "Valley of Honor, Orgrimmar" },
                { id = 6062, name = "Taming the Beast", npc = "Thotar", race = { "Orc", "Troll" }, mapID = 1, x = 0.5185, y = 0.4349, location = "Thotar, Durotar" },
                { id = 6083, name = "Taming the Beast", npc = "Thotar", race = { "Orc", "Troll" }, mapID = 1, x = 0.5185, y = 0.4349, location = "Thotar, Durotar" },
                { id = 6082, name = "Taming the Beast", npc = "Thotar", race = { "Orc", "Troll" }, mapID = 1, x = 0.5185, y = 0.4349, location = "Thotar, Durotar" },
                { id = 6081, name = "Training the Beast", npc = "Thotar", race = { "Orc", "Troll" }, mapID = 1, x = 0.5185, y = 0.4349, location = "Thotar, Durotar" },
            },
        },
        {
            chapter = "Rhok'delar",
            follows = false,
            requiredLevel = 60,
            summary = "If you ever bring the Ancient Petrified Leaf out of Molten Core, know that it belongs to someone. It looks like nothing much, and it's a big world. Start your search in Felwood.",
            recap = "Out of Molten Core, if you're lucky, comes a leaf. Ancient Petrified Leaf. Looks like nothing. Its owner turned out to be Vartrus, an ancient up in Felwood, and Vartrus wanted four demons dead.\n\nThey weren't hard to kill. They were hard to find, because they were living among ordinary folk under friendly names. Artorius the Amiable, for one. Very amiable. Less so after the first arrow.\n\nIt had to be done alone, the ancients said. My pet and I agreed the pet didn't count. The pet did most of the tracking, so that seemed only fair.\n\nThe other two ancients wanted sinew from a grown black dragon and a grown blue one. Neither dragon was in a giving mood. What I got for it all was Rhok'delar, the longbow of the Ancient Keepers. My pet still hasn't forgiven me for not getting one too.",
            quests = {
                { id = 7632, name = "The Ancient Leaf", npc = "Ancient Petrified Leaf", mapID = 77, x = 0.4800, y = 0.2400, location = "Irontree Woods, Felwood" },
                { id = 7636, name = "Stave of the Ancients", npc = "Vartrus the Ancient", mapID = 77, x = 0.4800, y = 0.2400, location = "Vartrus the Ancient, Irontree Woods, Felwood" },
                { id = 7635, name = "A Proper String", parallel = true, npc = "Stoma the Ancient", mapID = 77, x = 0.4800, y = 0.2400, location = "Stoma the Ancient, Irontree Woods, Felwood" },
                { id = 7634, name = "Ancient Sinew Wrapped Lamina", parallel = true, npc = "Hastat the Ancient", mapID = 77, x = 0.4800, y = 0.2400, location = "Hastat the Ancient, Irontree Woods, Felwood" },
            },
        },
    },
}

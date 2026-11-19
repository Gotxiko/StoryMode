local addonName, SM = ...

-- =============================================================================
-- Classic druid quests
-- Curated identity chains: iconic abilities, tools, weapons, and mounts.
-- =============================================================================

SM.ClassicDruidQuestData = {
    title = "The Cenarion Path",
    description = "Your trainer sends you to Moonglade for lessons that cannot be taught in a city. The Cenarion Circle has work for young druids who are ready to listen to spirits, heal sick beasts, and follow the call of distant waters.",
    zone = "Moonglade / Darkshore / Westfall / The Barrens",
    expansion = "Classic",
    class = "DRUID",
    gameVersions = { classicEra = true, tbc = true },
    color = { 1.00, 0.49, 0.04 },
    icon = 136041,
    adventureCoverTexture = 131882, -- Wailing Caverns: Cenarion/Naralex nature imagery closest to Classic druid class fantasy
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 5923, name = "Heeding the Call", excludeRace = "Skyborne", npc = "Kal", faction = "Alliance", mapID = 57, x = 0.5595, y = 0.6156, location = "Kal, Teldrassil" },
    startMapID = 80,
    startX = 0.5600,
    startY = 0.3000,

    chapterIcons = {
        ["Bear Form"] = 132276,
        ["Cure Poison"] = 136067,
        ["Aquatic Form"] = 132112,
    },

    npcDisplayIDs = {
        -- Quest givers' models from the cmangos Classic database.
        ["Kal"] = 1706,
        ["Mathrengyl Bearwalker"] = 2261,
        ["Dendrite Starblaze"] = 11769,
        ["Alanndarian Nightsong"] = 4487,
        ["Torwa Pathfinder"] = 8832,
        ["Tajarri"] = 11766,
        ["Great Cat Spirit"] = 11910,
        -- Quest givers' models from Wowhead's WoW Forever data.
        ["Urs'endris"] = 139269,
        ["Avatar of Saeyleenan"] = 146918,
    },

    chapters = {
        {
            chapter = "Bear Form",
            requiredLevel = 10,
            summary = "Your trainer says the call has come: the spirit of the bear will see you. Spirits are never in a hurry, and a bear's spirit least of all. Go where you're sent, and take your time. It will.",
            recap = "Nobody in the Circle is ever in a hurry, and the spirits are worse. I was sent to sit with the great spirit of the bear, and it took its time telling me what a bear is. Strong, mostly. I had guessed that part, but it's polite to let a spirit finish.\n\nThe trial that followed had claws. There was a beast to face, and it was not interested in my reasons. I won. Winning, it turned out, was the easy half. The other half was what the spirit had been getting at all along: strength is for something. A bear doesn't brawl for the fun of it. It stands between its own and the world, and then it goes back to its berries.\n\nI came home able to wear that shape whenever I like. People step out of your way more. I find it very restful.",
            quests = {
                { id = 94006, name = "The Great Ursera Spirit", race = "Skyborne", location = "Zephras Isle", gameVersions = { forever = true } },
                { id = 94638, name = "Strength and Mercy", npc = "Urs'endris", race = "Skyborne", location = "Urs'endris, falls northeast of Valanaar, Zephras Isle", gameVersions = { forever = true } },
                { id = 5923, altIds = { 5924, 5925 }, name = "Heeding the Call", excludeRace = "Skyborne", npc = "Kal", faction = "Alliance", mapID = 57, x = 0.5595, y = 0.6156, location = "Kal, Teldrassil" },
                { id = 5921, altIds = { 94914 }, name = "Moonglade", excludeRace = "Skyborne", npc = "Mathrengyl Bearwalker", faction = "Alliance", mapID = 89, x = 0.3537, y = 0.0840, location = "Mathrengyl Bearwalker, Darnassus" },
                { id = 5929, name = "Great Bear Spirit", excludeRace = "Skyborne", npc = "Dendrite Starblaze", faction = "Alliance", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade" },
                { id = 5931, name = "Back to Darnassus", excludeRace = "Skyborne", npc = "Dendrite Starblaze", faction = "Alliance", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade" },
                { id = 6001, name = "Body and Heart", excludeRace = "Skyborne", npc = "Mathrengyl Bearwalker", faction = "Alliance", mapID = 89, x = 0.3537, y = 0.0840, location = "Mathrengyl Bearwalker, Darnassus" },
                { id = 5926, altIds = { 5927, 5928 }, name = "Heeding the Call", excludeRace = "Skyborne", npc = "Gennia Runetotem", faction = "Horde", mapID = 7, x = 0.4848, y = 0.5964, location = "Gennia Runetotem, Mulgore" },
                { id = 5922, altIds = { 94913 }, name = "Moonglade", excludeRace = "Skyborne", npc = "Turak Runetotem", faction = "Horde", mapID = 88, x = 0.7648, y = 0.2722, location = "Turak Runetotem, Thunder Bluff" },
                { id = 5930, name = "Great Bear Spirit", excludeRace = "Skyborne", npc = "Dendrite Starblaze", faction = "Horde", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade" },
                { id = 5932, name = "Back to Thunder Bluff", excludeRace = "Skyborne", npc = "Dendrite Starblaze", faction = "Horde", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade" },
                { id = 6002, name = "Body and Heart", excludeRace = "Skyborne", npc = "Turak Runetotem", faction = "Horde", mapID = 88, x = 0.7648, y = 0.2722, location = "Turak Runetotem, Thunder Bluff" },
            },
        },
        {
            chapter = "Cure Poison",
            follows = false,
            requiredLevel = 14,
            summary = "Your trainer sends you to Moonglade, where Dendrite Starblaze has a new lesson waiting. This one is about healing, and the Circle doesn't teach healing from a book. Bring patience, and good boots.",
            recapAlliance = "The Circle never hands you a spell. It hands you a problem and sits back to see what you'll do with it.\n\nThis time it was the deer of Darkshore, sickening up and down the coast. I went up to Cliffspring Falls to find where it began, and Alanndarian Nightsong in Auberdine turned what I brought back into a salve.\n\nThen I spent a slow, pleasant afternoon walking Darkshore from the river nearly to Ashenvale, finding sick deer and putting salve on them. Ten in all. Not one of them said thank you. Each got up, gave me a look as though I'd been rude, and wandered off into the trees.\n\nHealthy, though. Gratitude is a people habit. Deer just get on with things, and the older I get, the more I think they have the right idea.",
            recapHorde = "Druids learn healing the way everyone learns anything: somebody's sick, and you're the one standing there.\n\nThe somebody was the gazelles of the northern Barrens. I climbed Dreadmist Peak to find where the sickness began, and Tonga Runetotem at the Crossroads set about making a salve. He needed kodo horns. The kodos had a view on that. We came to an arrangement.\n\nThen I spent a long, warm day north of the Crossroads, chasing sick gazelles and dabbing salve on them. Ten in all. Have you ever tried to doctor a gazelle? They're quick even when they're poorly. Not one stopped to thank me. They got up and ran.\n\nWhich is the point, really. A gazelle that runs is a gazelle that's well.",
            quests = {
                { id = 6121, name = "Lessons Anew", npc = "Mathrengyl Bearwalker", faction = "Alliance", mapID = 89, x = 0.3537, y = 0.0840, location = "Mathrengyl Bearwalker, Darnassus" },
                { id = 6122, name = "The Principal Source", npc = "Dendrite Starblaze", faction = "Alliance", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade" },
                { id = 6123, name = "Gathering the Cure", npc = "Alanndarian Nightsong", faction = "Alliance", mapID = 62, x = 0.3769, y = 0.4066, location = "Alanndarian Nightsong, Auberdine, Darkshore" },
                { id = 6124, name = "Curing the Sick", npc = "Alanndarian Nightsong", faction = "Alliance", mapID = 62, x = 0.3769, y = 0.4066, location = "Alanndarian Nightsong, Auberdine, Darkshore" },
                { id = 6125, name = "Power over Poison", npc = "Dendrite Starblaze", faction = "Alliance", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade" },
                { id = 6126, name = "Lessons Anew", npc = "Turak Runetotem", faction = "Horde", mapID = 88, x = 0.7648, y = 0.2722, location = "Turak Runetotem, Thunder Bluff" },
                { id = 6127, name = "The Principal Source", npc = "Dendrite Starblaze", faction = "Horde", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade" },
                { id = 6128, name = "Gathering the Cure", npc = "Tonga Runetotem", faction = "Horde", mapID = 10, x = 0.5226, y = 0.3193, location = "Tonga Runetotem, The Barrens" },
                { id = 6129, name = "Curing the Sick", npc = "Tonga Runetotem", faction = "Horde", mapID = 10, x = 0.5226, y = 0.3193, location = "Tonga Runetotem, The Barrens" },
                { id = 6130, name = "Power over Poison", npc = "Dendrite Starblaze", faction = "Horde", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade" },
            },
        },
        {
            chapter = "Aquatic Form",
            follows = false,
            requiredLevel = 16,
            summary = "Your trainer has another lesson for you, and Dendrite Starblaze in Moonglade will give it. This one is about water, so you will get wet. Druids teach the way water moves: slowly, and never in a straight line.",
            recap = "Moonglade is the one place in the world where nobody rushes you, so naturally it's where they teach you to swim.\n\nThe first trial meant hunting the bottom of Lake Elune'ara for a shrine bauble and carrying it up to the Shrine of Remulos. Tajarri was waiting there to tell me I'd passed. I was too waterlogged to argue.\n\nThe second was the Pendant of the Sea Lion, which comes in two halves, and nobody would simply tell me where they were. You ask the folk of Moonglade, and they give you a hint and a kind smile and go back to whatever they were doing. Druids. I'm allowed to say that.\n\nI found both halves and brought the pendant to Dendrite Starblaze, and I've had the sea lion's shape ever since. Finest way to travel I know. No boats, no docks, and nobody asks you for a fare.",
            quests = {
                { id = 26, name = "A Lesson to Learn", npc = "Mathrengyl Bearwalker", faction = "Alliance", mapID = 89, x = 0.3537, y = 0.0840, location = "Mathrengyl Bearwalker, Darnassus" },
                { id = 29, name = "Trial of the Lake", npc = "Dendrite Starblaze", faction = "Alliance", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade" },
                { id = 272, name = "Trial of the Sea Lion", npc = "Tajarri", faction = "Alliance", mapID = 80, x = 0.3652, y = 0.4010, location = "Tajarri, Nighthaven, Moonglade" },
                { id = 5061, name = "Aquatic Form", npc = "Dendrite Starblaze", faction = "Alliance", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade" },
                { id = 27, name = "A Lesson to Learn", npc = "Turak Runetotem", faction = "Horde", mapID = 88, x = 0.7648, y = 0.2722, location = "Turak Runetotem, Thunder Bluff" },
                { id = 28, name = "Trial of the Lake", npc = "Dendrite Starblaze", faction = "Horde", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade" },
                { id = 30, name = "Trial of the Sea Lion", npc = "Tajarri", faction = "Horde", mapID = 80, x = 0.3652, y = 0.4010, location = "Tajarri, Nighthaven, Moonglade" },
                { id = 31, name = "Aquatic Form", npc = "Dendrite Starblaze", faction = "Horde", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade" },
            },
        },
        {
            chapter = "Cat Form",
            requiredLevel = 20,
            gameVersions = { forever = true },
            summary = "Dendrite Starblaze wants you in Moonglade. There's someone to meet: the spirit of a great cat, out in the southern hills. Cats are particular about whom they teach, and they take their time deciding.",
            recap = "Dendrite Starblaze called me back to Moonglade to meet a cat. The spirit of one, anyway, up in the southern hills, and cats, as everybody knows, don't teach just anybody.\n\nBefore it would say much, it wanted three relics: the Fang, the Claw and the Silent Shadow. All three were down in the Stormrage Barrow Dens, a long, dim place where it pays to be quiet. I went in, came out with all three and laid them in front of the spirit. It looked at them for a good long while. Cats do.\n\nThen it gave me its blessing, and the shape that goes with it: soft feet, sharp claws and the knack of not being noticed. Dendrite didn't look the least bit surprised. I suspect the whole thing had been arranged before I ever arrived.",
            quests = {
                { id = 98393, name = "The Great Cat Spirit", npc = "Mathrengyl Bearwalker", faction = "Alliance", mapID = 89, x = 0.3537, y = 0.0840, location = "Mathrengyl Bearwalker, Darnassus", gameVersions = { forever = true } },
                { id = 98340, name = "The Great Cat Spirit", npc = "Turak Runetotem", faction = "Horde", mapID = 88, x = 0.7648, y = 0.2722, location = "Turak Runetotem, Thunder Bluff", gameVersions = { forever = true } },
                { id = 98394, name = "The Great Cat Spirit", npc = "Dendrite Starblaze", faction = "Alliance", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade", gameVersions = { forever = true } },
                { id = 98405, name = "The Great Cat Spirit", npc = "Dendrite Starblaze", faction = "Horde", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade", gameVersions = { forever = true } },
                { id = 98341, name = "The Great Windborne Cat Spirit", npc = "Dendrite Starblaze", race = "Skyborne", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade", gameVersions = { forever = true } },
                { id = 98396, name = "The Great Cat Spirit", npc = "Great Cat Spirit", faction = "Alliance", mapID = 1450, x = 0.5440, y = 0.7500, location = "Great Cat Spirit, Moonglade", gameVersions = { forever = true } },
                { id = 98342, name = "The Great Cat Spirit", npc = "Great Cat Spirit", faction = "Horde", mapID = 1450, x = 0.5440, y = 0.7500, location = "Great Cat Spirit, Moonglade", gameVersions = { forever = true } },
                { id = 98404, name = "The Great Windborne Cat Spirit", npc = "Avatar of Saeyleenan", race = "Skyborne", mapID = 1450, x = 0.4390, y = 0.7340, location = "Avatar of Saeyleenan, Moonglade", gameVersions = { forever = true } },
                { id = 98731, name = "Blessings of the Great Cat Spirit", npc = "Great Cat Spirit", faction = "Alliance", mapID = 1450, x = 0.5440, y = 0.7500, location = "Great Cat Spirit, Moonglade", gameVersions = { forever = true } },
                { id = 98739, name = "Blessings of the Great Cat Spirit", npc = "Great Cat Spirit", faction = "Horde", mapID = 1450, x = 0.5440, y = 0.7500, location = "Great Cat Spirit, Moonglade", gameVersions = { forever = true } },
                { id = 98738, name = "Blessings of the Great Windborne Cat Spirit", npc = "Avatar of Saeyleenan", race = "Skyborne", mapID = 1450, x = 0.4390, y = 0.7340, location = "Avatar of Saeyleenan, Moonglade", gameVersions = { forever = true } },
                { id = 98397, name = "To Darnassus", npc = "Dendrite Starblaze", faction = "Alliance", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade", gameVersions = { forever = true } },
                { id = 98362, name = "To Thunder Bluff", npc = "Dendrite Starblaze", faction = "Horde", mapID = 80, x = 0.5621, y = 0.3064, location = "Dendrite Starblaze, Nighthaven, Moonglade", gameVersions = { forever = true } },
            },
        },
    },
}

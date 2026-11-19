local addonName, SM = ...

-- =============================================================================
-- Classic shaman quests
-- Curated identity chains: iconic abilities, tools, weapons, and mounts.
-- =============================================================================

SM.ClassicShamanQuestData = {
    title = "Call of the Elements",
    description = "Your first totem begins with a call, not a command. The elements answer through trials, offerings, and long walks between trainers, spirits, and hidden shrines.\n\nFollow earth, fire, water, and air as each power is earned in turn. Later, the same lessons point toward a deeper test of balance.",
    zone = "Durotar / Mulgore / The Barrens / Sunken Temple",
    -- WoW Forever adds dwarf shamans, so the Horde limit sits on the Horde
    -- chapters and quest lines rather than on the story.
    zoneByFaction = {
        Horde = "Durotar / Mulgore / The Barrens / Sunken Temple",
        Alliance = "Dun Morogh / Loch Modan / Wetlands / Arathi Highlands",
    },
    expansion = "Classic",
    class = "SHAMAN",
    gameVersions = { classicEra = true, tbc = true },
    color = { 0.00, 0.44, 0.87 },
    icon = 136048,
    adventureCoverTexture = 131872, -- Sunken Temple: final Elemental Mastery class trial
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 1516, name = "Call of Earth", npc = "Canaga Earthcaller", faction = "Horde", mapID = 1, x = 0.4240, y = 0.6917, location = "Canaga Earthcaller, Durotar" },
    startMapID = 10,
    startX = 0.5300,
    startY = 0.4300,

    chapterIcons = {
        ["Call of Earth"] = 136025,
        ["Call of Fire"] = 135824,
        ["Call of Water"] = 135861,
        ["Call of Air"] = 136022,
        ["Elemental Mastery"] = 136075,
    },

    npcDisplayIDs = {
        -- Quest givers' models from the cmangos Classic database.
        ["Canaga Earthcaller"] = 4532,
        ["Searn Firewarder"] = 4534,
        ["Telf Joolam"] = 4537,
        ["Kardris Dreamseeker"] = 1360,
        ["Bath'rah the Windwatcher"] = 4954,
        -- Quest givers' models from Wowhead's WoW Forever data.
        ["Eldrun Stormbreaker"] = 143525,
        ["Teo Hammerstorm"] = 126743,
        ["Windshaper Boro"] = 136975,
        ["Braldir Ashmantle"] = 143528,
        ["Olariaan Swiftburn"] = 145521,
        ["Norric Lochthane"] = 143522,
        ["Minor Manifestation of Earth"] = 12110,
        ["Minor Manifestation of Water"] = 525,
    },

    chapters = {
        {
            chapter = "Call of Earth",
            requiredLevel = 4,
            summary = "Your trainer thinks you're ready to meet the earth. The earth is patient and expects the same of you, so there will be an errand or two before it has anything to say.",
            recap = "Earth is the first element a shaman meets, and the slowest to say anything. I respect that. I don't always enjoy it.\n\nAfter a small errand to prove I'd do as I was asked, I was handed the Earth Sapta and sent to a holy place to drink it. The world goes very quiet when you do. And then the earth was there in front of me, a spirit of it made small enough to talk to.\n\nIt didn't give a speech. It gave me a rock. A piece of rough quartz, plain as you like, and I carried it home as though it might break.\n\nFrom that rock came my first totem. I set it in the ground, and the ground answered. I've argued with the earth plenty since, mostly about how long things take. It has never once failed to show up.",
            quests = {
                { id = 96243, name = "Call of Earth", npc = "Eldrun Stormbreaker", race = { "Dwarf", "Gnome", "Skyborne" }, faction = "Alliance", mapID = 1455, x = 0.4740, y = 0.1340, location = "Eldrun Stormbreaker, Ironforge", gameVersions = { forever = true } },
                { id = 94373, name = "Call of Earth", npc = "Teo Hammerstorm", race = "Dwarf", faction = "Alliance", mapID = 1426, x = 0.2880, y = 0.6620, location = "Teo Hammerstorm, Anvilmar, Dun Morogh", gameVersions = { forever = true } },
                { id = 94374, name = "Call of Earth", npc = "Teo Hammerstorm", race = "Dwarf", faction = "Alliance", mapID = 1426, x = 0.2880, y = 0.6620, location = "Teo Hammerstorm, Anvilmar, Dun Morogh", gameVersions = { forever = true } },
                { id = 94375, name = "Call of Earth", npc = "Minor Manifestation of Earth", race = "Dwarf", faction = "Alliance", mapID = 1426, x = 0.2480, y = 0.6180, location = "Minor Manifestation of Earth, Dun Morogh", gameVersions = { forever = true } },
                { id = 92466, name = "Call of Earth", race = "Skyborne", location = "Thendal Grove, Zephras Isle", gameVersions = { forever = true } },
                { id = 92467, name = "Call of Earth", npc = "Windshaper Boro", race = "Skyborne", location = "Windshaper Boro, Thendal Grove, Zephras Isle", gameVersions = { forever = true } },
                { id = 92468, name = "Call of Earth", race = "Skyborne", location = "Rise of Spirits, Zephras Isle", gameVersions = { forever = true } },
                { id = 1516, name = "Call of Earth", npc = "Canaga Earthcaller", race = { "Orc", "Troll" }, faction = "Horde", mapID = 1, x = 0.4240, y = 0.6917, location = "Canaga Earthcaller, Durotar" },
                { id = 1517, name = "Call of Earth", npc = "Canaga Earthcaller", race = { "Orc", "Troll" }, faction = "Horde", mapID = 1, x = 0.4240, y = 0.6917, location = "Canaga Earthcaller, Durotar" },
                { id = 1518, name = "Call of Earth", npc = "Minor Manifestation of Earth", race = { "Orc", "Troll" }, faction = "Horde", mapID = 7, x = 0.5389, y = 0.8054, location = "Minor Manifestation of Earth, Mulgore" },
                { id = 1519, name = "Call of Earth", npc = "Seer Ravenfeather", race = "Tauren", faction = "Horde", mapID = 7, x = 0.4473, y = 0.7619, location = "Seer Ravenfeather, Mulgore" },
                { id = 1520, name = "Call of Earth", npc = "Seer Ravenfeather", race = "Tauren", faction = "Horde", mapID = 7, x = 0.4473, y = 0.7619, location = "Seer Ravenfeather, Mulgore" },
                { id = 1521, name = "Call of Earth", npc = "Minor Manifestation of Earth", race = "Tauren", faction = "Horde", mapID = 7, x = 0.5389, y = 0.8054, location = "Minor Manifestation of Earth, Mulgore" },
            },
        },
        {
            chapter = "Call of Fire",
            requiredLevel = 10,
            summary = "Your trainer says it's time to call fire. Fire is the least patient of the elements and the quickest to test you, so keep your wits about you. Your trainer will tell you who to find first.",
            recap = "Fire is the loud one. Ask it a question and it shouts the answer, usually at your eyebrows.\n\nThe rite starts with a torch that won't light, the Torch of the Dormant Flame, and you carry it about feeling foolish. Along the way there's a spirit to face, and it wanted a fight. Fire generally does. I gave it one and won, which is the only way that conversation ends well.\n\nAt the end there's a brazier at a shrine, and a flame that doesn't go out. I carried it back like it was the last fire in the world. Whatever the name says, I was not about to be the shaman who let the eternal flame go out.\n\nAfter that, fire came when I called. Not politely. But it came, and it's been at my side ever since, crackling away and offering opinions nobody asked for.",
            quests = {
                { id = 94449, name = "Call of Fire", npc = "Eldrun Stormbreaker", race = "Dwarf", faction = "Alliance", mapID = 1455, x = 0.4740, y = 0.1340, location = "Eldrun Stormbreaker, Ironforge", gameVersions = { forever = true } },
                { id = 94465, name = "Call of Fire", npc = "Bruegs Kindleborn", race = "Dwarf", faction = "Alliance", mapID = 1426, x = 0.8760, y = 0.4360, location = "Bruegs Kindleborn, Dun Morogh", gameVersions = { forever = true } },
                { id = 94466, name = "Call of Fire", npc = "Braldir Ashmantle", race = "Dwarf", faction = "Alliance", mapID = 1432, x = 0.3200, y = 0.6600, location = "Braldir Ashmantle, Loch Modan", gameVersions = { forever = true } },
                { id = 94467, name = "Call of Fire", npc = "Braldir Ashmantle", race = "Dwarf", faction = "Alliance", mapID = 1432, x = 0.3200, y = 0.6600, location = "Braldir Ashmantle, Loch Modan", gameVersions = { forever = true } },
                { id = 94468, name = "Call of Fire", race = "Dwarf", faction = "Alliance", location = "Shrine of Eternal Flame, Loch Modan", gameVersions = { forever = true } },
                { id = 98517, name = "Call of Fire", race = "Skyborne", gameVersions = { forever = true } },
                { id = 97243, name = "Call of Fire", race = "Skyborne", location = "Zephras Isle", gameVersions = { forever = true } },
                { id = 97244, name = "Call of Fire", npc = "Olariaan Swiftburn", race = "Skyborne", location = "Olariaan Swiftburn, Shrine of Flames, Zephras Isle", gameVersions = { forever = true } },
                { id = 97245, name = "Call of Fire", npc = "Olariaan Swiftburn", race = "Skyborne", location = "Olariaan Swiftburn, Shrine of Flames, Zephras Isle", gameVersions = { forever = true } },
                { id = 97257, name = "Call of Fire", npc = "Olariaan Swiftburn", race = "Skyborne", location = "Olariaan Swiftburn, Shrine of Flames, Zephras Isle", gameVersions = { forever = true } },
                { id = 1522, altIds = { 1523, 2983, 2984 }, name = "Call of Fire", excludeRace = "Skyborne", npc = "Searn Firewarder", faction = "Horde", mapID = 85, x = 0.3796, y = 0.3773, location = "Searn Firewarder, Orgrimmar" },
                { id = 1524, name = "Call of Fire", excludeRace = "Skyborne", npc = "Kranal Fiss", faction = "Horde", mapID = 10, x = 0.5603, y = 0.1989, location = "Kranal Fiss, The Barrens" },
                { id = 1525, name = "Call of Fire", excludeRace = "Skyborne", npc = "Telf Joolam", faction = "Horde", mapID = 1, x = 0.3855, y = 0.5896, location = "Telf Joolam, Durotar" },
                { id = 1526, name = "Call of Fire", excludeRace = "Skyborne", npc = "Telf Joolam", faction = "Horde", mapID = 1, x = 0.3855, y = 0.5896, location = "Telf Joolam, Durotar" },
                { id = 1527, name = "Call of Fire", excludeRace = "Skyborne", npc = "Brazier of the Dormant Flame", faction = "Horde", mapID = 1, x = 0.3896, y = 0.5822, location = "Brazier of the Dormant Flame, Durotar" },
            },
        },
        {
            chapter = "Call of Water",
            requiredLevel = 20,
            summaryAlliance = "Water is next, and the way to it starts with Norric Lochthane in Loch Modan. Of the four elements, water is the patient one, and it likes its students patient too. Pack for a long trip.",
            summaryHorde = "Your trainer says water is next and sends you to Islen Waterseer in the Barrens. Of the four elements, water is the patient one, and it likes its students patient too. Pack for a long trip.",
            recapAlliance = "Water doesn't hurry, and it doesn't want you to either.\n\nHervdana Saegrund in the Wetlands gave me an empty waterskin and directions. When I brought it back full, she gave me another, and then another. One of them had to be filled at Stonewatch Falls, right among the Nightcrawler murlocs, and I told the water the murlocs were its problem, not mine. It disagreed. Another meant crossing the sea to Astranaar. Out of the three, she made a vial of the purest water I've ever seen.\n\nAfter that came Stendel's Pond in Westfall, where something had gone foul. I fought the corruption out of it, and when the pond ran clean, its spirit rose and gave me a shard of itself for my totem.\n\nWater gives freely once it trusts you. Getting it to trust you takes about half of Azeroth.",
            recapHorde = "Water teaches patience, and it teaches it by sending you everywhere.\n\nBrine keeps a hut above a watering hole in the southern Barrens. Brine gave me an empty waterskin and told me where to fill it. When I brought it back, I got another, and then another. One of them had to come from the well in Tarren Mill, which is a very long way to go for a drink. Out of the three, she made a vial of the purest water.\n\nWhat was left of it went to the Brazier of Everfount in Silverpine, where a corrupted spirit of water was waiting. I beat it, and the water's true spirit rose clean and gave me a shard of itself to take home.\n\nI grumbled about the walk. The water, as far as I could tell, found that funny. Water goes everywhere and never complains.",
            quests = {
                { id = 94494, name = "Call of Water", faction = "Alliance", gameVersions = { forever = true } },
                { id = 94495, name = "Call of Water", npc = "Norric Lochthane", faction = "Alliance", location = "Norric Lochthane, Loch Modan", gameVersions = { forever = true } },
                { id = 94497, name = "Call of Water", npc = "Hervdana Saegrund", faction = "Alliance", mapID = 1437, x = 0.6560, y = 0.7640, location = "Hervdana Saegrund, Wetlands", gameVersions = { forever = true } },
                { id = 94499, name = "Call of Water", npc = "Hervdana Saegrund", faction = "Alliance", mapID = 1437, x = 0.6560, y = 0.7640, location = "Hervdana Saegrund, Wetlands", gameVersions = { forever = true } },
                { id = 94500, name = "Call of Water", npc = "Hervdana Saegrund", faction = "Alliance", mapID = 1437, x = 0.6560, y = 0.7640, location = "Hervdana Saegrund, Wetlands", gameVersions = { forever = true } },
                { id = 94501, name = "Call of Water", npc = "Hervdana Saegrund", faction = "Alliance", mapID = 1437, x = 0.6560, y = 0.7640, location = "Hervdana Saegrund, Wetlands", gameVersions = { forever = true } },
                { id = 94502, name = "Call of Water", npc = "Norric Lochthane", faction = "Alliance", location = "Norric Lochthane, Loch Modan", gameVersions = { forever = true } },
                { id = 94503, name = "Call of Water", faction = "Alliance", location = "Stendel's Pond, Westfall", gameVersions = { forever = true } },
                { id = 94505, name = "Call of Water", npc = "Minor Manifestation of Water", faction = "Alliance", location = "Minor Manifestation of Water, Stendel's Pond, Westfall", gameVersions = { forever = true } },
                { id = 1528, altIds = { 1529, 2985, 2986 }, name = "Call of Water", npc = "Searn Firewarder", faction = "Horde", mapID = 85, x = 0.3796, y = 0.3773, location = "Searn Firewarder, Orgrimmar" },
                { id = 1530, name = "Call of Water", npc = "Islen Waterseer", faction = "Horde", mapID = 10, x = 0.6583, y = 0.4378, location = "Islen Waterseer, The Barrens" },
                { id = 1535, name = "Call of Water", npc = "Brine", faction = "Horde", mapID = 10, x = 0.4342, y = 0.7741, location = "Brine, The Barrens" },
                { id = 1536, name = "Call of Water", npc = "Brine", faction = "Horde", mapID = 10, x = 0.4342, y = 0.7741, location = "Brine, The Barrens" },
                { id = 1534, name = "Call of Water", npc = "Brine", faction = "Horde", mapID = 10, x = 0.4342, y = 0.7741, location = "Brine, The Barrens" },
                { id = 220, name = "Call of Water", npc = "Brine", faction = "Horde", mapID = 10, x = 0.4342, y = 0.7741, location = "Brine, The Barrens" },
                { id = 63, name = "Call of Water", npc = "Islen Waterseer", faction = "Horde", mapID = 10, x = 0.6583, y = 0.4378, location = "Islen Waterseer, The Barrens" },
                { id = 100, name = "Call of Water", npc = "Brazier of Everfount", faction = "Horde", mapID = 21, x = 0.3826, y = 0.4456, location = "Brazier of Everfount, Silverpine Forest" },
                { id = 96, name = "Call of Water", npc = "Minor Manifestation of Water", faction = "Horde", mapID = 21, x = 0.3840, y = 0.4440, location = "Brazier of Everfount, Silverpine Forest" },
            },
        },
        {
            chapter = "Call of Air",
            requiredLevel = 30,
            summaryAlliance = "Air is the last of the four elements, and the hardest to pin down. Your road to it starts with Veyric Thunderhame in the Arathi Highlands, who has work for a shaman.",
            summaryHorde = "Air is the last of the four elements, and your trainer sends you to Thousand Needles to find Prate Cloudseer. Air goes where it likes and listens when it feels like it. Go and see if it feels like it.",
            recapAlliance = "Air was the last of the four, and the one that made me work hardest for it.\n\nThe quilboar had been working a ritual with twisted totems, one for each element, and Veyric up in the Arathi Highlands wanted it stopped. Charlga Razorflank down in Razorfen Kraul had the notes on it, so I went down and took the notes, the usual way. Then I collected their totems and turned them on their own ritual. What was left when it broke was the Eye of the Tempest, and I carried it to Bath'rah the Windwatcher in the Alterac Mountains.\n\nSo now I have all four. They argue constantly, mostly through me. I wouldn't have it any other way.",
            recapHorde = "After earth, fire and water, I braced myself for air. Air, it turns out, mostly wants you to show up.\n\nMy trainer sent me to Thousand Needles to find Prate Cloudseer, and that was the trial: go there. Mind you, it's a long way down and a long way back, and the wind up on those mesas will push you off one if you let it, so perhaps the walk was the point.\n\nPrate gave me the last totem, and the circle was closed. Earth under my feet, fire at my side, water in my hand and air at my back.\n\nFour elements, and not one of them likes the others. Earth thinks air is flighty. Fire thinks water is dull. Water thinks everybody's in too much of a hurry. And there's me in the middle, keeping the peace, which is about what a shaman is for.",
            quests = {
                { id = 94789, name = "Call of Air", faction = "Alliance", gameVersions = { forever = true } },
                { id = 96264, name = "Elemental Aid", npc = "Veyric Thunderhame", faction = "Alliance", mapID = 1417, x = 0.5980, y = 0.2740, location = "Veyric Thunderhame, Arathi Highlands", gameVersions = { forever = true } },
                { id = 79358, name = "Storm, Earth, and Fire", npc = "Veyric Thunderhame", faction = "Alliance", mapID = 1417, x = 0.5980, y = 0.2740, location = "Veyric Thunderhame, Arathi Highlands", gameVersions = { forever = true } },
                { id = 96135, name = "Heed My Call", npc = "Veyric Thunderhame", faction = "Alliance", mapID = 1417, x = 0.5980, y = 0.2740, location = "Veyric Thunderhame, Arathi Highlands", gameVersions = { forever = true } },
                { id = 96016, name = "The Tempest's Weapons", npc = "Veyric Thunderhame", faction = "Alliance", mapID = 1417, x = 0.5980, y = 0.2740, location = "Veyric Thunderhame, Arathi Highlands", gameVersions = { forever = true } },
                { id = 96136, name = "Call of Air", race = "Skyborne", gameVersions = { forever = true } },
                { id = 1531, name = "Call of Air", excludeRace = "Skyborne", npc = "Searn Firewarder", faction = "Horde", mapID = 85, x = 0.3796, y = 0.3773, location = "Searn Firewarder, Orgrimmar" },
            },
        },
        {
            -- WoW Forever keeps Season of Discovery's Horde chain (the
            -- Alliance has Forever's own copy, in Call of Air above). The
            -- quest cache doesn't say who gives Elemental Aid or With Wind
            -- Beneath Your Wings, or where Challenge of the Desert Wolf's
            -- totem stands.
            chapter = "The Quilboar Storm",
            requiredLevel = 30,
            faction = "Horde",
            gameVersions = { forever = true },
            summary = "Mastering the elements, it turns out, means owing them a favor. The quilboar have been twisting them for their own ends again, and Charlga Razorflank in Razorfen Kraul has notes on whatever they're planning.",
            recap = "Mastering the elements, I learned, means owing them. Fair enough.\n\nThe quilboar were twisting the elements again, and Charlga Razorflank down in Razorfen Kraul had the plans, so I took them. The plan was a flood. They meant to drown the Thousand Needles in a storm of their own making. Ambitious, for quilboar.\n\nPrate Cloudseer put my training on hold and handed me a tome instead. I gathered the quilboar's twisted totems, called up the corrupted elementals at the steam pools, and put them down one by one. Freewind Post was grateful. The elementals, less so.\n\nThe storm left an eye behind, the Eye of the Tempest, and I carried it to Bath'rah in the Alterac Mountains, who knows what to do with such things.\n\nThe elements didn't thank me. They rarely do. But the canyon is still dry.",
            quests = {
                { id = 79360, name = "Elemental Aid", faction = "Horde", gameVersions = { forever = true } },
                { id = 79364, name = "Eyes on the Sky", npc = "Rau Cliffrunner", faction = "Horde", location = "Freewind Post, Thousand Needles", gameVersions = { forever = true } },
                { id = 79361, name = "Storm, Earth, and Fire", npc = "Prate Cloudseer", faction = "Horde", location = "Thousand Needles", gameVersions = { forever = true } },
                { id = 79366, name = "Heed My Call", npc = "Prate Cloudseer", faction = "Horde", location = "Thousand Needles", gameVersions = { forever = true } },
                { id = 79365, name = "With Wind Beneath Your Wings", faction = "Horde", optional = true, gameVersions = { forever = true } },
                { id = 79442, name = "The Tempest's Weapons", npc = "Rau Cliffrunner", faction = "Horde", location = "Freewind Post, Thousand Needles", gameVersions = { forever = true } },
                { id = 95753, name = "Challenge of the Desert Wolf", hint = "Find the odd totem beside the great sun-bleached skeleton. Once you touch it, the clock starts.", hintExplorer = "Look for something out of place among the old bones of the desert.", location = "an odd totem beside a great sun-bleached skeleton", optional = true, gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Elemental Mastery",
            requiredLevel = 50,
            faction = "Horde",
            summary = "Kardris Dreamseeker in Orgrimmar thinks you're ready for the hardest lesson yet: all four elements at once. That lesson belongs to Bath'rah the Windwatcher in the Alterac Mountains, who will want a sample of each.",
            recap = "Long after my first totems, Kardris Dreamseeker in Orgrimmar decided I was ready for the harder lesson: holding all four elements at once instead of one at a time.\n\nThat meant Bath'rah the Windwatcher, up in the Alterac Mountains, and Bath'rah wanted a sample of each element. The real thing. You don't buy elemental fire off a cart. You take it from something made of fire, and the something objects.\n\nThen came the spirit totem, which wanted eight spider eyes and eight black claws. I asked the spirits what those had to do with anything. The spirits did not say. Spirits rarely do when you most want them to.\n\nMastery, they call it. I'd call it a truce. Four elements that can't stand one another, agreeing to work through me at the same time. Some days they even manage it.",
            quests = {
                { id = 8410, name = "Elemental Mastery", npc = "Kardris Dreamseeker", faction = "Horde", mapID = 85, x = 0.3880, y = 0.3637, location = "Kardris Dreamseeker, Orgrimmar" },
                { id = 8412, name = "Spirit Totem", npc = "Bath'rah the Windwatcher", faction = "Horde", mapID = 1416, x = 0.8040, y = 0.6300, location = "Bath'rah the Windwatcher, Ravenholdt Manor, Hillsbrad Foothills" },
            },
        },
        {
            chapter = "The Darkreaver Menace",
            requiredLevel = 58,
            faction = "Alliance",
            gameVersions = { forever = true },
            summary = "Eldrun Stormbreaker in Ironforge is building a scryer meant to see into the Great Ossuary beneath Scholomance. First it needs two fine diamonds. After that, it needs someone willing to take it down there.",
            recap = "Eldrun Stormbreaker was building a scryer to see through the shadows of the Great Ossuary in Scholomance, and a scryer like that wants diamonds. Two good ones. I found them. That was the easy part.\n\nThen I took the scryer down to the Ossuary's basement and set it going. The spirits came first, every one of them bound to a death knight called Darkreaver, and none of them pleased to be seen. I fought them down. When the last went, Darkreaver came himself.\n\nEarth held my feet, fire did the shouting, and between us we finished him. I carried his head back to Eldrun, and the restless dead under Scholomance are a good deal less restless now.\n\nMost of my life I've listened to spirits. Some of them, I've learned, you just have to shout over.",
            quests = {
                { id = 97168, name = "Material Assistance", npc = "Eldrun Stormbreaker", faction = "Alliance", mapID = 1455, x = 0.4740, y = 0.1340, location = "Eldrun Stormbreaker, Ironforge", gameVersions = { forever = true } },
                { id = 97169, name = "The Darkreaver Menace", npc = "Eldrun Stormbreaker", faction = "Alliance", mapID = 1455, x = 0.4740, y = 0.1340, location = "Eldrun Stormbreaker, Ironforge", gameVersions = { forever = true } },
            },
        },
    },
}

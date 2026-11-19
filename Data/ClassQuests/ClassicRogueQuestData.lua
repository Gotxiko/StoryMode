local addonName, SM = ...

-- =============================================================================
-- Classic rogue quests
-- Curated identity chains: iconic abilities, tools, weapons, and mounts.
-- =============================================================================

SM.ClassicRogueQuestData = {
    id = "poisons",  -- from its earlier title, "Poisons": saved progress and share links use it
    title = "The Road to Ravenholdt",
    description = "Master Mathias Shaw and Shenthul do not teach by lecture. They send rogues into guarded places, locked boxes, and situations where an antidote matters as much as a blade.\n\nBegin with your faction's poison work, then follow the hints that lead beyond city trainers into a wider trade of signals and reputation.",
    descriptionAlliance = "Master Mathias Shaw does not teach by lecture. SI:7 sends its rogues into guarded places, locked boxes, and situations where an antidote matters as much as a blade.\n\nBegin with the work Shaw hands you, then follow the hints that lead beyond city trainers into a wider trade of signals and reputation.",
    descriptionHorde = "Shenthul does not teach by lecture. The Shattered Hand sends its rogues into guarded places, locked boxes, and situations where an antidote matters as much as a blade.\n\nBegin with the work Shenthul hands you, then follow the hints that lead beyond city trainers into a wider trade of signals and reputation.",
    zone = "Westfall / The Barrens / Hillsbrad Foothills / Ravenholdt",
    zoneByFaction = {
        Alliance = "Westfall / Ravenholdt",
        Horde = "The Barrens / Hillsbrad Foothills / Ravenholdt",
    },
    expansion = "Classic",
    class = "ROGUE",
    gameVersions = { classicEra = true, tbc = true },
    color = { 1.00, 0.96, 0.41 },
    icon = 132320,
    adventureCoverTexture = 131833, -- Deadmines: the Defias hideout, where SI:7 first sends its rogues
    adventureCoverIsLoadingScreen = true,
    -- WoW Forever's Ruins of Lordaeron: an iron gate in the hills, like the way into Ravenholdt Manor.
    foreverCover = { texture = 7963782, texCoords = { 0, 1, 0.1592, 0.8408 } },

    startQuest = { id = 2360, name = "Mathias and the Defias", npc = "Master Mathias Shaw", location = "SI:7, Old Town, Stormwind", faction = "Alliance", mapID = 84, x = 0.7578, y = 0.5984, location = "Master Mathias Shaw, Stormwind" },
    startMapID = 84,
    startX = 0.7620,
    startY = 0.6010,

    npcLocations = {
        ["Master Mathias Shaw"] = { mapID = 84, x = 0.7620, y = 0.6010, location = "SI:7, Old Town, Stormwind" },
        ["Shenthul"] = { mapID = 85, x = 0.4300, y = 0.5360, location = "Cleft of Shadow, Orgrimmar" },
        -- WoW Forever: C's chest, and the Ravenholdt rogues who turn his last job against him.
        ["Dead Drop"] = { mapID = 1421, x = 0.4710, y = 0.7110, location = "a cabin outside Pyrewood Village, Silverpine Forest" },
        ["Fahrad"] = { mapID = 1416, x = 0.8450, y = 0.8020, location = "Fahrad, Ravenholdt Manor, Alterac Mountains" },
        ["Zan Shivsproket"] = { mapID = 1416, x = 0.8600, y = 0.8000, location = "Zan Shivsproket, the basement of Ravenholdt Manor" },
    },

    -- Quest givers' creature display IDs, from WoW Forever's creature cache
    -- (build 70938). Givers missing here show the chapter's icon.
    npcDisplayIDs = {
        ["Shenthul"] = 4360,
        ["Serge Hinott"] = 3678,
        ["Gest"] = 1327,
        ["Myrokos Silentform"] = 13150,
        ["Anastasia Miller"] = 144897,
        -- Quest givers' models from the cmangos Classic database.
        ["Master Mathias Shaw"] = 1736,
        ["Agent Kearnen"] = 5783,
        ["Doc Mixilpixil"] = 6446,
        ["Taskmaster Fizzule"] = 5986,
        ["Osborne the Night Man"] = 1507,
        -- Quest givers' models from Wowhead's WoW Forever data.
        ["Fahrad"] = 5528,
        ["Zan Shivsproket"] = 7004,
    },

    chapterIcons = {
        ["The Touch of Zanzil"] = 132273,
        ["The Dead Drop"] = "Interface\\Icons\\inv_misc_horn_04",  -- the Horn of Xelthos, C's first job
        ["Ravenholdt"] = 132331,
        ["Fool Me Twice"] = "Interface\\Icons\\inv_jewelry_necklace_26",  -- the Talisman of Kazdor
    },

    chapters = {
        {
            chapter = "The Touch of Zanzil",  -- both factions' poison work turns on Zanzil's mixture
            requiredLevel = 20,
            summaryAlliance = "Master Mathias Shaw at SI:7 has a job for you in Westfall. Find Agent Kearnen out there for a briefing. Kearnen has been watching the Defias, and Shaw wants to see how you handle yourself.",
            summaryHorde = "Shenthul, down in the Cleft of Shadow in Orgrimmar, has Shattered Hand work for a rogue. Before anything else, you learn the salute. The Shattered Hand likes its business quiet and its greetings complicated.",
            recapAlliance = "Shaw doesn't do pep talks. He sends me to Westfall to see his man Kearnen, and Kearnen points me at a Defias tower full of people who'd love to see me dead. Fine. I lift the key, I'm up the stairs, and there's a chest with a lovely lock on it. I open the lovely lock. Whatever was waiting inside opens me right back.\n\nBy the time I'm standing in front of Shaw again I'm a funny color and the floor won't hold still. The Touch of Zanzil, it turns out, and the only cure in Stormwind is a goblin in the barracks cellar called Doc Mixilpixil. First he has me lie down on his floor so he can look at me. Then he calls it the itis and sends me shopping: wildflowers, a vial, a tube, a spool of thread. Still don't know what the thread was for. It worked, though. And I learned something about poison that day. I'd rather be on the handle end.",
            recapHorde = "Shenthul's idea of hello is a salute you have to learn first. Shattered Hand business. So I learned it, and then he sent me out to the Barrens to fire two flares at a Venture Co. tower and do the salute again for his man inside, Taskmaster Fizzule. Very subtle, the Shattered Hand.\n\nFizzule wanted the tower taken apart, quietly. I lifted the foreman's key, put a few of their people down, and Grand Foreman Gallywix didn't get to keep his head. His lockbox was full of Zanzil's mix, and some of it ended up in me. Shenthul knew the one man who could fix that, Serge Hinott, all the way up in Tarren Mill. Long walk. Then I sat on a stool while he brewed the cure, which is the most patient I have ever been.\n\nFizzule got the head. I got the story.",
            quests = {
                { id = 2360, name = "Mathias and the Defias", npc = "Master Mathias Shaw", faction = "Alliance", mapID = 84, x = 0.7578, y = 0.5984, location = "Master Mathias Shaw, Stormwind" },
                { id = 2359, name = "Klaven's Tower", npc = "Agent Kearnen", faction = "Alliance", mapID = 52, x = 0.6849, y = 0.7008, location = "Agent Kearnen, Westfall" },
                { id = 2607, name = "The Touch of Zanzil", npc = "Master Mathias Shaw", faction = "Alliance", mapID = 84, x = 0.7578, y = 0.5984, location = "Master Mathias Shaw, Stormwind" },
                { id = 2608, name = "The Touch of Zanzil", npc = "Doc Mixilpixil", faction = "Alliance", mapID = 84, x = 0.7804, y = 0.5876, location = "Doc Mixilpixil, Stormwind" },
                { id = 2609, name = "The Touch of Zanzil", npc = "Doc Mixilpixil", faction = "Alliance", mapID = 84, x = 0.7804, y = 0.5876, location = "Doc Mixilpixil, Stormwind" },
                { id = 2460, name = "The Shattered Salute", npc = "Shenthul", faction = "Horde", mapID = 85, x = 0.4305, y = 0.5374, location = "Shenthul, Orgrimmar" },
                { id = 2458, name = "Deep Cover", npc = "Shenthul", faction = "Horde", mapID = 85, x = 0.4305, y = 0.5374, location = "Shenthul, Orgrimmar" },
                { id = 2478, name = "Mission: Possible But Not Probable", npc = "Taskmaster Fizzule", faction = "Horde", mapID = 10, x = 0.5544, y = 0.0556, location = "Taskmaster Fizzule, The Barrens" },
                { id = 2479, name = "Hinott's Assistance", npc = "Shenthul", faction = "Horde", mapID = 85, x = 0.4305, y = 0.5374, location = "Shenthul, Orgrimmar" },
                { id = 2480, name = "Hinott's Assistance", npc = "Serge Hinott", faction = "Horde", mapID = 25, x = 0.6163, y = 0.1919, location = "Serge Hinott, Tarren Mill, Hillsbrad Foothills" },
            },
        },
        {
            -- WoW Forever mails rogues of level 20 a letter signed only "C".
            -- Each job and each payment waits in the same chest; after a job,
            -- the next letter arrives in a city's mailbox.
            chapter = "The Dead Drop",
            requiredLevel = 20,
            gameVersions = { forever = true },
            summary = "A letter turns up in your mailbox. No name. Just a cabin outside Pyrewood Village and one letter at the bottom: C. Somebody wants a rogue who works alone.",
            recap = "Best letter I ever got had no name on it. Just a place, a cabin outside Pyrewood, and one letter at the bottom. C.\n\nIn the cabin there's a chest, and in the chest there's a job. Get the Horn of Xelthos out of Shadowfang Keep, and go alone. Alone, into Shadowfang. Sure. A goblin called Veenix up in Stonetalon got me past the courtyard gate, and after that it was me, the worgen and a lot of standing very still in corners. I put the horn in the chest and walked off, and a while later another letter tells me my pay is waiting. It was. Good pay, too.\n\nNext job was the Eye of Bhossca, in the Scarlet Monastery. I found a disguise on the grounds and strolled through the place like I'd been converted. Nobody blinked.\n\nNever met C. Never asked. When the money's that good, you don't.",
            quests = {
                { id = 78261, name = "The Horn of Xelthos", npc = "Dead Drop", instance = "dungeon", gameVersions = { forever = true } },
                { id = 78307, name = "The Horn of Xelthos", displayName = "C's Payment", npc = "Dead Drop", gameVersions = { forever = true } },
                { id = 78676, name = "The Eye of Bhossca", npc = "Dead Drop", instance = "dungeon", gameVersions = { forever = true } },
                { id = 78699, name = "The Eye of Bhossca", displayName = "C's Payment", npc = "Dead Drop", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Ravenholdt",
            follows = false,
            requiredLevel = 24,
            summary = "Your trainer slips you a seal with a raven on it. Take it to Fahrad at Ravenholdt Manor, hidden in the hills of Hillsbrad. Be ready: your cunning gets tested on the way.",
            recap = "Somebody in the city who knows somebody slips me a seal with a raven on it. Ravenholdt. It's a manor up in the hills above Hillsbrad where the best of us keep house, and you don't just walk up and knock. There's a test of cunning on the way in. I'm writing this, so you can guess how that went.\n\nFahrad met me inside. Lovely old place. Everybody's very polite and nobody turns their back on you. I liked it right away.",
            -- On WoW Forever the manor's work goes on: Myrokos Silentform's war on the Syndicate.
            foreverText = {
                summary = "Your trainer slips you a seal with a raven on it, for Fahrad at Ravenholdt Manor in the hills of Hillsbrad. Mind the test on the way in. Inside, Myrokos Silentform has a quarrel with the Syndicate, and work.",
                recap = "Somebody in the city who knows somebody slips me a seal with a raven on it. Ravenholdt. It's a manor up in the hills above Hillsbrad, and you don't just walk up and knock. There's a test of cunning on the way in. I'm writing this, so you can guess how that went.\n\nOnce you're in, Myrokos Silentform keeps you busy. The Syndicate has been getting cocky up in Alterac, and Myrokos has opinions about that. Lord Tomas, Durnholde Keep: no longer a problem. A scouting report, lifted right out of a Syndicate pocket. The old Perenolde heirlooms, out of the ruins of Alterac before their diggers got there.\n\nBest one was Stromgarde. I put on a stolen Syndicate uniform and walked into the keep like I owned it. Found Anastasia, found the money she'd rather nobody knew about, and suddenly she was very chatty. Then I broke up their little handoff at Thoradin's Wall and carried the prize home.",
            },
            quests = {
                { id = 6681, name = "The Manor, Ravenholdt", npc = "Osborne the Night Man", faction = "Alliance", mapID = 84, x = 0.7400, y = 0.5200, location = "SI:7, Old Town, Stormwind, then Ravenholdt Manor" },
                { id = 6681, name = "The Manor, Ravenholdt", npc = "Gest", faction = "Horde", mapID = 85, x = 0.4300, y = 0.5360, location = "Cleft of Shadow, Orgrimmar, then Ravenholdt Manor" },
                { id = 96779, name = "Syndicate Sabotage", npc = "Myrokos Silentform", mapID = 1416, x = 0.8500, y = 0.8040, location = "Myrokos Silentform, Ravenholdt Manor, Alterac Mountains", gameVersions = { forever = true } },
                { id = 96781, name = "What's the Big Idea?", npc = "Myrokos Silentform", mapID = 1416, x = 0.8500, y = 0.8040, location = "Myrokos Silentform, Ravenholdt Manor, Alterac Mountains", gameVersions = { forever = true } },
                { id = 96782, name = "Covert Extraction", npc = "Myrokos Silentform", mapID = 1416, x = 0.8500, y = 0.8040, location = "Myrokos Silentform, Ravenholdt Manor, Alterac Mountains", gameVersions = { forever = true } },
                { id = 96783, name = "A Way In", npc = "Myrokos Silentform", mapID = 1416, x = 0.8500, y = 0.8040, location = "Myrokos Silentform, Ravenholdt Manor, Alterac Mountains", gameVersions = { forever = true } },
                { id = 96784, name = "Master of Disguise", location = "Stromgarde Keep, Arathi Highlands", gameVersions = { forever = true } },
                { id = 96785, name = "Ain't No Telling", npc = "Anastasia Miller", mapID = 1417, x = 0.2640, y = 0.6320, location = "Anastasia Miller, Stromgarde Keep, Arathi Highlands", gameVersions = { forever = true } },
                { id = 96786, name = "The Syndicate Sting", npc = "Anastasia Miller", mapID = 1417, x = 0.2640, y = 0.6320, location = "Anastasia Miller, Stromgarde Keep, Arathi Highlands", gameVersions = { forever = true } },
            },
        },
        {
            -- Once C's jobs are done, a letter from Ravenholdt reaches a city's
            -- mailbox: Fahrad knows who C is.
            chapter = "Fool Me Twice",
            requiredLevel = 45,
            gameVersions = { forever = true },
            summary = "A letter from Ravenholdt this time. Fahrad wants a word about the jobs you've been taking. He doesn't say why.",
            recap = "Here's a fun way to find out you've been played. A letter shows up from Ravenholdt. Fahrad. Come home, we need to talk. So I go, and Fahrad sits me down and tells me C has a name. Caius Blackwood. Some big spellcaster in bed with the Syndicate, the very Syndicate I'd been cutting up for Myrokos, and there I was fetching his trinkets for him like a good dog.\n\nSo we fixed it. C wanted one more thing, the Talisman of Kazdor, out of Zul'Farrak. I went in alone, like always, and brought it out, but this time it went to the manor first. Zan Shivsproket took it down to the basement and put a little surprise inside. Anybody tries to pour magic into it or out of it, boom. Then I set it in the chest, same as ever, and walked away whistling.\n\nFahrad says now we wait. Fine by me. Waiting's half the job.",
            quests = {
                { id = 80526, name = "Fool Me Twice", npc = "Fahrad", gameVersions = { forever = true } },
                { id = 80411, name = "The Talisman of Kazdor", npc = "Fahrad", instance = "dungeon", gameVersions = { forever = true } },
                { id = 80453, name = "Best Laid Plans", npc = "Fahrad", gameVersions = { forever = true } },
                { id = 80454, name = "One Last Drop", npc = "Zan Shivsproket", gameVersions = { forever = true } },
                { id = 80455, name = "Biding Our Time", npc = "Dead Drop", gameVersions = { forever = true } },
            },
        },
    },
}

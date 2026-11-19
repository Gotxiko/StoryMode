local addonName, SM = ...

-- =============================================================================
-- Classic warlock quests
-- Curated identity chains: iconic abilities, tools, weapons, and mounts.
-- =============================================================================

SM.ClassicWarlockQuestData = {
    title = "The Binding",
    description = "Warlock trainers do not offer power freely. They give names, errands, and circles, then ask whether you can bind what answers.\n\nBegin with the first summons and follow the darker lessons through demons, tomes, mounts, and bargains that always ask for more than coin.",
    zone = "Capital Cities / The Barrens / Burning Steppes / Dire Maul",
    expansion = "Classic",
    class = "WARLOCK",
    gameVersions = { classicEra = true, tbc = true },
    color = { 0.53, 0.53, 0.93 },
    icon = 136145,
    adventureCoverTexture = 131835, -- Dire Maul: Dreadsteed of Xoroth ritual finale
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 1685, name = "Gakin's Summons", npc = "Remen Marcot", faction = "Alliance", mapID = 37, x = 0.4449, y = 0.6627, location = "Remen Marcot, Elwynn Forest" },
    startMapID = 84,
    startX = 0.2600,
    startY = 0.7800,

    chapterIcons = {
        ["Voidwalker"] = 136221,
        ["Succubus"] = 136220,
        ["Felhunter"] = 136217,
        ["Felsteed"] = 136103,
        ["Dreadsteed"] = 136103,
    },

    npcDisplayIDs = {
        -- Quest givers' models from the cmangos Classic database.
        ["Remen Marcot"] = 4866,
        ["Lago Blackwrench"] = 4865,
        ["Gakin the Darkbinder"] = 4867,
        ["Ophek"] = 1654,
        ["Godrick Farsan"] = 4020,
        ["Takar the Seer"] = 4928,
        ["Krom Stoutarm"] = 4988,
        ["Demisette Cloyce"] = 1469,
        ["Kaal Soulreaper"] = 2675,
        ["Mor'zul Bloodbringer"] = 14565,
        ["Gorzeeki Wildeyes"] = 14566,
        ["Lord Banehollow"] = 8611,
        ["Spackle Thornberry"] = 3316,
    },

    chapters = {
        {
            chapter = "Voidwalker",
            requiredLevel = 10,
            summary = "Your trainer passes along a summons from a warlock in the city. It's time you called something out of the void and put it to work. It won't want to. They never do.",
            recap = "Every warlock remembers their first voidwalker. Mine came out of the dark looking about as pleased as you'd expect.\n\nFirst my teacher sent me to fetch something the summoning couldn't be done without. Teachers like mine are never in a hurry to tell you why. I fetched it.\n\nThen the binding. You call, and something big and blue and hollow comes through and makes it plain it would rather not work for you. That's the part nobody can teach. You subdue it. You keep at it until it stops arguing and starts listening.\n\nIt's been with me ever since. Doesn't eat, doesn't sleep, doesn't talk. Stands between me and whatever's angry, takes the beating and never once asks about wages. I'd call it a friend, but I don't think it would know what to do with that.",
            quests = {
                { id = 1685, name = "Gakin's Summons", npc = "Remen Marcot", race = { "Human", "Gnome" }, faction = "Alliance", mapID = 37, x = 0.4449, y = 0.6627, location = "Remen Marcot, Elwynn Forest" },
                { id = 1715, name = "The Slaughtered Lamb", npc = "Lago Blackwrench", race = { "Human", "Gnome" }, faction = "Alliance", mapID = 87, x = 0.4763, y = 0.0926, location = "Lago Blackwrench, Ironforge" },
                { id = 1688, name = "Surena Caledon", npc = "Gakin the Darkbinder", race = { "Human", "Gnome" }, faction = "Alliance", mapID = 84, x = 0.2525, y = 0.7856, location = "Gakin the Darkbinder, Stormwind" },
                { id = 1689, name = "The Binding", npc = "Gakin the Darkbinder", race = { "Human", "Gnome" }, faction = "Alliance", mapID = 84, x = 0.2525, y = 0.7856, location = "Gakin the Darkbinder, Stormwind" },
                { id = 1478, name = "Halgar's Summons", npc = "Ageron Kargal", race = "Scourge", faction = "Horde", mapID = 18, x = 0.6162, y = 0.5268, location = "Ageron Kargal, Tirisfal Glades" },
                { id = 1473, name = "Creature of the Void", npc = "Carendin Halgar", race = "Scourge", faction = "Horde", mapID = 90, x = 0.8506, y = 0.2599, location = "Carendin Halgar, Undercity" },
                { id = 1471, name = "The Binding", npc = "Carendin Halgar", race = "Scourge", faction = "Horde", mapID = 90, x = 0.8506, y = 0.2599, location = "Carendin Halgar, Undercity" },
                { id = 1506, name = "Gan'rul's Summons", npc = "Ophek", race = "Orc", faction = "Horde", mapID = 1, x = 0.5437, y = 0.4129, location = "Ophek, Durotar" },
                { id = 1501, name = "Creature of the Void", npc = "Gan'rul Bloodeye", race = "Orc", faction = "Horde", mapID = 85, x = 0.4825, y = 0.4528, location = "Gan'rul Bloodeye, Orgrimmar" },
                { id = 1504, name = "The Binding", npc = "Gan'rul Bloodeye", race = "Orc", faction = "Horde", mapID = 85, x = 0.4825, y = 0.4528, location = "Gan'rul Bloodeye, Orgrimmar" },
            },
        },
        {
            chapter = "Succubus",
            follows = false,
            requiredLevel = 20,
            summary = "Your trainer thinks you're ready for a subtler demon than the voidwalker. A succubus takes more than a strong will to bind, and your trainer knows who can tell you what else it takes. Subtle things rarely come cheap.",
            recapAlliance = "Gakin the Darkbinder is a patient teacher, as long as you don't mind being sent across the sea for your lessons.\n\nA succubus needs the right focus, and Gakin sent me to Takar the Seer in the Barrens to learn what it was. Takar sent me north into Ashenvale for heartswood. I came back with it, and Gakin turned it into the Heartswood Core.\n\nThen the circle. I called, and a succubus answered. They always look you over first, as though they're the ones doing the choosing. She looked. I subdued her. We've had an understanding ever since.\n\nShe's charming, vicious and doesn't like me one bit, and I wouldn't trade her for any bodyguard in Stormwind. You always know where you stand with a demon. Usually it's slightly too close.",
            recapHorde = "For a succubus you need hearts. Pure ones. That narrows the field more than you'd think.\n\nGodrick Farsan in the Temple of the Damned gave me two names: Dalin Forgewright and Corma Villard. I came back with their hearts. I didn't ask what made them pure, and they weren't in a position to tell me.\n\nThen the circle. I called, and a succubus came through and looked me up and down as though she were the one doing the hiring. They all do, the first time. I subdued her, which is the polite word for it, and since then she's been the most charming thing in my employ.\n\nPeople ask whether she's dangerous. Of course she is. That's rather the point of her.",
            quests = {
                { id = 1472, name = "Devourer of Souls", npc = "Carendin Halgar", faction = "Horde", mapID = 90, x = 0.8506, y = 0.2599, location = "Carendin Halgar, Undercity" },
                { id = 1476, name = "Hearts of the Pure", npc = "Godrick Farsan", faction = "Horde", mapID = 90, x = 0.8481, y = 0.1483, location = "Godrick Farsan, Undercity" },
                { id = 1474, name = "The Binding", npc = "Carendin Halgar", faction = "Horde", mapID = 90, x = 0.8506, y = 0.2599, location = "Carendin Halgar, Undercity" },
                { id = 1717, name = "Gakin's Summons", npc = "Lago Blackwrench", faction = "Alliance", optional = true, mapID = 87, x = 0.4680, y = 0.1060, location = "Lago Blackwrench, Ironforge" },
                { id = 1716, name = "Devourer of Souls", npc = "Gakin the Darkbinder", faction = "Alliance", mapID = 84, x = 0.2525, y = 0.7856, location = "Gakin the Darkbinder, Stormwind" },
                { id = 1738, name = "Heartswood", npc = "Takar the Seer", faction = "Alliance", mapID = 10, x = 0.4931, y = 0.5710, location = "Takar the Seer, The Barrens" },
                { id = 1739, name = "The Binding", npc = "Gakin the Darkbinder", faction = "Alliance", mapID = 84, x = 0.2525, y = 0.7856, location = "Gakin the Darkbinder, Stormwind" },
            },
        },
        {
            -- An incubus instead of (or as well as) the succubus. The quests
            -- are in Classic Era's quest table too, but only WoW Forever's
            -- server has been seen to answer for them. Who gives Hearts of
            -- the Lovers and What Is Love? isn't in the quest cache, and
            -- which Horde warlocks go to which city is a guess, after the
            -- Voidwalker chapter: Forsaken to the Undercity, the rest to
            -- Orgrimmar.
            chapter = "Incubus",
            requiredLevel = 20,
            optional = true,
            gameVersions = { forever = true },
            summary = "A succubus isn't the only sayaad who answers a warlock's call. An incubus can be lured too, with something that holds great love and devotion, and your trainer's scrying has already found it.",
            recapAlliance = "An incubus, it turns out, can't resist true love. Neither can most people, but most people don't come with a summoning circle.\n\nThe lure was a wooden figurine, a keepsake of a young couple who've been gone for thousands of years, still sitting in a house past Maestra's Post in Ashenvale. I fetched it, took it down to the crypts below the Slaughtered Lamb, and set it in the circle.\n\nThe incubus came through, saw there was no lovesick fool waiting for him, and took it personally. I subdued him anyway, and Gakin the Darkbinder did the binding.\n\nWe get along. He thinks I'm unromantic. I think he's on the payroll.",
            recapHorde = "An incubus, it turns out, can't resist true love, so the trick is finding some to borrow.\n\nIn Orgrimmar there's an orc named Magar, still waiting for his mate to come home from Ashenvale. All I found at Fallen Sky Lake was a withered scarf. Gan'rul Bloodeye said the love was still woven into it, and that he'd let Magar know what I'd found. In the Undercity they go about it differently: Carendin Halgar wants the hearts of two lovers from opposite ends of the world. I'll let you guess which teacher I went to.\n\nEither way, the incubus came through the circle, saw there was no lovesick fool waiting for him, and took it personally. I subdued him anyway.\n\nWe get along. He thinks I'm unromantic. I think he's on the payroll.",
            quests = {
                { id = 65593, name = "Hearts of the Lovers", race = "Scourge", faction = "Horde", location = "the Undercity", gameVersions = { forever = true } },
                { id = 65597, name = "The Binding", npc = "Carendin Halgar", race = "Scourge", faction = "Horde", mapID = 90, x = 0.8506, y = 0.2599, location = "Carendin Halgar, Undercity", gameVersions = { forever = true } },
                { id = 65601, name = "Love Hurts", npc = "Blind Cazul", excludeRace = "Scourge", faction = "Horde", location = "the Cleft of Shadow, Orgrimmar", gameVersions = { forever = true } },
                { id = 65610, name = "Wish You Were Here", npc = "Magar", excludeRace = "Scourge", faction = "Horde", location = "Orgrimmar", gameVersions = { forever = true } },
                { id = 65604, name = "The Binding", npc = "Gan'rul Bloodeye", excludeRace = "Scourge", faction = "Horde", mapID = 85, x = 0.4825, y = 0.4528, location = "Gan'rul Bloodeye, Orgrimmar", gameVersions = { forever = true } },
                { id = 65602, name = "What Is Love?", faction = "Alliance", gameVersions = { forever = true } },
                { id = 65603, name = "The Binding", npc = "Gakin the Darkbinder", faction = "Alliance", mapID = 84, x = 0.2525, y = 0.7856, location = "Gakin the Darkbinder, Stormwind", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Felhunter",
            follows = false,
            requiredLevel = 30,
            summary = "Your trainer sends you down to Ratchet to find Strahad Farsan, who knows how to bind a felhunter. A felhunter eats magic. You'll want to be very sure of the binding before you try it.",
            recapAlliance = "A felhunter eats magic. That's the whole appeal. The trouble is you need a book to bind one, and the book was in pieces.\n\nStrahad Farsan down in Ratchet knew the binding, and Krom Stoutarm back in Ironforge knew books, and I spent a good while carrying scraps of moldy paper between the two of them. Eventually Krom had the thing put back together, and Strahad put the Tome of the Cabal in my hands.\n\nI drew the circle, and a felhunter came through starving, and I am, to a felhunter, a walking supper. I got the binding on it before it got a taste.\n\nNow it trots at my heel and sniffs at every mage we pass. I keep my own spellbooks off the floor.",
            recapHorde = "A felhunter takes the Tome of the Cabal, and the Tome of the Cabal, naturally, was in pieces.\n\nStrahad Farsan down in Ratchet knew the binding, and Jorah Annison back in the Undercity knew books, and I carried scraps of moldy paper between the two of them until I knew that road better than some caravans do. Eventually Jorah had the thing put back together, and Strahad handed it over.\n\nI drew the circle, and a felhunter came through hungry. Magic is what they eat, and I'm made of the stuff. I got the binding on it before it got a bite.\n\nNow it walks at my heel and makes mages nervous. I count that in its favor.",
            quests = {
                -- Alliance: Lago Blackwrench, then Krom Stoutarm in Ironforge (Wowhead 1798 1758 1802 1804 1795).
                { id = 1798, name = "Seeking Strahad", npc = "Lago Blackwrench", faction = "Alliance", mapID = 87, x = 0.4680, y = 0.1060, location = "Lago Blackwrench, Ironforge" },
                { id = 1758, name = "Tome of the Cabal", npc = "Strahad Farsan", faction = "Alliance", mapID = 10, x = 0.6263, y = 0.3550, location = "Strahad Farsan, The Barrens" },
                { id = 1802, name = "Tome of the Cabal", npc = "Krom Stoutarm", faction = "Alliance", mapID = 87, x = 0.7419, y = 0.0939, location = "Krom Stoutarm, Ironforge" },
                { id = 1804, name = "Tome of the Cabal", npc = "Krom Stoutarm", faction = "Alliance", mapID = 87, x = 0.7419, y = 0.0939, location = "Krom Stoutarm, Ironforge" },
                -- Horde: Carendin Halgar, then Jorah Annison in the Undercity (3001 1801 1803 1805 1795).
                { id = 3001, name = "Seeking Strahad", npc = "Carendin Halgar", faction = "Horde", mapID = 90, x = 0.8506, y = 0.2599, location = "Carendin Halgar, Undercity" },
                { id = 1801, name = "Tome of the Cabal", npc = "Strahad Farsan", faction = "Horde", mapID = 10, x = 0.6263, y = 0.3550, location = "Strahad Farsan, The Barrens" },
                { id = 1803, name = "Tome of the Cabal", npc = "Jorah Annison", faction = "Horde", mapID = 90, x = 0.7592, y = 0.3789, location = "Jorah Annison, Undercity" },
                { id = 1805, name = "Tome of the Cabal", npc = "Jorah Annison", faction = "Horde", mapID = 90, x = 0.7592, y = 0.3789, location = "Jorah Annison, Undercity" },
                { id = 1795, name = "The Binding", npc = "Strahad Farsan", mapID = 10, x = 0.6263, y = 0.3550, location = "Strahad Farsan, The Barrens" },
            },
        },
        {
            chapter = "Felsteed",
            follows = false,
            requiredLevel = 40,
            summary = "Your trainer sends you down to Ratchet, to Strahad Farsan, who knows how a warlock's mount is called. No stable sells one. It comes from somewhere a good deal warmer than Ratchet.",
            recap = "Most people buy a horse. Warlocks get sent to Ratchet.\n\nMy trainer pointed me back down to Strahad Farsan, who by then was practically family, to learn to summon a felsteed. It isn't bought and it isn't bred. You call it, it comes, and it carries you, and it would very much like everybody to know it's from somewhere worse than here.\n\nI've never named mine. It wouldn't answer to it anyway. But it doesn't tire, it doesn't spook, and it has never once wanted a stable or a bucket of oats. The hooves are on fire, mind. Keep it away from anybody's haystack.\n\nA warlock's mount ought to frighten people a little. It saves on conversation.",
            quests = {
                { id = 4488, altIds = { 4487 }, name = "Summon Felsteed", npc = "Demisette Cloyce", faction = "Alliance", mapID = 84, x = 0.2540, y = 0.7820, location = "Demisette Cloyce, Stormwind" },
                { id = 4489, altIds = { 3631 }, name = "Summon Felsteed", npc = "Kaal Soulreaper", faction = "Horde", mapID = 90, x = 0.8621, y = 0.1593, location = "Kaal Soulreaper, Undercity" },
                { id = 4490, name = "Summon Felsteed", npc = "Strahad Farsan", mapID = 10, x = 0.6263, y = 0.3550, location = "Strahad Farsan, Ratchet, The Barrens" },
            },
        },
        {
            chapter = "Dreadsteed",
            follows = false,
            requiredLevel = 60,
            summary = "The demon trainer in the city has a name for you: Mor'zul Bloodbringer, out in the Burning Steppes. Mor'zul knows how to call a dreadsteed of Xoroth, and doesn't share that with just anyone.",
            recap = "Anyone can call a felsteed. A dreadsteed of Xoroth you earn, and Mor'zul Bloodbringer in the Burning Steppes made very sure I knew it.\n\nThe shopping list for that ritual would make a dragon weep, partly because thirty-five black dragonscales were on it. But my favorite errand was the imp. Gorzeeki Wildeyes handed me an imp in a jar and had me take it to school. The Scholomance, I mean. It needed their alchemy lab to make a parchment. Only imp I know with an education.\n\nAt the end, in Dire Maul, I set it all out and called. The dreadsteed came through furious. I put it down, and when its spirit rose, I bound it.\n\nIt's still cross about that. We get along fine.",
            quests = {
                { id = 7562, name = "Mor'zul Bloodbringer", npc = "Spackle Thornberry", faction = "Alliance", mapID = 84, x = 0.2566, y = 0.7766, location = "Spackle Thornberry, Stormwind" },
                { id = 7562, name = "Mor'zul Bloodbringer", npc = "Kurgul", faction = "Horde", mapID = 85, x = 0.4752, y = 0.4672, location = "Kurgul, Orgrimmar" },
                { id = 7563, name = "Rage of Blood", npc = "Mor'zul Bloodbringer", mapID = 36, x = 0.1269, y = 0.3164, location = "Mor'zul Bloodbringer, Burning Steppes" },
                { id = 7564, name = "Wildeyes", npc = "Mor'zul Bloodbringer", mapID = 36, x = 0.1269, y = 0.3164, location = "Mor'zul Bloodbringer, Burning Steppes" },
                { id = 7623, name = "Lord Banehollow", after = {}, npc = "Gorzeeki Wildeyes", mapID = 36, x = 0.1244, y = 0.3163, location = "Gorzeeki Wildeyes, Burning Steppes" },
                { id = 7624, name = "Ulathek the Traitor", npc = "Lord Banehollow", mapID = 77, x = 0.3593, y = 0.4442, location = "Lord Banehollow, Shadow Hold, Felwood" },
                { id = 7625, name = "Xorothian Stardust", npc = "Lord Banehollow", mapID = 77, x = 0.3593, y = 0.4442, location = "Lord Banehollow, Shadow Hold, Felwood" },
                { id = 7626, name = "Bell of Dethmoora", after = 7564, npc = "Mor'zul Bloodbringer", mapID = 36, x = 0.1269, y = 0.3164, location = "Mor'zul Bloodbringer, Burning Steppes" },
                { id = 7627, name = "Wheel of the Black March", parallel = true, npc = "Mor'zul Bloodbringer", mapID = 36, x = 0.1269, y = 0.3164, location = "Mor'zul Bloodbringer, Burning Steppes" },
                { id = 7628, name = "Doomsday Candle", parallel = true, npc = "Mor'zul Bloodbringer", mapID = 36, x = 0.1269, y = 0.3164, location = "Mor'zul Bloodbringer, Burning Steppes" },
                { id = 7629, name = "Imp Delivery", after = { 7564, 7625 }, npc = "Gorzeeki Wildeyes", mapID = 36, x = 0.1244, y = 0.3163, location = "Gorzeeki Wildeyes, Burning Steppes" },
                { id = 7630, name = "Arcanite", after = { 7626, 7627, 7628 }, npc = "Gorzeeki Wildeyes", mapID = 36, x = 0.1244, y = 0.3163, location = "Gorzeeki Wildeyes, Burning Steppes" },
                { id = 7631, name = "Dreadsteed of Xoroth", after = { 7629, 7630 }, npc = "Mor'zul Bloodbringer", mapID = 36, x = 0.1269, y = 0.3164, location = "Mor'zul Bloodbringer, Burning Steppes" },
            },
        },
    },
}

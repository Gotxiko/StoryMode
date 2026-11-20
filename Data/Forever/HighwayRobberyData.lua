local addonName, SM = ...

-- =============================================================================
-- WoW Forever: Highway Robbery
-- A looted camp in Desolace, a marauder drinking in Booty Bay, and the night
-- elf who paid for the raids, on a dock off the Arathi coast. Both factions,
-- level 30 and up. Season of Discovery's chain, brought to Forever in 1.60.1
-- with new rewards.
-- =============================================================================
--
-- Chain, from Wowhead's WoW Forever pages and their comments:
--   Highway Robbery (79229) starts at an Extinguished Campfire on a rise at
--   the Kodo Graveyard's northwest edge > On the Lam (79235, Bibbly
--   F'utzbuckle) > Cherry for Your Thoughts? (79236, Tokal: buy her a Cherry
--   Grog from the barkeep) > No Honor Among Thieves (79242, Tokal; ends at
--   Illari's Loot Cache). A rowboat by the Arathi end of the Thandol Span
--   takes the player to Illari's dock. Night elves may be offered her key
--   for agreeing with her; everyone else fights her for it, so the journal
--   leaves that conversation open.

SM.ForeverHighwayRobberyData = {
    title = "Highway Robbery",
    description = "On a rise at the edge of the Kodo Graveyard in Desolace, a campfire has gone cold beside a camp that's been picked clean. The travelers who made it never left, and the marks on their bones don't match any centaur's weapon.\n\nIf the caravans' gossip is right, whoever did it has done it before. Following that gossip leads a long way out of Desolace, to the docks of Booty Bay and farther still.",
    zone = "Desolace / Stranglethorn Vale / Arathi Highlands",
    expansion = "Classic",
    recommendedLevel = { min = 30, max = 40 },
    requiredLevel = 30,
    gameVersions = { forever = true },
    achievements = {},
    color = { 0.66, 0.42, 0.30 },
    icon = "Interface\\Icons\\INV_Misc_Key_02",  -- Illari's Key
    adventureCoverTexture = 7963776,  -- WoW Forever's Eastern Kingdoms loading screen: Booty Bay and the Arathi coast have none of their own
    adventureCoverTexCoords = { 0, 1, 0.1592, 0.8408 },  -- the picture, between its transparent bands
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 79229, name = "Highway Robbery", npc = "Extinguished Campfire", location = "the Kodo Graveyard, Desolace", gameVersions = { forever = true } },
    startMapID = 1443,
    startX = 0.4750,
    startY = 0.5450,

    npcLocations = {
        ["Extinguished Campfire"] = { mapID = 1443, x = 0.4750, y = 0.5450, location = "the Kodo Graveyard, Desolace" },
        ["Bibbly F'utzbuckle"] = { mapID = 1443, x = 0.6220, y = 0.3880, location = "Kormek's Hut, Desolace" },
        ["Tokal"] = { mapID = 1434, x = 0.2700, y = 0.7720, location = "the inn, Booty Bay, Stranglethorn Vale" },
    },

    npcDisplayIDs = {
        -- From the cmangos Classic database.
        ["Bibbly F'utzbuckle"] = 11461,
        -- From Wowhead's WoW Forever data.
        ["Tokal"] = 116412,
    },

    chapterIcons = {
        ["The Pillaged Camp"] = "Interface\\Icons\\INV_Misc_Bone_HumanSkull_01",
        ["On the Lam"] = "Interface\\Icons\\INV_Drink_03",  -- Cherry Grog
        ["No Honor Among Thieves"] = "Interface\\Icons\\INV_Misc_Key_02",
    },

    chapters = {
        {
            chapter = "The Pillaged Camp",
            summary = "On a rise at the edge of the Kodo Graveyard in Desolace, a campfire has burned out and the camp around it has been stripped bare. Take a look at what's left. Whatever happened here, the scavengers of Desolace may have seen it before.",
            recap = "So I'm crossing Desolace, which is never anyone's first choice, and on a rise above the Kodo Graveyard there's a campfire gone cold. Around it lay two humans and a dwarf, or what was left of them. Their packs had been emptied, and the cuts on the bones didn't come from any centaur blade I know.\n\nI wanted someone who knew this country's bones, so I took it to the goblin bone collector at Kormek's Hut. Bibbly F'utzbuckle heard me out and said I'd found another one, in the tone you'd use for a cart that's thrown a wheel again.",
            quests = {
                { id = 79229, name = "Highway Robbery", npc = "Extinguished Campfire", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "On the Lam",
            summary = "Bibbly F'utzbuckle at Kormek's Hut has seen camps like this before. Caravan gossip blames a band of marauders who fled Desolace with an Alliance marshal on their trail. If one of them is trying to get a boat out, Booty Bay is the place to look.",
            recap = "According to Bibbly, the caravans blamed a band of marauders who ran once a marshal got on their trail. People on the run end up in ports, so I went to Booty Bay and found one of them, Tokal, drinking at the inn. Tokal asked if I was with the marshal, looked me over and decided I wasn't. I'm still working out how to take that.\n\nThe rest of the story cost me a cherry grog. Tokal's crew had robbed those camps, yes, but for pay, not for the Horde. Their boss was a night elf named Illari Duskfeather. She told them which camps to hit and let them keep most of the loot. The rarer finds she kept for herself, and when the marshal closed in, she left them for dead.\n\nTokal isn't out for revenge, but won't stand in the way of anyone who is. Illari had once mentioned a hideout on the Arathi coast.",
            quests = {
                { id = 79235, name = "On the Lam", npc = "Bibbly F'utzbuckle", gameVersions = { forever = true } },
                { id = 79236, name = "Cherry for Your Thoughts?", npc = "Tokal", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "No Honor Among Thieves",
            summary = "Tokal says the crew's old boss, Illari Duskfeather, once mentioned a hideout on the coast of the Arathi Highlands. Near the Arathi end of the Thandol Span, a rope bridge crosses to a hillside, and a rowboat waits at the water below.",
            recap = "The rowboat below the Thandol Span goes where no road does, out to a lonely dock on the Arathi coast. Illari Duskfeather was waiting there, and she wanted to know what I was doing on her dock.\n\nShe has her reasons for what happened in Desolace, and how much of them you get to hear depends on who's asking. I'll keep my half of that conversation to myself. It ended with her key in my hand.\n\nThe key opened her cache at the other end of the dock. Inside were a small box and some coin, likely the rarer finds she'd kept from her crew. I took them. The people they were taken from won't be needing them.",
            quests = {
                { id = 79242, name = "No Honor Among Thieves", npc = "Tokal", gameVersions = { forever = true } },
            },
        },
    },
}

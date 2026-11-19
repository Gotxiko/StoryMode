local addonName, SM = ...

-- =============================================================================
-- WoW Forever: The Cozy Sleeping Bag
-- A trail of hidden notes from a burned-out wreck to a satchel on Thoradin's
-- Wall. Every step starts at an object, not an NPC. Each faction begins at
-- its own burned-out remains and turns the note in at the other's, across
-- the sea, where the trail goes on for both.
-- Quest IDs and places: Forever's /sm scan and the Forever Mastery and
-- wow.gg guides (Wowhead data).
-- =============================================================================

SM.ForeverCozySleepingBagData = {
    title = "The Cozy Sleeping Bag",
    description = "Someone left more than ash in a burned-out wreck: a note, written for whoever thought to look, and a plank nailed up where it would be found.\n\nFollow the trail across both continents, through a hidden camp in the mountains and over a great dam, to whatever its writer went to such lengths to hide.",
    zone = "Stonetalon Mountains / Arathi Highlands",
    expansion = "Classic",
    recommendedLevel = { min = 22, max = 32 },
    requiredLevel = 14,
    gameVersions = { forever = true },
    achievements = {},
    color = { 0.72, 0.55, 0.36 },
    icon = "Interface\\Icons\\INV_Misc_Note_02",
    adventureCoverTexture = 7963777,  -- WoW Forever's Excavation Site: Wetlands, a camp of crates and carts
    adventureCoverTexCoords = { 0, 1, 0.1592, 0.8408 },  -- the picture, between its transparent bands
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 79008, name = "... and that note you found", faction = "Alliance", mapID = 1436, x = 0.3710, y = 0.5010, location = "Burned-Out Remains, Westfall", gameVersions = { forever = true } },
    startMapID = 1436,
    startX = 0.3710,
    startY = 0.5010,

    chapterIcons = {
        ["A Note in the Ashes"] = "Interface\\Icons\\INV_Misc_Note_02",
        ["The Hidden Camp"] = "Interface\\Icons\\INV_Misc_Bag_09",
        ["Thoradin's Wall"] = "Interface\\Icons\\INV_Misc_Bag_10",
    },

    chapters = {
        {
            chapter = "A Note in the Ashes",
            summaryAlliance = "In Westfall there's a burned-out wreck nobody looks at twice, and in the ash there's a note. Charred, mostly gone, but someone plainly meant it to be found. Read what's left and see where it points.",
            summaryHorde = "Out in the Barrens there's a burned-out wreck nobody looks at twice, and in the ash there's a note. Charred, mostly gone, but someone plainly meant it to be found. Read what's left and see where it points.",
            recapAlliance = "Some of the best things I've ever found, I found poking through ash. There's a burned-out wreck in Westfall, nothing left in it worth stealing, and in the middle of it a note. Charred half to nothing. But somebody had written it for whoever bothered to look, and I always bother to look.\n\nWhat was left of it pointed across the sea. To the Barrens, of all places. So I went, a very long way for a scrap of paper, and found a second burned-out ruin waiting for me. The twin of the first, an ocean apart, with the same sign left on it. And nailed up beside it, a plank with more writing.\n\nWhoever this was had gone to a lot of trouble. That's usually a good sign. Usually.",
            recapHorde = "There's a burned-out wreck out in the Barrens, the kind you ride past a hundred times. I didn't ride past it. In the ash was a note, charred so badly I could barely make it out, but somebody had plainly meant it to be found.\n\nWhat was left of it sent me across the sea to Westfall. Long trip for a scrap of paper. And there it was: a second burned-out ruin, twin of the first, a whole ocean away, with the same sign left on it. Nailed up beside it was a plank with the next set of instructions.\n\nI stood there a while thinking somebody out there had far too much time on their hands. Then I read the plank.",
            quests = {
                { id = 79008, name = "... and that note you found", faction = "Alliance", mapID = 1436, x = 0.3710, y = 0.5010, location = "Burned-Out Remains, Westfall", gameVersions = { forever = true } },
                { id = 79007, name = "... and that note you found", faction = "Horde", mapID = 1413, x = 0.4610, y = 0.7430, location = "Burned-Out Remains, The Barrens", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "The Hidden Camp",
            summaryAlliance = "Beside the burned-out remains in the Barrens, someone has nailed up a plank with a note on it. More directions, and this time they point up into the Stonetalon Mountains. Whoever left this trail went to a lot of trouble.",
            summaryHorde = "Beside the burned-out remains in Westfall, someone has nailed up a plank with a note on it. More directions, and this time they point up into the Stonetalon Mountains. Whoever left this trail went to a lot of trouble.",
            recap = "The plank sent me up into the Stonetalon Mountains, to a camp tucked away where nobody would ever stumble on it. Whoever lived there had left in a hurry. Crates still full of tools. Two good sturdy bags. And the sort of pocket litter you only leave behind when you're in a rush to be somewhere else.\n\nThe litter pointed me to the edge of the cliff, and then, as far as I could tell, over it. So I jumped.\n\nThey call that a leap of faith. I call it a very long moment. I came down on a ledge below in one piece, right beside a mound of fresh dirt. Somebody had been digging there, and not long ago.\n\nI'd come this far. I wasn't going to be stopped by a pile of dirt.",
            quests = {
                -- The plank stands by the remains the note was turned in at: the other faction's.
                { id = 79192, name = "Stepping Stones", hint = "A note is nailed to a plank in the Burned-Out Remains. Read it to continue.", hintExplorer = "Someone left word in the Burned-Out Remains.", faction = "Alliance", mapID = 1413, x = 0.4610, y = 0.7430, location = "Burned-Out Remains, The Barrens", gameVersions = { forever = true } },
                { id = 79192, name = "Stepping Stones", hint = "A note is nailed to a plank in the Burned-Out Remains. Read it to continue.", hintExplorer = "Someone left word in the Burned-Out Remains.", faction = "Horde", mapID = 1436, x = 0.3710, y = 0.5010, location = "Burned-Out Remains, Westfall", gameVersions = { forever = true } },
                { id = 79980, name = "Scramble", mapID = 1442, x = 0.4060, y = 0.5240, location = "Abandoned camp, Stonetalon Mountains", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Thoradin's Wall",
            summary = "On the ledge below the abandoned camp in the Stonetalon Mountains sits a mound of fresh dirt. Somebody was digging here not long ago. You've followed this trail across an ocean. A pile of dirt isn't going to stop you.",
            recap = "The dirt gave up a messenger bag with a parchment in it, and the parchment sent me clear across the sea to Stonewrought Dam, where a carved eagle on the stone heads pointed its fist at Thoradin's Wall. Lovely view, if you like heights.\n\nUp on the old wall was one more bag and one last note. Whoever had left it was gone. I'd just missed them, by the look of it. And under the note was what the whole trail had been guarding, across two continents, a cliff and a dam.\n\nA sleeping bag. A cozy one.\n\nI'd love to tell you I was disappointed. I wasn't. It's a very good sleeping bag.",
            quests = {
                { id = 79974, name = "Wet Job", hint = "Look for a mound of dirt in Stonetalon Mountains. Something is half-buried in it.", hintExplorer = "The trail continues in Stonetalon Mountains. Keep an eye on the ground.", mapID = 1442, x = 0.3960, y = 0.4990, location = "Mound of Dirt, Stonetalon Mountains", gameVersions = { forever = true } },
                { id = 79975, name = "Eagle's Fist", hint = "The trail leads to the Stonewrought Dam in Loch Modan. Climb up and take in the view.", hintExplorer = "The trail heads to Loch Modan.", mapID = 1432, x = 0.4940, y = 0.1290, location = "Stonewrought Dam, Loch Modan", gameVersions = { forever = true } },
                { id = 79976, name = "This Must Be The Place", hint = "The trail ends at Thoradin's Wall in Arathi Highlands. Someone was here, and not long ago.", hintExplorer = "The trail heads to Arathi Highlands.", mapID = 1417, x = 0.2250, y = 0.2420, location = "Thoradin's Wall, Arathi Highlands", gameVersions = { forever = true } },
            },
        },
    },
}

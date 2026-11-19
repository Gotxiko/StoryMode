local addonName, SM = ...

-- =============================================================================
-- Classic: Arugal and Shadowfang Keep
-- Silverpine's worgen curse, Ambermill's Dalaran mages, and Arugal's fall.
-- =============================================================================

SM.ArugalData = {
    id = "arugal-and-shadowfang-keep",  -- from its earlier title, "Arugal and Shadowfang Keep": saved progress and share links use it
    title = "Arugal's Folly",
    description = "The Sepulcher needs help holding Silverpine Forest. Worgen stalk the roads, Dalaran mages keep their own counsel at Ambermill, and rumors from Shadowfang Keep have not grown quieter.\n\nTake the Forsaken orders one by one and learn why the forest still refuses to be claimed.",
    zone = "Silverpine Forest / Shadowfang Keep",
    expansion = "Classic",
    recommendedLevel = { min = 9, max = 27 },
    faction = "Horde",
    gameVersions = { classicEra = true, tbc = true },
    achievements = {},
    color = { 0.42, 0.48, 0.58 },
    icon = 136150,
    portraitDisplayID = 2353,
    adventureCoverTexture = 131869, -- Shadowfang Keep loading screen
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 421, name = "Prove Your Worth", npc = "Dalar Dawnweaver", location = "the Sepulcher, Silverpine Forest" },
    startMapID = 21,
    startX = 0.4430,
    startY = 0.3950,

    npcLocations = {
        ["Dalar Dawnweaver"] = { mapID = 21, x = 0.4430, y = 0.3950, location = "the Sepulcher, Silverpine Forest" },
        ["Shadow Priest Allister"] = { mapID = 21, x = 0.4340, y = 0.4100, location = "the Sepulcher, Silverpine Forest" },
        ["High Executor Hadrec"] = { mapID = 21, x = 0.4300, y = 0.4100, location = "the Sepulcher, Silverpine Forest" },
        ["Keeper Bel'dugur"] = { mapID = 90, x = 0.5300, y = 0.5400, location = "the Apothecarium, Undercity" },
        ["Dalaran Crate"] = { mapID = 21, x = 0.4989, y = 0.6033, location = "the Dalaran camp north of Pyrewood Village" },
        ["Pyrewood Village"] = { mapID = 21, x = 0.4600, y = 0.7350, location = "Pyrewood Village, Silverpine Forest" },
        ["Ambermill"] = { mapID = 21, x = 0.6100, y = 0.6400, location = "Ambermill, Silverpine Forest" },
        ["Shadowfang Keep"] = { mapID = 21, x = 0.4400, y = 0.6750, location = "Shadowfang Keep, Silverpine Forest" },
        ["Archmage Ataeric"] = { mapID = 21, x = 0.6120, y = 0.6400, location = "Ambermill, Silverpine Forest" },
        ["Archmage Arugal"] = { mapID = 310, x = 0.5120, y = 0.4820, location = "Shadowfang Keep" },
    },

    npcDisplayIDs = {
        ["Dalar Dawnweaver"] = 1278,
        ["Shadow Priest Allister"] = 1948,
        ["High Executor Hadrec"] = 3545,
        ["Keeper Bel'dugur"] = 5751,
        ["Archmage Ataeric"] = 3601,
        ["Archmage Arugal"] = 2353,
    },

    chapterDisplayIDs = {
        ["Arugal's Folly"] = 1278,
        ["Ambermill"] = 3601,
        ["Shadowfang Keep"] = 2353,
    },

    chapterIcons = {
        ["Arugal's Folly"] = 136150,
        ["Ambermill"] = 136096,
        ["Shadowfang Keep"] = 136163,
    },

    chapters = {
        {
            chapter = "Arugal's Folly",
            summary = "Silverpine Forest is crawling with worgen, and Dalar Dawnweaver at the Sepulcher calls it Arugal's mess. Dalar means to clean it up for the Dark Lady and needs a capable aide. First, you'll have to prove you are one.",
            recap = "Arugal is the reason Silverpine has worgen. Dalar Dawnweaver, down at the Sepulcher, wanted proof the curse was still at work. I could have saved us both some time. Stand in that forest after dark for a minute. That's your proof.\n\nDalar wanted it done properly, though, and properly mostly meant shackles. Shackles off the gluttons, shackles off the darksouls, shackles out of Pyrewood, until I could have opened a smithy. Somewhere along the way there was a thing called the Remedy of Arugal. Judging by the forest, it remedied nothing. And there was Grimson the Pale, whose head I brought back. Paler, by then.\n\nDalar took all of it and looked pleased, in a grim sort of way. Grim is about as pleased as anyone gets in Silverpine.",
            quests = {
                { id = 421, name = "Prove Your Worth", npc = "Dalar Dawnweaver" },
                { id = 422, name = "Arugal's Folly", displayName = "The Remedy of Arugal", npc = "Dalar Dawnweaver" },
                { id = 423, name = "Arugal's Folly", displayName = "Moonrage Shackles", npc = "Dalar Dawnweaver" },
                { id = 424, name = "Arugal's Folly", displayName = "Grimson the Pale", npc = "Dalar Dawnweaver" },
                { id = 99, name = "Arugal's Folly", displayName = "Pyrewood Shackles", npc = "Dalar Dawnweaver" },
                { id = 98298, name = "Arugal's Folly", npc = "Dalar Dawnweaver", gameVersions = { forever = true } },
                { id = 98299, name = "Stop the Spread", npc = "Dalar Dawnweaver", optional = true, gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Ambermill",
            summary = "Shadow Priest Allister at the Sepulcher has a new worry: Dalaran. Its wizards have taken an interest in Ambermill, and their crates keep turning up at a camp north of Pyrewood Village. Allister wants to know what's inside.",
            recap = "Shadow Priest Allister had a different worry: Dalaran. A band of their wizards had settled in at Ambermill, and they had crates moving along the road north of Pyrewood. I helped myself to one. Inside was a pendant scratched all over with runes.\n\nDalar Dawnweaver had a look and decided the wizards were digging into old magic under Silverpine. The kind Dalaran gets very excited about and everybody else comes to regret. Allister wanted more of those pendants, which meant a good few wizards who no longer needed them.\n\nAt the top of it all was the Weaver, Archmage Ataeric. I took his staff off him the direct way and handed it to Allister. Very nice staff. It seemed a shame to hand it over.",
            quests = {
                { id = 477, name = "Border Crossings", npc = "Shadow Priest Allister" },
                { id = 478, name = "Maps and Runes", npc = "Dalaran Crate" },
                { id = 481, name = "Dalar's Analysis", npc = "Shadow Priest Allister" },
                { id = 482, name = "Dalaran's Intentions", npc = "Dalar Dawnweaver" },
                { id = 479, name = "Ambermill Investigations", npc = "Shadow Priest Allister" },
                { id = 95981, name = "Watching the Roads", npc = "Shadow Priest Allister", parallel = true, gameVersions = { forever = true } },
                { id = 480, name = "The Weaver", after = 479, npc = "Shadow Priest Allister" },
            },
        },
        {
            chapter = "Shadowfang Keep",
            summary = "Everyone at the Sepulcher has business in Shadowfang Keep. High Executor Hadrec sent two deathstalkers in, and they haven't come back. Dalar Dawnweaver wants Arugal's head. In the Undercity's Apothecarium, Keeper Bel'dugur wants a book.",
            recap = "Everything in Silverpine ends up pointing at Shadowfang Keep sooner or later, so I stopped arguing and went in.\n\nEverybody wanted something out of there. The High Executor wanted to know what had become of two missing deathstalkers. A keeper in the Apothecarium wanted a book called the Book of Ur. And Dalar Dawnweaver wanted Arugal's head. Just the head. Dalar was very clear on that.\n\nI found the deathstalkers. Only one of them was in any shape to talk. I found the book. And I found Arugal at the top of his keep, with worgen at every turn on the way up, and he made me work for every step.\n\nThe book went to the Undercity and the head went to the Sepulcher. That's about as tidy as Silverpine ever gets.",
            quests = {
                { id = 1098, name = "Deathstalkers in Shadowfang", npc = "High Executor Hadrec" },
                { id = 1013, name = "The Book of Ur", npc = "Keeper Bel'dugur", parallel = true },
                { id = 1014, name = "Arugal Must Die", npc = "Dalar Dawnweaver", parallel = true },
            },
        },
    },
}

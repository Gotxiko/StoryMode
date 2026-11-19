local addonName, SM = ...

-- =============================================================================
-- Classic: A New Plague
-- The Royal Apothecary Society's early plague research, from Brill to Hillsbrad.
-- =============================================================================

SM.ANewPlagueData = {
    title = "A New Plague",
    description = "Apothecary Johaan has work in Brill, and it is not the sort of work the living would approve of. The Forsaken need samples, records, and willing hands if they are to learn what can still kill the dead.\n\nBegin with the Royal Apothecary Society's errands in Tirisfal and follow the plague work into Silverpine and Hillsbrad. Each vial answers one question and raises another.",
    zone = "Tirisfal Glades / Silverpine Forest / Hillsbrad Foothills",
    expansion = "Classic",
    recommendedLevel = { min = 6, max = 32 },
    faction = "Horde",
    gameVersions = { classicEra = true, tbc = true },
    achievements = {},
    color = { 0.45, 0.72, 0.36 },
    icon = 136066,
    portraitDisplayID = 1565,
    adventureCoverTexture = 131868, -- Scholomance loading screen
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 367, name = "A New Plague", npc = "Apothecary Johaan", location = "Gallows' End Tavern, Brill" },
    startMapID = 18,
    startX = 0.5945,
    startY = 0.5240,

    npcLocations = {
        ["Apothecary Johaan"] = { mapID = 18, x = 0.5945, y = 0.5240, location = "Gallows' End Tavern, Brill" },
        ["Captured Mountaineer"] = { mapID = 18, x = 0.5900, y = 0.5200, location = "cellar of Gallows' End Tavern, Brill" },
        ["Apothecary Renferrel"] = { mapID = 21, x = 0.4290, y = 0.4090, location = "the Sepulcher, Silverpine Forest" },
        ["Master Apothecary Faranell"] = { mapID = 90, x = 0.4800, y = 0.6900, location = "the Apothecarium, Undercity" },
        ["Apothecary Lydon"] = { mapID = 25, x = 0.6160, y = 0.1900, location = "Tarren Mill, Hillsbrad Foothills" },
        ["Umpi"] = { mapID = 25, x = 0.6160, y = 0.1900, location = "Apothecary Lydon's room, Tarren Mill" },
        ["Stanley"] = { mapID = 25, x = 0.3200, y = 0.3500, location = "the northern farm in Hillsbrad Fields" },
        ["Berard's Journal"] = { mapID = 21, x = 0.4300, y = 0.7300, location = "Pyrewood Village Inn, Silverpine Forest" },
        ["Nethander Stead"] = { mapID = 25, x = 0.6400, y = 0.6200, location = "Nethander Stead, Hillsbrad Foothills" },
        ["Dun Garok"] = { mapID = 25, x = 0.7100, y = 0.8000, location = "Dun Garok, southeastern Hillsbrad Foothills" },
        ["Dusty Rug"] = { mapID = 25, x = 0.6200, y = 0.1800, location = "upstairs in the Tarren Mill inn" },
        ["Theodore Griffs"] = { mapID = 1458, x = 0.4640, y = 0.7140, location = "the Apothecarium, Undercity" },
        ["Deathguard Kristof"] = { mapID = 18, x = 0.6520, y = 0.6020, location = "Brill, Tirisfal Glades" },
        ["Tabitha Heartweaver"] = { mapID = 21, x = 0.4440, y = 0.4280, location = "the Sepulcher, Silverpine Forest" },
        ["Morbin Lightbane"] = { mapID = 90, x = 0.5780, y = 0.8980, location = "the Royal Quarter, Undercity" },
        ["Unfinished Abomination"] = { mapID = 90, x = 0.4600, y = 0.6220, location = "the Apothecarium, Undercity" },
    },

    npcDisplayIDs = {
        ["Apothecary Johaan"] = 1565,
        ["Apothecary Renferrel"] = 1661,
        ["Master Apothecary Faranell"] = 1680,
        ["Apothecary Lydon"] = 1660,
        ["Umpi"] = 901,
        ["Stanley"] = 855,
        ["Captured Mountaineer"] = 11426,
        -- Quest givers' models from Wowhead's WoW Forever data.
        ["Deathguard Kristof"] = 1590,
        ["Tabitha Heartweaver"] = 136424,
    },

    chapterDisplayIDs = {
        ["Johaan's Formula"] = 1565,
        ["A Recipe for Death"] = 1661,
        ["Tarren Mill Trials"] = 1660,
        ["Plagued Brew"] = 1660,
    },

    chapterIcons = {
        ["Johaan's Formula"] = 136066,
        ["A Recipe for Death"] = 134941,
        ["Tarren Mill Trials"] = 136067,
        ["Plagued Brew"] = 132792,
    },

    chapters = {
        {
            chapter = "Johaan's Formula",
            summary = "Apothecary Johaan, at the Gallows' End Tavern in Brill, needs darkhound blood. Then other things. He's working on something new for the Royal Apothecary Society, and he hums while he works, which is never a good sign.",
            recap = "So there's this apothecary in Brill. Johaan. Hums while he works. First day, he sends me out to kill dogs for their blood. Then murlocs for their scales, then spiders for their venom, and I'm thinking this had better be a soup.\n\nIt was not a soup. It was a drink, and the lucky guest was a dwarf they were keeping in the tavern cellar. I'll spare you that part. Johaan was thrilled. He wrote it all down, handed me his findings for Silverpine and told me to walk carefully.\n\nI walked very carefully.",
            quests = {
                { id = 367, name = "A New Plague", displayName = "Darkhound Blood", npc = "Apothecary Johaan" },
                { id = 368, name = "A New Plague", displayName = "Vile Fin Scales", npc = "Apothecary Johaan" },
                { id = 369, name = "A New Plague", displayName = "Night Web Venom", npc = "Apothecary Johaan" },
                { id = 492, name = "A New Plague", displayName = "Johaan's Special Drink", npc = "Apothecary Johaan" },
                { id = 445, name = "Delivery to Silverpine Forest", npc = "Apothecary Johaan" },
            },
        },
        {
            chapter = "A Recipe for Death",
            follows = false,
            summary = "Johaan's findings are with Apothecary Renferrel now, at the Sepulcher in Silverpine Forest. Renferrel has a shopping list of bear hearts and spider blood, all bound for Master Apothecary Faranell in the Undercity. Don't ask what for.",
            recap = "Silverpine is where Johaan's work goes to grow up. Renferrel at the Sepulcher wanted bear hearts and spider blood, which by then felt like ordinary shopping, and I hauled the lot down to Master Apothecary Faranell in the Undercity. He looked at it the way most people look at cake.\n\nTurns out somebody had tried this recipe before. A fellow called Berard, whose journal was still lying around in Pyrewood Village. Lovely place. Do not stay the night. I got the journal out, and then Faranell wanted moss off the things in Lake Lordamere and a hardened tumor, and I stopped asking what any of it was for.\n\nThat's the trick with apothecaries. The less you ask, the better you sleep.",
            quests = {
                { id = 447, name = "A Recipe For Death", npc = "Apothecary Renferrel" },
                { id = 450, name = "A Recipe For Death", displayName = "Berard's Journal", npc = "Master Apothecary Faranell" },
                { id = 451, name = "A Recipe For Death", displayName = "Lake Lordamere Samples", npc = "Apothecary Renferrel" },
            },
        },
        {
            chapter = "The Apothecarium",
            gameVersions = { forever = true },
            summary = "Theodore Griffs, in the Undercity's Apothecarium, has heard of a spider in the ruins above the city, Witherfang, whose venom eats through undead flesh. He wants a sample. In the Undercity, that isn't a rumor. It's a job offer.",
            recap = "Next job for the Society was back home in the Apothecarium, for a fellow named Theodore Griffs. He'd heard about a spider up in the ruins over the city, Witherfang, whose venom eats right through dead flesh. In the Undercity that's not a rumor. That's a job offer.\n\nSo into the Ruins of Lordaeron we went, a few of us, because nobody sane goes in there alone. Witherfang was big and quick and not at all happy to see us. We brought Griffs his Highly Toxic Strain anyway, and he held the vial up to the light like a jeweler.\n\nEverything else I'd fetched them was for killing the living. That one was for the dead. I went up for some air after that, which in the Undercity takes a while.",
            quests = {
                { id = 95216, name = "The New Plague", npc = "Theodore Griffs", gameVersions = { forever = true } },
                { id = 92422, name = "The Wrath of Rath'mael", npc = "Deathguard Kristof", optional = true, gameVersions = { forever = true }, recap = "Deathguard Kristof had reports of an unholy fog over the ruins, with the Scourge moving about inside it and a new necromancer called Rath'mael behind it all. I took friends, and we put Rath'mael down. Kristof expects another one along soon, because deathguards are not optimists." },
                { id = 92401, name = "A Frightened Request", npc = "Tabitha Heartweaver", optional = true, gameVersions = { forever = true }, recap = "Tabitha Heartweaver at the Sepulcher had a husband, Edward, who walked to a graveyard in the ruins every week to look for the son they lost when the city fell. One week he didn't come home. I went in and found out why, and that part stays between Tabitha and me." },
                { id = 92421, name = "Light's Justice", npc = "Morbin Lightbane", optional = true, gameVersions = { forever = true }, recap = "Morbin Lightbane serves the Light and the Dark Lady both and sees no trouble in it. What Morbin wanted was twenty-five intact limbs off the Scourge in the ruins: spare parts, for Forsaken whose own were wearing out. The Scourge had no further use for theirs by the time I left." },
                { id = 95204, name = "Crest of Lordaeron", location = "Ruins of Lordaeron, Tirisfal Glades", optional = true, gameVersions = { forever = true }, recap = "Somewhere in the ruins I picked up an old crest with Lordaeron's mark on it, and Oran Snakewrithe in the Undercity was glad to have it. Oran checked it was genuine by biting it. I've seen people test gold that way, never history." },
                { id = 97288, name = "Unending Torment", location = "Ruins of Lordaeron, Tirisfal Glades", optional = true, gameVersions = { forever = true } },
                { id = 97289, name = "Unending Torment", npc = "Master Apothecary Faranell", optional = true, gameVersions = { forever = true } },
                { id = 97290, name = "Unending Torment", npc = "Unfinished Abomination", optional = true, gameVersions = { forever = true } },
                { id = 97291, name = "Unending Torment", npc = "Master Apothecary Faranell", optional = true, gameVersions = { forever = true } },
                { id = 97292, name = "Unending Torment", npc = "Master Apothecary Faranell", optional = true, gameVersions = { forever = true }, recap = "The thing I put down in the ruins lost its head, and Faranell knew whose it was: a grand marshal the Dark Lady had killed personally. Faranell found the head a new body, and it woke up calling me an abomination, which was rich, coming from it. I put a serum in the drip above it, and now it simmers in its new home while Faranell makes plans." },
            },
        },
        {
            chapter = "Tarren Mill Trials",
            follows = false,
            summary = "Apothecary Lydon, in Tarren Mill, wants gray bear tongues and creeper ichor for a new elixir. Lydon likes to see his work tested, on somebody other than Lydon. That's where you come in.",
            recap = "Apothecary Lydon runs things in Tarren Mill, and Lydon likes to test his work on whoever's handy. I brought him bear tongues and creeper ichor, he cooked up the Elixir of Suffering, and then he handed it back to me. Not to drink. For Umpi, the poor beast he keeps in his room. Umpi did not enjoy it.\n\nNext came mountain lion blood for the Elixir of Pain, and that one was for Stanley. Stanley lived on a farm down in Hillsbrad Fields and was, until I came along, a very good dog. One sip and he was something else entirely, and we had words, and I won.\n\nLydon was delighted. Lydon is always delighted.",
            quests = {
                { id = 496, name = "Elixir of Suffering", npc = "Apothecary Lydon" },
                { id = 499, name = "Elixir of Suffering", displayName = "Umpi", npc = "Apothecary Lydon" },
                { id = 501, name = "Elixir of Pain", npc = "Apothecary Lydon" },
                { id = 502, name = "Elixir of Pain", displayName = "Stanley", npc = "Apothecary Lydon" },
            },
        },
        {
            chapter = "Plagued Brew",
            follows = false,
            summary = "Apothecary Lydon, in Tarren Mill, has his eye on a greater work: the Elixir of Agony. It starts with mudsnout blossoms. It does not end there. Lydon's recipes never do.",
            recap = "The Elixir of Agony was Lydon's masterpiece, and it took half of Hillsbrad to make. Mudsnout blossoms. A trip down to Faranell so he could add his own little touch. Troll's blood, scales off the naga on the coast, eyes off the murlocs. And then the secret ingredient: beer. A keg of Shindigger Stout from Dun Garok.\n\nLydon had some farmers locked upstairs at the inn, and the farmers, he figured, would drink anything. He tainted the keg and I carried it up and set it on their rug, friendly as you like.\n\nThen I went downstairs and had a drink of my own. Not from that keg.",
            quests = {
                { id = 509, name = "Elixir of Agony", displayName = "Mudsnout Blossoms", npc = "Apothecary Lydon" },
                { id = 513, name = "Elixir of Agony", displayName = "Mudsnout Composite", npc = "Apothecary Lydon" },
                { id = 515, name = "Elixir of Agony", displayName = "Faranell's Mixture", npc = "Master Apothecary Faranell" },
                { id = 517, name = "Elixir of Agony", displayName = "Shindigger Stout", npc = "Apothecary Lydon" },
                { id = 524, name = "Elixir of Agony", displayName = "Tainted Keg", npc = "Apothecary Lydon" },
            },
        },
    },
}

local addonName, SM = ...

-- =============================================================================
-- Classic: The Fallen Hero of the Horde
-- Swamp of Sorrows, Blasted Lands, Azshara, Felbane, and Razelikh.
-- =============================================================================

SM.FallenHeroData = {
    title = "A Tale of Sorrow",
    description = "At the edge of the Blasted Lands, a fallen hero still waits for orders that never came. His regiment is gone, and the demons beyond Nethergarde have had years to make use of what was left behind.\n\nListen to the dead man's account and follow the scattered trail of soldiers, relics, and old command. The road is long because the failure was not simple.",
    zone = "Swamp of Sorrows / Blasted Lands / Azshara / Stranglethorn Vale",
    expansion = "Classic",
    recommendedLevel = { min = 45, max = 60 },
    gameVersions = { classicEra = true, tbc = true },
    achievements = {},
    color = { 0.64, 0.16, 0.10 },
    icon = 136189,
    adventureCoverTexture = 131872, -- Sunken Temple: closest Classic loading screen rooted in Swamp of Sorrows
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 2801, name = "A Tale of Sorrow", npc = "Fallen Hero of the Horde", location = "the road between Swamp of Sorrows and the Blasted Lands" },
    startMapID = 51,
    startX = 0.3400,
    startY = 0.6600,

    npcLocations = {
        ["Fallen Hero of the Horde"] = { mapID = 51, x = 0.3400, y = 0.6600, location = "the road between Swamp of Sorrows and the Blasted Lands" },
        ["Dispatch Commander Ruag"] = { mapID = 51, x = 0.4700, y = 0.5500, location = "Stonard, Swamp of Sorrows" },
        ["Bengor"] = { mapID = 51, x = 0.4550, y = 0.5700, location = "Stonard, Swamp of Sorrows" },
        ["Swamp Talker"] = { mapID = 51, x = 0.6500, y = 0.7750, location = "the murloc camps in southern Swamp of Sorrows" },
        ["Ambassador Ardalan"] = { mapID = 17, x = 0.6600, y = 0.1900, location = "Nethergarde Keep, Blasted Lands" },
        ["Corporal Thund Splithoof"] = { mapID = 51, x = 0.3620, y = 0.6540, location = "near the road into the Blasted Lands" },
        ["Spectral Lockbox"] = { mapID = 51, x = 0.3620, y = 0.6540, location = "beside Corporal Thund Splithoof" },
        ["Spirit of Kirith"] = { mapID = 17, x = 0.6300, y = 0.3200, location = "the Serpent's Coil, Blasted Lands" },
        ["Loramus Thalipedes"] = { mapID = 76, x = 0.6082, y = 0.6635, location = "the Bay of Storms, Azshara" },
        ["Lord Arkkoroc"] = { mapID = 76, x = 0.7700, y = 0.4200, location = "the Temple of Arkkoran, Azshara" },
        ["Galvan the Ancient"] = { mapID = 50, x = 0.5062, y = 0.2048, location = "northern Stranglethorn Vale" },
        ["Grol the Destroyer"] = { mapID = 17, x = 0.4100, y = 0.3400, location = "Dreadmaul Hold, Blasted Lands" },
        ["Archmage Allistarj"] = { mapID = 17, x = 0.6500, y = 0.2900, location = "the Serpent's Coil, Blasted Lands" },
        ["Lady Sevine"] = { mapID = 17, x = 0.4500, y = 0.1400, location = "near the Altar of Storms, Blasted Lands" },
        ["Razelikh the Defiler"] = { mapID = 17, x = 0.4700, y = 0.2300, location = "the Rise of the Defiler, Blasted Lands" },
    },

    npcDisplayIDs = {
        ["Fallen Hero of the Horde"] = 6775,
        ["Loramus Thalipedes"] = 6879,
        ["Lord Arkkoroc"] = 170,
        ["Grol the Destroyer"] = 10169,
        ["Archmage Allistarj"] = 6769,
        ["Lady Sevine"] = 6768,
        ["Razelikh the Defiler"] = 10543,
        -- Quest givers' models from the cmangos Classic database.
        ["Dispatch Commander Ruag"] = 6571,
        ["Bengor"] = 6570,
        ["Ambassador Ardalan"] = 7010,
        ["Corporal Thund Splithoof"] = 6777,
        ["Spirit of Kirith"] = 6878,
    },

    chapterDisplayIDs = {
        ["Orders That Never Came"] = 6775,
        ["A Tale of Sorrow"] = 6775,
        ["The Last Souls"] = 6775,
        ["Loramus and the Beast's Name"] = 6879,
        ["Felbane"] = 6879,
        ["Rakh'likh"] = 10543,
    },

    chapterIcons = {
        ["Orders That Never Came"] = 132343,
        ["A Tale of Sorrow"] = 136189,
        ["The Last Souls"] = 136123,
        ["Loramus and the Beast's Name"] = 136172,
        ["Felbane"] = 135343,
        ["Rakh'likh"] = 136121,
    },

    chapters = {
        {
            chapter = "Orders That Never Came",
            faction = "Horde",
            summary = "A ghost waits on the road where the Swamp of Sorrows gives way to the Blasted Lands. The Fallen Hero of the Horde, they call him, and he has a story for anyone willing to stop and listen.",
            recap = "There's a ghost on the road where the Swamp of Sorrows gives way to the Blasted Lands. The Fallen Hero of the Horde, they call him, and his is a sorry tale. He took his soldiers toward the Blasted Lands and waited for orders. The orders never came.\n\nStonard knew the story. A few questions there, and I knew where the orders had actually gone: out to the murloc camps, into the keeping of something called the Swamp Talker. I went and took them back. The Warchief's own orders, long overdue and a bit damp.\n\nI carried them to the ghost. A dead man, finally reading the orders he'd waited for. I let him have a minute.",
            quests = {
                { id = 2784, name = "Fall From Grace", npc = "Fallen Hero of the Horde" },
                { id = 2621, name = "The Disgraced One", npc = "Fallen Hero of the Horde" },
                { id = 2622, name = "The Missing Orders", npc = "Dispatch Commander Ruag" },
                { id = 2623, name = "The Swamp Talker", npc = "Bengor" },
            },
        },
        {
            chapter = "A Tale of Sorrow",
            follows = false,
            summaryAlliance = "Ambassador Ardalan at Nethergarde Keep has an odd errand for you: go and hear out a Horde ghost. The Fallen Hero of the Horde waits on the road where the Blasted Lands meet the swamp, with a story to tell.",
            summaryHorde = "The Fallen Hero of the Horde isn't done talking. On his road at the edge of the Blasted Lands, he has the rest of his story to tell: what became of the soldiers who crossed over.",
            recapAlliance = "An ambassador at Nethergarde Keep had an errand for me I didn't see coming: go and talk to a Horde ghost. With demons camped on the doorstep, I suppose the old squabbles can wait.\n\nThe Fallen Hero of the Horde stands where the swamp gives way to the Blasted Lands, and he told me all of it. Soldiers who crossed over, and what Razelikh the Defiler's people did with them after. Out there the dead don't get to rest. They get bound to stones and put to work.\n\nSo he gave me a job: set them loose, eighteen of them, at the Stones of Binding. You have to stay right by the stone while you work or it all comes apart, and fighting well while rooted to one spot is harder than it sounds.\n\nOdd work for the Alliance. The dead don't seem to mind whose colors you wear.",
            recapHorde = "With the orders read, the Fallen Hero told me the rest of it. What happened to the soldiers who crossed into the Blasted Lands, and what Razelikh the Defiler's people did with them after. Out there the dead don't get to rest. They get bound to stones and put to work.\n\nSo he gave me a job: set them loose, eighteen of them, at the Stones of Binding. The catch is that you have to stay close to the stone while you work, or the whole thing comes apart. Nobody tells you how hard it is to fight well while rooted to one spot.\n\nWhen it was done, he didn't thank me, exactly. He started remembering names.",
            quests = {
                { id = 2783, name = "Petty Squabbles", npc = "Ambassador Ardalan", faction = "Alliance" },
                { id = 2801, name = "A Tale of Sorrow", npc = "Fallen Hero of the Horde" },
                { id = 2681, name = "The Stones That Bind Us", npc = "Fallen Hero of the Horde" },
            },
        },
        {
            chapter = "The Last Souls",
            summary = "The Fallen Hero of the Horde has two names for you. Corporal Thund Splithoof is waiting near the road into the Blasted Lands. Lieutenant Kirith is another matter: nobody knows what became of the lieutenant.",
            recap = "Once the stones were quiet, the Fallen Hero gave me a name: Corporal Thund Splithoof, one of his own. Thund was waiting near the road into the Blasted Lands, with a spectral lockbox and something inside it for me. The dead, it turns out, pay their debts.\n\nThe second name was Lieutenant Kirith. Find out what became of Kirith, the Fallen Hero said. So I went looking, and out at the Serpent's Coil I found what was left: a spirit, with news.\n\nI carried the news back to the road. The Fallen Hero took it in, and then said two words I didn't expect from an old soldier of the Horde. Demon hunter.",
            quests = {
                { id = 2702, name = "Heroes of Old", displayName = "The Splithoof Shard", npc = "Fallen Hero of the Horde" },
                { id = 2701, name = "Heroes of Old", displayName = "Corporal Thund", npc = "Corporal Thund Splithoof" },
                { id = 2721, name = "Kirith", npc = "Fallen Hero of the Horde" },
                { id = 2743, name = "The Cover of Darkness", npc = "Spirit of Kirith" },
            },
        },
        {
            chapter = "Loramus and the Beast's Name",
            summary = "The Fallen Hero of the Horde has a name for you, and it's a long way off: Loramus Thalipedes, a demon hunter who lives by the Bay of Storms in Azshara. Loramus has a story of his own.",
            recap = "The demon hunter was Loramus Thalipedes, who lives on the coast of Azshara by the Bay of Storms. Loramus told me his story, then worked a spell of enlightenment while I stood there waiting, and when it was done I understood the problem. Razelikh is warded, and getting through that ward takes the beast's name.\n\nThe name came by way of a temple down by the water, whose lord wanted Hetaera dead first and the heads brought as proof. All three of them. Bloodied, beaten and bruised, which tells you how that fight went.\n\nLast came twenty chunks of Azsharite, hidden all over southern Azshara, and a felhound to sniff them out. Best partner I had that year. Never said a word.",
            quests = {
                { id = 2744, name = "The Demon Hunter", npc = "Fallen Hero of the Horde" },
                { id = 3141, name = "Loramus", npc = "Loramus Thalipedes" },
                { id = 3508, name = "Breaking the Ward", npc = "Loramus Thalipedes" },
                { id = 3509, name = "The Name of the Beast", displayName = "Lord Arkkoroc", npc = "Loramus Thalipedes" },
                { id = 3510, name = "The Name of the Beast", displayName = "Hetaera", npc = "Lord Arkkoroc" },
                { id = 3511, name = "The Name of the Beast", displayName = "Hetaera's Blood", npc = "Lord Arkkoroc" },
                { id = 3602, name = "Azsharite", npc = "Loramus Thalipedes" },
            },
        },
        {
            chapter = "Felbane",
            summary = "Loramus Thalipedes has packed your Azsharite into a shipment for Galvan the Ancient, in northern Stranglethorn Vale. It's most of the world away from Azshara, and Loramus has very particular plans for what's inside.",
            recap = "The demon hunter packed the Azsharite into a shipment and sent me off with it to Galvan the Ancient, in northern Stranglethorn. That's one end of the world to the other, near enough, hauling a crate of crystal somebody had very particular plans for.\n\nGalvan is called the Ancient for a reason, and nobody hurries Galvan. I stood by while the forge did its work, and what came out of the fire was Felbane, made for the one job ordinary steel can't do. Razelikh's lieutenants can't be killed by anything else.\n\nThen I carried it all the way back to the Blasted Lands, to the Fallen Hero on his road. I'd like to think it was the first good news he'd had since he died.",
            quests = {
                { id = 3621, name = "The Formation of Felbane", npc = "Loramus Thalipedes" },
                { id = 3625, name = "Enchanted Azsharite Fel Weaponry", npc = "Galvan the Ancient" },
                { id = 3626, name = "Return to the Blasted Lands", npc = "Galvan the Ancient" },
            },
        },
        {
            chapter = "Rakh'likh",
            summary = "The Fallen Hero of the Horde has a use for Felbane. Razelikh the Defiler keeps three lieutenants in the Blasted Lands, each wearing a piece of a shattered amulet, and ordinary steel won't finish any of them.",
            recap = "Razelikh kept three lieutenants, and each of them wore a piece of a shattered amulet. None of them could die until Felbane had weakened them, and the weapons only had so much in them. Use them wisely, the Fallen Hero said. I did. Mostly.\n\nThree pieces made one, and with that I went up the Rise of the Defiler to see the demon himself. The Fallen Hero had a name for him by then. Rakh'likh.\n\nI came back with the demon's severed horn, and the Ward of the Defiler with it, so the Fallen Hero could destroy that ward before it fell into the wrong hands. He didn't get his soldiers back. He got the horn.",
            quests = {
                { id = 3627, name = "Uniting the Shattered Amulet", npc = "Fallen Hero of the Horde" },
                { id = 3628, name = "You Are Rakh'likh, Demon", npc = "Fallen Hero of the Horde" },
            },
        },
    },
}

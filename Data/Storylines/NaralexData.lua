local addonName, SM = ...

-- =============================================================================
-- Classic: Waking Naralex
-- The Barrens oases, the Druids of the Fang, the Disciples of Naralex, and the
-- dreamer at the bottom of the Wailing Caverns.
-- =============================================================================

SM.NaralexData = {
    title = "Waking Naralex",
    description = "Beneath the Barrens, in the Wailing Caverns, a druid named Naralex lies asleep. He went down to dream the dry land green again, and the dream went wrong. Strange beasts crawl out of the caves now, and the oases carry a taint nobody can name.\n\nFind his disciples above the caverns' entrance, and follow the trouble down into the dark to where the dreamer sleeps.",
    descriptionAlliance = "Above the entrance to the Wailing Caverns, in the Barrens, the disciples of a druid named Naralex keep a lonely watch. Their master went down to dream the dry land green again, and strange beasts have been crawling up out of the caves ever since.\n\nLend the disciples a hand, and follow the trouble down into the dark to where the dreamer sleeps.",
    descriptionHorde = "New oases have sprung up across the Barrens, and the druids of Thunder Bluff can feel a strange power seeping up beneath them. Tonga Runetotem, at the Crossroads, wants to know where it comes from.\n\nFollow the water down to the Wailing Caverns, where a druid named Naralex went to dream the Barrens green again and never came back up.",
    zone = "The Barrens / Thunder Bluff / Darnassus / Wailing Caverns",
    zoneByFaction = {
        Alliance = "The Barrens / Darnassus / Wailing Caverns",
        Horde = "The Barrens / Thunder Bluff / Wailing Caverns",
    },
    expansion = "Classic",
    recommendedLevel = { min = 10, max = 26 },
    gameVersions = { classicEra = true, tbc = true },
    achievements = {},
    color = { 0.30, 0.58, 0.50 },
    icon = 136090, -- spell_nature_sleep
    portraitDisplayID = 4216, -- Naralex
    adventureGuideInstanceName = "Wailing Caverns",
    adventureCoverTexture = 131882, -- Wailing Caverns loading screen
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 870, name = "The Forgotten Pools", npc = "Tonga Runetotem", location = "the Crossroads, The Barrens", faction = "Horde" },
    startMapID = 10,
    startX = 0.5226,
    startY = 0.3193,

    npcLocations = {
        ["Tonga Runetotem"] = { mapID = 10, x = 0.5226, y = 0.3193, location = "the Crossroads, The Barrens" },
        ["Arch Druid Hamuul Runetotem"] = { mapID = 88, x = 0.7862, y = 0.2856, location = "Elder Rise, Thunder Bluff" },
        ["Nara Wildmane"] = { mapID = 88, x = 0.7565, y = 0.3161, location = "Elder Rise, Thunder Bluff" },
        ["Nalpak"] = { mapID = 10, x = 0.4599, y = 0.3566, location = "the cave above the Wailing Caverns entrance, The Barrens" },
        ["Ebru"] = { mapID = 10, x = 0.4601, y = 0.3574, location = "the cave above the Wailing Caverns entrance, The Barrens" },
        ["Apothecary Zamah"] = { mapID = 88, x = 0.2281, y = 0.2089, location = "the Pools of Vision, Thunder Bluff" },
        ["Crane Operator Bigglefuzz"] = { mapID = 10, x = 0.6309, y = 0.3761, location = "the docks, Ratchet, The Barrens" },
        ["Mebok Mizzyrix"] = { mapID = 10, x = 0.6237, y = 0.3762, location = "Ratchet, The Barrens" },
        ["Falla Sagewind"] = { mapID = 10, x = 0.4818, y = 0.3278, location = "near the Wailing Caverns, The Barrens" },
        ["Mathrengyl Bearwalker"] = { mapID = 89, x = 0.3537, y = 0.0840, location = "the Cenarion Enclave, Darnassus" },
    },

    npcDisplayIDs = {
        -- Quest givers' models from the cmangos Classic database.
        ["Tonga Runetotem"] = 3914,
        ["Arch Druid Hamuul Runetotem"] = 4519,
        ["Nara Wildmane"] = 4513,
        ["Nalpak"] = 4289,
        ["Ebru"] = 4290,
        ["Apothecary Zamah"] = 1814,
        ["Crane Operator Bigglefuzz"] = 7051,
        ["Mebok Mizzyrix"] = 7034,
        ["Falla Sagewind"] = 7870,
        ["Mathrengyl Bearwalker"] = 2261,
    },

    chapterDisplayIDs = {
        ["The Dreaming Oases"] = 3914, -- Tonga Runetotem
        ["Disciples of Naralex"] = 4289, -- Nalpak
        ["Waking Naralex"] = 4216, -- Naralex
    },

    chapterIcons = {
        ["The Dreaming Oases"] = 134431, -- inv_misc_shell_01
        ["Disciples of Naralex"] = 134134, -- inv_misc_gem_stone_01 (Gem of Cobrahn)
        ["Waking Naralex"] = 135229, -- inv_stone_03 (Glowing Shard)
    },

    chapters = {
        {
            chapter = "The Dreaming Oases",
            faction = "Horde",
            requiredLevel = 10,
            summary = "New oases have been springing up across the Barrens, and the druids can feel a strange power seeping up from beneath them. Tonga Runetotem, at the Crossroads, wants someone to go and look into the water. Closely.",
            recap = "Tonga Runetotem, at the Crossroads, had a problem most places would envy: the Barrens kept growing new oases. Tonga didn't trust it. The druids could feel some power seeping up from below, and a druid who feels something will not rest until somebody else has gone and poked it.\n\nI poked. There were cracks in the bottoms of the pools, with gas bubbling up out of them. Tonga gave me a handful of seeds, dead and dry, and had me drop them into the crack at the Stagnant Oasis. They grew. Right there, out of nothing.\n\nA few snapjaw shells later, Tonga had an answer and didn't like it. The land was dreaming and couldn't wake, and the dream was coming from the Wailing Caverns. Before I went anywhere near them, I was to see Hamuul Runetotem in Thunder Bluff. Druids always want a second opinion.",
            quests = {
                { id = 886, name = "The Barrens Oases", npc = "Arch Druid Hamuul Runetotem", optional = true, breadcrumbFor = 870 },
                { id = 870, name = "The Forgotten Pools", npc = "Tonga Runetotem" },
                { id = 877, name = "The Stagnant Oasis", npc = "Tonga Runetotem" },
                { id = 880, name = "Altered Beings", npc = "Tonga Runetotem" },
                { id = 1489, name = "Hamuul Runetotem", npc = "Tonga Runetotem" },
            },
        },
        {
            chapter = "Disciples of Naralex",
            requiredLevel = 12,
            summaryAlliance = "Above the entrance to the Wailing Caverns, in the Barrens, two disciples of the druid Naralex keep watch: Nalpak and Ebru. Their master went down into the caverns to heal the land, and strange beasts have been coming up ever since.",
            summaryHorde = "Arch Druid Hamuul Runetotem, on Elder Rise in Thunder Bluff, has walked in the land of dreams and seen what waits in the Wailing Caverns. Above the caverns' entrance, two disciples of the druid Naralex could use a hand too.",
            recapAlliance = "There's a cave above the entrance to the Wailing Caverns, and in it two disciples of a druid named Naralex. Naralex had a lovely plan: enter the Emerald Dream and grow the Barrens back into a forest. Somewhere along the way the dream went bad, and the caverns filled up with whatever crawled out of it.\n\nDeviates, the disciples call them. Nalpak looks on the bright side and thought their hides would make good leather. Ebru just wanted them dead, seven each of four kinds, and was very particular about the count. Happily, the hides came off the same beasts, so I did both jobs at once.\n\nEbru called it the first step toward a restored Barrens. Their master, I gathered, was still down there somewhere, asleep.",
            recapHorde = "Hamuul Runetotem does his scouting asleep. He'd gone into the land of dreams and seen a cult of druids in the Wailing Caverns, druids who had meant to heal the Barrens and lost their way. He was too old to stay long. Nara Wildmane had stayed, and Nara had seen their faces.\n\nThe Druids of the Fang, she called them. Four leaders, a dream gem apiece, and all four haunting her sleep. She wanted the gems. I understood that to include the leaders.\n\nAbove the cave mouth, two disciples of Naralex had requests of their own, hides and a body count, and the caverns supplied both. When I came back with the gems, Nara said her dreams were finally free of those faces. Somebody slept well that night. Not me.",
            quests = {
                { id = 1490, name = "Nara Wildmane", npc = "Arch Druid Hamuul Runetotem", faction = "Horde" },
                { id = 914, name = "Leaders of the Fang", npc = "Nara Wildmane", faction = "Horde" },
                { id = 1486, name = "Deviate Hides", npc = "Nalpak", parallel = true },
                { id = 1487, name = "Deviate Eradication", npc = "Ebru", parallel = true },
                { id = 962, name = "Serpentbloom", npc = "Apothecary Zamah", faction = "Horde", optional = true, parallel = true, recap = "Apothecary Zamah, sent out to Thunder Bluff by the Royal Apothecary Society, wanted ten serpentbloom from the darkest corners of the Wailing Caverns, in the service of the Dark Lady. I picked them between snakes. Zamah called them splendid specimens, which from an apothecary is practically a hug." },
                { id = 959, name = "Trouble at the Docks", npc = "Crane Operator Bigglefuzz", optional = true, parallel = true, recap = "Crane Operator Bigglefuzz in Ratchet had tried to unload a huge shipment from Booty Bay all at once and brought the lot down, and in the confusion Mad Magglish ran off with a bottle of 99-year-old port and hid in the Wailing Caverns. I brought the bottle back. Bigglefuzz, who had been about to lose the job over it, hurried it off to Gazlowe as a gift." },
                { id = 865, name = "Raptor Horns", npc = "Mebok Mizzyrix", optional = true, parallel = true, recap = "Mebok Mizzyrix in Ratchet is convinced the raptors of the Barrens are cleverer than other raptors, that the cleverness lives in their horns, and that ground horn in wine makes a smart drink worth a fortune. I brought back horns off the sunscale scytheclaws. Mebok was grinding them before I'd let go." },
                { id = 1491, name = "Smart Drinks", npc = "Mebok Mizzyrix", optional = true, parallel = true, recap = "The horns didn't work. Mebok wasn't discouraged, since nobody gets rich on the first try, and had moved on to Wailing Essence, which gathers in the ectoplasmic things down in the Wailing Caverns and might be what makes the Barrens so strange. I brought six portions. Mebok promised to send me more once the fortune came in. I'm still waiting." },
            },
        },
        {
            chapter = "Waking Naralex",
            follows = false,
            requiredLevel = 15,
            summary = "Just inside the Wailing Caverns, a Disciple of Naralex waits for the four Fanglords to fall. Once they have, the disciple means to walk all the way down to the sleeping druid and wake him, and will need protecting every step.",
            recapAlliance = "With the Fanglords dead, the disciple waiting inside the caverns finally had a clear road and someone to stand in front. We walked all the way down. Every time the disciple stopped to cast, the caverns sent something to interrupt, and I interrupted back.\n\nNaralex lay at the bottom, tossing in his sleep. The disciple reached into the dream after him, and Naralex, not helping, dreamed up something huge and hungry that climbed out of the water. It went down. Naralex woke with a shout, thanked us kindly, and left to find the rest of his disciples.\n\nThe beast left a glowing green shard behind. Someone in Ratchet sent me back toward the caverns to Falla Sagewind, who called it a nightmare and said it belonged with a wise druid. Mathrengyl Bearwalker, all the way over in Darnassus, looked into it, said things in the Emerald Dream were not as anyone had thought, and that the Cenarion druids alone would attend to it. I took the hint.",
            recapHorde = "With the Fanglords dead, the disciple waiting inside the caverns finally had a clear road and someone to stand in front. We walked all the way down. Every time the disciple stopped to cast, the caverns sent something to interrupt, and I interrupted back.\n\nNaralex lay at the bottom, tossing in his sleep. The disciple reached into the dream after him, and Naralex, not helping, dreamed up something huge and hungry that climbed out of the water. It went down. Naralex woke with a shout, thanked us kindly, and left to find the rest of his disciples.\n\nThe beast left a glowing green shard behind. Someone in Ratchet sent me back toward the caverns to Falla Sagewind, who called it a nightmare and said it belonged with a wise druid. Hamuul Runetotem looked into it, said things in the Emerald Dream were not as anyone had thought, and told me not to concern myself with it. I'm trying.",
            quests = {
                { id = 6981, name = "The Glowing Shard", npc = "Glowing Shard", location = "the depths of the Wailing Caverns" },
                { id = 3369, name = "In Nightmares", npc = "Falla Sagewind", faction = "Horde" },
                { id = 3370, name = "In Nightmares", npc = "Falla Sagewind", faction = "Alliance" },
            },
        },
    },
}

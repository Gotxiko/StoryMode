local addonName, SM = ...

-- =============================================================================
-- Classic: The Shards of Myzrael
-- A voice in an Arathi crystal, the Stones of Binding, and the princess beneath them.
-- =============================================================================

SM.MyzraelData = {
    title = "The Shards of Myzrael",
    description = "High in the northern mountains of the Arathi Highlands, a cluster of crystals pulses with a voice. It belongs to Myzrael, a princess of the earth, held deep beneath the Highlands by the giants.\n\nFind the Shards of Myzrael and hear her out. Freeing a princess is the stuff of old songs, though the songs never mention how much walking is involved.",
    zone = "Arathi Highlands / Ironforge / Badlands",
    zoneByFaction = {
        Alliance = "Arathi Highlands / Ironforge / Badlands",
        Horde = "Arathi Highlands / Badlands",
    },
    expansion = "Classic",
    recommendedLevel = { min = 37, max = 50 },
    gameVersions = { classicEra = true, tbc = true },
    achievements = {},
    color = { 0.52, 0.46, 0.84 },
    icon = 134132,
    portraitDisplayID = 1165,
    adventureCoverTexture = 131820, -- Arathi Basin loading screen: the Arathi Highlands' own Classic cover
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 642, name = "The Princess Trapped", npc = "Shards of Myzrael", location = "the northern mountains, Arathi Highlands" },
    startMapID = 14,
    startX = 0.6240,
    startY = 0.3380,

    npcLocations = {
        ["Shards of Myzrael"] = { mapID = 14, x = 0.6240, y = 0.3380, location = "the northern mountains, Arathi Highlands" },
        ["Iridescent Shards"] = { mapID = 14, x = 0.8430, y = 0.3090, location = "Drywhisker Gorge, Arathi Highlands" },
        ["Stone of Inner Binding"] = { mapID = 14, x = 0.3610, y = 0.5740, location = "the Circle of Inner Binding, Arathi Highlands" },
        ["Keystone"] = { mapID = 14, x = 0.3610, y = 0.5790, location = "the Circle of Inner Binding, Arathi Highlands" },
        ["Gerrig Bonegrip"] = { mapID = 87, x = 0.5050, y = 0.0600, location = "the Forlorn Cavern, Ironforge" },
        ["Zaruk"] = { mapID = 14, x = 0.7440, y = 0.3550, location = "Hammerfall, Arathi Highlands" },
        ["Theldurin the Lost"] = { mapID = 15, x = 0.5140, y = 0.7640, location = "Badlands" },
    },

    npcDisplayIDs = {
        -- Quest givers' models from the cmangos Classic database.
        ["Gerrig Bonegrip"] = 3599,
        ["Zaruk"] = 4463,
        ["Theldurin the Lost"] = 4903,
    },

    chapterDisplayIDs = {
        ["The Princess Trapped"] = 1165, -- Myzrael
        ["Breaking the Keystone"] = 1918, -- Fozruk
        ["Theldurin the Lost"] = 4903,
        ["Summoning the Princess"] = 1165, -- Myzrael
    },

    chapterIcons = {
        ["The Princess Trapped"] = 134133, -- Mote of Myzrael
        ["Breaking the Keystone"] = 135463, -- Rod of Order
        ["Theldurin the Lost"] = 134937, -- Scroll of Myzrael
        ["Summoning the Princess"] = 132612, -- Eldritch Shackles
    },

    chapters = {
        {
            chapter = "The Princess Trapped",
            summary = "In the northern mountains of the Arathi Highlands, a cluster of crystals called the Shards of Myzrael pulses with a voice. It belongs to a princess of the earth, trapped beneath the Highlands by giants, and she would very much like out.",
            recap = "So there's a crystal up in the mountains of northern Arathi, and it talks. Put a hand on it and a voice turns up in your head: Myzrael, a princess of the earth, chained deep under the Highlands by the giants. She asked very nicely.\n\nThe kobolds of Drywhisker Gorge were allies of the giants, and they had what she needed: a dozen Motes of Myzrael, to wake a second cluster of shards in their cave. They gave them up eventually.\n\nThen the Stones of Binding. Three stone circles across the Highlands, a key in each, and elementals on guard at every one. I brought all three keys to the Stone of Inner Binding, and the princess called me her rescuer.\n\nNobody had ever called me that before. I could get used to it.",
            quests = {
                { id = 635, name = "Crystal in the Mountains", npc = "Pendant of Myzrael", location = "a rare drop from foes around level 30 to 40", optional = true, recap = "I took a pendant off a fallen foe once, and it would not stop pulsing. Hold it and a vision comes: the northern mountains of Arathi, a brilliant crystal jutting out of the earth, and a sense of someone pleading for help. I followed the vision. The crystal was there, and so was the pleading." },
                { id = 642, name = "The Princess Trapped", npc = "Shards of Myzrael" },
                { id = 651, name = "Stones of Binding", npc = "Iridescent Shards" },
            },
        },
        {
            chapter = "Breaking the Keystone",
            summary = "Myzrael has one more favor to ask, through the Stone of Inner Binding. A last lock, the Keystone, still holds her, and its key is carried by Fozruk, a stone watcher who walks the Arathi Highlands. You may want company.",
            recapAlliance = "The last lock was the Keystone, and its key, the Rod of Order, belonged to Fozruk. Fozruk is a stone watcher, which is a polite word for a giant, and spends the day walking the Highlands. Finding the giant took a while. Taking the rod took a while longer.\n\nI set the rod in the Keystone and felt the ground shudder. Then the princess, very loud: free, she was free! Not ready to face her old jailers, mind you. She needed time to gather her strength, and when she was ready, someone would have to summon her to the surface. You can guess who.\n\nShe sent me to a friend of hers, Gerrig Bonegrip, in a shop in the Forlorn Cavern of Ironforge. Gerrig had been expecting me, and welcomed me as one who serves a higher cause. Nobody had ever said that about me before either.",
            recapHorde = "The last lock was the Keystone, and its key, the Rod of Order, belonged to Fozruk. Fozruk is a stone watcher, which is a polite word for a giant, and spends the day walking the Highlands. Finding the giant took a while. Taking the rod took a while longer.\n\nI set the rod in the Keystone and felt the ground shudder. Then the princess, very loud: free, she was free! Not ready to face her old jailers, mind you. She needed time to gather her strength, and when she was ready, someone would have to summon her to the surface. You can guess who.\n\nShe sent me to a friend of hers, Zaruk, in Hammerfall. Zaruk had been expecting me, and said that if we were to bring the Lady back to the surface, we had much to discuss. Nobody had ever needed me for anything that grand before.",
            quests = {
                { id = 652, name = "Breaking the Keystone", npc = "Stone of Inner Binding" },
                { id = 653, name = "Myzrael's Allies", npc = "Keystone", faction = "Alliance" },
                { id = 688, name = "Myzrael's Allies", npc = "Keystone", faction = "Horde" },
            },
        },
        {
            chapter = "Theldurin the Lost",
            follows = false,
            summaryAlliance = "Gerrig Bonegrip, in the Forlorn Cavern of Ironforge, knows how Myzrael can be summoned. It takes a scroll, and the scroll went missing along with someone called Theldurin the Lost, last heard of in the Badlands. The name is not encouraging.",
            summaryHorde = "Zaruk, in Hammerfall, knows how Myzrael can be summoned. It takes a scroll, and the scroll went missing along with someone called Theldurin the Lost, last heard of in the Badlands. The name is not encouraging.",
            recapAlliance = "Gerrig had more to say after that. The higher cause had a name, the Twilight's Hammer, and the Lady was their Lady. To bring her back they needed the Scroll of Myzrael, and one of their own, Theldurin, had lost his mind, scorned their teachings and fled to the Badlands with it.\n\nTheldurin was mad, all right. He said hello seven times, apologized, and took the apology back. But when I mentioned the scroll, he made perfect sense. Summon her? You don't want that, he said. If she comes up, we're all in trouble. Maybe she's already free, gathering her strength.\n\nI had just finished setting her free.\n\nThe scroll had been torn up by enraged rock elementals, who were still fighting over the scraps. I collected the scraps. Theldurin called them our only chance against the evil of Myzrael, and went looking for his scrap-ratchet.",
            recapHorde = "Zaruk had more to say after that. The higher cause had a name, the Twilight's Hammer, and the Lady was their Lady. To bring her back they needed the Scroll of Myzrael, and one of their own, Theldurin, had lost his mind, scorned their teachings and fled to the Badlands with it.\n\nTheldurin was mad, all right. He said hello seven times, apologized, and took the apology back. But when I mentioned the scroll, he made perfect sense. Summon her? You don't want that, he said. If she comes up, we're all in trouble. Maybe she's already free, gathering her strength.\n\nI had just finished setting her free.\n\nThe scroll had been torn up by enraged rock elementals, who were still fighting over the scraps. I collected the scraps. Theldurin called them our only chance against the evil of Myzrael, and went looking for his scrap-ratchet.",
            quests = {
                { id = 687, name = "Theldurin the Lost", npc = "Gerrig Bonegrip", faction = "Alliance" },
                { id = 687, name = "Theldurin the Lost", npc = "Zaruk", faction = "Horde" },
                { id = 692, name = "The Lost Fragments", npc = "Theldurin the Lost" },
            },
        },
        {
            chapter = "Summoning the Princess",
            summary = "Theldurin the Lost, hiding in the Badlands, has pieced the Scroll of Myzrael back together with his scrap-ratchet. Read at the Shards of Myzrael, where you first heard her voice, it will call the princess up. Theldurin has some firm ideas about what happens next.",
            recap = "I read the scroll at the Shards of Myzrael, right where the princess first asked me for help, and up she came. Free, rested, and in no mood to thank anyone. She'd promised me once that her gratitude would shake the very foundations of the earth. She meant it literally.\n\nWhen she finally went down, I took her Eldritch Shackles and bound them to the Shards. From somewhere far below came a wail, and then a roar.\n\nThe Shards don't feel warm anymore. They hum with something that wishes the surface ill. Fair enough. If somebody let me out and then put me back, I'd hold a grudge too.\n\nRescuing a princess, it turns out, is only half the job. The other half is putting her back.",
            quests = {
                { id = 656, name = "Summoning the Princess", npc = "Theldurin the Lost" },
            },
        },
    },
}

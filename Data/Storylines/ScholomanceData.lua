local addonName, SM = ...

-- =============================================================================
-- Classic: Scholomance
-- The Skeleton Key, the Sarkhoffs, Ras Frostwhisper, and the Barov inheritance.
-- =============================================================================

SM.ScholomanceData = {
    id = "scholomance",  -- from its earlier title, "Scholomance": saved progress and share links use it
    title = "The Key to Scholomance",
    description = "Caer Darrow's ruined school is locked behind more than a door. The Scourge has made Scholomance a place of experiments, ghosts and old family secrets that refuse to stay buried.\n\nForge the Skeleton Key, then follow the stories Caer Darrow's ghosts still want told.",
    zone = "Western Plaguelands / Tanaris / Un'Goro Crater / Scholomance",
    zoneByFaction = {
        Alliance = "Western Plaguelands / Tanaris / Un'Goro Crater / Scholomance",
        Horde = "Tirisfal Glades / Western Plaguelands / Tanaris / Un'Goro Crater / Scholomance",
    },
    expansion = "Classic",
    requiredLevel = 52,
    recommendedLevel = { min = 52, max = 60 },
    gameVersions = { classicEra = true, tbc = true },
    achievements = {},
    color = { 0.38, 0.48, 0.58 },
    icon = 134459,
    adventureGuideInstanceName = "Scholomance",
    adventureCoverTexture = 131868,
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 5533, name = "Scholomance", npc = "Commander Ashlam Valorfist", location = "Chillwind Camp, Western Plaguelands", faction = "Alliance" },
    startMapID = 22,
    startX = 0.4300,
    startY = 0.8400,

    npcLocations = {
        ["Commander Ashlam Valorfist"] = { mapID = 22, x = 0.4300, y = 0.8400, location = "Chillwind Camp, Western Plaguelands" },
        ["High Executor Derrington"] = { mapID = 22, x = 0.8300, y = 0.6900, location = "the Bulwark, Tirisfal Glades" },
        ["Leonid Barthalomew the Revered"] = { mapID = 23, x = 0.8160, y = 0.5780, location = "Light's Hope Chapel, Eastern Plaguelands" },
        ["Betina Bigglezink"] = { mapID = 23, x = 0.8140, y = 0.5940, location = "Light's Hope Chapel, Eastern Plaguelands" },
        ["Alchemist Arbington"] = { mapID = 22, x = 0.4300, y = 0.8400, location = "Chillwind Camp, Western Plaguelands" },
        ["Apothecary Dithers"] = { mapID = 22, x = 0.8300, y = 0.6900, location = "the Bulwark, Tirisfal Glades" },
        ["Krinkle Goodsteel"] = { mapID = 71, x = 0.5150, y = 0.2800, location = "Gadgetzan, Tanaris" },
        ["Araj the Summoner"] = { mapID = 22, x = 0.4500, y = 0.6900, location = "the ruins of Andorhal, Western Plaguelands" },
        ["Eva Sarkhoff"] = { mapID = 22, x = 0.7000, y = 0.7300, location = "Caer Darrow, Western Plaguelands" },
        ["Magistrate Marduke"] = { mapID = 22, x = 0.7000, y = 0.7300, location = "Caer Darrow, Western Plaguelands" },
        ["Artist Renfray"] = { mapID = 22, x = 0.6500, y = 0.7500, location = "Caer Darrow, Western Plaguelands" },
        ["Eva's Remains"] = { mapID = 476, x = 0.4700, y = 0.5200, location = "Doctor Theolen Krastinov's room, Scholomance" },
        ["Kirtonos the Herald"] = { mapID = 476, x = 0.3800, y = 0.3700, location = "the Chamber of Summoning, Scholomance" },
        ["Ras Frostwhisper"] = { mapID = 476, x = 0.7000, y = 0.4600, location = "Scholomance" },
        ["Alexi Barov"] = { mapID = 22, x = 0.8300, y = 0.6900, location = "near the Bulwark, Tirisfal Glades" },
        ["Weldon Barov"] = { mapID = 22, x = 0.4300, y = 0.8400, location = "Chillwind Camp, Western Plaguelands" },
    },

    chapterDisplayIDs = {
        ["The Skeleton Key"] = 10876,
        ["The Sarkhoffs"] = 10729,
        ["Ras Frostwhisper"] = 10689,
        ["Barov Family Fortune"] = 10740,
    },

    chapterIcons = {
        ["The Skeleton Key"] = 134459,
        ["The Sarkhoffs"] = 136122,
        ["Ras Frostwhisper"] = 135852,
        ["Barov Family Fortune"] = 133731,
    },

    npcDisplayIDs = {
        -- Quest givers' models from the cmangos Classic database.
        ["Commander Ashlam Valorfist"] = 10151,
        ["High Executor Derrington"] = 10150,
        ["Alchemist Arbington"] = 10551,
        ["Apothecary Dithers"] = 10552,
        ["Krinkle Goodsteel"] = 7217,
        ["Eva Sarkhoff"] = 10895,
        ["Magistrate Marduke"] = 10931,
        ["Artist Renfray"] = 11890,
        ["Weldon Barov"] = 10457,
        ["Alexi Barov"] = 10456,
        ["Leonid Barthalomew the Revered"] = 10474,
        ["Betina Bigglezink"] = 10465,
    },

    chapters = {
        {
            chapter = "The Skeleton Key",
            requiredLevel = 55,
            summaryAlliance = "Commander Ashlam Valorfist at Chillwind Camp wants someone inside Scholomance, the Scourge's school on Caer Darrow. The door is locked, and nobody hands out keys. Alchemist Arbington, in the same camp, thinks you can make one.",
            summaryHorde = "High Executor Derrington at the Bulwark wants someone inside Scholomance, the Scourge's school on Caer Darrow. The door is locked, and nobody hands out keys. Apothecary Dithers, at the Bulwark too, thinks you can make one.",
            recapAlliance = "Scholomance has one front door and nobody hands out keys, so you make your own. Alchemist Arbington at Chillwind Camp had the recipe, and it was mostly a tour of the worst corners of the world: bones from the Plaguelands, a lava lake at the top of Fire Plume Ridge, a scarab off a summoner in Andorhal.\n\nThe best stop was Gadgetzan. A goblin called Krinkle Goodsteel would turn my bones into a key mold for fifteen gold. Mold rhymes with gold. I noticed. I paid.\n\nWhen it was all done, Arbington fitted the pieces together, handed me the Skeleton Key, and called it as certain to work as anything could be. Then suggested I go and find out.\n\nThat's an alchemist for you. Confident right up to the door.",
            recapHorde = "High Executor Derrington wanted me inside Scholomance, and Apothecary Dithers explained the catch. The door is locked, and the only key is one you build yourself, out of bones from the Plaguelands, a lava lake at the top of Fire Plume Ridge and a scarab from a summoner in Andorhal.\n\nThe bit I remember is Gadgetzan. A goblin called Krinkle Goodsteel would make the key mold, for fifteen gold. Mold, gold. I noticed. I paid anyway. You don't haggle with a goblin over something you can't make yourself.\n\nDithers put the pieces together and handed over the Skeleton Key, with a send-off about fame and power and laying waste to Scholomance.\n\nNow that's how you see somebody out the door.",
            quests = {
                { id = 5533, name = "Scholomance", npc = "Commander Ashlam Valorfist", faction = "Alliance" },
                { id = 838, name = "Scholomance", npc = "High Executor Derrington", faction = "Horde" },
                { id = 5537, name = "Skeletal Fragments", npc = "Alchemist Arbington", faction = "Alliance" },
                { id = 964, name = "Skeletal Fragments", npc = "Apothecary Dithers", faction = "Horde" },
                { id = 5538, name = "Mold Rhymes With...", npc = "Alchemist Arbington", faction = "Alliance" },
                { id = 5514, name = "Mold Rhymes With...", npc = "Apothecary Dithers", faction = "Horde" },
                { id = 5801, name = "Fire Plume Forged", npc = "Krinkle Goodsteel", faction = "Alliance" },
                { id = 5802, name = "Fire Plume Forged", npc = "Krinkle Goodsteel", faction = "Horde" },
                { id = 5803, name = "Araj's Scarab", npc = "Alchemist Arbington", faction = "Alliance" },
                { id = 5804, name = "Araj's Scarab", npc = "Apothecary Dithers", faction = "Horde" },
                { id = 5505, name = "The Key to Scholomance", npc = "Alchemist Arbington", faction = "Alliance" },
                { id = 5511, name = "The Key to Scholomance", npc = "Apothecary Dithers", faction = "Horde" },
            },
        },
        {
            chapter = "The Sarkhoffs",
            follows = false,
            requiredLevel = 55,
            summary = "Caer Darrow is full of ghosts, and Eva Sarkhoff is one of the saddest. She has unfinished business with Doctor Theolen Krastinov, the Butcher, who is still at work somewhere inside Scholomance.",
            recap = "Caer Darrow is a town of ghosts, and one of the sadder ones is Eva Sarkhoff. Doctor Theolen Krastinov, the Butcher, had killed her family, and he was still at work in Scholomance.\n\nEva wanted him dead. Then she wanted her own remains burned, and her family's beside them. That's a strange thing to be asked by the person whose bones you'll be burning. I did it. It seemed to matter to her.\n\nHer last request came with a vial, the Blood of Innocents, and instructions: find the porch, put the blood in the brazier, and Kirtonos the Herald would come to feast upon my soul.\n\nKirtonos came. My soul is still with me. Kirtonos isn't.",
            quests = {
                { id = 5382, name = "Doctor Theolen Krastinov, the Butcher", npc = "Eva Sarkhoff" },
                { id = 5515, altIds = { 5383 }, name = "Krastinov's Bag of Horrors", npc = "Eva Sarkhoff" },
                { id = 5384, name = "Kirtonos the Herald", npc = "Eva Sarkhoff" },
            },
        },
        {
            chapter = "Barov Family Fortune",
            follows = false,
            requiredLevel = 52,
            summaryAlliance = "Weldon Barov at Chillwind Camp wants the family fortune back. It's somewhere in Scholomance, as four deeds: Caer Darrow, Brill, Tarren Mill and Southshore. Somebody has to go in after them. Weldon has someone in mind.",
            summaryHorde = "Alexi Barov, near the Bulwark, has a business proposal. The Barov fortune is lying in Scholomance as four deeds: Caer Darrow, Brill, Tarren Mill and Southshore. Alexi wants them home, and would rather not fetch them personally.",
            recapAlliance = "Weldon Barov waits at Chillwind Camp for his family's fortune to come back to him. The fortune was in Scholomance, as four deeds: Caer Darrow, Brill, Tarren Mill and Southshore. Imagine owning Brill. Imagine wanting to.\n\nI brought him the deeds, and then he had one small family matter left over. His brother Alexi wanted the same fortune and was living at the Bulwark, in Horde territory. Weldon wanted Alexi's head. Alexi, he warned me, would be well protected by Horde filth.\n\nAlexi was, a bit. Not enough.\n\nI carried the head back to Chillwind, and that made Weldon the last Barov. Sounds grand. Mostly it means a smaller table at family dinners.",
            recapHorde = "Alexi Barov keeps to the Bulwark these days, and Alexi had a business proposal. The Barov fortune was lying about in Scholomance as four deeds: Caer Darrow, Brill, Tarren Mill and Southshore. Bring them home and the fortune was Alexi's again. Southshore included, for what that's worth.\n\nI brought them home. Then came the other half of the job. There was a brother, Weldon, down at Chillwind Camp with a claim to the very same papers, and Alexi wanted his head. Weldon, I was told, would be well protected by Alliance scum.\n\nLovely family. You could tell they were related.\n\nI walked into Chillwind and came out with the head, and Chillwind had some loud opinions about that. The last Barov. Alexi liked the sound of it.",
            quests = {
                { id = 5343, name = "Barov Family Fortune", npc = "Weldon Barov", faction = "Alliance" },
                { id = 5341, name = "Barov Family Fortune", npc = "Alexi Barov", faction = "Horde" },
                { id = 5344, name = "The Last Barov", npc = "Weldon Barov", faction = "Alliance" },
                { id = 5342, name = "The Last Barov", npc = "Alexi Barov", faction = "Horde" },
            },
        },
        {
            chapter = "Ras Frostwhisper",
            follows = false,
            requiredLevel = 57,
            summary = "Magistrate Marduke, another of Caer Darrow's ghosts, wants the lich Ras Frostwhisper destroyed, and has some advice: before you fight a lich, find out who it used to be. That trail starts in the ruins of Stromgarde.",
            recap = "Ras Frostwhisper haunts Scholomance, and Ras is a lich. Magistrate Marduke, another of Caer Darrow's ghosts, had a theory about liches. You don't kill one. You remind it that it used to be a man, and then you kill the man.\n\nSo I went looking for the man. In the ruins of Stromgarde I found his Keepsake of Remembrance. Leonid Barthalomew at Light's Hope knew what to do with it, and what to do was carry it into Stratholme and set it on the unholy ground called Menethil's Gift. I won't describe that place. You've either been or you're lucky.\n\nBack in Scholomance, I held the Soulbound Keepsake up to the lich, and for one moment Ras Frostwhisper was a mortal again.\n\nIt was a short moment. Marduke got the head.",
            quests = {
                { id = 5461, name = "The Human, Ras Frostwhisper", npc = "Magistrate Marduke" },
                { id = 5462, name = "The Dying, Ras Frostwhisper", npc = "Magistrate Marduke" },
                { id = 5463, name = "Menethil's Gift", npc = "Leonid Barthalomew the Revered" },
                { id = 5464, name = "Menethil's Gift", npc = "Menethil's Gift", mapID = 23, x = 0.2700, y = 0.1200, location = "Stratholme" },  -- inside the instance; the pin is its gate
                { id = 5465, name = "Soulbound Keepsake", npc = "Leonid Barthalomew the Revered" },
                { id = 5466, name = "The Lich, Ras Frostwhisper", npc = "Magistrate Marduke" },
                { id = 5531, name = "Betina Bigglezink", npc = "Leonid Barthalomew the Revered", optional = true },
                { id = 4771, name = "Dawn's Gambit", npc = "Betina Bigglezink", optional = true, recap = "Leonid Barthalomew sent me over to Betina Bigglezink with some frozen eggs, and Betina sent me back into Scholomance with something called Dawn's Gambit, to set down in the Viewing Room. A gambit, as I understand it, means giving up a piece to win the game. I made sure the piece was Vectus." },
                { id = 5529, name = "Plagued Hatchlings", npc = "Betina Bigglezink", optional = true },
                { id = 5582, name = "Healthy Dragon Scale", location = "Scholomance", optional = true, recap = "Betina Bigglezink at Light's Hope wanted twenty plagued dragon hatchlings put down in Scholomance. Somewhere in all that plague I found one healthy dragon scale, and brought that back too. I don't know what Betina wanted it for. In Scholomance, anything healthy is worth a second look." },
            },
        },
    },
}

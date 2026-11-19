local addonName, SM = ...

-- =============================================================================
-- Classic: Darrowshire
-- Pamela Redpath, Chromie, and the battle that never stopped echoing.
-- =============================================================================

SM.DarrowshireData = {
    title = "The Battle of Darrowshire",
    description = "Marlene Redpath asks you to find her niece Pamela in Darrowshire. In the ruins, a lonely child is still waiting for family and trying to remember where her doll has gone.\n\nBegin with Pamela's small request and follow the Redpath family through old grief, missing records, and the question of what really happened on Darrowshire's last night.",
    zone = "Western Plaguelands / Eastern Plaguelands",
    expansion = "Classic",
    recommendedLevel = { min = 50, max = 60 },
    gameVersions = { classicEra = true, tbc = true },
    achievements = {},
    color = { 0.68, 0.62, 0.48 },
    icon = 134331,
    portraitDisplayID = 7069,
    adventureCoverTexture = 131859,
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 5142, altIds = { 5601 }, name = "Little Pamela", npc = "Marlene Redpath", location = "Sorrow Hill, Western Plaguelands" },
    startMapID = 22,
    startX = 0.4900,
    startY = 0.7800,

    npcLocations = {
        ["Marlene Redpath"] = { mapID = 22, x = 0.4900, y = 0.7800, location = "Sorrow Hill, Western Plaguelands" },
        ["Jessica Redpath"] = { mapID = 83, x = 0.6100, y = 0.3900, location = "Everlook, Winterspring" },
        ["Pamela Redpath"] = { mapID = 23, x = 0.3600, y = 0.9000, location = "Darrowshire, Eastern Plaguelands" },
        ["Chromie"] = { mapID = 22, x = 0.3900, y = 0.6600, location = "the ruined inn of Andorhal, Western Plaguelands" },
        ["Carlin Redpath"] = { mapID = 23, x = 0.8100, y = 0.5900, location = "Light's Hope Chapel, Eastern Plaguelands" },
    },

    npcDisplayIDs = {
        ["Marlene Redpath"] = 10232,
        ["Jessica Redpath"] = 11512,
        ["Pamela Redpath"] = 10445,
        ["Chromie"] = 10008,
        ["Carlin Redpath"] = 10476,
    },

    chapterDisplayIDs = {
        ["Pamela's Doll"] = 10445,
        ["The Annals of Darrowshire"] = 10008,
        ["The Redpath Relics"] = 10476,
        ["Darrowshire Rewritten"] = 10445,
    },

    chapterIcons = {
        ["Pamela's Doll"] = 134506,
        ["The Annals of Darrowshire"] = 133739,
        ["The Redpath Relics"] = 134331,
        ["Darrowshire Rewritten"] = 135994,
    },

    chapters = {
        {
            chapter = "Pamela's Doll",
            summary = "When the battle of Darrowshire began, Marlene Redpath hid her niece Pamela, and never learned what became of her. Marlene, at Sorrow Hill in the Western Plaguelands, wants someone to go and look. So does Pamela's sister Jessica, in Everlook.",
            recap = "Marlene Redpath asked me to look in on her niece, Pamela, in Darrowshire. Darrowshire's over in the Eastern Plaguelands, and nobody has lived there in a long time. I went anyway.\n\nPamela was there. A little girl at her old home in the ruins, waiting for her family to come back and very worried about her doll. She was also a ghost. She didn't bring it up, so neither did I.\n\nThe doll had come apart, and the pieces were scattered about the town. I picked through Darrowshire until I had the lot, and for a minute there, with Pamela hugging that doll, I almost forgot where we were standing.\n\nThen she asked me to go and see her Auntie Marlene, and I started to understand how long she'd been waiting.",
            quests = {
                { id = 5142, altIds = { 5601 }, name = "Little Pamela", npc = "Marlene Redpath" },
                { id = 5149, name = "Pamela's Doll", npc = "Pamela Redpath" },
            },
        },
        {
            chapter = "The Annals of Darrowshire",
            summary = "In Darrowshire, Pamela Redpath is lonely. Auntie Marlene told her to stay put and never came back, and her father hasn't come home either. Maybe Marlene knows where he is. She lives on a hill south of Andorhal.",
            recap = "Pamela's aunt had a job waiting for me: a wedding ring, for a historian who'd been asking around about Darrowshire.\n\nThe historian was Chromie. A gnome, cheerful, and a little too well informed about things that hadn't happened yet. Chromie wanted the Annals of Darrowshire, an old history of the town that took some finding, and once she had it she added to it. Extended, she called it. I didn't ask where the extra pages came from. I'm not sure I'd have liked the answer.\n\nThe extended version went to Pamela's uncle, Carlin Redpath, at Light's Hope Chapel.",
            quests = {
                { id = 5152, name = "Auntie Marlene", npc = "Pamela Redpath" },
                { id = 5153, name = "A Strange Historian", npc = "Marlene Redpath" },
                { id = 5154, name = "The Annals of Darrowshire", npc = "Chromie" },
                { id = 5241, name = "Uncle Carlin", npc = "Pamela Redpath", optional = true },
                { id = 5211, name = "Defenders of Darrowshire", npc = "Carlin Redpath", optional = true, recap = "Carlin wanted Darrowshire's old defenders freed from that town, and I freed fifteen of them. The dead of Darrowshire have waited long enough for everything." },
                { id = 5210, name = "Brother Carlin", npc = "Chromie" },
            },
        },
        {
            chapter = "The Redpath Relics",
            summary = "Carlin Redpath, at Light's Hope Chapel, has read the strange new pages at the end of the Annals of Darrowshire and wants the truth of them. The annals also say where the heroes and villains of that last battle left their relics.",
            recap = "Carlin Redpath had the annals now, and Carlin wanted the last battle of Darrowshire put right. Putting it right, it turned out, takes a great many relics off the dead.\n\nA villain's skull and another villain's broken sword. A hero's libram, and the shield of Pamela's father. And five skulls that resonated, which meant sorting through a great many skulls that didn't. Most skulls, it turns out, have nothing to say.\n\nWhen it was all gathered, Carlin wrapped the lot in one bundle and sent me back to Chromie with it. Every hero and villain of that night, packed into one sack on my back. It was heavier than it looked.",
            quests = {
                { id = 5181, name = "Villains of Darrowshire", npc = "Carlin Redpath" },
                { id = 5168, name = "Heroes of Darrowshire", parallel = true, npc = "Carlin Redpath" },
                { id = 5206, name = "Marauders of Darrowshire", npc = "Carlin Redpath" },
                { id = 5941, name = "Return to Chromie", npc = "Carlin Redpath" },
            },
        },
        {
            chapter = "Darrowshire Rewritten",
            summary = "Chromie, at the ruined inn in Andorhal, has bound the relics you gathered into one powerful spell and believes Joseph Redpath can still be saved. The bundle has to go to Darrowshire's town square, and you're the one carrying it.",
            recap = "Chromie sent me back to Darrowshire with the bundle. I set it down in the town square, and the night Darrowshire fell started again all around me. The dead got up. Both sides.\n\nMy job was to keep the right people standing long enough, and mostly that meant Captain Redpath, Pamela's father, who had to hold on until his own corrupted self came to meet him. Then it did. I put it down, and the captain's spirit came walking into the square, himself again.\n\nAfter that I went to see Pamela at her home. For once, somebody had good news for her: her father had come home.\n\nShe gave me the key to his old chest by way of thanks. There was treasure in it. Some stories end well, and I'm not about to argue.",
            quests = {
                { id = 5721, name = "The Battle of Darrowshire", npc = "Chromie" },
                { id = 5942, name = "Hidden Treasures", npc = "Pamela Redpath" },
            },
        },
    },
}

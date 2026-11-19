local addonName, SM = ...

-- =============================================================================
-- WoW Forever: The Echoing Orbs (paladin)
-- Season of Discovery's paladin storyline, which Forever kept and added to:
-- the Althalaxx Orb, Aeonas the Vindicated and the Scarlet Crusade, and the
-- trap in Theramore. Forever's own quests are Battle at the Mannoroc Coven
-- (96438), Aeonas's Secret Refuge (96449) and In Search of Aeonas (96476).
-- Quest IDs, order and text: /sm scan and the client's enUS quest cache
-- (build 1.60.1.70959). The cache doesn't say who gives a quest, so givers
-- come from the quest text, and quests that start from an item or an object
-- carry the place instead. Nobody sends you to Aeonas's Secret Refuge
-- (96449): after A Lost Brother you have to find the man in Menethil Harbor
-- who knows Aeonas, and ask him (seen in game).
--
-- Not yet confirmed:
-- - Alliance only. Every chapter runs through Katherine the Pure in
--   Stormwind, and Forsaken paladins don't seem to get the chain in game,
--   though nobody has checked every step yet.
-- - A Newly Discovered Purpose... (81944) is left out: the cache has no text
--   for it.
-- =============================================================================

SM.ForeverEchoingOrbsData = {
    title = "The Echoing Orbs",
    description = "Something in the Tower of Althalaxx is whispering, and it isn't speaking a language the Light teaches. It won't be the last of its kind.\n\nFollow the orbs from Ashenvale to Stormwind's least official corners, the Scarlet Monastery and Theramore, and find out who else has been hunting them.",
    zone = "Ashenvale / Stormwind / Desolace / Scarlet Monastery / Felwood",
    expansion = "Classic",
    class = "PALADIN",
    faction = "Alliance",
    recommendedLevel = { min = 30, max = 53 },
    requiredLevel = 22,
    gameVersions = { forever = true },
    achievements = {},
    color = { 0.96, 0.55, 0.73 },
    icon = "Interface\\Icons\\INV_Misc_Orb_01",
    adventureCoverTexture = 131852,  -- Scarlet Monastery loading screen: where Aeonas is held
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 78088, name = "A Strange Artifact", hint = "Search the Tower of Althalaxx in Darkshore. Whatever the cult was guarding is still up there.", hintExplorer = "Darkshore hides an old tower with something still inside.", location = "found in the Tower of Althalaxx, Darkshore", gameVersions = { forever = true } },
    startMapID = 62,
    startX = 0.5500,
    startY = 0.2400,

    npcLocations = {
        ["Delgren the Purifier"] = { mapID = 63, x = 0.2660, y = 0.3830, location = "Maestra's Post, Ashenvale" },
        -- Duthorian Rall's spot: the Cathedral of Light.
        ["Katherine the Pure"] = { mapID = 84, x = 0.3981, y = 0.2980, location = "the Cathedral of Light, Stormwind" },
        ["Ursula Deline"] = { location = "the warlock sanctum, Stormwind" },
        ["Aeonas"] = { location = "the Scarlet Monastery, Tirisfal Glades" },
        ["Elrick"] = { mapID = 70, x = 0.6620, y = 0.4560, location = "the inn at Theramore Isle, Dustwallow Marsh" },
    },

    npcDisplayIDs = {
        ["Delgren the Purifier"] = 2531,
    },

    chapters = {
        {
            chapter = "The Althalaxx Orb",
            requiredLevel = 22,
            summary = "The orb you found in the Tower of Althalaxx whispers in a voice you'd rather not hear, in a language the Light never taught you. Delgren the Purifier at Maestra's Post in Ashenvale is the nearest senior paladin. Start there.",
            recap = "So I found an orb in the Tower of Althalaxx, and it whispered. In demonic. I don't speak demonic, but I got the gist, and the gist was bad.\n\nDelgren the Purifier took one look and sent me to Katherine the Pure in Stormwind. Katherine took one look and sent me to the warlocks. Officially, the Church doesn't allow warlocks in the city. Unofficially, it knows where they live.\n\nThe warlock, Ursula Deline, would study the orb for a price: summoning salts off the Blackrock orcs in Redridge. Then came the verdict. The thing had a mind of its own, too strong even for her, and it had to be broken on a demon lord's weapon. There's one still standing in Ashenvale, where a pit lord fell.\n\nSo I shattered it there and brought the pieces back to Delgren. The Light keeps odd company these days.",
            quests = {
                { id = 78088, name = "A Strange Artifact", hint = "Search the Tower of Althalaxx in Darkshore. Whatever the cult was guarding is still up there.", hintExplorer = "Darkshore hides an old tower with something still inside.", location = "found in the Tower of Althalaxx, Darkshore", gameVersions = { forever = true } },
                { id = 78089, name = "Advice From Stormwind", npc = "Delgren the Purifier", gameVersions = { forever = true } },
                { id = 78090, name = "A Second Opinion", npc = "Katherine the Pure", gameVersions = { forever = true } },
                { id = 78091, name = "Earning Your Salt", npc = "Ursula Deline", gameVersions = { forever = true } },
                { id = 78092, name = "It Must Be Destroyed", npc = "Ursula Deline", gameVersions = { forever = true } },
                { id = 78093, name = "Return to Delgren", location = "the Spear of Mannoroth, Demon Fall Canyon, Ashenvale", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "The Broken Hammer",
            requiredLevel = 35,
            summary = "A brother passing through Nijel's Point heard of a battle at the Mannoroc Coven in Desolace, where one side fought with the Light. Katherine the Pure in Stormwind wants to know who was there, and whether one of the order fell.",
            recap = "There'd been a fight at the Mannoroc Coven in Desolace, with holy light on one side. What I found was dead cultists, dead Scarlet Crusaders, and a broken warhammer of the Silver Hand. A very particular one.\n\nKatherine knew it at once. She wouldn't say much about its owner, Aeonas, because the telling shamed her. He had left the order, and not on good terms.\n\nFinding him took some asking around. In Menethil Harbor I finally met someone who knew Ol' Aeonas, and who lent me his old dinghy to look for him at a hideout called Newman's Landing. Nobody knows who Newman is. Aeonas wasn't there either. There were signs of a fight, and orders from the Grand Crusader himself. The Crusade had him.\n\nI found him in the Scarlet Monastery, closer to dead than alive, and the Light did the rest. He asked me to meet him at the Cathedral. He'd find his own way out, he said. I believe him.",
            quests = {
                { id = 96438, name = "Battle at the Mannoroc Coven", npc = "Katherine the Pure", gameVersions = { forever = true } },
                { id = 79939, name = "The Broken Hammer", hint = "Something was left behind after the battle at the Mannoroc Coven in Desolace. Look for a broken warhammer.", hintExplorer = "A battle was fought in Desolace not long ago. Not everything was carried away.", location = "a broken warhammer at the Mannoroc Coven, Desolace", gameVersions = { forever = true } },
                { id = 79940, name = "A Lost Brother", npc = "Katherine the Pure", gameVersions = { forever = true } },
                { id = 96449, name = "Aeonas's Secret Refuge", hint = "Aeonas can't be reached on foot. Ask around Menethil Harbor, and look for a boat at the docks.", hintExplorer = "Someone in Menethil Harbor knows how to reach Aeonas.", mapID = 56, x = 0.1058, y = 0.6059, location = "ask around Menethil Harbor for someone who knows Aeonas, Wetlands", gameVersions = { forever = true } },
                { id = 79945, name = "Orders from the Grand Crusader", location = "Newman's Landing, south of Menethil Harbor", gameVersions = { forever = true } },
                { id = 79946, name = "A Brother In Need", npc = "Katherine the Pure", gameVersions = { forever = true } },
                { id = 79963, name = "By The Light's Grace", npc = "Aeonas", gameVersions = { forever = true } },
                { id = 79970, name = "Aeonas the Vindicated", npc = "Aeonas", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "The Mysterious Merchant",
            requiredLevel = 45,
            summary = "Aeonas has made contact with an old friend, and another orb has surfaced in Kalimdor. He can't be in two places at once. Katherine the Pure at the Cathedral of Light has the details, and a merchant in Theramore has something to sell.",
            recap = "Aeonas had a friend to meet, so the next orb fell to me. Stormwind's spies said a merchant at the Theramore Inn was selling off dangerous curios, an orb among them, and Katherine sent me alone so as not to draw attention.\n\nThere was no merchant. There was a paladin of the Silver Hand, or someone dressed as one, and a trap. The note on his body said as much. Very considerate of him to carry it.\n\nAeonas had gone to Felwood, so I went too. There was a ritual that might break the orb, a list of components it took friends to gather, and Aeonas, who knew it was hard to trust an agent of the Lich King and hoped to bring his friend back to the Light all the same.\n\nThe ritual worked. Afterwards Aeonas handed me the orb without a word and turned away. I didn't ask. Some hopes cost more than others.",
            quests = {
                { id = 81762, name = "Some Good News", npc = "Aeonas", location = "the Cathedral of Light, Stormwind", gameVersions = { forever = true } },
                { id = 81764, name = "The Mysterious Merchant", npc = "Katherine the Pure", gameVersions = { forever = true } },
                { id = 81765, name = "Elrick, Paladin of the Silver Hand", npc = "Elrick", gameVersions = { forever = true } },
                { id = 81766, name = "The Bloody Missive", hint = "Someone at the Theramore Inn in Dustwallow Marsh never got to deliver their message. Check the body.", hintExplorer = "A message never reached Stormwind. Theramore may know why.", location = "a body at the Theramore Inn, Dustwallow Marsh", gameVersions = { forever = true } },
                { id = 96476, name = "In Search of Aeonas", npc = "Katherine the Pure", gameVersions = { forever = true } },
                { id = 81790, name = "Materials of Significance", hint = "Gregory's Note points the way to Felwood. Bring friends, because you won't manage this alone.", hintExplorer = "The note points to Felwood. Don't go alone.", location = "Felwood", gameVersions = { forever = true } },
                { id = 81885, name = "The Ritual", npc = "Aeonas", location = "Felwood", gameVersions = { forever = true } },
                { id = 82135, name = "The Price of Hope", npc = "Aeonas", location = "Felwood", gameVersions = { forever = true } },
            },
        },
    },
}

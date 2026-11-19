local addonName, SM = ...

-- =============================================================================
-- Classic mage quests
-- Curated identity chains: iconic abilities, tools, weapons, and mounts.
-- =============================================================================

SM.ClassicMageQuestData = {
    id = "mage-s-wand",  -- from its earlier title, "Mage's Wand": saved progress and share links use it
    title = "Tabetha's Lessons",
    description = "Your mage trainer sends you to Tabetha in Dustwallow Marsh, where practical magic begins with travel, errands, and materials that will not gather themselves.\n\nFollow the lessons that turn study into tools: a wand, a strange polymorph, and food enough for hungry companions.",
    zone = "Dustwallow Marsh / Scarlet Monastery / Azshara / Dire Maul",
    expansion = "Classic",
    class = "MAGE",
    gameVersions = { classicEra = true, tbc = true },
    color = { 0.25, 0.78, 0.92 },
    icon = 135932,
    adventureCoverTexture = 131835, -- Dire Maul: arcane library setting for Arcane Refreshment
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 1947, name = "Journey to the Marsh", npc = "Jennea Cannon", mapID = 84, x = 0.3854, y = 0.7934, location = "Jennea Cannon, Stormwind" },
    startMapID = 70,
    startX = 0.4600,
    startY = 0.5700,

    chapterIcons = {
        ["Boughs in the Wind"] = 135463,
        ["Mage's Wand"] = 135463,
        ["Polymorph: Pig"] = 135997,
        ["Arcane Refreshment"] = 132805,
    },

    npcDisplayIDs = {
        -- Quest givers' models from the cmangos Classic database.
        ["Jennea Cannon"] = 3292,
        ["Tabetha"] = 5375,
        ["Magus Tirth"] = 5374,
        ["Archmage Xylem"] = 7591,
        ["Lorekeeper Lydros"] = 14407,
        -- Quest givers' models from Wowhead's WoW Forever data.
        ["Belann Windwood"] = 139671,
    },

    chapters = {
        {
            chapter = "Boughs in the Wind",
            requiredLevel = 10,
            gameVersions = { forever = true },
            summary = "Belann Windwood in Valanaar has made staves and wands for the High Order's mages for more than a century, and now it's your turn to visit. Belann keeps one of the order's oldest traditions. It asks for a fallen bough, and Belann is particular.",
            recap = "Every mage needs a focus, and the clever ones have theirs made by the best. In Valanaar, the best is Belann Windwood, who has been shaping staves and wands for the High Order for more than a century.\n\nThe price is one of the order's oldest traditions: a fallen bough from the oldest trees on the isle, the kind the wind has been working on longer than anyone has kept count. A Wind-Infused Bough, to be precise, and I always am.\n\nYou'd think a fallen branch would be easy to find. Fallen branches are everywhere. The right one is not. I found it anyway, because I'm good at this.\n\nOut of it Belann made a focus that answers to me and nobody else. It's a tradition, apparently. I prefer to think of it as overdue recognition.",
            quests = {
                { id = 93791, name = "Speak with Belann", race = "Skyborne", location = "Zephras Isle", gameVersions = { forever = true } },
                { id = 93797, name = "Boughs in the Wind", npc = "Belann Windwood", race = "Skyborne", location = "Belann Windwood, Valanaar, Zephras Isle", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Mage's Wand",
            follows = false,
            requiredLevel = 30,
            summary = "Your trainer says it's time you met Tabetha. She lives out in Dustwallow Marsh, far from any library, and she's where trainers send a mage once book learning stops being enough.",
            recap = "Tabetha lives out in Dustwallow Marsh, and she's who the trainers send you to when you're ready for a wand. Practical sort. Knows her business.\n\nShe wanted a book called Rituals of Power, which Magus Tirth keeps in a strongbox out on the Shimmering Flats. The box only opens to the right phrase, and nobody was going to just tell me the phrase. I had to go and find it. Frankly, that was the easiest part of the whole affair. Words are what I do.\n\nAfter a little shopping, jade and a bramble with lightning still crackling in it, Tabetha did her ritual. I watched very closely. I walked out with a wand of my own school.\n\nMost people think a wand is a stick that throws sparks. Most people are right. But it's my stick, and the sparks go exactly where I tell them.",
            quests = {
                { id = 1947, name = "Journey to the Marsh", npc = "Jennea Cannon", faction = "Alliance", mapID = 84, x = 0.3854, y = 0.7934, location = "Jennea Cannon, Stormwind" },
                { id = 1947, name = "Journey to the Marsh", npc = "Deino", faction = "Horde", mapID = 85, x = 0.3845, y = 0.8613, location = "Deino, Orgrimmar" },
                { id = 1949, name = "Hidden Secrets", npc = "Tabetha", mapID = 70, x = 0.4606, y = 0.5709, location = "Tabetha, Dustwallow Marsh" },
                { id = 1950, name = "Get the Scoop", npc = "Magus Tirth", mapID = 64, x = 0.7829, y = 0.7570, location = "Magus Tirth, Thousand Needles" },
                { id = 1951, name = "Rituals of Power", npc = "Magus Tirth", mapID = 64, x = 0.7829, y = 0.7570, location = "Magus Tirth, Thousand Needles" },
                { id = 1948, name = "Items of Power", after = {}, npc = "Tabetha", mapID = 70, x = 0.4606, y = 0.5709, location = "Tabetha, Dustwallow Marsh" },
                { id = 1952, name = "Mage's Wand", after = 1951, npc = "Tabetha", mapID = 70, x = 0.4606, y = 0.5709, location = "Tabetha, Dustwallow Marsh" },
            },
        },
        {
            chapter = "Polymorph: Pig",
            follows = false,
            requiredLevel = 60,
            summary = "Archmage Xylem lives in a tower atop the cliffs of Azshara, about as far from anyone as a tower can get. Xylem wants a Prismatic Shell, and a warlord named Krellian has one. Archmages call this research.",
            recap = "Archmage Xylem keeps a tower on the cliffs of Azshara, and when an archmage that far from anywhere asks for help, it's never boring.\n\nPolymorph does something odd to the Spitelash naga. Turn one into a sheep, and a few seconds later a copy of it falls out of the spell, as though the magic can't decide what it's holding. You kill the copy. Xylem needed fifty.\n\nFifty. I sheeped half the coast. It was the most scientific afternoon of my life.\n\nAnd what do fifty scraps of broken magic teach you? How to turn someone into a pig. Is a pig better than a sheep? It's funnier, and I've come to believe that counts.",
            quests = {
                { id = 9362, name = "Warlord Krellian", npc = "Archmage Xylem", mapID = 76, x = 0.2971, y = 0.4052, location = "Archmage Xylem, Azshara" },
                { id = 90789, name = "Scalebeard", npc = "Archmage Xylem", optional = true, mapID = 76, x = 0.2971, y = 0.4052, location = "Archmage Xylem, Azshara", gameVersions = { forever = true }, recapAfter = 1, recap = "The errand was a Prismatic Shell, and a warlord called Krellian had one. Had. The real work came after." },
                { id = 9364, name = "Fragmented Magic", npc = "Archmage Xylem", mapID = 76, x = 0.2971, y = 0.4052, location = "Archmage Xylem, Azshara" },
            },
        },
        {
            chapter = "Arcane Refreshment",
            follows = false,
            requiredLevel = 60,
            summary = "Deep in Dire Maul, Lorekeeper Lydros still keeps the Athenaeum, and still knows a spell or two worth learning. The price is the essence of Hydrospawn, a water elemental loose in the Warpwood Quarter. Lydros calls that a fair trade.",
            recap = "Dire Maul has a library, the Athenaeum, and in it sits Lorekeeper Lydros, who looks after a great many books and a few very good spells. I liked Lydros at once. Anyone who stays in a ruin for the reading has their priorities in order.\n\nThe spell's price was the essence of Hydrospawn, a water elemental loose in the Warpwood Quarter. Hydrospawn didn't care to be anybody's price. It was a damp afternoon. I brought the essence back.\n\nWhat I got for it isn't flashy. No fire, no frost, nothing anyone will write a song about. But a fight is a short thing between two long rests. Anyone can throw a fireball. Not everyone can bring refreshments, and at the end of a long day underground, you'd be amazed which one people remember.",
            quests = {
                { id = 7463, name = "Arcane Refreshment", npc = "Lorekeeper Lydros", mapID = 234, x = 0.2470, y = 0.6480, location = "Lorekeeper Lydros, Athenaeum, Dire Maul" },
            },
        },
    },
}

local addonName, SM = ...

-- =============================================================================
-- WoW Forever: Brother Paxton's Library
-- Northshire's kobolds are stealing (and eating) Brother Paxton's books, and a
-- trail of chewed pages runs from Echo Ridge Mine to Fargodeep and Jasperlode.
-- Quest IDs, order and text: /sm scan and the client's enUS quest cache
-- (build 1.60.1.70959). Wowhead Forever has the NPCs (Kelsey Fargo 247226,
-- Tordrin Sternblade 248415) but no coordinates for them yet, so their quests
-- carry the place as text, from the quests themselves.
-- =============================================================================

SM.ForeverPaxtonsLibraryData = {
    title = "Brother Paxton's Library",
    description = "Brother Paxton keeps a small library in Northshire Abbey, and the kobolds have found it. They aren't reading the books. They're eating them.\n\nGet the books back, find out who wants the ones with pictures, and follow a kobold thief out of the valley, all the way to the mines of Elwynn Forest.",
    zone = "Northshire / Elwynn Forest",
    expansion = "Classic",
    recommendedLevel = { min = 2, max = 7 },
    requiredLevel = 1,
    faction = "Alliance",
    gameVersions = { forever = true },
    achievements = {},
    color = { 0.55, 0.42, 0.25 },
    icon = "Interface\\Icons\\INV_Misc_Book_09",

    startQuest = { id = 91741, name = "Nibbled-On Book", faction = "Alliance", location = "dropped by kobolds in Northshire Valley", gameVersions = { forever = true } },
    startMapID = 37,
    startX = 0.4820,
    startY = 0.4290,

    npcLocations = {
        -- The abbey's door: Brother Paxton and Marshal McBride are just inside.
        ["Brother Paxton"] = { mapID = 37, x = 0.4820, y = 0.4290, location = "inside Northshire Abbey, Elwynn Forest" },
        ["Marshal McBride"] = { mapID = 37, x = 0.4820, y = 0.4290, location = "just inside Northshire Abbey, Elwynn Forest" },
        ["Marshal Dughan"] = { mapID = 37, x = 0.4210, y = 0.6590, location = "Goldshire, Elwynn Forest" },
    },

    npcDisplayIDs = {
        ["Marshal Dughan"] = 1985,
    },

    chapters = {
        {
            chapter = "Nibbled Pages",
            summary = "One of Northshire's kobolds dropped a book, and by the look of it, tried to eat it first. Brother Paxton keeps a small library inside the abbey. It must have come from there, and it's probably not the only one missing.",
            recap = "A kobold dropped a book. That's not something you see every day, and the teeth marks in it were even stranger. I carried it back to Brother Paxton at the abbey, who keeps a small library there.\n\nPaxton was beside himself. Those awful kobolds were eating the books, and at this rate they'd devour the whole library. So I went back out and took the rest of the stolen books off the kobolds, one chewed volume at a time.\n\nI never thought I'd be rescuing literature from vermin. Northshire is full of surprises.",
            quests = {
                { id = 91741, name = "Nibbled-On Book", faction = "Alliance", location = "dropped by kobolds in Northshire Valley", gameVersions = { forever = true } },
                { id = 91743, name = "Rascally Rodents", npc = "Brother Paxton", faction = "Alliance", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Picture for Narf",
            summary = "The kobolds keep coming from Echo Ridge Mine. Kelsey Fargo, the new mining apprentice, works right outside it and has probably seen what they're up to. Brother Paxton sends you to ask.",
            recap = "Kelsey Fargo works outside Echo Ridge Mine, and Kelsey had heard something odd. Every so often a kobold came out yelling \"Picture for Narf!\" Nobody knew who Narf was. Kelsey's guess: one of the head kobolds at the back of the mine, sitting on a whole sack of books by now.\n\nKelsey was right. Shinyfinder Narf had a sack of \"picture\" books, and I took it. The kobolds back there are meaner than the ones outside, but none of them were holding books, so they weren't my problem.\n\nI handed the sack to Marshal McBride, just inside the abbey. Our local law enforcement, as Kelsey put it.",
            quests = {
                { id = 91745, name = "Mining Consultant", npc = "Brother Paxton", faction = "Alliance", gameVersions = { forever = true } },
                { id = 91752, name = "The Big Picture", npc = "Kelsey Fargo", location = "outside Echo Ridge Mine, Northshire Valley", faction = "Alliance", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Kobold Tracks",
            summary = "Narf's sack wasn't the end of it. Kelsey has seen a kobold leave the mine with a large sack of books, and Marshal McBride wants it tracked down. Tordrin Sternblade, the new hunter trainer behind the abbey, can help you follow it.",
            recap = "Word came from Kelsey that another kobold had left the mine, this time with a large sack of books. Marshal McBride wanted it found, and sent me to Tordrin Sternblade, the new hunter trainer from Ironforge, out by the stable behind the abbey.\n\nTordrin gave me a kobold tracking kit and a warning: these varmints were up to something outside Northshire.\n\nThe tracks led out of the valley. I followed them all the way to Goldshire and brought what I'd found to Marshal Dughan.",
            quests = {
                { id = 91758, name = "Follow That Kobold!", npc = "Marshal McBride", faction = "Alliance", gameVersions = { forever = true } },
                { id = 91772, name = "Shhh! We're Hunting Kobolds", npc = "Tordrin Sternblade", location = "by the stable behind Northshire Abbey, Elwynn Forest", faction = "Alliance", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Overdue",
            summary = "The trail ends in the mines of Elwynn Forest. Marshal Dughan in Goldshire wants Brother Paxton's books back, and one above all: \"Fun with Elementals\", which Paxton fears even a kobold could use to summon a servant.",
            recap = "Marshal Dughan gave me a book bag and a list. Paxton's books were somewhere in the Fargodeep Mine, and Paxton was worried about one in particular: \"Fun with Elementals\". Even a kobold, Paxton thought, could use it to summon an elemental servant.\n\nPaxton was right to worry. One of them was already trying. I came out with six lost books and \"Fun with Elementals\".\n\nTwo were still missing: \"Geomancy for Curious Young Wizards\" and \"Arcane Explainer: Magical Stuff in Simple Words\". Those had gone to the Jasperlode Mine. If the apprentice was summoning elementals, Dughan wondered, what could the master do?\n\nI found out. Then I took both books home to Brother Paxton, and the library was whole again. A little chewed, but whole.",
            quests = {
                { id = 91775, name = "Book Return", npc = "Marshal Dughan", faction = "Alliance", gameVersions = { forever = true } },
                { id = 91777, name = "Rare Books", npc = "Marshal Dughan", faction = "Alliance", gameVersions = { forever = true } },
            },
        },
    },
}

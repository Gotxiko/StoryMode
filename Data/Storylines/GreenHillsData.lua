local addonName, SM = ...

-- =============================================================================
-- Classic: The Green Hills of Stranglethorn
-- Hemet Nesingwary's hunting camp: three masteries, a white tiger, and a
-- novel blown all over the jungle.
-- =============================================================================

SM.GreenHillsData = {
    id = "the-green-hills-of-stranglethorn",  -- from its first title: saved progress and share links use it
    title = "The Green Hills",
    description = "In the north of Stranglethorn Vale, a famous dwarf hunter has pitched camp with a handful of companions and a great many guns. Hemet Nesingwary has come for big game, and he only takes on hunters who can prove themselves.\n\nLearn the jungle's tigers, panthers and raptors from the expedition's own hunters, and you may hear what Hemet really came for. Barnil Stonepot, meanwhile, has a small literary emergency and would rather Master Nesingwary never heard about it.",
    zone = "Stranglethorn Vale",
    expansion = "Classic",
    recommendedLevel = { min = 30, max = 43 },
    gameVersions = { classicEra = true, tbc = true },
    achievements = {},
    color = { 0.47, 0.62, 0.28 },
    icon = "Interface\\Icons\\INV_Misc_Book_08",
    portraitDisplayID = 1410,
    adventureCoverTexture = 131886, -- Zul'Gurub loading screen: shared Classic/TBC jungle cover
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 583, name = "Welcome to the Jungle", npc = "Barnil Stonepot", location = "Nesingwary's Expedition, Stranglethorn Vale" },
    startMapID = 50,
    startX = 0.3560,
    startY = 0.1050,

    npcLocations = {
        ["Barnil Stonepot"] = { mapID = 50, x = 0.3560, y = 0.1050, location = "Nesingwary's Expedition, Stranglethorn Vale" },
        ["Hemet Nesingwary"] = { mapID = 50, x = 0.3560, y = 0.1080, location = "Nesingwary's Expedition, Stranglethorn Vale" },
        ["Ajeck Rouack"] = { mapID = 50, x = 0.3560, y = 0.1060, location = "Nesingwary's Expedition, Stranglethorn Vale" },
        ["Sir S. J. Erlgadin"] = { mapID = 50, x = 0.3553, y = 0.1047, location = "Nesingwary's Expedition, Stranglethorn Vale" },
        ["Kravel Koalbeard"] = { mapID = 64, x = 0.7780, y = 0.7720, location = "Mirage Raceway, Thousand Needles" },
        ["Roon Wildmane"] = { mapID = 66, x = 0.2500, y = 0.7220, location = "Shadowprey Village, Desolace" },
    },

    npcDisplayIDs = {
        -- Quest givers' models from the cmangos Classic database.
        ["Hemet Nesingwary"] = 1410,
        ["Barnil Stonepot"] = 1413,
        ["Ajeck Rouack"] = 1658,
        ["Sir S. J. Erlgadin"] = 1659,
        ["Kravel Koalbeard"] = 5426,
        ["Roon Wildmane"] = 11852,
    },

    chapterDisplayIDs = {
        ["Welcome to the Jungle"] = 1413,
        ["Tiger Mastery"] = 1658,
        ["Panther Mastery"] = 1659,
        ["Raptor Mastery"] = 1410,
        ["The Missing Pages"] = 1413,
        ["King Bangalash"] = 616, -- King Bangalash
    },

    -- Icons of the chapters' own quest items (Paw of Sin'Dall, Fang of
    -- Bhag'thera, the Green Hills book, Head of Bangalash) where there is one.
    chapterIcons = {
        ["Welcome to the Jungle"] = "Interface\\Icons\\Ability_Tracking",
        ["Tiger Mastery"] = "Interface\\Icons\\Ability_Hunter_MendPet",
        ["Panther Mastery"] = "Interface\\Icons\\INV_Misc_MonsterFang_01",
        ["Raptor Mastery"] = "Interface\\Icons\\Ability_Hunter_Pet_Raptor",
        ["The Missing Pages"] = "Interface\\Icons\\INV_Misc_Book_08",
        ["King Bangalash"] = "Interface\\Icons\\INV_Misc_Head_Tiger_01",
    },

    chapters = {
        {
            chapter = "Welcome to the Jungle",
            summary = "Barnil Stonepot greets visitors at Nesingwary's Expedition, in the north of Stranglethorn Vale. The camp belongs to Hemet Nesingwary, a famous big game hunter who doesn't usually welcome strangers. Barnil thinks you look like you've seen enough action to meet him.",
            recap = "So there's a camp up in the north of Stranglethorn, and the first face you meet there is Barnil Stonepot. Barnil told me whose camp it was. Hemet Nesingwary's: war hero, big game hunter, not one for welcoming strangers. Then Barnil looked me over and decided I'd seen enough action to risk an introduction.\n\nHemet turned out friendlier than his reputation. He'd come to the jungle for a rare beast, he said, and I could join the hunt once I'd proved myself. Raptors with him. Tigers and panthers with two of his hunters.\n\nI'd come to Stranglethorn looking for paid work. I'd found three teachers and an exam.",
            quests = {
                { id = 583, name = "Welcome to the Jungle", npc = "Barnil Stonepot" },
                { id = 5762, name = "Hemet Nesingwary", npc = "Kravel Koalbeard", optional = true, recap = "Kravel Koalbeard, at the Mirage Raceway, had a crate for an old customer who'd long since left for Stranglethorn. Hemet's a rich dwarf, Kravel explained, and it's a good idea to keep up with the rich ones. The crate held special-gauge ammunition. Hemet paid me, asked after crusty old Kravel, and answered the question himself: still up to no good, he'd wager." },
                { id = 5763, name = "Hunting in Stranglethorn", npc = "Roon Wildmane", faction = "Horde", optional = true, recap = "Roon Wildmane, in Shadowprey Village, once spent many days hunting Desolace with a dwarf named Hemet, long enough for the old enmity between their peoples to be forgotten. Roon sent me to Stranglethorn with a kodo horn. Hemet knew whose it was at a glance, and what it meant: come back and hunt again. His next expedition might take him to Desolace, he said. Hunters always say that about the next expedition." },
            },
        },
        {
            chapter = "Tiger Mastery",
            summary = "Ajeck Rouack, at Nesingwary's Expedition, learned tiger hunting from her father as a girl, and she teaches it the same way: start easy, on the young tigers near camp. It gets harder from there.",
            recap = "Ajeck Rouack learned to hunt tigers from her father when she was a girl, and she teaches it the way he must have: start small. The young ones live near camp. From there you work your way up the family tree, and the elders take it personally.\n\nThen the real lesson. The party had been tracking one tigress for weeks without getting near her. They called her Sin'Dall. Ajeck wanted her paw, and wanted me to do what nobody of my kind had done before.\n\nTracking her was no easy task, exactly as promised. But I came back with the paw, and Ajeck named me a Master Tiger Hunter. Most impressive, I do say, was how she put it.\n\nNo certificate, mind you. Just the title, and a paw nobody asked to have back.",
            quests = {
                { id = 185, name = "Tiger Mastery", displayName = "Young Tigers", npc = "Ajeck Rouack" },
                { id = 186, name = "Tiger Mastery", displayName = "Stranglethorn Tigers", npc = "Ajeck Rouack" },
                { id = 187, name = "Tiger Mastery", displayName = "Elder Tigers", npc = "Ajeck Rouack" },
                { id = 188, name = "Tiger Mastery", displayName = "Sin'Dall", npc = "Ajeck Rouack" },
            },
        },
        {
            chapter = "Panther Mastery",
            follows = false,
            summary = "Sir S. J. Erlgadin, at Nesingwary's Expedition, won't let anyone into Hemet's crack hunting party who can't handle a panther. The lessons start easy, with the young ones. Tracking them down, the knight warns, is only half the challenge.",
            recap = "Sir S. J. Erlgadin handles the panthers, and in the knight's view Hemet has assembled a crack group, and nobody joins a crack group without proving it. So: panthers. They start you easy, on the young ones, and work you up to the shadowmaws.\n\nTracking them down is only half the challenge, Erlgadin says. I can tell you what the other half is. It's the panther.\n\nAt the top of the list sat Bhag'thera, a great panther who'd been prowling the jungle and slipping the whole expedition. His fang would earn me Erlgadin's respect. I spent a good while learning why everyone else had come home empty-handed. Then I didn't.\n\nErlgadin cheered and called me mighty. I've been living up to it ever since, mostly sitting down.",
            quests = {
                { id = 190, name = "Panther Mastery", displayName = "Young Panthers", npc = "Sir S. J. Erlgadin" },
                { id = 191, name = "Panther Mastery", displayName = "Panthers", npc = "Sir S. J. Erlgadin" },
                { id = 192, name = "Panther Mastery", displayName = "Shadowmaw Panthers", npc = "Sir S. J. Erlgadin" },
                { id = 193, name = "Panther Mastery", displayName = "Bhag'thera", npc = "Sir S. J. Erlgadin" },
            },
        },
        {
            chapter = "Raptor Mastery",
            follows = false,
            summary = "Hemet Nesingwary teaches the raptor lessons himself, at his camp in northern Stranglethorn. He'll tell you which raptors to hunt. He won't tell you where to find them. Locating the beasts, he says, is half the challenge.",
            recap = "Hemet teaches raptors himself, and his first lesson is that he won't tell you where they are. Locating the beasts is half the challenge, he says. Raptors, in my experience, are happy to help with that half.\n\nThree breeds of raptor later, he told me about the one that kept getting away from him. Tethis, Ajeck calls him, a wily old raptor that even Hemet had failed to kill. Prove yourself a true master, Hemet said, and bring back the talon.\n\nTethis was elusive right up until the moment he wasn't. I'll leave it there.\n\nHemet took the talon and tried a title out on me: Master Raptor Slayer. Has a nice ring to it, eh? It does. I'd never once managed to work it into conversation. Until now.",
            quests = {
                { id = 194, name = "Raptor Mastery", displayName = "Stranglethorn Raptors", npc = "Hemet Nesingwary" },
                { id = 195, name = "Raptor Mastery", displayName = "Lashtail Raptors", npc = "Hemet Nesingwary" },
                { id = 196, name = "Raptor Mastery", displayName = "Jungle Stalkers", npc = "Hemet Nesingwary" },
                { id = 197, name = "Raptor Mastery", displayName = "Tethis", npc = "Hemet Nesingwary" },
            },
        },
        {
            chapter = "The Missing Pages",
            follows = false,
            summary = "Barnil Stonepot, at Nesingwary's Expedition, was trusted to proofread Hemet's novel, The Green Hills of Stranglethorn, right up until a gust of wind scattered it across the jungle. Barnil needs the missing pages back before Master Nesingwary finds out.",
            recap = "Barnil Stonepot was proofreading Hemet's novel, The Green Hills of Stranglethorn, when a gust of wind went through camp and took the novel with it. Barnil got most of it back. The rest was out in the jungle, and Master Nesingwary, I was told firmly, must never find out.\n\nHere's what nobody tells you about collecting a book one page at a time. The pages don't share. A page only stacks with copies of itself, and I got copies of every page except the one I needed. For weeks I carried more of that novel than its author did. Somewhere in Booty Bay, someone is still asking for page fourteen.\n\nI read a few on the walk back. The sentences were short. The hunts were long. Somebody was always having a drink and being brave about it.\n\nBarnil says the ending is quite something. I'll take Barnil's word for it.",
            quests = {
                { id = 338, name = "The Green Hills of Stranglethorn", npc = "Barnil Stonepot" },
                { id = 339, name = "Chapter I", npc = "Barnil Stonepot", parallel = true },
                { id = 340, name = "Chapter II", npc = "Barnil Stonepot", parallel = true },
                { id = 341, name = "Chapter III", npc = "Barnil Stonepot", parallel = true },
                { id = 342, name = "Chapter IV", npc = "Barnil Stonepot", parallel = true },
            },
        },
        {
            chapter = "King Bangalash",
            follows = false,
            summary = "You've proved yourself against the expedition's tigers, panthers and raptors, and Hemet Nesingwary is finally ready to tell you why he came to Stranglethorn: a great white tiger he has had in his sights for a long time.",
            recap = "With the tigers, the panthers and the raptors behind me, Hemet finally told me about the big hunt. King Bangalash, a great white tiger. Hemet had had his sights on that tiger for a long time. He was the reason the whole expedition was in Stranglethorn.\n\nI won't tell you where the king holds court. Locating the beast is half the challenge, as a dwarf once told me. I'll tell you he was well named, and that I came back with his head.\n\nHemet was delighted. Bloody well done, right-o, cheers, I say, cheers. He said he was honored to count me a comrade of his great hunting party, which is a thing I now get to say in taverns.\n\nIn the morning the sun also rose, over a jungle with one king fewer in it.",
            quests = {
                { id = 208, name = "Big Game Hunter", npc = "Hemet Nesingwary" },
            },
        },
    },
}

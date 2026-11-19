local addonName, SM = ...

-- =============================================================================
-- WoW Forever: Odd Jobs on Hyjal
-- Three neighbours on Mount Hyjal's lower slopes: Kaylaena Springwhisper's
-- workshop and her mentor's glaive thrower, two gnome brothers and a rocket
-- test gone astray, and (Alliance only) Johun "Punchy" Dillas, who is not
-- just camping. Quest IDs, order and text: /sm scan and the client's enUS
-- quest cache (build 1.60.1.70959). Wowhead Forever has the NPCs (Kaylaena
-- 249235, Johun 249234, Fenwick 249549, Wennzut 249550) but no coordinates
-- for them yet, so their quests carry the place as text, from the quests.
-- The quests call Kaylaena both Springwhisper and Springbolt; Wowhead and
-- most of the quests say Springwhisper.
-- =============================================================================

SM.ForeverHyjalFoothillsData = {
    title = "Odd Jobs on Hyjal",
    description = "Not everyone on Mount Hyjal is fighting gods or demons. Some of them just need a hand.\n\nA tinker in the foothills is finishing her late mentor's last machine, a gnome is dangling from a tree after a rocket test, and a camper with an awful lot of crates wants help with the skunks. Every one of them has more going on than it first seems.",
    descriptionAlliance = "Not everyone on Mount Hyjal is fighting gods or demons. Some of them just need a hand.\n\nA tinker in the foothills is finishing her late mentor's last machine, a gnome is dangling from a tree after a rocket test, and a camper with an awful lot of crates wants help with the skunks. That camper, it turns out, answers to Stormwind.",
    zone = "Mount Hyjal",
    expansion = "Classic",
    recommendedLevel = { min = 56, max = 60 },
    requiredLevel = 52,
    gameVersions = { forever = true },
    achievements = {},
    color = { 0.66, 0.52, 0.30 },
    icon = "Interface\\Icons\\INV_Misc_Gear_01",
    adventureCoverTexture = 7963779,  -- Kalimdor's loading screen: Hyjal has none of its own
    adventureCoverTexCoords = { 0, 1, 0.1592, 0.8408 },  -- the picture, between its transparent bands
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 94479, name = "One Person's Trash", hint = "Look over the rusting machine in the Tainted Foothills. Some tinker would want what's inside.", hintExplorer = "Not everything in the Tainted Foothills is natural.", location = "a rusting machine in the Tainted Foothills, Mount Hyjal", gameVersions = { forever = true } },
    startMapID = 2482,

    npcLocations = {
        ["Master Mathias Shaw"] = { mapID = 1453, x = 0.7580, y = 0.5980, location = "SI:7, Old Town, Stormwind City" },
    },

    chapters = {
        {
            chapter = "Woods Workshop",
            summary = "Among the wrecked machines in the Tainted Foothills, one piece is still shiny. Somebody nearby must know what it's for. The answer is a tinker named Kaylaena, who has barely left her workshop since she lost her mentor, Yaely.",
            recap = "In the Tainted Foothills I found a rusting machine, picked clean, with one shiny part left in it. Someone pointed me to the tinker in the hills, Kaylaena, who hadn't come down much since losing her mentor, Yaely. After Archimonde fell, the two of them had picked the foothills clean of anything useful.\n\nKaylaena took the part and asked a favor. Proper parts are hard to get up a mountain, and Nami in Everlook had an order waiting. A winter sprint, Kaylaena called it.\n\nThe sprint was the easy part. At the bottom of Nami's crate sat a few inverted mana cells that discharge when bumped. I rode down Hyjal very, very slowly.",
            quests = {
                { id = 94479, name = "One Person's Trash", hint = "Look over the rusting machine in the Tainted Foothills. Some tinker would want what's inside.", hintExplorer = "Not everything in the Tainted Foothills is natural.", location = "a rusting machine in the Tainted Foothills, Mount Hyjal", gameVersions = { forever = true } },
                { id = 96796, name = "Woods Workshop", location = "the Tainted Foothills, Mount Hyjal", gameVersions = { forever = true } },
                { id = 92008, name = "Premiere Parts", npc = "Kaylaena Springwhisper", location = "her workshop in the hills, lower Mount Hyjal", gameVersions = { forever = true } },
                { id = 92009, name = "Crate Expectations", npc = "Nami", location = "Everlook, Winterspring", gameVersions = { forever = true } },
                { id = 92594, name = "Kindling, Kinda", npc = "Kaylaena Springwhisper", location = "her workshop in the hills, lower Mount Hyjal", optional = true, gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Yaely's Glaive Thrower",
            summary = "With Nami's parts in hand, Kaylaena can finally finish Yaely's last plans: a glaive thrower. It still needs scrap from the old Horde base up the mountain, a second pair of hands, and something worth shooting.",
            recap = "Kaylaena wanted scrap from Dae'gun, the old Horde base far up the mountain: frayed wire, scrap metal, and bat droppings. They have their uses, Kaylaena insisted. I didn't ask.\n\nWith that, Yaely's glaive thrower could be finished. I turned the gears and connected the batteries while Kaylaena crossed her fingers. It worked.\n\nThen we found it a target. Ghansurok, a fel chimaera, had been terrorizing the hills. My job was to beat a drum on the ridge until it came for me, then hide. Kaylaena's job was to aim.\n\nKaylaena didn't miss. Yaely would have been proud.",
            quests = {
                { id = 92011, name = "Rubble Rummage", npc = "Kaylaena Springwhisper", location = "her workshop in the hills, lower Mount Hyjal", gameVersions = { forever = true } },
                { id = 92328, name = "Siegecraft", npc = "Kaylaena Springwhisper", location = "her workshop in the hills, lower Mount Hyjal", gameVersions = { forever = true } },
                { id = 92329, name = "Drum Up Trouble", npc = "Kaylaena Springwhisper", location = "her workshop in the hills, lower Mount Hyjal", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Rocket Gnomes",
            summary = "Wennzut Togglespring and his brother Fenwick have just finished a successful rocket test. The only problem: Fenwick hasn't come back. Wennzut last saw his parachute drifting south, into Hyjal.",
            recap = "Wennzut Togglespring's rocket test had gone perfectly, apart from the part where his brother never came back. Fenwick's parachute had drifted off toward Hyjal.\n\nI found Fenwick hanging from a tree, tangled in his own ropes and blaming his rusty brother's math. A stick didn't reach him. Breaking the branch did. There was, Fenwick promised, no chance of catastrophic failure. Probably.\n\nEvery gnomish test pilot carries a survival kit, and Fenwick's had landed in the bushes nearby. Fenwick told me to open it and help myself. The kit told me to stand by while its security mechanism discharged. I stood well back.",
            quests = {
                { id = 92094, name = "Rocket Gnomes", npc = "Wennzut Togglespring", location = "the brothers' launch pad", gameVersions = { forever = true } },
                { id = 92702, name = "Branch Out", npc = "Fenwick Togglespring", location = "stuck in a tree, Mount Hyjal", gameVersions = { forever = true } },
                { id = 92064, name = "Tree Free", npc = "Fenwick Togglespring", location = "stuck in a tree, Mount Hyjal", gameVersions = { forever = true } },
                { id = 96559, name = "Supply Drop", npc = "Fenwick Togglespring", location = "Mount Hyjal", gameVersions = { forever = true } },
                { id = 93383, name = "Contents Under Pressure", location = "Fenwick's survival pack, Mount Hyjal", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Punchy's Camp",
            faction = "Alliance",
            summary = "Johun \"Punchy\" Dillas has lugged a lot of supplies up Mount Hyjal, and the local wildlife has noticed. Help with the skunks, the foxes and the missing nails, and Johun might share some of that gear. Or something more.",
            recap = "Johun \"Punchy\" Dillas had a camp full of crates and a skunk problem. The rule was simple: don't attack them, or they WILL spray you. I herded them off gently.\n\nThen foxes, rummaging through the supplies from a burrow under the boulders. Their tails ended up hung around the camp to scare off the rest. After that, nails and brackets from the burned Alliance buildings around the Cradle of Tranquility, because there's never enough fastening material.\n\nOnly after all that did Johun ask for something real: go into Dae'gun, the ruins of the Horde base, and find a high point for a lookout. That's when I realized this wasn't a camp. It was an intelligence station.",
            quests = {
                { id = 92015, name = "Area Denial Skunks", npc = "Johun \"Punchy\" Dillas", location = "his camp, Mount Hyjal", faction = "Alliance", gameVersions = { forever = true } },
                { id = 92014, name = "Fox Hole", npc = "Johun \"Punchy\" Dillas", location = "his camp, Mount Hyjal", faction = "Alliance", gameVersions = { forever = true } },
                { id = 96992, name = "Resupply", npc = "Johun \"Punchy\" Dillas", location = "his camp, Mount Hyjal", faction = "Alliance", gameVersions = { forever = true } },
                { id = 92593, name = "Avalanche of Corruption", npc = "Johun \"Punchy\" Dillas", location = "his camp, Mount Hyjal", faction = "Alliance", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "The Wild King",
            faction = "Alliance",
            summary = "Johun is SI:7, and now you know it. A druidic cult, the Blackthorne Pact, has taken root on the mountain in service to something called the Wild King. Stormwind wants to know where.",
            recap = "With the perimeter scouted, Johun came clean. SI:7, here to gather information for the Alliance. Not just anyone gets told that, Johun said, and I was to mind my discretion.\n\nThe target was the Blackthorne Pact, a cult of druids serving something they called the Wild King. I found their reinforcement point at the entrance to Hyjal Summit and marked it.\n\nThen I carried the information all the way to Master Mathias Shaw in Stormwind, without a word to anyone about Johun. Shaw called me an informant, promoted me on the spot, and sent me back up the mountain with new orders and a load of Alliance equipment.\n\nI'm told that's how SI:7 says thank you.",
            quests = {
                { id = 96494, name = "Gathering Storm", npc = "Johun \"Punchy\" Dillas", location = "his camp, Mount Hyjal", faction = "Alliance", gameVersions = { forever = true } },
                { id = 96529, name = "A Shaw Deal", npc = "Johun \"Punchy\" Dillas", location = "his camp, Mount Hyjal", faction = "Alliance", gameVersions = { forever = true } },
                { id = 96676, name = "Unsealing Blackthorne Pact", npc = "Master Mathias Shaw", faction = "Alliance", gameVersions = { forever = true } },
            },
        },
    },
}

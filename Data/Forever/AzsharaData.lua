local addonName, SM = ...

-- =============================================================================
-- WoW Forever: Azshara Reclaimed
-- Sentinels, a betrayed Horde camp and the exiled Blackmaw furbolgs fight over Azshara.
-- =============================================================================

SM.ForeverAzsharaData = {
    title = "Azshara Reclaimed",
    description = "Azshara's broken towers still hold the secrets of the highborne, and everyone has come to dig for them. Night elf sentinels at Talrendis Point fight the Spitelash naga for the ruins of Eldarath, while at Valormok the Horde has paid in blood for trusting a blood elf mage.\n\nTo the north, the Blackmaw furbolgs shelter in the camps of Ursolan, driven from their home by the Legashi satyr and sickening from the corruption the demons spread. Their gatekeeper is looking for allies.",
    descriptionAlliance = "Azshara's broken towers still hold the secrets of the highborne, and everyone has come to dig for them. Night elf sentinels at Talrendis Point fight the Spitelash naga for the ruins of Eldarath.\n\nTo the north, the Blackmaw furbolgs shelter in the camps of Ursolan, driven from their home by the Legashi satyr and sickening from the corruption the demons spread. Their gatekeeper is looking for allies.",
    descriptionHorde = "Azshara's broken towers still hold the secrets of the highborne, and everyone has come to dig for them. At Valormok, the Horde has paid in blood for trusting a blood elf mage.\n\nTo the north, the Blackmaw furbolgs shelter in the camps of Ursolan, driven from their home by the Legashi satyr and sickening from the corruption the demons spread. Their gatekeeper is looking for allies.",
    zone = "Azshara",
    expansion = "Classic",
    recommendedLevel = { min = 47, max = 60 },
    requiredLevel = 44,
    gameVersions = { forever = true },
    achievements = {},
    color = { 0.76, 0.38, 0.26 },
    icon = "Interface\\Icons\\Ability_Racial_BearForm",
    adventureCoverTexture = 7963784,  -- Blackmaw Hold's loading screen, in Azshara
    adventureCoverTexCoords = { 0, 1, 0.1592, 0.8408 },  -- the picture, between its transparent bands
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 98096, name = "Sisters In Duty", npc = "Sentinel Dalia Sunblade", location = "Darnassus, Teldrassil", faction = "Alliance" },
    startMapID = 1457, startX = 0.3980, startY = 0.8920,

    npcLocations = {
        -- Alliance
        ["Sentinel Dalia Sunblade"] = { mapID = 1457, x = 0.3980, y = 0.8920, location = "Darnassus, Teldrassil" },
        ["Commander Truesong"] = { mapID = 1447, x = 0.1180, y = 0.7820, location = "Talrendis Point, Azshara" },
        ["Saria Fairmoon"] = { mapID = 1447, x = 0.5040, y = 0.4260, location = "the Shattered Strand, Azshara" },
        ["Mathrengyl Bearwalker"] = { mapID = 1457, x = 0.3520, y = 0.0800, location = "Darnassus, Teldrassil" },
        ["Archmage Timear"] = { mapID = 1416, x = 0.1540, y = 0.7380, location = "Dalaran, Alterac Mountains" },
        -- Horde
        ["Ag'tor Bloodfist"] = { mapID = 1447, x = 0.2220, y = 0.5140, location = "Valormok, Azshara" },
        ["Jediga"] = { mapID = 1447, x = 0.2240, y = 0.5140, location = "Valormok, Azshara" },
        ["Belgrom Rockmaul"] = { mapID = 1454, x = 0.7500, y = 0.3420, location = "Valley of Honor, Orgrimmar" },
        ["Zevrost"] = { mapID = 1454, x = 0.4820, y = 0.4540, location = "the Cleft of Shadow, Orgrimmar" },
        ["Nara Wildmane"] = { mapID = 1456, x = 0.7560, y = 0.3120, location = "Thunder Bluff" },
        ["Muln Earthfury"] = { mapID = 1412, x = 0.3340, y = 0.2240, location = "near Thunder Bluff, Mulgore" },
        -- Blackmaw
        ["Ekkal"] = { mapID = 1447, x = 0.4200, y = 0.3880, location = "the Ruins of Eldarath, Azshara" },
        ["Gatekeeper Rageroar"] = { mapID = 1447, x = 0.4240, y = 0.2020, location = "Ursolan, Azshara" },
        ["Korsa"] = { mapID = 1447, x = 0.6300, y = 0.2140, location = "outside the Legashi Stronghold, Azshara" },
        ["Graal"] = { mapID = 1447, x = 0.6440, y = 0.1670, location = "the Legashi Stronghold, Azshara" },
        ["Furze"] = { mapID = 1447, x = 0.4520, y = 0.2220, location = "Ursolan, Azshara" },
        ["Elder Bramblesnap"] = { mapID = 1447, x = 0.4160, y = 0.1960, location = "Ursolan, Azshara" },
        ["Legashi Cauldron"] = { mapID = 1447, x = 0.5770, y = 0.2100, location = "the Legashi Encampment, Azshara" },
        ["Gorn One Eye"] = { mapID = 1448, x = 0.6520, y = 0.0260, location = "Timbermaw Hold, Felwood" },
        ["Lorekeeper Nok"] = { mapID = 1447, x = 0.4140, y = 0.2000, location = "Ursolan, Azshara" },
        ["Ogtinc"] = { mapID = 1447, x = 0.4240, y = 0.4260, location = "the Ruins of Eldarath, Azshara" },
    },

    npcDisplayIDs = {
        -- Quest givers' models from the cmangos Classic database.
        ["Sentinel Dalia Sunblade"] = 7602,
        ["Ag'tor Bloodfist"] = 7871,
        ["Jediga"] = 7876,
        ["Gatekeeper Rageroar"] = 1012,
        ["Gorn One Eye"] = 1012,
        -- Quest givers' models from Wowhead's WoW Forever data.
        ["Commander Truesong"] = 127408,
        ["Saria Fairmoon"] = 127409,
        ["Ekkal"] = 5851,
        ["Korsa"] = 5851,
        ["Graal"] = 2003,
        ["Furze"] = 3028,
        ["Elder Bramblesnap"] = 6829,
        ["Keldara Sunblade"] = 7603,
        ["Belgrom Rockmaul"] = 5535,
        ["Ogtinc"] = 1012,
        ["Mathrengyl Bearwalker"] = 2261,
        ["Nara Wildmane"] = 4513,
        -- Quest givers' models from Wowhead's WoW Forever data.
        ["Archmage Timear"] = 27592,
        ["Lorekeeper Nok"] = 11363,
    },

    chapters = {
        {
            chapter = "Talrendis Point",
            faction = "Alliance",
            requiredLevel = 45,
            summary = "Sentinel Dalia Sunblade in Darnassus hasn't heard from her sister Keldara in far too long. Keldara is posted to Talrendis Point in Azshara, where the sentinels fight the naga for the old ruins. Commander Truesong there should know where she is.",
            recap = "A young sentinel in Darnassus hadn't heard from her sister in too long, so I went to Azshara to look. I found Keldara Sunblade a prisoner of the satyr, and hurt. Except she wasn't. She'd been playing it up the whole time, waiting for her captors to get careless. Turns out I was the opening she'd been waiting for.\n\nAfter that the commander at Talrendis Point put me to work on the naga picking over the old kaldorei ruins, which kept me busy a good while. It ended with Warlord Krellian, hiding behind his guards in a temple. Guards only get you so far.\n\nThe commander held that head like a promise. Azshara might be kaldorei again yet.",
            quests = {
                { id = 98096, name = "Sisters In Duty", npc = "Sentinel Dalia Sunblade", faction = "Alliance", gameVersions = { forever = true } },
                { id = 88857, name = "Saving a Sentinel", npc = "Keldara Sunblade", faction = "Alliance", location = "the Haldarr Encampment, Azshara", gameVersions = { forever = true } },
                { id = 88809, name = "Preserving Eldarath", npc = "Commander Truesong", faction = "Alliance", gameVersions = { forever = true } },
                { id = 88812, name = "Reclaiming Ravencrest", npc = "Commander Truesong", faction = "Alliance", gameVersions = { forever = true } },
                { id = 88813, name = "The Head of the Serpent", npc = "Commander Truesong", faction = "Alliance", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "The Archaeologist",
            faction = "Alliance",
            requiredLevel = 47,
            summary = "One of Commander Truesong's sentinels has spotted a kaldorei woman alone on the Shattered Strand, plainly no fighter, with naga on every side. Truesong at Talrendis Point wants to know who she is and what she's doing out there.",
            recap = "One of the sentinels had spotted a kaldorei woman alone on the Shattered Strand, plainly no fighter. Saria Fairmoon. An archaeologist, more or less, digging for highborne relics while the naga looted everything around her, and very glad to find an assistant who could fight.\n\nSo I assisted. A staff from under a naga lady's nose, a crystal off a murloc, a mark of the old queen's favor. And three highborne tablets called Creation, Manipulation and Power, which in hindsight should have told me something.\n\nThen Saria wanted to show me what it had all been for, and I found out what she'd really been after.\n\nI went back to Talrendis Point with her knapsack full of artifacts and news nobody wanted. Saria didn't come with me.",
            quests = {
                { id = 88821, name = "Making Contact", npc = "Commander Truesong", faction = "Alliance", gameVersions = { forever = true } },
                { id = 88917, name = "Slithering Looters", npc = "Saria Fairmoon", faction = "Alliance", gameVersions = { forever = true } },
                { id = 88884, name = "Highborne Tablets", npc = "Saria Fairmoon", faction = "Alliance", gameVersions = { forever = true } },
                { id = 89037, name = "Murloc Thieves", npc = "Saria Fairmoon", faction = "Alliance", gameVersions = { forever = true } },
                { id = 89038, name = "A Monumental Task", npc = "Saria Fairmoon", faction = "Alliance", gameVersions = { forever = true } },
                { id = 89053, name = "Your Final Reward", npc = "Saria Fairmoon", faction = "Alliance", gameVersions = { forever = true } },
                { id = 89470, name = "Ill Tidings", faction = "Alliance", location = "the Shattered Strand, Azshara", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Rimtori's Betrayal",
            faction = "Horde",
            requiredLevel = 44,
            summary = "Belgrom Rockmaul in Orgrimmar sent a dozen warriors to Azshara to guard Magus Rimtori, a blood elf mage who had promised him the riches of the highborne. That bargain has gone badly. Take Belgrom's sealed letter to Ag'tor Bloodfist at Valormok.",
            recap = "Belgrom Rockmaul had sent a dozen warriors to Azshara to guard a blood elf mage who'd promised him the riches of the highborne. When I got there the warriors were dead. The mage, Magus Rimtori, had killed them all.\n\nI found the camp: three sealed crystals feeding a summoning spell, and the seals in the pockets of Rimtori's officers. I took the seals and broke them, the crystals erupted, and while Rimtori was still reeling I finished it. The head went to Belgrom.\n\nThe mage's tome ended up with a warlock in Orgrimmar, who found a demon in its diagrams and wanted its heart. So I called the thing up at the Altar of Storms and brought the heart back. The warlock never said what it was for. I didn't ask.",
            quests = {
                { id = 3504, name = "Betrayed", npc = "Belgrom Rockmaul", faction = "Horde", gameVersions = { forever = true } },
                { id = 3505, name = "Betrayed", npc = "Ag'tor Bloodfist", faction = "Horde", location = "Valormok, Azshara", gameVersions = { forever = true } },
                { id = 91497, name = "Seals of the Sin'dorei", hint = "Magus Rimtori's camp holds three seals. Find all of them before you open the tome.", hintExplorer = "Magus Rimtori's camp holds what the tome needs.", faction = "Horde", location = "Magus Rimtori's camp, Azshara", gameVersions = { forever = true } },
                { id = 91500, name = "An Explosive Gambit", faction = "Horde", location = "Magus Rimtori's camp, Azshara", gameVersions = { forever = true } },
                { id = 91531, name = "Revenge Exacted", npc = "Ag'tor Bloodfist", faction = "Horde", gameVersions = { forever = true } },
                { id = 91538, name = "Sin'dorei Tome of Summoning", faction = "Horde", location = "Magus Rimtori's camp, Azshara", gameVersions = { forever = true } },
                { id = 91547, name = "Sin'dorei Tome of Summoning", npc = "Jediga", faction = "Horde", gameVersions = { forever = true } },
                { id = 91548, name = "Vek'zol", npc = "Zevrost", faction = "Horde", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "The Exiles of Ursolan",
            requiredLevel = 47,
            summary = "In the Ruins of Eldarath, a Blackmaw furbolg named Ekkal has a score to settle with the Legashi satyr, who drove the tribe from its home. The Blackmaw are short of friends. Their gatekeeper, Rageroar, is camped to the north at Ursolan.",
            recap = "The Blackmaw are furbolgs without a home. The Legashi satyr drove them out of their den, and they've been living in makeshift camps ever since, getting sicker.\n\nTheir gatekeeper had sent scouts to spy on the satyr stronghold and hadn't heard back. I found one of them, Korsa, alone outside the walls. One scout dead, one taken, and Korsa too ashamed to go home and say so.\n\nSo we fixed it. We cut down Master Feardred, who served the satyr lord, thinned out the stronghold, and broke Graal out of a satyr cage.\n\nThe scouts walked back into Ursolan with their heads up. That was the whole point.",
            quests = {
                { id = 86746, name = "The Legashi Threat", npc = "Ekkal", gameVersions = { forever = true } },
                { id = 86752, name = "Report to Rageroar", npc = "Ekkal", gameVersions = { forever = true } },
                { id = 86791, name = "Missing Blackmaw Scouts", npc = "Gatekeeper Rageroar", gameVersions = { forever = true } },
                { id = 86777, name = "Master Feardred", npc = "Korsa", gameVersions = { forever = true } },
                { id = 86792, name = "Thinning Their Forces", npc = "Korsa", gameVersions = { forever = true } },
                { id = 86796, name = "Later, Satyr", npc = "Graal", gameVersions = { forever = true } },
                { id = 86797, name = "Return to Rageroar", npc = "Korsa", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Satyrweed and Firewater",
            requiredLevel = 47,
            summary = "Furze, a Blackmaw at Ursolan, is burning up with a fever that seems to unmake its victims from the inside, and Furze isn't the first to catch it. Tell Elder Bramblesnap. If anyone knows a cure, it's the elder.",
            recap = "A Blackmaw named Furze was burning up with a fever that looked like it was unmaking him from the inside, and he wasn't the first. The tribe's elder had a theory about a cure, and it was the last place anybody wanted it to be: the Legashi's own firewater.\n\nSo I went into the satyr camp for a drink. They weren't sharing, so I took the recipe off one of them and brewed my own batch in their cauldron, satyrweed and a mote of fel power. I've smelled worse. Not much worse.\n\nThe elder turned it into a tincture, and I tested it on corrupted beasts out east: knock one down, dose it, watch. It worked well enough to give the elder hope.\n\nThe first real dose went to Furze. He'd waited long enough.",
            quests = {
                { id = 86799, name = "Encroaching Corruption", npc = "Furze", gameVersions = { forever = true } },
                { id = 86804, name = "An Unlikely Source", npc = "Elder Bramblesnap", gameVersions = { forever = true } },
                { id = 86925, name = "Toil and Trouble", npc = "Legashi Cauldron", gameVersions = { forever = true } },
                { id = 86926, name = "Felfire Burn, Cauldron Bubble", npc = "Legashi Cauldron", gameVersions = { forever = true } },
                { id = 86927, name = "Running Firewater", npc = "Legashi Cauldron", gameVersions = { forever = true } },
                { id = 86812, name = "Transmuted Tincture", npc = "Elder Bramblesnap", gameVersions = { forever = true } },
                { id = 86813, name = "Potential Panacea", npc = "Elder Bramblesnap", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "The Timbermaw Banner",
            requiredLevel = 47,
            summary = "Gatekeeper Rageroar is ready to take the fight to the Legashi, but the Blackmaw don't have the warriors for it. The Timbermaw might. Go to Timbermaw Hold in Felwood and ask Gorn One Eye for help.",
            recap = "The Blackmaw needed warriors, so I went to Timbermaw Hold to ask their cousins. Funny thing: when the satyr overran the Blackmaw, the rest of the Timbermaw sealed their passage and never knew their own kin had made it out.\n\nGorn One Eye was glad to help, and couldn't. The Timbermaw had their own war on with the Deadwood. So I brought back the Deadwood chieftain's mace, with nobody holding it, and that freed up some warriors.\n\nI planted the Timbermaw War Banner in the satyr prince's summoning circle, the reinforcements came, and the prince fell. The demon who'd moved into Blackmaw Hold went the same way.\n\nFor the first time in a long while, the Blackmaw had something to plan besides the next retreat.",
            quests = {
                { id = 86798, name = "Timbermaw Reinforcements", npc = "Gatekeeper Rageroar", gameVersions = { forever = true } },
                { id = 87346, name = "Chieftain Bloodmaw", npc = "Gorn One Eye", gameVersions = { forever = true } },
                { id = 86814, name = "Blackmaw Counter-Offensive", npc = "Gorn One Eye", gameVersions = { forever = true } },
                { id = 92065, name = "Blackmaw Reclamation", npc = "Gatekeeper Rageroar", gameVersions = { forever = true } },
                { id = 92066, name = "The Twin Bears", npc = "Lorekeeper Nok", optional = true, gameVersions = { forever = true }, recap = "Lorekeeper Nok at Ursolan wanted two totems brought out of Blackmaw Hold, one for Ursoc and one for Ursol, the twin bears every furbolg looks up to. I found both and carried them very carefully. Losing a fight in there is one thing. Dropping a demigod on the way home is another." },
                { id = 97327, name = "Blackmaw Pouches", npc = "Ekkal", optional = true, gameVersions = { forever = true }, recap = "Ekkal wanted five Blackmaw pouches fetched out of the hold. Not weapons, not treasure. Pouches. I didn't look inside. Some things you carry without asking, and a furbolg's pouch is one of them." },
                { id = 92069, name = "Claws That Rend, Tusks that Gore", npc = "Ogtinc", optional = true, gameVersions = { forever = true }, recap = "Ogtinc, out by the Ruins of Eldarath, wanted the claws of the Great Bear and the tusks of the Unbroken from inside the hold. Both came attached to their owners, who had opinions about that. Claws that rend and tusks that gore, I'd been warned. I can confirm both." },
                { id = 92070, name = "A Lost Memento", location = "Blackmaw Hold, Azshara", optional = true, gameVersions = { forever = true }, recap = "In the hold I came across a feathered charm necklace that plainly belonged to somebody. Somebody turned out to be Unele, back at Ursolan, so I gave it back. Some loot is worth more returned than sold." },
                { id = 92344, name = "Get to the Roots of It", npc = "Mathrengyl Bearwalker", faction = "Alliance", optional = true, gameVersions = { forever = true }, recap = "Mathrengyl Bearwalker in Darnassus wanted ten Nordrassil root caps, and the place to pick them, of all places, was Blackmaw Hold. I picked ten. I didn't ask what a druid wants with them. Ask a druid a question and the answer takes the rest of the afternoon." },
                { id = 92343, name = "Get to the Roots of It", npc = "Nara Wildmane", faction = "Horde", optional = true, gameVersions = { forever = true }, recap = "Nara Wildmane in Thunder Bluff wanted ten Nordrassil root caps, and the place to pick them, of all places, was Blackmaw Hold. I picked ten, between fights. I didn't ask what they were for. Up on the Elder Rise a question turns into a lesson, and the lesson turns into the evening." },
                { id = 97173, name = "Blackmaw Magic", npc = "Archmage Timear", faction = "Alliance", optional = true, gameVersions = { forever = true }, recap = "Archmage Timear of the Kirin Tor wanted a Blackmaw ritual totem brought out of the hold. I found one and carried it all the way to Dalaran. Mages will study anything that sits still long enough. Totems are very good at sitting still." },
                { id = 97198, name = "Blackmaw Magic", npc = "Muln Earthfury", faction = "Horde", optional = true, gameVersions = { forever = true }, recap = "Muln Earthfury of the Earthen Ring wanted a Blackmaw ritual totem brought out of the hold. I found one and carried it home to Mulgore. I didn't ask what it had to say. With the Earthen Ring, the totems do most of the talking." },
            },
        },
    },
}

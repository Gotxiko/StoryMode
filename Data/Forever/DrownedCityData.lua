local addonName, SM = ...

-- =============================================================================
-- WoW Forever: The Drowned City
-- The Rebel Camp's question about Colonel Kurzen and Kin'weelay's sunken legends
-- both lead to I'lalai, an old Gurubashi city risen off Stranglethorn's coast.
-- =============================================================================
--
-- Chain order, from Wowhead's WoW Forever pages and their comments:
--   Alliance: Troll Witchery (205) opens An Acquaintance in Southshore (95786);
--   Colonel Kurzen (202) is not needed. Dibbs gives both dungeon quests, then
--   Findings for the Explorer's League (95799) and The Web of Magic (95798).
--   Horde: The Vile Reef (629) > The Gurubashi Legends of Old (95748), which
--   opens both Locating the Lost City (95770) and Aggro'gosh's Enemies in the
--   Water (95773). The Drowned City (95775) leads to A Tale Spun Around the Fire.
-- Side branches that can be played alongside the main line are `parallel`, so
-- finishing them first doesn't count the main line as done.

SM.ForeverDrownedCityData = {
    title = "The Drowned City",
    description = "At the Rebel Camp in northern Stranglethorn, a few deserters are holding out against their old commander, Colonel Kurzen, and Brother Nimetz wants to know what turned a good officer so cruel. To the south, at Grom'gol Base Camp, Kin'weelay of the Darkspear wants a piece of an old legend from the Vile Reef, a troll city the sea swallowed long ago.\n\nBoth trails lead out to the water off Stranglethorn's coast, where something old has come back up. Every treasure hunter in Booty Bay has heard about it.",
    descriptionAlliance = "At the Rebel Camp in northern Stranglethorn, a few deserters are holding out against their old commander, Colonel Kurzen, outnumbered ten to one. Lieutenant Doren needs every blade he can get, and Brother Nimetz wants to know what turned a good officer so cruel.\n\nThe answer leads a long way from the jungle and then straight back to it, out to the water off Stranglethorn's coast, where something old has come back up. Every treasure hunter in Booty Bay has heard about it.",
    descriptionHorde = "At Grom'gol Base Camp in Stranglethorn, Kin'weelay of the Darkspear wants a piece of an old legend from the Vile Reef, a troll city the sea swallowed long ago. Commander Aggro'gosh has trouble enough on land without more of it coming out of the water.\n\nThe legend leads out to the reef and past it, to something old that has come back up off Stranglethorn's coast. Every treasure hunter in Booty Bay has heard about it.",
    zone = "Stranglethorn Vale / The Drowned City",
    zoneByFaction = {
        Alliance = "Stranglethorn Vale / Hillsbrad Foothills / The Drowned City / Ironforge",
        Horde = "Stranglethorn Vale / The Drowned City / Durotar",
    },
    expansion = "Classic",
    recommendedLevel = { min = 30, max = 40 },
    requiredLevel = 30,
    gameVersions = { forever = true },
    achievements = {},
    color = { 0.20, 0.52, 0.50 },
    icon = "Interface\\Icons\\INV_Misc_Archaeology_TrollGolem",  -- the Ancient Gurubashi Idol's icon
    adventureCoverTexture = 7963741,  -- the Drowned City's loading screen
    adventureCoverTexCoords = { 0, 1, 0.1592, 0.8408 },  -- the picture, between its transparent bands
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 215, name = "Jungle Secrets", npc = "Private Thorsen", location = "near the Rebel Camp, Stranglethorn Vale", faction = "Alliance", gameVersions = { forever = true } },
    startMapID = 1434,
    startX = 0.3800,
    startY = 0.0340,

    npcLocations = {
        -- Alliance
        ["Private Thorsen"] = { mapID = 1434, x = 0.3800, y = 0.0340, location = "near the Rebel Camp, Stranglethorn Vale" },
        ["Lieutenant Doren"] = { mapID = 1434, x = 0.3800, y = 0.0300, location = "the Rebel Camp, Stranglethorn Vale" },
        ["Bookie Herod's Records"] = { mapID = 1434, x = 0.4370, y = 0.0940, location = "the two-story house in Kurzen's Compound, Stranglethorn Vale" },
        ["Bookie Herod's Strongbox"] = { mapID = 1434, x = 0.4960, y = 0.0760, location = "the Stockpile, Kurzen's Compound, Stranglethorn Vale" },
        ["Corporal Sethman"] = { mapID = 1434, x = 0.3760, y = 0.0340, location = "the Rebel Camp, Stranglethorn Vale" },
        ["Sergeant Yohwa"] = { mapID = 1434, x = 0.3800, y = 0.0360, location = "the Rebel Camp, Stranglethorn Vale" },
        ["Brother Nimetz"] = { mapID = 1434, x = 0.3780, y = 0.0340, location = "the Rebel Camp, Stranglethorn Vale" },
        ["Loremaster Dibbs"] = { mapID = 1424, x = 0.5040, y = 0.5700, location = "Southshore, Hillsbrad Foothills" },
        ["Historian Karnik"] = { mapID = 1455, x = 0.7720, y = 0.1180, location = "the Hall of Explorers, Ironforge" },
        ["Abra Cadabra"] = { mapID = 1416, x = 0.1200, y = 0.7020, location = "Dalaran, Alterac Mountains" },
        ["Archmage Timear"] = { mapID = 1416, x = 0.1540, y = 0.7380, location = "Dalaran, Alterac Mountains" },
        -- Horde
        ["Kin'weelay"] = { mapID = 1434, x = 0.3220, y = 0.2780, location = "Grom'gol Base Camp, Stranglethorn Vale" },
        ["Commander Aggro'gosh"] = { mapID = 1434, x = 0.3220, y = 0.2880, location = "Grom'gol Base Camp, Stranglethorn Vale" },
        ["Master Gadrin"] = { mapID = 1411, x = 0.5580, y = 0.7440, location = "Sen'jin Village, Durotar" },
        ["Mazu'kon"] = { mapID = 1412, x = 0.3240, y = 0.2060, location = "Mulgore" },
        -- Both
        ["Krazek"] = { mapID = 1434, x = 0.2700, y = 0.7720, location = "the top floor of the inn, Booty Bay, Stranglethorn Vale" },
        ["Dudd Fizzlescroll"] = { mapID = 1434, x = 0.2820, y = 0.7620, location = "Booty Bay, Stranglethorn Vale" },
    },

    npcDisplayIDs = {
        -- Quest givers' models from the cmangos Classic database.
        ["Private Thorsen"] = 4664,
        ["Lieutenant Doren"] = 2593,
        ["Corporal Sethman"] = 4395,
        ["Sergeant Yohwa"] = 4393,
        ["Brother Nimetz"] = 4392,
        ["Loremaster Dibbs"] = 3702,
        ["Kin'weelay"] = 4475,
        ["Commander Aggro'gosh"] = 1735,
        ["Krazek"] = 7164,
        -- Quest givers' models from Wowhead's WoW Forever data.
        ["Archmage Timear"] = 27592,
        ["Mazu'kon"] = 143984,
    },

    chapters = {
        {
            chapter = "Jungle Secrets",
            faction = "Alliance",
            summary = "The Rebel Camp in northern Stranglethorn is a band of deserters holding out against Colonel Kurzen, their old commander. Private Thorsen, on the road near camp, could use a hand right now, and Sergeant Yohwa has work for anyone who can fight.",
            recap = "So there's a camp of deserters in northern Stranglethorn, outnumbered ten to one by their old colonel. I pulled one of them, Private Thorsen, out of a scrap with Kurzen's men on the road. Thorsen had been sent back to spy on Kurzen. Kurzen, it turned out, knew.\n\nSo somebody in camp was talking. Lieutenant Doren sent me into Kurzen's Compound for his logistics officer's papers. Nothing about Thorsen, but a little brass key hidden in a ledger's binding, and a strongbox in the caves out back that it opened. Inside was a muddy note with Thorsen's whole routine, signed with one letter. M.\n\nBetween errands, the sergeant had me thin out Kurzen's men and rob his medicine men of their remedies. Then the corporal who keeps the patrol schedules told me who'd walked with Thorsen last week. I took that back to Doren and let him do the arithmetic.",
            quests = {
                { id = 215, name = "Jungle Secrets", npc = "Private Thorsen", faction = "Alliance", gameVersions = { forever = true } },
                { id = 200, name = "Bookie Herod", npc = "Lieutenant Doren", faction = "Alliance", gameVersions = { forever = true } },
                { id = 328, name = "The Hidden Key", npc = "Bookie Herod's Records", faction = "Alliance", gameVersions = { forever = true } },
                { id = 329, name = "The Spy Revealed!", npc = "Bookie Herod's Strongbox", faction = "Alliance", gameVersions = { forever = true } },
                { id = 330, name = "Patrol Schedules", npc = "Lieutenant Doren", faction = "Alliance", gameVersions = { forever = true } },
                { id = 331, name = "Report to Doren", npc = "Corporal Sethman", faction = "Alliance", gameVersions = { forever = true } },
                { id = 203, name = "The Second Rebellion", npc = "Sergeant Yohwa", faction = "Alliance", parallel = true, gameVersions = { forever = true } },
                { id = 204, name = "Bad Medicine", npc = "Sergeant Yohwa", faction = "Alliance", parallel = true, gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Colonel Kurzen",
            follows = false,
            faction = "Alliance",
            summary = "Brother Nimetz at the Rebel Camp has a question nobody else is asking: what turned a once-noble man into the colonel they're fighting? Sergeant Yohwa and Lieutenant Doren, meanwhile, are ready to go after Kurzen's best troops, and the colonel himself.",
            recap = "The sergeant sent me after Kurzen's special forces, down in the caves they call the Stockpile, and then the lieutenant sent me after the colonel himself. Kurzen commanded from the very back of it. I came out with his head, which settled the military side of things.\n\nBrother Nimetz was stuck on another side. Kurzen had once been a good man, and Nimetz wanted to know what turned him. So I copied four troll legends off tablets in the old ruins, and pried a handful of fetishes off the Skullsplitter witchdoctors down south.\n\nNimetz added a scout's report: the local trolls were all worked up, repeating one word. I'lalai. He bundled the lot and sent me to a friend of his in Southshore. Stranglethorn to Hillsbrad, with a parcel. Nobody in that camp does anything by halves.",
            quests = {
                { id = 207, name = "Kurzen's Mystery", npc = "Brother Nimetz", faction = "Alliance", gameVersions = { forever = true } },
                { id = 205, name = "Troll Witchery", npc = "Brother Nimetz", faction = "Alliance", gameVersions = { forever = true } },
                { id = 95786, name = "An Acquaintance in Southshore", npc = "Brother Nimetz", faction = "Alliance", gameVersions = { forever = true } },
                { id = 574, name = "Special Forces", npc = "Sergeant Yohwa", faction = "Alliance", parallel = true, gameVersions = { forever = true } },
                { id = 202, name = "Colonel Kurzen", after = 574, npc = "Lieutenant Doren", faction = "Alliance", gameVersions = { forever = true } },
                { id = 206, name = "Mai'Zoth", npc = "Brother Nimetz", faction = "Alliance", optional = true, parallel = true, gameVersions = { forever = true }, recap = "Nimetz had one more name for me later on. Kurzen was dead, but whatever had turned him was not: an ogre mage called Mai'Zoth, holed up in a mound in the eastern mountains and said to bend minds. Nimetz was positive Mai'Zoth had done it. I brought back the Mind's Eye, the thing the ogre used, and handed it over very carefully." },
            },
        },
        {
            chapter = "The Vile Reef",
            faction = "Horde",
            summary = "Kin'weelay at Grom'gol Base Camp wants a shard of an old tablet in the Vile Reef, a troll city the sea swallowed long ago. The tablet is sacred to the Darkspear. The murlocs living in the ruins don't care.",
            recap = "Kin'weelay wanted a shard of a tablet out of the Vile Reef, an old troll city an earthquake sank long ago. Murlocs live in it now. The tablet tells the tale of Gri'lek, a hero of troll legend, and Kin'weelay wanted a piece of it for Orgrimmar. I chipped one off and swam for it.\n\nKin'weelay found the shard odd. It spoke of a lost city, I'lalai, as a great sprawling civilization, and the reef ruins aren't nearly big enough. So I went up the coast to another old ruin with hide and charcoal and took a rubbing of a second legend.\n\nCommander Aggro'gosh had naga swarming the ruins on the sea floor and wanted their tridents. Kin'weelay remembered a cavern by the reef from diving there as a youngster. I found it, west of the reef, with naga gathered all around. Naga never gather anywhere for a good reason.",
            quests = {
                { id = 629, name = "The Vile Reef", npc = "Kin'weelay", faction = "Horde", gameVersions = { forever = true } },
                { id = 95748, name = "The Gurubashi Legends of Old", npc = "Kin'weelay", faction = "Horde", gameVersions = { forever = true } },
                { id = 95770, name = "Locating the Lost City", npc = "Kin'weelay", faction = "Horde", gameVersions = { forever = true } },
                { id = 95773, name = "Enemies in the Water", npc = "Commander Aggro'gosh", faction = "Horde", parallel = true, gameVersions = { forever = true } },
            },
        },
        {
            chapter = "The Drowned City",
            summaryAlliance = "Loremaster Dibbs in Southshore has read the report from the Rebel Camp with shaking hands, and he believes a lost city has risen off Stranglethorn's coast. He wants its legends and its magic studied. Krazek in Booty Bay wants something from the place too.",
            summaryHorde = "Beyond the cavern west of the Vile Reef lie ruins the naga are guarding, and Kin'weelay at Grom'gol thinks they may be the lost city. Commander Aggro'gosh wants to know what the naga are after. Krazek in Booty Bay has an interest in the place too.",
            recapAlliance = "Loremaster Dibbs read the report with shaking hands. If the trolls were right, the lost city of I'lalai had risen off Stranglethorn's coast, which made it, in his words, the archeological discovery of the century. Could I possibly go back down there? With hide and charcoal?\n\nSo into the Drowned City I went, with friends. I took rubbings of four tablets and collected troll fetishes, since Dibbs suspected whatever magic raised the city might have something to do with what took the colonel's mind.\n\nKrazek in Booty Bay had me on a second job: a crew of Saltseer pirates had got there first and were looting magical things he'd rather loot himself. He especially wanted their captain, Dreadrise, out of the picture. Permanently. The picture is clearer now.",
            recapHorde = "Past the cavern the naga were guarding stood the ruins Kin'weelay had hoped for: the lost city of I'lalai, up out of the sea after all that time. Kin'weelay was too old to go in, and wanted etchings of every tablet inside. Commander Aggro'gosh wanted the naga's leader dead before they found whatever they were looking for. I brought enough friends to manage both.\n\nKrazek in Booty Bay had me on a second job: a crew of Saltseer pirates had got there first and were looting magical things he'd rather loot himself. He especially wanted their captain out of the picture. Permanently. The picture is clearer now.",
            quests = {
                { id = 95787, name = "Take Two With Water", npc = "Loremaster Dibbs", faction = "Alliance", instance = "dungeon", gameVersions = { forever = true } },
                { id = 95788, name = "Magics of the Drowned City", npc = "Loremaster Dibbs", faction = "Alliance", instance = "dungeon", parallel = true, gameVersions = { forever = true } },
                { id = 95775, name = "The Drowned City", npc = "Kin'weelay", faction = "Horde", instance = "dungeon", gameVersions = { forever = true } },
                { id = 95776, name = "The Only Good Brinescale...", npc = "Commander Aggro'gosh", faction = "Horde", instance = "dungeon", parallel = true, gameVersions = { forever = true } },
                { id = 95789, name = "Shady Saltseers", npc = "Krazek", instance = "dungeon", parallel = true, gameVersions = { forever = true } },
                { id = 95791, name = "The Saltseer Captain", npc = "Krazek", instance = "dungeon", parallel = true, gameVersions = { forever = true } },
                { id = 97130, name = "Ancient Gurubashi Secrets", npc = "Archmage Timear", faction = "Alliance", instance = "dungeon", optional = true, parallel = true, gameVersions = { forever = true }, recap = "Archmage Timear in Dalaran had heard about the ruin and wanted one of the idols the old Gurubashi witch doctors used to focus their blood magic. For its archeological value, the archmage said. I found one and handed it over to the Kirin Tor, who I'm sure will be very responsible with it." },
                { id = 96774, name = "Ancient Gurubashi Idol", npc = "Mazu'kon", faction = "Horde", instance = "dungeon", optional = true, parallel = true, gameVersions = { forever = true }, recap = "Mazu'kon in Mulgore had heard the old Gurubashi channeled their blood magic through idols of pure truesilver and wanted one, strictly for academics. The advice was to kill the most impressive-looking priest in the place. It was good advice. Academics, I'm told, is a very broad field." },
                -- Starts from the Partial Mystical Notes, a scroll found in the city.
                { id = 95384, name = "Partial Mystical Notes", location = "the Drowned City", optional = true, parallel = true, gameVersions = { forever = true }, recap = "Somewhere in the city I picked up a scrap of scroll covered in symbols I couldn't read. It didn't feel dangerous, so I took it to Dudd Fizzlescroll in Booty Bay, a collector of odd magic. One less mystery in my pack." },
            },
        },
        {
            chapter = "A Tale Worth Telling",
            summaryAlliance = "Loremaster Dibbs calls what you brought back a discovery of historical proportions, and has written to the Explorers' League in Ironforge to say so. Someone has to carry the letter. He also has a friend in Dalaran who would love to see one of those fetishes.",
            summaryHorde = "The Darkspear keep their history by telling it. Kin'weelay at Grom'gol wants your etchings taken to Master Gadrin in Sen'jin Village, one of the wisest of the Darkspear, who will want to hear this tale.",
            recapAlliance = "Dibbs called it a discovery of historical proportions and wrote to his colleague at the Explorers' League straight away. I carried the letter to Historian Karnik in Ironforge, with a copy of Dibbs's translations of the tablets. A whole drowned city's worth of legend, in my pack.\n\nI'd gone to Stranglethorn to help a few rebels with their colonel. I came back with the archeological discovery of the century. That's the thing about discoveries of historical proportions: somebody still has to walk them to Ironforge.",
            recapHorde = "The Darkspear keep their history by telling it, Kin'weelay explained: legends passed down to the younglings, lessons and cautionary tales. So the etchings went to Master Gadrin in Sen'jin Village, their spiritual leader, to hear the truth of it. Kin'weelay even made me a copy of my own, and offered another if I ever lost it. For a small fee.\n\nSo the tale of I'lalai goes into the telling now, around the fire in Durotar. Somewhere a youngling is going to hear it and want to go diving. I know the feeling.",
            quests = {
                { id = 95799, name = "Findings for the Explorer's League", npc = "Loremaster Dibbs", faction = "Alliance", gameVersions = { forever = true } },
                { id = 95798, name = "The Web of Magic", npc = "Loremaster Dibbs", faction = "Alliance", optional = true, parallel = true, gameVersions = { forever = true }, recap = "Dibbs also had a friend in Dalaran, Abra Cadabra, who studies troll magic and would want a look at one of the fetishes. The Kirin Tor are particular about who they let in. They let me in. Abra got the fetish, and I got to say I'd delivered a troll fetish to someone called Abra Cadabra, which I still enjoy." },
                { id = 96078, name = "A Tale Spun Around the Fire", npc = "Kin'weelay", faction = "Horde", gameVersions = { forever = true } },
            },
        },
    },
}

local addonName, SM = ...

-- =============================================================================
-- WoW Forever: The Smuggler's Lessons
-- Friz Frazzlespark of Powderfuse Port takes on a new lackey: Eastsea pirates,
-- a debtor in Steamwheedle Port and a heist outside Booty Bay. The Horde
-- arrive through Kreza Darkthorn at Rog'mar, the Alliance through Watcher
-- Terral of Farholde; both chains lead into Smuggler's Paradise.
-- Quest IDs, order and text: /sm scan and the client's enUS quest cache
-- (build 1.60.1.70959). Smuggler's Bargain leads on to Shipping and Handling;
-- I Know a Guy follows the same pirate business, so it comes after it here.
-- Only Friz and Kreza have known coordinates (from Twilight in the
-- Riverglades); the other quests carry the place as text, from the quests.
-- =============================================================================

SM.ForeverFrizsLessonsData = {
    title = "The Smuggler's Lessons",
    description = "Friz Frazzlespark runs a lot of business through Powderfuse Port, and very little of it is the kind you'd write down. Friz is always looking for a new lackey, and you look like you do what you're told.\n\nLesson one: never backstab a backstabber. The rest of the lessons take you from the Eastwind Shore to Tanaris and Booty Bay.",
    zone = "Riverglades / Tanaris / Stranglethorn Vale",
    expansion = "Classic",
    recommendedLevel = { min = 38, max = 43 },
    requiredLevel = 36,
    gameVersions = { forever = true },
    achievements = {},
    color = { 0.78, 0.62, 0.18 },
    icon = "Interface\\Icons\\INV_Misc_Bag_10",
    adventureCoverTexture = 7963780,  -- Krol'dok Stronghold's loading screen, in the Riverglades
    adventureCoverTexCoords = { 0, 1, 0.1592, 0.8408 },  -- the picture, between its transparent bands
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 93788, name = "Borrowed Blades", npc = "Kreza Darkthorn", location = "Rog'mar, Riverglades", faction = "Horde" },
    startMapID = 2548,
    startX = 0.7720,
    startY = 0.5280,

    npcLocations = {
        ["Friz Frazzlespark"] = { mapID = 2548, x = 0.7720, y = 0.5280, location = "Powderfuse Port, Riverglades" },
        ["Kreza Darkthorn"] = { mapID = 2548, x = 0.5980, y = 0.4600, location = "Rog'mar, Riverglades" },
    },

    npcDisplayIDs = {
        -- From Twilight in the Riverglades (Wowhead's WoW Forever data).
        ["Friz Frazzlespark"] = 139287,
        ["Kreza Darkthorn"] = 139731,
    },

    chapters = {
        {
            chapter = "An Introduction",
            summaryHorde = "Kreza Darkthorn at Rog'mar would rather take the humans' blades than gather resources among enemies. Some of what Kreza forges from them is meant for an acquaintance at the docks east of Rog'mar, a goblin well connected all across the Kingdoms.",
            summaryAlliance = "Farholde prides itself on its independence, but some things it can only get through trade. Watcher Terral has an arrangement with a dealer at Powderfuse Port, and right now she's in the market for lion fur.",
            recapHorde = "Kreza Darkthorn had an idea about resources: why gather them among enemies when the enemies' own blades will do? I took the axes off the woodworkers at Turner's Logging Camp, and Kreza and Gur'dok turned them into weapons.\n\nOne blade was meant for an acquaintance at the docks. Friend, Kreza said, might be too strong a word. I was to say who sent me, and that they were even.\n\nThe acquaintance was Friz Frazzlespark of Powderfuse Port. Friz took the blade, looked me up and down, and offered me a job.",
            recapAlliance = "Watcher Terral of Farholde explained it plainly. The keep prides itself on its independence, but there are a few things it can only get through trade. Farholde supplied a dealer at Powderfuse Port with goods that are dangerous to get, and she supplied them with specialty munitions.\n\nThis time the dealer wanted lion hides, from the pride on the big hill in the middle of the plains. I brought back eight, and took the bundle to Friz Frazzlespark at the port. From Cornelius, I was to say. Friz would know what they were for.\n\nFriz did. Friz also looked me up and down and offered me a job.",
            quests = {
                { id = 93788, name = "Borrowed Blades", npc = "Kreza Darkthorn", faction = "Horde", gameVersions = { forever = true } },
                { id = 93976, name = "The Goblin Trader", npc = "Kreza Darkthorn", faction = "Horde", gameVersions = { forever = true } },
                { id = 94925, name = "A Fur Trade", npc = "Watcher Terral", location = "Farholde Keep, Riverglades", faction = "Alliance", gameVersions = { forever = true } },
                { id = 94928, name = "A Few Furs for Friz", npc = "Watcher Terral", location = "Farholde Keep, Riverglades", faction = "Alliance", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Never Backstab a Backstabber",
            summary = "Friz likes a lackey who does what they're told. The Eastsea pirates made off with a shipment of Friz's stolen goods, which is bad sportsmanship: Friz stole them first. Time for lesson one.",
            recap = "Lesson one: never backstab a backstabber. The Eastsea pirates had taken a shipment of Friz's stolen goods, and Friz had stolen them first. I took them back, with force, as recommended.\n\nLesson two: we're civilized people. Captain Bentcoin, it seemed, was trying to start a trade war, so Friz made the captain a crate, a special one, as a reward for his shrewd negotiating tactics. I delivered it to his ship on the Eastwind Shore.\n\nI didn't ask what was in it. When I came back, there was a new captain in charge, who foresaw a profitable relationship with Friz. Friz, it turns out, knows how to get a point across.",
            quests = {
                { id = 95288, name = "Smuggler's Paradise", npc = "Friz Frazzlespark", gameVersions = { forever = true } },
                { id = 95293, name = "Smuggler's Special", npc = "Friz Frazzlespark", gameVersions = { forever = true } },
                { id = 95294, name = "Smuggler's Bargain", npc = "Captain Bentcoin", location = "his ship, Eastwind Shore, Riverglades", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Shipping and Handling",
            summary = "Next lesson: getting a goblin to pay his dues is much harder than roughing up the local riffraff. Friz has a crate for an associate in Steamwheedle Port, and somebody there owes Friz money.",
            recap = "Friz handed me a crate and put me on a ship to Steamwheedle Port. Getting through customs took a coin for Wharfmaster Steamfizzle, who suddenly remembered that Tazzik, on the dock, was interested in that sort of thing.\n\nTazzik was also the one who owed Friz money. Tazzik had bet it all on a fighter called Slugjaw in Fizbuz Mithril's arena in Gadgetzan, and won big, Tazzik said. Would I mind collecting the winnings?\n\nFizbuz laughed. Slugjaw hadn't lasted two minutes. And while I stood there, Tazzik was probably trying to hop the next ship out.\n\nI got back in time. Tazzik had nothing left but the shirt off his back. So I took the shirt to Friz.",
            quests = {
                { id = 95296, name = "Shipping and Handling", npc = "Friz Frazzlespark", gameVersions = { forever = true } },
                { id = 95383, name = "Shipping and Handling", npc = "Wharfmaster Steamfizzle", location = "Steamwheedle Port, Tanaris", gameVersions = { forever = true } },
                { id = 95312, name = "Coming to Collect", npc = "Tazzik", location = "Steamwheedle Port, Tanaris", gameVersions = { forever = true } },
                { id = 95321, name = "Tazzik's Dues", npc = "Fizbuz Mithril", location = "Gadgetzan, Tanaris", gameVersions = { forever = true } },
                { id = 95472, name = "Consolation Prize", npc = "Tazzik", location = "Steamwheedle Port, Tanaris", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Free Booty",
            summary = "What some call a pirate, Friz calls a freebooter, and there's no better place for free booty than Booty Bay. Friz's contact there, Ruzzgot, gets goods from the local freebooters. Go and find out what's held up the latest shipment.",
            recap = "You can't spell freebooter without free booty, Friz explained, and there's no better place for free booty than Booty Bay. Friz's contact there, Ruzzgot, bought goods from the Bloodsail Buccaneers, good friends of Ruzzgot's, who had left the latest shipment in a chest on a hill outside town.\n\nThe chest was there. The shipment wasn't.\n\nThis wasn't about money anymore, Ruzzgot said. It was about justice. And maybe a little about the money. The trail led to a Venture Co. camp by Lake Nezferiti, where a ledger named the agent holding Ruzzgot's goods. I took them back.\n\nThe Venture Co. got their comeuppance, Friz got the loot, and Ruzzgot called it a pretty smooth transaction.",
            quests = {
                { id = 95295, name = "I Know a Guy", npc = "Friz Frazzlespark", gameVersions = { forever = true } },
                { id = 95322, name = "Get the Goods", npc = "Ruzzgot", location = "Booty Bay, Stranglethorn Vale", gameVersions = { forever = true } },
                { id = 95325, name = "We've Been Robbed!", npc = "Ruzzgot", location = "the hill outside Booty Bay, Stranglethorn Vale", gameVersions = { forever = true } },
                { id = 95326, name = "The Big Payback", location = "the Venture Co. camp by Lake Nezferiti, Stranglethorn Vale", gameVersions = { forever = true } },
                { id = 95327, name = "All's Well That Ends Well", npc = "Ruzzgot", location = "Booty Bay, Stranglethorn Vale", gameVersions = { forever = true } },
            },
        },
    },
}

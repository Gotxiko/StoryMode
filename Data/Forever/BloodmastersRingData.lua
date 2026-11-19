local addonName, SM = ...

-- =============================================================================
-- WoW Forever: The Bloodmaster's Ring
-- After Land of Giants (Twilight in the Riverglades), Clugfist sends you into
-- Bolder'ok's fighting pit, run by the goblin Jezap Jinglesprocket, all the
-- way up to the Bloodmaster, Chub'chob.
-- Quest IDs, order and text: /sm scan and the client's enUS quest cache
-- (build 1.60.1.70959). NPC IDs: Wowhead Forever (Jezap 257062, Gobam 257058).
-- Faction is inferred: Bolder'ok is only reached through the Horde chapter
-- Land of Giants, and the first quest picks up where it ends.
-- =============================================================================

SM.ForeverBloodmastersRingData = {
    title = "The Bloodmaster's Ring",
    description = "The ogres of Bolder'ok respect one thing: whoever hits hardest. Smashing a few Twilight weaklings for Clugfist got you through the gate. It didn't get you respect.\n\nFor that there's the Bloodmaster's Ring, a fighting pit run by a fast-talking goblin and ruled by the Bloodmaster, Chub'chob. Pay the fee, step into the pit, and keep winning until there's no one left to fight.",
    zone = "Riverglades",
    expansion = "Classic",
    recommendedLevel = { min = 41, max = 45 },
    requiredLevel = 36,
    faction = "Horde",
    gameVersions = { forever = true },
    achievements = {},
    color = { 0.62, 0.20, 0.16 },
    icon = "Interface\\Icons\\Ability_DualWield",
    adventureCoverTexture = 7963780,  -- Krol'dok Stronghold's loading screen, in the Riverglades
    adventureCoverTexCoords = { 0, 1, 0.1592, 0.8408 },  -- the picture, between its transparent bands
    adventureCoverIsLoadingScreen = true,

    startQuest = { id = 94668, name = "Bloodmaster's Ring", npc = "Clugfist", location = "Bolder'ok, Riverglades", faction = "Horde" },
    startMapID = 2548,
    startX = 0.6440,
    startY = 0.1480,

    -- Jezap and Gobam have no coordinates on Wowhead yet, so their quests carry
    -- the place as text (from the quests themselves) instead.
    npcLocations = {
        ["Clugfist"] = { mapID = 2548, x = 0.6440, y = 0.1480, location = "Bolder'ok, Riverglades" },
    },

    npcDisplayIDs = {
        ["Clugfist"] = 11565,
    },

    chapters = {
        {
            chapter = "Pay to Play",
            summary = "Clugfist allowed that the Horde might be stronger than expected. Allowing isn't respecting. If you want Bolder'ok's respect, Clugfist has a place for you to earn it: the Bloodmaster's Ring, and the little goblin who runs it.",
            recap = "Clugfist wasn't done with me. Smashing Twilight weaklings, it turned out, proved only that I could smash weaklings. Tomorrow, Clugfist said, maybe we meet again, if you still breathing. Ogres don't do encouragement.\n\nSo I went to the Bloodmaster's Ring and met Jezap Jinglesprocket, the goblin who runs it. Before I could fight, I had to pay a deposit. For my safety. Jezap didn't make the rules, Jezap said, but it would be a real shame if Clugfist heard I wasn't keen on proving myself.\n\nI paid. I've been robbed with less charm.",
            quests = {
                { id = 94668, name = "Bloodmaster's Ring", npc = "Clugfist", faction = "Horde", gameVersions = { forever = true } },
                { id = 94669, name = "Pay to Play", npc = "Jezap Jinglesprocket", location = "the Bloodmaster's Ring, Bolder'ok, Riverglades", faction = "Horde", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "Fame Awaits",
            summary = "The deposit is paid, the crowd is waiting, and Jezap has a lineup. It starts easy, Jezap promises. It doesn't stay easy.",
            recap = "Jezap started me off easy, or so Jezap said. First came Buzzbeak, a flighty thing that meant to take me down and pick me clean. It didn't.\n\nThen Kronk, an old acquaintance of Jezap's. Not the brightest, but very good at pummeling anything in his path. I made sure I wasn't in his path.\n\nAfter that Jezap promised me a fight I wouldn't soon forget, and a surprise. That was Bonegnaw. And after Bonegnaw, to keep the crowd excited, Mog'thar, who was no joke at all.\n\nFour fights, four wins. Jezap looked almost disappointed to see me still standing.",
            quests = {
                { id = 94670, name = "Bloodmaster's Ring", npc = "Jezap Jinglesprocket", location = "the Bloodmaster's Ring, Bolder'ok, Riverglades", faction = "Horde", gameVersions = { forever = true } },
                { id = 94739, name = "Bloodmaster's Ring", npc = "Jezap Jinglesprocket", location = "the Bloodmaster's Ring, Bolder'ok, Riverglades", faction = "Horde", gameVersions = { forever = true } },
                { id = 94962, name = "Bloodmaster's Ring", npc = "Jezap Jinglesprocket", location = "the Bloodmaster's Ring, Bolder'ok, Riverglades", faction = "Horde", gameVersions = { forever = true } },
                { id = 94964, name = "Bloodmaster's Ring", npc = "Jezap Jinglesprocket", location = "the Bloodmaster's Ring, Bolder'ok, Riverglades", faction = "Horde", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "A Treat for Snufflesnout",
            summary = "You've won a few fights, and Jezap thinks you might have what it takes. Before the next match, though, Jezap needs a favor: food for Snufflesnout, the Bloodmaster's beloved pet boar. A shy ogre named Gobam knows just what she likes.",
            recap = "Between fights, Jezap had a chore for me. Chub'chob, the Bloodmaster, has a pet boar named Snufflesnout, and Jezap had promised to look after her. Jezap was busy. I was not, apparently.\n\nGobam, a shy ogre east of Clugfist's clubhouse, knew what Snufflesnout liked: sweetberries from a human farm near the ocean, and riverweed. I picked, Gobam cooked, and the result was a bundle of something Snufflesnout would snort over happily.\n\nGobam had one more message for Jezap: please stop talk so much. I passed it on. It didn't help.",
            quests = {
                { id = 94733, name = "Our Ogre Friend", npc = "Jezap Jinglesprocket", location = "the Bloodmaster's Ring, Bolder'ok, Riverglades", faction = "Horde", gameVersions = { forever = true } },
                { id = 94734, name = "A Boar's Delight", npc = "Gobam", location = "east of Clugfist's clubhouse, Bolder'ok, Riverglades", faction = "Horde", gameVersions = { forever = true } },
                { id = 94737, name = "A Treat for a Friend", npc = "Gobam", location = "east of Clugfist's clubhouse, Bolder'ok, Riverglades", faction = "Horde", gameVersions = { forever = true } },
            },
        },
        {
            chapter = "The Bloodmaster of Bolder'ok",
            summary = "Jezap will place the treat, and you'll step into the ring. What Jezap forgot to mention is how Snufflesnout behaves around her favorite food. After that, only one fighter is left: Chub'chob, the Bloodmaster.",
            recap = "The treat was never for feeding. Jezap set it down in the ring, and Snufflesnout came for it, and for me, very upset. Jezap had admitted to being nervous about harming the Bloodmaster's precious companion. Jezap was standing well outside the ring at the time.\n\nThat upset Chub'chob more than words can explain, which was the point. The Bloodmaster of Bolder'ok stepped into the ring in person. Jezap reminded me that my entry fee did not cover accidental death, wished me luck, and left me to it.\n\nI won. I walked out the new champion of the Bloodmaster's Ring and went to tell Clugfist.\n\nI'd say Clugfist was impressed. With ogres, it's hard to tell.",
            quests = {
                { id = 94965, name = "Bloodmaster's Ring", npc = "Jezap Jinglesprocket", location = "the Bloodmaster's Ring, Bolder'ok, Riverglades", faction = "Horde", gameVersions = { forever = true } },
                { id = 95063, name = "Bloodmaster's Ring", npc = "Jezap Jinglesprocket", location = "the Bloodmaster's Ring, Bolder'ok, Riverglades", faction = "Horde", gameVersions = { forever = true } },
            },
        },
    },
}

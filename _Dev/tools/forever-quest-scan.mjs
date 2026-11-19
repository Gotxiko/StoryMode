// WoW Forever quest scan (proof of concept).
//
//   node _Dev/tools/forever-quest-scan.mjs ids [root] [--build 1.60.1.70938]
//     Writes Data/Forever/ForeverQuestIDs.lua: every quest ID in Forever's
//     QuestV2 table (wago.tools), which /sm scan asks the server for.
//
//   node _Dev/tools/forever-quest-scan.mjs report [root] [--wdb path] [--saved path] [--offline]
//     Reads the Forever client's quest cache (Cache/WDB/<locale>/questcache.wdb),
//     plus StoryModeDB.foreverScan if /sm scan ran, and writes
//     _Dev/reports/forever-quest-scan.md and .json: per Classic story, which
//     quests Forever renamed or dropped, where Forever's chain leaves the
//     story's order, and new Forever quests in the same zones that name the
//     story's characters.
//
//   node _Dev/tools/forever-quest-scan.mjs text [root] [--objectives file.json] [--wowhead] [--locale xxXX]
//     Writes Data/Forever/ForeverQuestText.lua: the objective line of every
//     quest the Forever stories use, for the quest cards. The game empties
//     its quest cache now and then, so lines for quests the cache no longer
//     holds are kept from the file, or else taken from --objectives (a saved
//     scan, a JSON list of { id, objective }), or with --wowhead from
//     Wowhead's quest tooltips. With --locale (not enUS) it writes
//     Data/Forever/QuestText/<locale>.lua instead, for the quests the English
//     file has; Wowhead has every client language but Italian, so itIT comes
//     from --objectives alone. --refetch 123,456 reads those quests from Wowhead
//     again even when the file has them.
//
//   node _Dev/tools/forever-quest-scan.mjs levels [root]
//     Writes Data/Forever/ForeverStoryLevels.lua: each Forever story's level
//     range from its own quests, which the story cards show on Forever.
//
//   node _Dev/tools/forever-quest-scan.mjs models [root]
//     Writes Data/Forever/ForeverNPCDisplayIDs.lua: the model of every quest
//     giver the stories name, from the client's creature cache, for their
//     portraits on Forever. The cache only holds the NPCs this client has
//     met, so run it again after playing; models it no longer holds are kept.
//
//   node _Dev/tools/forever-quest-scan.mjs models [root] --cmangos ClassicDB.sql.gz
//     Adds to each story's npcDisplayIDs the model of every Classic quest
//     giver with none yet, from the cmangos Classic database (cmangos/classic-db
//     on GitHub, Full_DB): the creature that starts or ends that very quest.
//     Forever shows Classic NPCs with their Classic models.
//
//   node _Dev/tools/forever-quest-scan.mjs models [root] --wowhead [--displays models.json]
//     For the givers still without a model, finds their Wowhead Forever NPC
//     IDs and prints a script for a Wowhead page's browser console that reads
//     their models (Wowhead's NPC pages refuse scripts). Save what it copies as
//     a file and run again with --displays to add the models to the stories.
//
//   node _Dev/tools/forever-quest-scan.mjs check [root] --cmangos ClassicDB.sql.gz [--offline]
//     Checks every story quest against the cmangos Classic database and the
//     /sm scan's Forever titles: its name, who gives it, which faction, race
//     and class can take it, and whether what it needs first comes earlier
//     in the story. Writes _Dev/reports/forever-check.md and .json. cmangos is
//     sometimes wrong, so its findings are only leads: the command prints a
//     script that reads the flagged quests' Wowhead pages in a browser; run
//     again with --facts <saved file> to mark each confirmed or overruled.
//
//   node _Dev/tools/forever-quest-scan.mjs audit [root] [--offline]
//     Lists, per Forever story, the quests whose giver has no model, whose card
//     has no objective in each language, or whose ID Forever doesn't know.
//
// The quest cache only holds quests the client has asked the server about.
// Run /sm scan in game and log out first, or the report only covers the quests
// you have already seen.

import { mkdir, readFile, readdir, writeFile } from "node:fs/promises";
import path from "node:path";
import { parseDataFile } from "./story-data-utils.mjs";
import {
  WOWHEAD_LOCALES, addStoryModels, cmangosModel, loadCmangos, storyTables, wowheadFactsSnippet, wowheadModelSnippet, wowheadNpcs, wowheadObjective,
} from "./forever-lookups.mjs";

const args = process.argv.slice(2);
const command = args[0];
const VALUE_OPTIONS = new Set(["--wdb", "--saved", "--build", "--era-build", "--locale", "--objectives", "--cmangos", "--displays", "--refetch", "--facts"]);
const positional = args.slice(1).filter((arg, index, list) => !arg.startsWith("--") && !VALUE_OPTIONS.has(list[index - 1]));
const root = path.resolve(positional[0] || process.cwd());
const gameDir = path.resolve(root, "..", "..", "..");
const cacheDir = path.join(root, ".forever-scan-cache");
const reportDir = path.join(root, "_Dev", "reports");
const TOC = "StoryMode_Camelot.toc";

function option(name) {
  const index = args.indexOf(`--${name}`);
  return index >= 0 ? args[index + 1] : null;
}

async function exists(file) {
  try {
    await readFile(file);
    return true;
  } catch {
    return false;
  }
}

// ---------------------------------------------------------------------------
// wago.tools tables
// ---------------------------------------------------------------------------

async function fetchText(url) {
  const response = await fetch(url, { headers: { "User-Agent": "StoryMode-dev-tools" } });
  if (!response.ok) throw new Error(`${url}: HTTP ${response.status}`);
  return response.text();
}

async function latestBuilds() {
  const builds = JSON.parse(await fetchText("https://wago.tools/api/builds"));
  return {
    forever: option("build") || builds.wowf?.[0]?.version,
    classicEra: option("era-build") || builds.wow_classic_era?.[0]?.version,
  };
}

async function questIdsForBuild(build) {
  const file = path.join(cacheDir, `QuestV2-${build}.csv`);
  let csv;
  if (await exists(file)) {
    csv = await readFile(file, "utf8");
  } else {
    csv = await fetchText(`https://wago.tools/db2/QuestV2/csv?build=${build}`);
    await mkdir(cacheDir, { recursive: true });
    await writeFile(file, csv);
  }
  const ids = new Set();
  for (const line of csv.split(/\r?\n/).slice(1)) {
    const id = Number(line.split(",")[0]);
    if (id > 0) ids.add(id);
  }
  return ids;
}

async function cachedQuestIdSets() {
  let files = [];
  try {
    files = (await readdir(cacheDir)).filter((name) => name.startsWith("QuestV2-"));
  } catch {
    return null;
  }
  const forever = files.filter((name) => name.startsWith("QuestV2-1.6")).sort().pop();
  const era = files.filter((name) => name.startsWith("QuestV2-1.15")).sort().pop();
  if (!forever || !era) return null;
  return {
    forever: await questIdsForBuild(forever.slice(8, -4)),
    classicEra: await questIdsForBuild(era.slice(8, -4)),
  };
}

async function questIdSets() {
  if (args.includes("--offline")) return cachedQuestIdSets();
  try {
    const builds = await latestBuilds();
    return {
      builds,
      forever: await questIdsForBuild(builds.forever),
      classicEra: await questIdsForBuild(builds.classicEra),
    };
  } catch (error) {
    console.warn(`wago.tools unavailable (${error.message}); using cached tables if any.`);
    return cachedQuestIdSets();
  }
}

function toRanges(ids) {
  const sorted = [...ids].sort((a, b) => a - b);
  const parts = [];
  for (let i = 0; i < sorted.length; i++) {
    const first = sorted[i];
    while (i + 1 < sorted.length && sorted[i + 1] === sorted[i] + 1) i++;
    parts.push(first === sorted[i] ? `${first}` : `${first}-${sorted[i]}`);
  }
  return parts.join(",");
}

async function writeIdList() {
  const sets = await questIdSets();
  if (!sets?.builds) throw new Error("Could not read Forever's QuestV2 table from wago.tools.");
  const newIds = [...sets.forever].filter((id) => !sets.classicEra.has(id));
  const ranges = toRanges(sets.forever);
  const lines = [];
  for (let i = 0; i < ranges.length; i += 100) lines.push(ranges.slice(i, i + 100));
  const lua = [
    "local addonName, SM = ...",
    "",
    "-- AUTO-GENERATED by _Dev/tools/forever-quest-scan.mjs ids. Do not edit by hand.",
    `-- Every quest in WoW Forever ${sets.builds.forever}'s QuestV2 table (wago.tools), as ID ranges:`,
    `-- ${sets.forever.size} quests, ${newIds.length} of them not in Classic Era ${sets.builds.classicEra}.`,
    "-- /sm scan asks the server for each of them.",
    "",
    `SM.ForeverQuestIDs = table.concat({`,
    ...lines.map((line) => `    "${line}",`),
    "})",
    "",
  ].join("\n");
  const out = path.join(root, "Data", "Forever", "ForeverQuestIDs.lua");
  await mkdir(path.dirname(out), { recursive: true });
  await writeFile(out, lua);
  console.log(`Wrote ${path.relative(root, out)}: ${sets.forever.size} quests from Forever ${sets.builds.forever}, ${newIds.length} new since Classic Era.`);
}

// ---------------------------------------------------------------------------
// questcache.wdb
// ---------------------------------------------------------------------------

// Fixed fields at the start of each record, as far as the Forever 1.60 layout
// has been worked out: level, minimum level, zone (QuestSortID: an AreaTable
// ID, or negative for a class or profession sort) and the quest the game
// offers next in the chain.
const FIELD = { id: 0, type: 1, level: 2, minLevel: 4, sortID: 6, infoID: 7, nextQuest: 9 };
const STRING_BITS = [9, 12, 12, 9, 10, 8, 10, 8, 11];
const STRING_NAMES = ["title", "objectivesText", "description", "areaDescription", "giverText", "giverName", "turnInText", "turnInName", "completionLog"];

function readBits(buffer, byteOffset, widths) {
  const values = [];
  let bit = byteOffset * 8;
  for (const width of widths) {
    let value = 0;
    for (let i = 0; i < width; i++, bit++) {
      value = (value << 1) | ((buffer[bit >> 3] >> (7 - (bit & 7))) & 1);
    }
    values.push(value);
  }
  return values;
}

const utf8 = new TextDecoder("utf-8", { fatal: true });

function decodeText(bytes) {
  try {
    const text = utf8.decode(bytes);
    return /[\u0000-\u0008\u000b\u000c\u000e-\u001f]/.test(text) ? null : text;
  } catch {
    return null;
  }
}

// The strings sit at the end of the record, right after a 12-byte header of
// bit-packed lengths. Find the header whose lengths account for exactly the
// bytes that follow it.
function readRecordStrings(body) {
  for (let header = body.length - 12; header >= 0; header--) {
    const lengths = readBits(body, header, STRING_BITS);
    if (lengths[0] === 0) continue;
    const start = header + 12;
    const total = lengths.reduce((sum, length) => sum + length, 0);
    if (start + total !== body.length) continue;
    const strings = {};
    let offset = start;
    let valid = true;
    lengths.forEach((length, index) => {
      if (!valid) return;
      const text = decodeText(body.subarray(offset, offset + length));
      if (text === null) valid = false;
      strings[STRING_NAMES[index]] = text;
      offset += length;
    });
    if (valid && /^\p{L}|^\d|^["'(]/u.test(strings.title)) return strings;
  }
  return null;
}

async function readQuestCache(file) {
  const buffer = await readFile(file);
  if (buffer.toString("latin1", 0, 4) !== "TSQW") throw new Error(`${file} is not a quest cache`);
  const build = buffer.readUInt32LE(4);
  const locale = buffer.toString("latin1", 8, 12).split("").reverse().join("");
  const quests = new Map();
  let unreadable = 0;
  let retired = 0;
  let offset = 24;
  while (offset + 8 <= buffer.length) {
    const id = buffer.readUInt32LE(offset);
    const length = buffer.readUInt32LE(offset + 4);
    if (id === 0 && length === 0) break;
    const body = buffer.subarray(offset + 8, offset + 8 + length);
    offset += 8 + length;
    const field = (index) => body.readInt32LE(index * 4);
    const strings = readRecordStrings(body);
    if (!strings) unreadable++;
    // Blizzard marks retired quests "zzOLD …" or "[DEPRECATED] …"; they never show in game.
    if (strings && /^(zz|\[DEPRECATED\]|\[DNT\]|<UNUSED>)/i.test(strings.title)) {
      retired++;
      continue;
    }
    quests.set(id, {
      id,
      level: field(FIELD.level),
      minLevel: field(FIELD.minLevel),
      sortID: field(FIELD.sortID),
      nextQuest: field(FIELD.nextQuest) || null,
      ...(strings || {}),
    });
  }
  return { build, locale, quests, unreadable, retired };
}

// ---------------------------------------------------------------------------
// StoryModeDB.foreverScan
// ---------------------------------------------------------------------------

async function findSavedVariables() {
  if (option("saved")) return option("saved");
  const accountDir = path.join(gameDir, "WTF", "Account");
  let accounts = [];
  try {
    accounts = await readdir(accountDir, { withFileTypes: true });
  } catch {
    return null;
  }
  for (const account of accounts) {
    if (!account.isDirectory()) continue;
    const file = path.join(accountDir, account.name, "SavedVariables", "StoryMode.lua");
    if (await exists(file)) return file;
  }
  return null;
}

async function readScanTitles() {
  const file = await findSavedVariables();
  if (!file) return null;
  const text = await readFile(file, "utf8");
  const start = text.indexOf('["foreverScan"]');
  if (start < 0) return null;
  const titlesStart = text.indexOf('["titles"]', start);
  if (titlesStart < 0) return null;
  const titles = new Map();
  // WoW saves the start of the list as plain values (quest 1, 2, …, with nil
  // for gaps), then the rest as [id] = value.
  const entry = /(?:\[(\d+)\] = )?(false|nil|"((?:[^"\\]|\\.)*)"),/g;
  const open = text.indexOf("{", titlesStart);
  let depth = 0;
  for (let i = open; i < text.length; i++) {
    if (text[i] === "{") depth++;
    else if (text[i] === "}" && --depth === 0) {
      const block = text.slice(open + 1, i);
      let position = 0;
      for (const match of block.matchAll(entry)) {
        const id = match[1] ? Number(match[1]) : ++position;
        if (match[2] === "nil") continue;
        titles.set(id, match[2] === "false" ? false : match[3].replace(/\\"/g, '"').replace(/\\\\/g, "\\"));
      }
      break;
    }
  }
  const build = text.slice(start).match(/\["build"\] = "([^"]+)"/)?.[1] || null;
  return { file, build, titles };
}

// ---------------------------------------------------------------------------
// Stories
// ---------------------------------------------------------------------------

// Forever shows what Classic Era shows, unless gameVersions names forever.
function foreverIncludes(versions) {
  if (/\bforever\s*=\s*true/.test(versions)) return true;
  if (/\bforever\s*=\s*false/.test(versions)) return false;
  return /\bclassicEra\s*=\s*true/.test(versions);
}

// Drop the chapters and quests whose own gameVersions leave Forever out, as
// SM.IsContentAvailableForClient does in game.
function foreverLines(text, hidden = []) {
  const out = [];
  let inChapter = false;
  let chapterExcluded = false;
  let chapterHeader = false;
  for (const line of text.split(/\r?\n/)) {
    if (/\bchapter\s*=\s*"/.test(line)) {
      inChapter = true;
      chapterHeader = true;
      chapterExcluded = false;
    }
    if (inChapter && /\bquests\s*=\s*\{/.test(line)) chapterHeader = false;
    const versions = line.match(/gameVersions\s*=\s*\{([^}]*)\}/)?.[1];
    const isQuest = /\bid\s*=\s*\d+/.test(line);
    if (versions !== undefined && inChapter && chapterHeader && !isQuest) chapterExcluded = !foreverIncludes(versions);
    if (isQuest && inChapter && (chapterExcluded || (versions !== undefined && !foreverIncludes(versions)))) {
      hidden.push(line);
      continue;
    }
    out.push(line);
  }
  return out.join("\n");
}

function questIdsOf(line) {
  const ids = [];
  const id = line.match(/\bid\s*=\s*(\d+)/)?.[1];
  if (id) ids.push(Number(id));
  const alt = line.match(/\baltIds\s*=\s*\{([^}]*)\}/)?.[1];
  if (alt) ids.push(...[...alt.matchAll(/\d+/g)].map((match) => Number(match[0])));
  return ids;
}

async function loadForeverStories(hiddenQuests = []) {
  const toc = await readFile(path.join(root, TOC), "utf8");
  const files = toc.split(/\r?\n/)
    .map((line) => line.trim().replace(/\\/g, "/"))
    .filter((line) => /^Data\/(Storylines|ClassQuests)\/.*\.lua$/.test(line) || /^Data\/Forever\/\w+Data\.lua$/.test(line));
  const stories = [];
  for (const rel of files) {
    const text = await readFile(path.join(root, rel), "utf8");
    // A file may hold more than one dataset (SM.<key> = { … }).
    const blocks = text.split(/\n(?=SM\.\w+Data\s*=\s*\{)/).filter((block) => /^SM\.\w+Data\s*=/.test(block));
    for (const block of blocks.length ? blocks : [text]) {
      const hiddenLines = [];
      const story = parseDataFile(root, path.join(root, rel), foreverLines(block, hiddenLines));
      story.key = block.match(/^SM\.(\w+)\s*=/)?.[1] || null;
      const storyVersions = block.split(/\n\s*(?:startQuest|chapters|prereqs)\s*=/)[0].match(/gameVersions\s*=\s*\{([^}]*)\}/)?.[1];
      if (storyVersions !== undefined && !foreverIncludes(storyVersions)) {
        for (const quest of story.quests) hiddenQuests.push({ story: story.title, id: quest.id, name: quest.name, ids: questIdsOf(quest.line) });
        continue;
      }
      for (const line of hiddenLines) {
        const name = line.match(/\bname\s*=\s*"((?:[^"\\]|\\.)*)"/)?.[1];
        hiddenQuests.push({ story: story.title, id: questIdsOf(line)[0], name, ids: questIdsOf(line) });
      }
      // Lines with foreverId use that ID on Forever, as SM.ApplyClientQuestIDs does.
      for (const quest of story.quests) {
        quest.ids = questIdsOf(quest.line);
        const foreverId = quest.line.match(/\bforeverId\s*=\s*(\d+)/)?.[1];
        if (foreverId) {
          quest.classicId = quest.id;
          quest.id = Number(foreverId);
          quest.ids[0] = quest.id;
        }
      }
      const seen = new Set();
      story.quests = story.quests.filter((quest) => !seen.has(quest.id) && seen.add(quest.id));
      stories.push(story);
    }
  }
  return stories;
}

function norm(value) {
  return (value || "").toLowerCase().replace(/[‘’]/g, "'").replace(/\s+/g, " ").trim();
}

function storyNames(story) {
  const names = new Set();
  for (const quest of story.quests) if (quest.npc && !/poster|wanted|sign|board/i.test(quest.npc)) names.add(quest.npc);
  for (const name of story.npcLocations.keys()) if (!/poster|wanted|sign|board/i.test(name)) names.add(name);
  return [...names].filter((name) => name.length >= 5);
}

function questText(quest) {
  return [quest.title, quest.objectivesText, quest.description, quest.completionLog].filter(Boolean).join(" ");
}

function nameMentions(text, names) {
  const lower = norm(text);
  return names.filter((name) => {
    const full = norm(name);
    if (lower.includes(full)) return true;
    // "Vanessa VanCleef" is often just "VanCleef" in quest text.
    const last = full.split(" ").pop();
    return last.length >= 6 && full.includes(" ") && new RegExp(`\\b${last.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}\\b`).test(lower);
  });
}

// ---------------------------------------------------------------------------
// Report
// ---------------------------------------------------------------------------

function label(id, quests, newIds) {
  const quest = quests.get(id);
  const title = quest?.title ? `"${quest.title}"` : "(not in cache)";
  const tag = newIds?.has(id) ? " **new in Forever**" : "";
  return `${id} ${title}${tag}`;
}

function analyzeStory(story, context) {
  const { quests, titles, sets, newIds, previousOf } = context;
  const storyIds = new Set(story.quests.flatMap((quest) => quest.ids || [quest.id]));
  const findings = { renamed: [], missing: [], unconfirmed: [], notCached: [], chain: [], nearby: [] };

  for (const quest of story.quests) {
    // A line with altIds is there on Forever if any of its quests is.
    const presentId = (quest.ids || [quest.id]).find((id) => quests.has(id) || titles?.get(id)) ?? quest.id;
    const cached = quests.get(presentId);
    const scanned = titles?.get(presentId);
    if (scanned === false && !cached) {
      findings.missing.push({ id: quest.id, name: quest.name });
      continue;
    }
    // QuestV2 isn't a full quest list (Classic Era's lacks quests too), so
    // only /sm scan can say a quest is gone.
    if (sets && !sets.forever.has(quest.id) && !cached && scanned === undefined) {
      findings.unconfirmed.push({ id: quest.id, name: quest.name });
    }
    const title = cached?.title || scanned;
    if (!title) {
      findings.notCached.push(quest.id);
      continue;
    }
    // Story data numbers repeated titles ("The Tower of Althalaxx part 7").
    const bare = (value) => norm(value).replace(/\s+\(?part \d+\)?$/, "");
    if (quest.name && bare(title) !== bare(quest.name) && bare(title) !== bare(quest.displayName)) {
      findings.renamed.push({ id: quest.id, data: quest.name, forever: title });
    }
  }

  // Forever's chain: follow each story quest's follow-up through quests the
  // story doesn't list, until it reaches the story again or ends.
  const seenDetours = new Set();
  for (const quest of story.quests) {
    const detour = [];
    let next = quests.get(quest.id)?.nextQuest;
    while (next && !storyIds.has(next) && !detour.includes(next) && detour.length < 8) {
      detour.push(next);
      next = quests.get(next)?.nextQuest;
    }
    if (!detour.length) continue;
    const key = `${quest.id}:${detour.join(",")}`;
    if (seenDetours.has(key)) continue;
    seenDetours.add(key);
    findings.chain.push({
      after: quest.id,
      afterName: quest.name,
      quests: detour,
      rejoins: next && storyIds.has(next) ? next : null,
    });
  }
  for (const quest of story.quests) {
    for (const previous of previousOf.get(quest.id) || []) {
      if (storyIds.has(previous)) continue;
      if (findings.chain.some((entry) => entry.quests.includes(previous))) continue;
      findings.chain.push({ before: quest.id, beforeName: quest.name, quests: [previous] });
    }
  }
  // A link through a quest Forever added is a Forever change; any other
  // link the story skips was already there on Classic.
  for (const entry of findings.chain) entry.addedByForever = Boolean(newIds && entry.quests.some((id) => newIds.has(id)));
  findings.chain.sort((a, b) => Number(b.addedByForever) - Number(a.addedByForever));

  // Forever often gives a reworked quest a new ID with the old title.
  const byTitle = context.byTitle;
  for (const entry of [...findings.missing, ...findings.unconfirmed]) {
    entry.sameTitle = (byTitle.get(norm(entry.name)) || []).filter((id) => !storyIds.has(id));
  }

  // New quests in the story's zones that name its characters.
  const zones = new Set(story.quests.map((quest) => quests.get(quest.id)?.sortID).filter((id) => id > 0));
  const names = storyNames(story);
  const chained = new Set(findings.chain.flatMap((entry) => entry.quests));
  for (const quest of quests.values()) {
    if (storyIds.has(quest.id) || chained.has(quest.id)) continue;
    if (newIds && !newIds.has(quest.id)) continue;
    if (!zones.has(quest.sortID)) continue;
    const mentions = nameMentions(questText(quest), names);
    if (mentions.length) findings.nearby.push({ id: quest.id, mentions });
  }
  findings.nearby.sort((a, b) => b.mentions.length - a.mentions.length || a.id - b.id);
  findings.zones = [...zones];
  return findings;
}

// QuestSortIDs the game files class quests under.
const CLASS_SORTS = { [-81]: "WARRIOR", [-82]: "SHAMAN", [-141]: "PALADIN", [-161]: "MAGE", [-162]: "ROGUE", [-261]: "HUNTER", [-262]: "PRIEST", [-263]: "DRUID", [-61]: "WARLOCK" };

// Class quests no story uses, as chains, per class. The "nearby" check above
// only looks at zones, and class quests sit under a class sort instead. Many
// of them (Aeonas, The Mysterious Merchant) came from Season of Discovery, so
// Classic Era's quest table has their IDs too and they don't count as new.
function analyzeClassQuests(stories, context) {
  const { quests, newIds, previousOf } = context;
  const used = new Map();
  for (const story of stories) for (const quest of story.quests) for (const id of [quest.id, quest.classicId, ...(quest.ids || [])]) if (id) used.set(id, story.title);
  const classStories = new Map();
  for (const story of stories) for (const cls of [story.class].flat().filter(Boolean)) {
    if (!classStories.has(cls)) classStories.set(cls, []);
    classStories.get(cls).push(story.title);
  }
  const byClass = new Map();
  for (const quest of quests.values()) {
    const cls = CLASS_SORTS[quest.sortID];
    if (!cls || used.has(quest.id) || !quest.title || /^UNUSED$/i.test(quest.title)) continue;
    if (!byClass.has(cls)) byClass.set(cls, new Set());
    byClass.get(cls).add(quest.id);
  }
  const result = [];
  for (const cls of Object.values(CLASS_SORTS)) {
    const ids = byClass.get(cls);
    if (!ids?.size) continue;
    // A chain starts at a quest nothing else in the set leads into.
    const chains = [];
    const placed = new Set();
    const starts = [...ids].filter((id) => !(previousOf.get(id) || []).some((prev) => ids.has(prev))).sort((a, b) => a - b);
    for (const start of [...starts, ...[...ids].sort((a, b) => a - b)]) {
      if (placed.has(start)) continue;
      const chain = [];
      for (let id = start; id && ids.has(id) && !placed.has(id); id = quests.get(id)?.nextQuest) {
        placed.add(id);
        chain.push(id);
      }
      const last = quests.get(chain[chain.length - 1]);
      const from = (previousOf.get(chain[0]) || []).filter((prev) => used.has(prev));
      chains.push({
        quests: chain,
        levels: chain.map((id) => quests.get(id).level),
        newInForever: newIds ? chain.some((id) => newIds.has(id)) : null,
        after: from.map((id) => ({ id, story: used.get(id) })),
        leadsInto: last?.nextQuest && used.has(last.nextQuest) ? { id: last.nextQuest, story: used.get(last.nextQuest) } : null,
      });
    }
    chains.sort((a, b) => Math.min(...a.levels) - Math.min(...b.levels) || a.quests[0] - b.quests[0]);
    result.push({ class: cls, stories: classStories.get(cls) || [], quests: ids.size, chains });
  }
  return result;
}

function renderClassQuests(classes, context) {
  const { quests, newIds } = context;
  if (!classes.length) return "";
  const lines = ["", "## Class quests no story uses", "", "Quests the game files under a class that no story lists, as Forever chains them. Only chains added after Classic 1.12 are listed: Season of Discovery quests Forever kept (IDs from 10000 up), and quests marked new because Classic Era's quest table lacks them. The original Classic quests the stories skip are counted, and listed in the JSON report."];
  for (const entry of classes) {
    const cls = entry.class[0] + entry.class.slice(1).toLowerCase();
    const later = entry.chains.filter((chain) => chain.newInForever || chain.quests.some((id) => id >= 10000));
    const original = entry.chains.length - later.length;
    lines.push("", `### ${cls} (${entry.quests} quests${entry.stories.length ? `; class story: ${entry.stories.join(", ")}` : ""})`, "");
    if (!later.length) lines.push("- Nothing added after Classic.");
    for (const chain of later) {
      const low = Math.min(...chain.levels), high = Math.max(...chain.levels);
      const list = chain.quests.map((id) => label(id, quests, newIds)).join(" → ");
      const notes = [
        ...chain.after.map((from) => `follows ${from.id} in ${from.story}`),
        chain.leadsInto ? `leads into ${chain.leadsInto.id} in ${chain.leadsInto.story}` : null,
      ].filter(Boolean);
      lines.push(`- Level ${low === high ? low : `${low}-${high}`}: ${list}` + (notes.length ? ` (${notes.join("; ")})` : ""));
    }
    if (original) lines.push(`- Plus ${original} original Classic chain${original === 1 ? "" : "s"} no story uses.`);
  }
  return lines.join("\n") + "\n";
}

function sameTitleNote(entry) {
  if (!entry.sameTitle?.length) return "";
  const ids = entry.sameTitle.slice(0, 20).join(", ") + (entry.sameTitle.length > 20 ? ", …" : "");
  return `; Forever has the same title as ${ids}`;
}

function renderReport(stories, results, context, meta) {
  const { quests, newIds } = context;
  const lines = [
    "# WoW Forever quest scan",
    "",
    `Quest cache: ${meta.cacheFile} (build ${meta.cacheBuild}, ${meta.cacheLocale}), ${quests.size} quests` + (meta.unreadable ? `, ${meta.unreadable} with unreadable text` : "") + (meta.retired ? `, ${meta.retired} retired (zzOLD) quests left out` : "") + ".",
    "Missing means the server refused the quest during /sm scan. That's also how it answers for content that isn't out yet, such as Ahn'Qiraj.",
    meta.scan ? `/sm scan: build ${meta.scan.build}, ${meta.scan.titles.size} quests.` : "/sm scan: not run yet. The quest cache only holds quests this client has seen, so most chains below are incomplete.",
    meta.sets ? `Forever has ${meta.sets.forever.size} quests, ${newIds.size} of them new since Classic Era.` : "Forever's quest table: not loaded (offline).",
    "",
    `Story quests in the cache: ${meta.storyCached} of ${meta.storyTotal}.`,
    "",
    "| Story | Quests | Cached | Renamed | Missing | Forever chain changes | Skipped links | New quests nearby |",
    "|---|---:|---:|---:|---:|---:|---:|---:|",
  ];
  stories.forEach((story, index) => {
    const result = results[index];
    const forever = result.chain.filter((entry) => entry.addedByForever).length;
    const cached = story.quests.filter((quest) => quests.has(quest.id)).length;
    lines.push(`| ${story.title} | ${story.quests.length} | ${cached} | ${result.renamed.length} | ${result.missing.length} | ${forever} | ${result.chain.length - forever} | ${result.nearby.length} |`);
  });

  stories.forEach((story, index) => {
    const result = results[index];
    if (!result.renamed.length && !result.missing.length && !result.unconfirmed.length && !result.chain.length && !result.nearby.length) return;
    lines.push("", `## ${story.title}`, "", `${story.rel}${story.faction ? `, ${story.faction}` : ""}. ${result.notCached.length + result.missing.length ? `${result.notCached.length + result.missing.length} of its quests aren't in the cache.` : "Every quest is in the cache."}`);
    if (result.missing.length) {
      lines.push("", "Missing on Forever (the server didn't know them during /sm scan):");
      for (const entry of result.missing) lines.push(`- ${entry.id} "${entry.name}"` + sameTitleNote(entry));
    }
    if (result.unconfirmed.length) {
      lines.push("", "Not in Forever's QuestV2 table, so /sm scan should check them:");
      for (const entry of result.unconfirmed) lines.push(`- ${entry.id} "${entry.name}"` + sameTitleNote(entry));
    }
    if (result.renamed.length) {
      lines.push("", "Different title on Forever:");
      for (const entry of result.renamed) lines.push(`- ${entry.id} "${entry.data}" is "${entry.forever}"`);
    }
    for (const [heading, entries] of [
      ["Forever added quests to the chain:", result.chain.filter((entry) => entry.addedByForever)],
      ["Chain links the story skips (not new in Forever, so probably on Classic too):", result.chain.filter((entry) => !entry.addedByForever)],
    ]) {
      if (!entries.length) continue;
      lines.push("", heading);
      for (const entry of entries) {
        const list = entry.quests.map((id) => label(id, quests, newIds)).join(", then ");
        if (entry.after) {
          lines.push(`- After ${entry.after} "${entry.afterName}", Forever offers ${list}` + (entry.rejoins ? `, which leads back to ${entry.rejoins}.` : "."));
        } else {
          lines.push(`- ${list} leads into ${entry.before} "${entry.beforeName}".`);
        }
      }
    }
    if (result.nearby.length) {
      lines.push("", "New Forever quests in the same zones that name the story's characters:");
      for (const entry of result.nearby.slice(0, 12)) {
        const quest = quests.get(entry.id);
        lines.push(`- ${label(entry.id, quests, null)}, level ${quest.level}: names ${entry.mentions.join(", ")}`);
      }
      if (result.nearby.length > 12) lines.push(`- …and ${result.nearby.length - 12} more in the JSON report.`);
    }
  });

  return lines.join("\n") + "\n";
}

async function writeReport() {
  const locale = option("locale") || "enUS";
  const cacheFile = option("wdb") || path.join(gameDir, "Cache", "WDB", locale, "questcache.wdb");
  const cache = await readQuestCache(cacheFile);
  const scan = await readScanTitles();
  const sets = await questIdSets();
  const newIds = sets ? new Set([...sets.forever].filter((id) => !sets.classicEra.has(id))) : null;
  const hiddenQuests = [];
  const stories = await loadForeverStories(hiddenQuests);
  const hiddenAnswered = hiddenQuests.filter((quest) => quest.ids.some((id) => cache.quests.has(id) || scan?.titles.get(id)));

  const previousOf = new Map();
  for (const quest of cache.quests.values()) {
    if (!quest.nextQuest) continue;
    if (!previousOf.has(quest.nextQuest)) previousOf.set(quest.nextQuest, []);
    previousOf.get(quest.nextQuest).push(quest.id);
  }

  const byTitle = new Map();
  for (const quest of cache.quests.values()) {
    if (!quest.title) continue;
    const key = norm(quest.title);
    if (!byTitle.has(key)) byTitle.set(key, []);
    byTitle.get(key).push(quest.id);
  }

  const context = { quests: cache.quests, titles: scan?.titles, sets, newIds, previousOf, byTitle };
  const results = stories.map((story) => analyzeStory(story, context));
  const storyTotal = stories.reduce((sum, story) => sum + story.quests.length, 0);
  const storyCached = stories.reduce((sum, story) => sum + story.quests.filter((quest) => cache.quests.has(quest.id)).length, 0);
  const meta = {
    cacheFile: path.relative(root, cacheFile),
    cacheBuild: cache.build,
    cacheLocale: cache.locale,
    unreadable: cache.unreadable,
    retired: cache.retired,
    scan,
    sets,
    storyTotal,
    storyCached,
  };

  await mkdir(reportDir, { recursive: true });
  const classQuests = analyzeClassQuests(stories, context);
  let markdown = renderReport(stories, results, context, meta);
  markdown += renderClassQuests(classQuests, context);
  if (hiddenAnswered.length) {
    markdown += "\n## Hidden on Forever, but the server answered\n\nThese lines have `forever = false` (or sit in a story or chapter that does), yet the server sent their quest. Check whether they can come back.\n\n";
    markdown += hiddenAnswered.map((quest) => `- ${quest.story}: ${quest.id} "${quest.name}"`).join("\n") + "\n";
  }
  await writeFile(path.join(reportDir, "forever-quest-scan.md"), markdown);
  await writeFile(path.join(reportDir, "forever-quest-scan.json"), JSON.stringify({
    cache: { file: meta.cacheFile, build: cache.build, locale: cache.locale, quests: cache.quests.size },
    scan: scan ? { build: scan.build, quests: scan.titles.size } : null,
    stories: stories.map((story, index) => ({ title: story.title, file: story.rel, ...results[index] })),
    hidden: hiddenQuests.map((quest) => ({ ...quest, answered: hiddenAnswered.includes(quest) })),
    classQuests,
  }, null, 2));

  const changed = results.filter((result) => result.renamed.length || result.missing.length || result.chain.some((entry) => entry.addedByForever) || result.nearby.length).length;
  console.log(`Read ${cache.quests.size} quests from ${meta.cacheFile} (build ${cache.build}).`);
  console.log(`Story quests in the cache: ${storyCached} of ${storyTotal}. Stories Forever changed so far: ${changed} of ${stories.length}.`);
  console.log(`Wrote _Dev/reports/forever-quest-scan.md and .json.`);
  if (!scan) console.log("Tip: run /sm scan in WoW Forever and log out, then run this again for every quest.");
}

// Print cached quests, and which quests lead into them, for writing story data.
async function printQuests() {
  const locale = option("locale") || "enUS";
  const cacheFile = option("wdb") || path.join(gameDir, "Cache", "WDB", locale, "questcache.wdb");
  const cache = await readQuestCache(cacheFile);
  const previousOf = new Map();
  for (const quest of cache.quests.values()) {
    if (quest.nextQuest) previousOf.set(quest.nextQuest, [...(previousOf.get(quest.nextQuest) || []), quest.id]);
  }
  const ids = args.slice(1).filter((arg) => /^\d+$/.test(arg)).map(Number);
  for (const id of ids) {
    const quest = cache.quests.get(id);
    if (!quest) {
      console.log(`${id}: not in the quest cache`);
      continue;
    }
    console.log(`${id} "${quest.title}" level ${quest.level} (min ${quest.minLevel}), zone ${quest.sortID}, next ${quest.nextQuest || "-"}, from ${(previousOf.get(id) || []).join(", ") || "-"}`);
    if (quest.objectivesText) console.log(`  Objectives: ${quest.objectivesText}`);
    if (quest.description) console.log(`  Text: ${quest.description.replace(/\$B/gi, " ")}`);
    if (quest.completionLog) console.log(`  Completion: ${quest.completionLog}`);
  }
}

// Data/Forever/ForeverQuestText.lua: the game's own objective line for every
// quest the Forever stories use, from the quest cache, for the Legacy-style
// quest cards, in every client language.
// Hand-in quests with no objective line in the game. Wowhead's tooltip shows
// the giver's words instead ("Well, here you are $N - the completed Skeleton
// Key…") or a placeholder, so --wowhead leaves them out.
const NO_OBJECTIVE = new Set([
  1714,  // Essence of the Exile: the cauldron's description
  1792,  // Whirlwind Weapon
  1793,  // The Tome of Valor
  5505, 5511,  // The Key to Scholomance
  78307, 78699,  // C's payments at the dead drop: "Log"
]);

function readTextFile(text) {
  const unescapeLua = (value) => value.replace(/\\(n|"|\\)/g, (_, c) => (c === "n" ? "\n" : c));
  const lines = new Map();
  for (const match of text.matchAll(/^\s*\[(\d+)\] = "((?:[^"\\]|\\.)*)",$/gm)) lines.set(Number(match[1]), unescapeLua(match[2]));
  return lines;
}

const questTextFile = (locale) => (locale === "enUS"
  ? path.join(root, "Data", "Forever", "ForeverQuestText.lua")
  : path.join(root, "Data", "Forever", "QuestText", `${locale}.lua`));

async function writeQuestText() {
  const locale = option("locale") || "enUS";
  const english = locale === "enUS";
  const cacheFile = option("wdb") || path.join(gameDir, "Cache", "WDB", locale, "questcache.wdb");
  const cache = (await exists(cacheFile)) ? await readQuestCache(cacheFile) : { quests: new Map(), locale, build: null };
  const stories = await loadForeverStories([]);
  const ids = new Set();
  for (const story of stories) {
    for (const quest of story.quests) for (const id of quest.ids || [quest.id]) ids.add(id);
  }
  const out = questTextFile(locale);
  // Another language only has the quests the English file has a line for.
  const englishLines = english ? null : readTextFile(await readFile(questTextFile("enUS"), "utf8"));
  const kept = (await exists(out)) ? readTextFile(await readFile(out, "utf8")) : new Map();
  const saved = new Map();
  if (option("objectives")) {
    const list = JSON.parse(await readFile(option("objectives"), "utf8"));
    for (const entry of Array.isArray(list) ? list : Object.values(list)) {
      if (entry && entry.id && entry.objective) saved.set(Number(entry.id), entry.objective);
    }
  }
  const useWowhead = args.includes("--wowhead");
  // Quests to read from Wowhead again even though the file has a line.
  const refetch = new Set((option("refetch") || "").split(",").filter(Boolean).map(Number));
  if (useWowhead && WOWHEAD_LOCALES[locale] === undefined) throw new Error(`Wowhead has no ${locale}; use --objectives`);
  const tokens = new Map();
  const lines = [];
  const from = { cache: 0, saved: 0, kept: 0, wowhead: 0 };
  const missing = [];
  for (const id of [...ids].sort((a, b) => a - b)) {
    if (englishLines && !englishLines.has(id)) continue;
    let text = cache.quests.get(id)?.objectivesText;
    // Lines saved by an earlier scan were cut at 200 characters; read those again.
    const cutShort = (line) => line && line.length === 200 && !/[.!?…>)"']$/.test(line);
    if (text) from.cache++;
    // Wowhead's untranslated text starts with "[": never keep it.
    else if ((text = kept.get(id)) && !text.startsWith("[") && !(useWowhead && (cutShort(text) || refetch.has(id)))) from.kept++;
    else if ((text = saved.get(id))) from.saved++;
    else if (useWowhead && !NO_OBJECTIVE.has(id)) {
      text = (await wowheadObjective(id, locale))?.text;
      if (text) from.wowhead++;
      await new Promise((resolve) => setTimeout(resolve, 250));
    }
    if (!text) { missing.push(id); continue; }
    for (const match of text.matchAll(/\$[A-Za-z0-9]+/g)) tokens.set(match[0], (tokens.get(match[0]) || 0) + 1);
    lines.push(`    [${id}] = "${text.replace(/\\/g, "\\\\").replace(/"/g, '\\"').replace(/\r?\n/g, "\\n")}",`);
  }
  const sources = english
    ? `the client's enUS quest cache${cache.build ? ` (build ${cache.build})` : ""} and earlier scans of it, and\n-- Wowhead's WoW Forever quest tooltips for quests the cache doesn't hold`
    : WOWHEAD_LOCALES[locale] !== undefined
      ? "Wowhead's WoW Forever quest tooltips in that language, and\n-- translations of the English lines where Wowhead has none"
      : "a translation of the English lines (Wowhead has no such language)";
  const lua = [
    "local addonName, SM = ...",
    ...(english ? [] : [`if GetLocale() ~= "${locale}" then return end`]),
    "",
    `-- AUTO-GENERATED by _Dev/tools/forever-quest-scan.mjs text${english ? "" : ` --locale ${locale}`}. Do not edit by hand.`,
    `-- The objective line of every quest the WoW Forever stories use${english ? "" : ` (${locale})`}, from`,
    `-- ${sources}. $ tokens are filled in game.`,
    "",
    `SM.${english ? "ForeverQuestText" : "ForeverQuestTextLocalized"} = {`,
    ...lines,
    "}",
    "",
  ].join("\n");
  await mkdir(path.dirname(out), { recursive: true });
  await writeFile(out, lua);
  console.log(`Wrote ${path.relative(root, out)}: ${lines.length} of ${englishLines ? englishLines.size : ids.size} quests `
    + `(${from.cache} from the cache, ${from.wowhead} from Wowhead, ${from.saved} from --objectives, ${from.kept} kept from the file).`);
  if (missing.length) console.log(`No line for ${missing.length}: ${missing.join(", ")}`);
  console.log("Tokens:", [...tokens.entries()].sort((a, b) => b[1] - a[1]).map(([t, n]) => `${t} ${n}`).join(", "));
}

// Data/Forever/ForeverStoryLevels.lua: each Forever story's level range from
// its own quests in the quest cache, from the lowest level any of them can be
// picked up at to the highest quest level. Classic Era ranges in the story
// data miss Forever's new quests (Poisons runs to 36 with its new chapter).
async function writeStoryLevels() {
  const locale = option("locale") || "enUS";
  const cacheFile = option("wdb") || path.join(gameDir, "Cache", "WDB", locale, "questcache.wdb");
  const cache = await readQuestCache(cacheFile);
  const stories = await loadForeverStories([]);
  const lines = [];
  for (const story of [...stories].sort((a, b) => a.title.localeCompare(b.title))) {
    let low = Infinity;
    let high = 0;
    for (const quest of story.quests) {
      const cached = cache.quests.get(quest.id);
      if (!cached || !(cached.level > 0)) continue;
      // A chapter's requiredLevel can be later than its quests' own minimum:
      // the rogue's dead drop asks for level 1, but C's letter comes at 20.
      const pickup = cached.minLevel > 0 ? cached.minLevel : cached.level;
      low = Math.min(low, Math.max(pickup, quest.chapterRequiredLevel || 0));
      high = Math.max(high, cached.level);
    }
    if (high === 0) continue;
    lines.push(`    ["${story.title.replace(/"/g, '\\"')}"] = { ${low}, ${high} },`);
  }
  const lua = [
    "local addonName, SM = ...",
    "",
    "-- AUTO-GENERATED by _Dev/tools/forever-quest-scan.mjs levels. Do not edit by hand.",
    "-- Each WoW Forever story's level range: the lowest level any of its quests can be",
    "-- picked up at (no earlier than its chapter's requiredLevel), to its highest quest",
    `-- level, from the client's ${cache.locale} quest cache (build ${cache.build}). Keyed by`,
    "-- story title; the cards use it on Forever only.",
    "",
    "SM.ForeverStoryLevels = {",
    ...lines,
    "}",
    "",
  ].join("\n");
  const out = path.join(root, "Data", "Forever", "ForeverStoryLevels.lua");
  await writeFile(out, lua);
  console.log(`Wrote ${path.relative(root, out)}: ${lines.length} stories.`);
}

// Data/Forever/ForeverNPCDisplayIDs.lua: quest givers' creature display IDs
// from Cache/WDB/<locale>/creaturecache.wdb. A record holds the creature's
// name as plain text and, after its bit-packed strings, its display entries
// (display ID, scale, probability), then the health and power multipliers,
// two zero words and the movement ID.
function readCreatureModels(buffer) {
  const records = [];
  let offset = 24;
  while (offset + 8 <= buffer.length) {
    const id = buffer.readUInt32LE(offset);
    const length = buffer.readUInt32LE(offset + 4);
    if (id === 0 && length === 0) break;
    records.push({ id, body: buffer.subarray(offset + 8, offset + 8 + length) });
    offset += 8 + length;
  }
  for (const record of records) {
    const body = record.body;
    record.displays = [];
    for (let i = 0; i + 32 <= body.length; i++) {
      const display = body.readUInt32LE(i);
      const scale = body.readFloatLE(i + 4);
      const probability = body.readFloatLE(i + 8);
      if (!(display > 0 && display < 1e6 && scale >= 0.05 && scale <= 20 && probability > 0 && probability <= 100)) continue;
      const health = body.readFloatLE(i + 12);
      const power = body.readFloatLE(i + 16);
      const movement = body.readUInt32LE(i + 28);
      if (health > 0 && health < 1000 && power >= 0 && power < 1000
        && body.readUInt32LE(i + 20) === 0 && body.readUInt32LE(i + 24) === 0 && movement > 0 && movement < 1e5) {
        record.displays.push(display);
      }
    }
  }
  return records;
}

// Givers whose own model shows nothing in a portrait, with a stand-in that
// does. The Unfinished Abomination lies on Faranell's table, so the portrait
// camera, which looks for a standing creature's head, finds empty space; it
// gets the Classic abomination model (Stitches, Captive Abomination).
const PORTRAIT_MODELS = {
  "Unfinished Abomination": 1693,
};

async function writeNpcModels() {
  const locale = option("locale") || "enUS";
  const cacheFile = option("wdb") || path.join(gameDir, "Cache", "WDB", locale, "creaturecache.wdb");
  const cache = await readFile(cacheFile);
  const build = cache.readUInt32LE(4);
  const records = readCreatureModels(cache);
  const names = new Set();
  async function walk(dir) {
    for (const entry of await readdir(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) await walk(full);
      else if (entry.name.endsWith(".lua")) {
        for (const match of (await readFile(full, "utf8")).matchAll(/\bnpc = "((?:[^"\\]|\\.)*)"/g)) names.add(match[1]);
      }
    }
  }
  await walk(path.join(root, "Data"));
  const out = path.join(root, "Data", "Forever", "ForeverNPCDisplayIDs.lua");
  const kept = new Map();
  if (await exists(out)) {
    for (const match of (await readFile(out, "utf8")).matchAll(/^\s*\["((?:[^"\\]|\\.)*)"\] = (\d+),/gm)) kept.set(match[1], Number(match[2]));
  }
  const models = new Map();
  let fromCache = 0;
  let fromFile = 0;
  for (const name of [...names].sort()) {
    const needle = Buffer.from(name.replace(/\\"/g, '"') + "\0", "utf8");
    // The NPC itself, not a name that ends with it; the original (lowest ID)
    // when the game keeps several creatures of that name.
    const hit = records
      .filter((record) => {
        const at = record.body.indexOf(needle);
        return at > 0 && !/[A-Za-z0-9']/.test(String.fromCharCode(record.body[at - 1])) && record.displays.length;
      })
      .sort((a, b) => a.id - b.id)[0];
    if (PORTRAIT_MODELS[name]) models.set(name, PORTRAIT_MODELS[name]);
    else if (hit) { models.set(name, hit.displays[0]); fromCache++; }
    else if (kept.has(name)) { models.set(name, kept.get(name)); fromFile++; }
  }
  const lines = [...models].map(([name, display]) => `    ["${name}"] = ${display},`);
  const lua = [
    "local addonName, SM = ...",
    "",
    "-- AUTO-GENERATED by _Dev/tools/forever-quest-scan.mjs models. Do not edit by hand.",
    "-- The model of every quest giver the stories name that this client has met, from",
    `-- its creature cache (build ${build}), for their portraits on WoW Forever.`,
    "",
    "SM.ForeverNPCDisplayIDs = {",
    ...lines,
    "}",
    "",
  ].join("\n");
  await writeFile(out, lua);
  console.log(`Wrote ${path.relative(root, out)}: ${models.size} of ${names.size} quest givers `
    + `(${fromCache} from the cache, ${fromFile} kept from the file).`);
}

// ---------------------------------------------------------------------------
// Quest givers' models from outside sources, and the audit
// ---------------------------------------------------------------------------

async function cacheModels() {
  const file = path.join(root, "Data", "Forever", "ForeverNPCDisplayIDs.lua");
  if (!(await exists(file))) return new Map();
  const text = await readFile(file, "utf8");
  return new Map([...text.matchAll(/^\s*\["((?:[^"\\]|\\.)*)"\] = (\d+),/gm)].map((m) => [m[1].replace(/\\(["\\])/g, "$1"), Number(m[2])]));
}

// The quest givers of the Forever stories with no model in the story or in
// ForeverNPCDisplayIDs.lua, with the quests each gives.
async function giversWithoutModels() {
  const stories = await loadForeverStories([]);
  const tables = await storyTables(root);
  const met = await cacheModels();
  const givers = [];
  for (const story of stories) {
    const known = tables.get(story.key)?.models || new Map();
    const byNpc = new Map();
    for (const quest of story.quests) {
      if (!quest.npc || known.has(quest.npc) || met.has(quest.npc)) continue;
      if (!byNpc.has(quest.npc)) byNpc.set(quest.npc, new Set());
      for (const id of [quest.classicId, ...(quest.ids || [quest.id])]) if (id) byNpc.get(quest.npc).add(id);
    }
    for (const [npc, quests] of byNpc) givers.push({ key: story.key, story: story.title, npc, quests: [...quests] });
  }
  return givers;
}

async function addCmangosModels() {
  const db = await loadCmangos(path.resolve(option("cmangos")), cacheDir);
  const entries = [];
  const unmatched = [];
  for (const giver of await giversWithoutModels()) {
    const hit = cmangosModel(db, giver.npc, giver.quests);
    if (!hit) { unmatched.push(giver); continue; }
    entries.push({ key: giver.key, npc: giver.npc, model: hit.model });
    // A match by name alone may be another creature of that name: check those.
    console.log(`${hit.how.startsWith("the only") ? "CHECK " : "      "}${giver.story} | ${giver.npc} → ${hit.model} (creature ${hit.creature}, ${hit.how})`);
  }
  const added = await addStoryModels(root, entries, "the cmangos Classic database");
  for (const [file, count] of added) console.log(`${String(count).padStart(4)}  ${file}`);
  console.log(`${entries.length} models added; ${unmatched.length} givers not in the Classic database `
    + `(objects, or Forever's own NPCs: try --wowhead).`);
}

async function addWowheadModels() {
  const givers = await giversWithoutModels();
  const lookupFile = path.join(cacheDir, "wowhead-npcs.json");
  let lookup = {};
  try { lookup = JSON.parse(await readFile(lookupFile, "utf8")); } catch { /* first run */ }
  for (const giver of givers) {
    if (lookup[giver.npc]) continue;
    lookup[giver.npc] = await wowheadNpcs(giver.npc);
    console.log(`${giver.npc}: ${lookup[giver.npc].map((npc) => npc.id).join(", ") || "not on Wowhead"}`);
    await new Promise((resolve) => setTimeout(resolve, 800));
  }
  await mkdir(cacheDir, { recursive: true });
  await writeFile(lookupFile, JSON.stringify(lookup, null, 1));
  if (!option("displays")) {
    const ids = [...new Set(givers.flatMap((giver) => (lookup[giver.npc] || []).map((npc) => npc.id)))];
    console.log(`\n${ids.length} Wowhead NPC pages to read. Paste this into the console of a Wowhead page, save what it copies as a .json file, and run again with --displays <file>:\n`);
    console.log(wowheadModelSnippet(ids));
    return;
  }
  const displays = JSON.parse(await readFile(option("displays"), "utf8"));
  // The zone most of a story's givers stand in, to tell same-named NPCs apart.
  const homeZone = new Map();
  for (const giver of givers) {
    const zone = lookup[giver.npc]?.[0]?.zone;
    if (!zone) continue;
    const counts = homeZone.get(giver.key) || new Map();
    counts.set(zone, (counts.get(zone) || 0) + 1);
    homeZone.set(giver.key, counts);
  }
  const entries = [];
  for (const giver of givers) {
    const candidates = (lookup[giver.npc] || []).filter((npc) => displays[npc.id]);
    let models = new Set(candidates.map((npc) => displays[npc.id]));
    if (models.size > 1) {
      const zone = [...(homeZone.get(giver.key) || new Map())].sort((a, b) => b[1] - a[1])[0]?.[0];
      models = new Set(candidates.filter((npc) => npc.zone === zone && npc.coords).map((npc) => displays[npc.id]));
    }
    if (models.size === 1) entries.push({ key: giver.key, npc: giver.npc, model: [...models][0] });
    else console.log(`${giver.story} | ${giver.npc}: ${candidates.length ? "Wowhead's NPCs of that name have different models; pick one by hand" : "no model read"}`);
  }
  const added = await addStoryModels(root, entries, "Wowhead's WoW Forever data");
  for (const [file, count] of added) console.log(`${String(count).padStart(4)}  ${file}`);
  console.log(`${entries.length} models added.`);
}

async function writeAudit() {
  const stories = await loadForeverStories([]);
  const tables = await storyTables(root);
  const met = await cacheModels();
  const texts = new Map([["enUS", readTextFile(await readFile(questTextFile("enUS"), "utf8"))]]);
  const textDir = path.join(root, "Data", "Forever", "QuestText");
  for (const name of (await readdir(textDir).catch(() => [])).filter((file) => file.endsWith(".lua")).sort()) {
    texts.set(name.slice(0, -4), readTextFile(await readFile(path.join(textDir, name), "utf8")));
  }
  const idSets = await questIdSets();
  const scan = await readScanTitles();
  const lines = ["# WoW Forever story audit", ""];
  const totals = { quests: 0, givers: 0, modelled: 0 };
  for (const story of stories) {
    const known = tables.get(story.key)?.models || new Map();
    const noModel = new Set();
    const noText = new Map();
    const unknown = [];
    for (const quest of story.quests) {
      totals.quests++;
      if (quest.npc) {
        totals.givers++;
        if (known.has(quest.npc) || met.has(quest.npc)) totals.modelled++;
        else noModel.add(quest.npc);
      }
      for (const id of quest.ids || [quest.id]) {
        for (const [locale, text] of texts) {
          if (!text.has(id) && !NO_OBJECTIVE.has(id)) noText.set(locale, [...(noText.get(locale) || []), id]);
        }
        const title = scan?.titles.get(id);
        if (title === false) unknown.push(`${id} (no answer in /sm scan)`);
        else if (!title && idSets?.forever && !idSets.forever.has(id)) unknown.push(`${id} (not in Forever's quest table${scan ? " or the scan" : ""})`);
      }
    }
    const issues = [];
    if (noModel.size) issues.push(`no model: ${[...noModel].join(", ")}`);
    for (const [locale, ids] of noText) issues.push(`no ${locale} objective: ${ids.join(", ")}`);
    if (unknown.length) issues.push(`unknown quest IDs: ${unknown.join(", ")}`);
    lines.push(`## ${story.title} (${story.quests.length} quests)`, "", ...(issues.length ? issues.map((issue) => `- ${issue}`) : ["- nothing missing"]), "");
  }
  lines.splice(2, 0, `${totals.quests} quests in ${stories.length} stories; ${totals.modelled} of ${totals.givers} quests with a giver show the giver's model. `
    + `Objective lines checked in ${[...texts.keys()].join(", ")}; ${NO_OBJECTIVE.size} hand-in quests have none in the game.`, "");
  await mkdir(reportDir, { recursive: true });
  const out = path.join(reportDir, "forever-audit.md");
  await writeFile(out, lines.join("\n"));
  console.log(lines.slice(2, 3).join(""));
  console.log(`Wrote ${path.relative(root, out)}.`);
}

// ---------------------------------------------------------------------------
// check: every story quest against the Classic database and Forever's titles
// ---------------------------------------------------------------------------

const FACTION_RACES = { Alliance: 1 | 4 | 8 | 64, Horde: 2 | 16 | 32 | 128 };
const RACE_BITS = { Human: 1, Orc: 2, Dwarf: 4, NightElf: 8, Scourge: 16, Tauren: 32, Gnome: 64, Troll: 128 };
const CLASS_BITS = { WARRIOR: 1, PALADIN: 2, HUNTER: 4, ROGUE: 8, PRIEST: 16, SHAMAN: 64, MAGE: 128, WARLOCK: 256, DRUID: 1024 };
// The races that can play each class on Forever: Classic's, plus Forever's
// Forsaken paladins and dwarf shamans.
const CLASS_RACES = {
  WARRIOR: ["Human", "Orc", "Dwarf", "NightElf", "Scourge", "Tauren", "Gnome", "Troll"],
  PALADIN: ["Human", "Dwarf", "Scourge"],
  HUNTER: ["Dwarf", "NightElf", "Orc", "Tauren", "Troll"],
  ROGUE: ["Human", "Dwarf", "NightElf", "Gnome", "Orc", "Scourge", "Troll"],
  PRIEST: ["Human", "Dwarf", "NightElf", "Scourge", "Troll"],
  SHAMAN: ["Orc", "Tauren", "Troll", "Dwarf"],
  MAGE: ["Human", "Gnome", "Scourge", "Troll"],
  WARLOCK: ["Human", "Gnome", "Orc", "Scourge"],
  DRUID: ["NightElf", "Tauren"],
};
const list = (value) => (Array.isArray(value) ? value : value ? [value] : []);
const bitsOf = (names, table) => list(names).reduce((mask, name) => mask | (table[name] || 0), 0);
const namesOf = (mask, table) => Object.entries(table).filter(([, bit]) => mask & bit).map(([name]) => name);

async function checkQuests() {
  if (!option("cmangos")) throw new Error("check needs --cmangos ClassicDB.sql.gz");
  const db = await loadCmangos(path.resolve(option("cmangos")), cacheDir);
  const scan = await readScanTitles();
  const idSets = await questIdSets();
  const stories = await loadForeverStories([]);
  const findings = [];
  const add = (story, quest, type, detail, claim = null) => findings.push({ story: story.title, file: story.rel, chapter: quest.chapter, id: quest.id, name: quest.name, type, detail, claim });

  for (const story of stories) {
    // Where each quest sits in the story, by every ID it goes by.
    const order = new Map();
    story.quests.forEach((quest, index) => {
      // A guidance hint points to what its quest needs first: it counts as
      // coming just before that quest.
      const at = /^guidanceQuest\s*=/.test(quest.line) ? index - 1.5 : index;
      for (const id of [quest.id, quest.classicId, ...(quest.ids || [])]) if (id && !order.has(id)) order.set(id, at);
    });
    story.quests.forEach((quest, index) => {
      // A guidance hint inside another quest isn't a step of the story.
      if (/^guidanceQuest\s*=/.test(quest.line)) return;
      const title = scan?.titles.get(quest.id);
      // No answer can mean the request timed out: Wowhead's Forever data has
      // some of these quests, so it's worth a look, not proof they're gone.
      if (title === false) add(story, quest, "no-answer", "/sm scan got no answer for this quest ID");
      else if (!title && idSets?.forever && !idSets.forever.has(quest.id)) add(story, quest, "unknown", "not in Forever's quest table or the scan");
      const classic = db.quests[quest.classicId || quest.id];
      if (typeof title === "string" && norm(title) !== norm(quest.name)) add(story, quest, "title", `Forever calls it "${title}"`);
      else if (!title && classic && norm(classic.title) !== norm(quest.name)) add(story, quest, "title", `Classic calls it "${classic.title}"`);
      if (!classic) return;
      const id = quest.classicId || quest.id;

      // Who gives it.
      const starters = [...(db.starts[id] || []).map((c) => db.creatures[c]?.name), ...(db.objectStarts[id] || []).map((o) => db.objects[o])].filter(Boolean);
      const enders = [...(db.ends[id] || []).map((c) => db.creatures[c]?.name), ...(db.objectEnds[id] || []).map((o) => db.objects[o])].filter(Boolean);
      if (quest.npc && starters.length && !starters.some((name) => norm(name) === norm(quest.npc))) {
        const turnIn = enders.some((name) => norm(name) === norm(quest.npc));
        add(story, quest, turnIn ? "giver-is-ender" : "giver", `given by ${[...new Set(starters)].join(" / ")}${turnIn ? `; ${quest.npc} takes it in` : ""}`, { start: starters });
      } else if (!quest.npc && starters.length) add(story, quest, "no-giver", `given by ${[...new Set(starters)].join(" / ")}`, { start: starters });

      // Who can take it.
      // A quest for certain races is for those races' faction.
      const raceMask = bitsOf(quest.race || quest.storyRace, RACE_BITS);
      const faction = quest.faction || quest.chapterFaction || quest.storyFaction
        || (raceMask && !(raceMask & FACTION_RACES.Horde) ? "Alliance" : raceMask && !(raceMask & FACTION_RACES.Alliance) ? "Horde" : null);
      if (classic.races) {
        const allianceOnly = !(classic.races & FACTION_RACES.Horde);
        const hordeOnly = !(classic.races & FACTION_RACES.Alliance);
        if (allianceOnly && faction !== "Alliance") add(story, quest, "faction", `Alliance only, but the story shows it to ${faction || "both factions"}`, { side: "Alliance" });
        if (hordeOnly && faction !== "Horde") add(story, quest, "faction", `Horde only, but the story shows it to ${faction || "both factions"}`, { side: "Horde" });
        // Who the story shows it to: its faction's races, less any it excludes,
        // and only those that can play the story's class.
        let shownTo = faction === "Alliance" ? FACTION_RACES.Alliance : faction === "Horde" ? FACTION_RACES.Horde : 255;
        const storyClass = list(quest.class || quest.storyClass);
        if (storyClass.length) shownTo &= storyClass.reduce((mask, name) => mask | bitsOf(CLASS_RACES[name], RACE_BITS), 0);
        shownTo &= ~bitsOf(quest.line.match(/\bexcludeRace\s*=\s*"(\w+)"/)?.[1], RACE_BITS);
        if (!raceMask && (shownTo & ~classic.races)) add(story, quest, "race", `only ${namesOf(classic.races, RACE_BITS).join(", ")}, but the story also shows it to ${namesOf(shownTo & ~classic.races, RACE_BITS).join(", ")}`, { races: classic.races });
        else if (raceMask && (raceMask & ~classic.races)) add(story, quest, "race", `only ${namesOf(classic.races, RACE_BITS).join(", ")}, but the story names ${list(quest.race || quest.storyRace).join(", ")}`, { races: classic.races });
      }
      if (classic.classes) {
        const classMask = bitsOf(quest.class || quest.storyClass, CLASS_BITS);
        if (!classMask) add(story, quest, "class", `only ${namesOf(classic.classes, CLASS_BITS).join(", ")}, but the story names no class`, { classes: classic.classes });
        else if (classMask & ~classic.classes) add(story, quest, "class", `only ${namesOf(classic.classes, CLASS_BITS).join(", ")}, but the story names ${list(quest.class || quest.storyClass).join(", ")}`, { classes: classic.classes });
      }

      // What has to come first.
      const prev = Math.abs(classic.prev);
      if (prev && db.quests[prev]) {
        if (order.has(prev) && order.get(prev) > index) add(story, quest, "order", `needs ${prev} "${db.quests[prev].title}" first, which the story puts later`);
        else if (!order.has(prev)) add(story, quest, "prerequisite", `needs ${prev} "${db.quests[prev].title}" first, which isn't in the story`);
      }
    });
  }

  // cmangos is a private server's database and is sometimes wrong (it swaps
  // some Classic quest IDs), so its findings are leads: Wowhead's Forever quest
  // pages (--facts, read in a browser) confirm or overrule them.
  const facts = option("facts") ? JSON.parse(await readFile(option("facts"), "utf8")) : null;
  const WOWHEAD_RACES = { 1: "Human", 2: "Orc", 3: "Dwarf", 4: "NightElf", 5: "Scourge", 6: "Tauren", 7: "Gnome", 8: "Troll" };
  const WOWHEAD_CLASSES = { 1: "WARRIOR", 2: "PALADIN", 3: "HUNTER", 4: "ROGUE", 5: "PRIEST", 7: "SHAMAN", 8: "MAGE", 9: "WARLOCK", 11: "DRUID" };
  for (const finding of findings) {
    if (!finding.claim) continue;
    const fact = facts?.[finding.id];
    if (!fact) { finding.verdict = "not checked on Wowhead"; continue; }
    const { side, races, classes, start } = finding.claim;
    let agrees = true;
    if (side) agrees = fact.side === side;
    if (races !== undefined) agrees = bitsOf(fact.races.map((race) => WOWHEAD_RACES[race]).filter(Boolean), RACE_BITS) === races;
    if (classes !== undefined) agrees = bitsOf(fact.classes.map((cls) => WOWHEAD_CLASSES[cls]).filter(Boolean), CLASS_BITS) === classes;
    if (start) agrees = start.some((name) => fact.start.some((other) => norm(other) === norm(name)));
    finding.verdict = agrees ? "confirmed by Wowhead"
      : `Wowhead disagrees (side ${fact.side || "none"}, races ${fact.races.join(",") || "any"}, classes ${fact.classes.join(",") || "any"}, given by ${fact.start.join(" / ") || "?"})`;
  }
  const types = ["no-answer", "unknown", "title", "faction", "class", "race", "order", "giver", "giver-is-ender", "no-giver", "prerequisite"];
  const lines = ["# WoW Forever story quest check", "",
    `${stories.reduce((n, story) => n + story.quests.length, 0)} quests in ${stories.length} stories, against the cmangos Classic database${scan ? " and Forever's /sm scan titles" : ""}.`, ""];
  for (const type of types) {
    const rows = findings.filter((finding) => finding.type === type);
    if (!rows.length) continue;
    lines.push(`## ${type} (${rows.length})`, "", ...rows.map((f) => `- ${f.story} › ${f.chapter} › ${f.id} ${f.name}: ${f.detail}${f.verdict ? ` [${f.verdict}]` : ""}`), "");
  }
  await mkdir(reportDir, { recursive: true });
  await writeFile(path.join(reportDir, "forever-check.md"), lines.join("\n"));
  await writeFile(path.join(reportDir, "forever-check.json"), JSON.stringify(findings, null, 1));
  console.log(types.map((type) => `${type} ${findings.filter((f) => f.type === type).length}`).join(", "));
  console.log(`Wrote ${path.relative(root, path.join(reportDir, "forever-check.md"))}.`);
  const unchecked = [...new Set(findings.filter((f) => f.claim && (!facts || !facts[f.id])).map((f) => f.id))];
  if (unchecked.length) {
    console.log(`\n${unchecked.length} findings rest on cmangos alone. Paste this into the console of a Wowhead page, save what it copies as a .json file, and run again with --facts <file>:\n`);
    console.log(wowheadFactsSnippet(unchecked));
  }
}

if (command === "ids") await writeIdList();
else if (command === "text") await writeQuestText();
else if (command === "levels") await writeStoryLevels();
else if (command === "models" && option("cmangos")) await addCmangosModels();
else if (command === "models" && args.includes("--wowhead")) await addWowheadModels();
else if (command === "models") await writeNpcModels();
else if (command === "audit") await writeAudit();
else if (command === "check") await checkQuests();
else if (command === "quest") await printQuests();
else if (command === "report") await writeReport();
else {
  console.log("Usage: node _Dev/tools/forever-quest-scan.mjs ids|report|quest|text|levels|models|audit|check [root] [questID…] [--wdb file] [--saved file] [--offline] [--wowhead] [--locale xxXX] [--objectives file] [--cmangos dump.sql.gz] [--displays file]");
  process.exitCode = 1;
}

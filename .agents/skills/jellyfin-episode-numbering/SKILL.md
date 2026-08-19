---
name: jellyfin-episode-numbering
description: Set season and episode numbers in Jellyfin when it failed to parse them from filenames. Numbers come from the file paths themselves; no external database is needed. Use when the user says Jellyfin does not see episodes, dumped everything into Season Unknown, shows episodes without numbers, or mis-organized a downloaded show. Works through the JellyRoller CLI, one show or one season at a time.
---

# Jellyfin episode numbering

Jellyfin failed to parse episode numbers from filenames. The numbers are always present
in the paths — this is a string-reading task, no TVDB/TMDB lookups.

**Scope: one show or one season. Never the whole library.**

Verified against Jellyfin 10.11.11 + JellyRoller 1.1.5. Anything unverified is marked.

## Who does what

**You determine season and episode numbers by reading full paths.** There is no parser
script here on purpose: release-group naming schemes are mutually incompatible, fixed
regexes fail silently on the next new scheme, and a silent error is worse than a refusal.
The scripts do the mechanics — fetch, validate, write. Do not call the Jellyfin API
directly.

Field-proven: a parser that handled three shows in a row produced 48 errors out of 48 on
the fourth (`Vinland_Saga_[01]_[AniLibria_TV]_[WEBRip_1080p-LQ_HEVC].mkv`) — it stripped
`[...]` as release-group noise, and the episode number lived exactly there. A human sees
this in a second.

## Running the scripts

**Everything in `scripts/` is Python 3, not shell.** Run each one directly — the files
are executable and carry a `#!/usr/bin/env python3` shebang:

```bash
scripts/preflight            # correct
python3 scripts/preflight    # also correct
bash scripts/preflight       # WRONG — never do this
```

`bash scripts/apply` does not fail cleanly, it does damage: the shell reaches the
`import argparse` lines and runs ImageMagick's `import` tool, which **takes screenshots
of the user's desktop** and writes 14 MB files named `argparse`, `json`, `sys` into the
current directory. This has already happened once. There is no `.sh` file in this skill.

## Procedure

```bash
scripts/preflight                                    # 1. jellyroller installed + authorized?
jellyroller create-backup --skip-trickplay --skip-subtitles   # 2. backup BEFORE any write
scripts/list-episodes "Show name" > ep.json          # 3. episodes with paths
scripts/plan-template ep.json > plan.tsv             # 4. table skeleton
#    5. READ the paths, fill new_s / new_e / confidence / why
scripts/validate --expect-count <N> plan.tsv         # 6. gaps, duplicates, unfilled rows
#       N = "Episodes: <n>" printed by list-episodes, or the folder's file count
#    7. SHOW the table to the user. Wait for confirmation.
scripts/apply --plan plan.tsv --items ep.json --dry-run       # 8. what will be sent
scripts/apply --plan plan.tsv --items ep.json --only <ID>     # 9. ONE episode first
#   10. verify, then the rest:
scripts/apply --plan plan.tsv --items ep.json
```

Never skip steps 7 and 9: `update-metadata` is irreversible, the only undo is the backup.

Hard rules:

1. `preflight` first. If it fails, ask the user to install and authorize JellyRoller and
   stop there.
2. Back up before any write.
3. Show the table and **wait for confirmation**. Never write unasked.
4. First write goes to a single episode (`--only <ID>`), verify, then the rest.
5. One show or one season. Never the whole library.
6. Never invent numbers. Ambiguous → `uncertain` plus a clear reason in `why`; the user
   resolves those, not you. A skipped episode is cheaper than a wrong one.
   If `plan-template` prints a `STOP:` block, stop and ask before filling `new_s`.
7. Do not edit the Season object (see Limitations).
8. Finish with a report: what changed, what was skipped, what needs hands.

## How to assign numbers

Look at the **full path**, not just the filename — the season number often lives only in
the folder name. Identify the scheme across the whole batch at once: one scheme per
folder, and inconsistency inside a folder almost always means you misread the scheme.

Fill in `new_s`, `new_e`, `confidence`, `why` (and optionally `new_name`).

**Never invent numbers.** A skipped episode costs the user one manual fix; a wrong one
silently breaks playback order and gets discovered a month later.

### Cases that have actually caused trouble

| Path | Reading |
|---|---|
| `GOT.S01E01.BDRip.1080p.mkv` | S01E01; `1080p`, `BDRip` are not numbers |
| `137. Имя прародительницы.mkv` | episode 137, season only from the folder |
| `Vinland_Saga_[01]_[AniLibria_TV]_[WEBRip_1080p-LQ_HEVC].mkv` | **episode 1** — number inside brackets, next to identical brackets holding junk |
| `86_Eighty_Six_[11.5]_[AniLibria_TV].mkv` | **recap between 11 and 12.** Fractional number is not an episode → `uncertain` |
| `133-134. Женщина.mkv` | double episode: `new_e=133`, `new_e_end=134` |
| `The.Big.Bang.Theory.S07.Gag.Reel.1080p.mkv` | **not an episode at all** — blooper reel → `uncertain` |
| `Show.101.mkv` | `uncertain`: S01E01 or episode 101? The neighbouring batch decides |
| `Show.2005.03.14.mkv` | `uncertain`: a date, not a number |

Numbers that are never episode numbers: `1080p`/`720p`, `x264`/`x265`/`hevc`, `10bit`,
`5.1`, `AAC`/`AC3`, a year in parentheses, `1920x1080`, `vol.2`, bitrate. Self-check:
does this number change from file to file in the folder? If all 48 files share `1080`,
it is definitely not an episode number.

### Season

Look in the folder name: `Season 2`, `Сезон 2`, `S02`, `2nd Attack`, `/2/`. A folder
named `Vinland Saga 2 - AniLibria.TV [WEBRip 1080p HEVC]` **probably** means season 2 —
but verify: `86 EIGHTY-SIX` is not season 86, and `JoJo's Bizarre Adventure 3` may be a
third part with its own numbering. When unsure, ask the user — they know their show.

### When the folders carry no season number at all — STOP and ask

Anime franchises routinely name folders by arc, not by season:

```
Seishun Buta Yarou wa Bunny Girl Senpai no Yume wo Minai   13 files
Seishun Buta Yarou wa Santa Claus no Yume wo Minai         13 files
Seishun Buta Yarou wa Yumemiru Shoujo no Yume wo Minai      1 file
```

Which of these is season 1 and which is season 2 **is not in the paths**. Answering it
means recalling release years — that is memory, not reading, and memory is exactly what
this skill refuses to rely on. It also gets stale: a franchise gains new entries.

`plan-template` detects this and prints a `STOP:` block to stderr listing every folder
with its file count. When you see it:

1. **Do not fill `new_s`.** Not from release dates you recall, not from alphabetical
   order, not from folder mtime.
2. Show the user that same list and ask which folder is which season, and what to do
   with the single-file folders.
3. Only then fill the table, and record the user's answer in `why`.

A folder holding **one file** is almost never an episode — it is a movie, an OVA or a
special. Never silently make it "season N, episode 1". Ask, or mark `uncertain`.

The same applies to OVAs and spin-offs sitting next to the main show with their own
`[01]`–`[25]` numbering: they are not its seasons.

If no season marker exists but the user says "it's a single season", use 1 and record
that in `why`. Never guess: `validate` blocks rows that have an episode but no season.

When seasons live in separate folders, process one at a time:

```bash
scripts/list-episodes --series-id <ID> --path-contains "Vinland Saga 2" > s2.json
```

### Double episodes

`new_e=21`, `new_e_end=22` — `apply` sends `IndexNumber` + `IndexNumberEnd`.
**Whether Jellyfin accepts `IndexNumberEnd` through this endpoint is unverified.**
On a 400, fall back to writing only the first number; the season keeps a gap at 22,
which is cosmetic and does not break playback order.

### Confidence

* `high` — scheme is unambiguous and confirmed by the whole batch.
* `medium` — plausible but rests on an assumption (season guessed from folder name).
* `uncertain` — not an episode, ambiguous number, or unreadable scheme. `apply` skips
  these unless given `--include-uncertain`.

`validate` prints every `medium` and `uncertain` as a separate list — that is what the
human reviews before the write.

## Episode names

**An episode must never end up with an empty name.** Decide per episode by looking at
`cur_name` in the skeleton. Work out the user's language from the conversation: if they
write to you in Russian, their library should read in Russian.

### The decision

| What is in `cur_name` | What you do | Result |
|---|---|---|
| Empty | leave `new_name` empty, pass `--set-name` | title from the filename, else `Эпизод N` |
| Junk — repeats across episodes (`Japanese`, `Original [Tuxoid]`, `Vinland_Saga`) | same | same |
| Placeholder — `Эпизод 7`, `Episode 7`, `Folge 7` | same | same |
| Real title, **already in the user's language** | **do not pass `--set-name`** | left untouched |
| Real title, **in a foreign language** | translate it into `new_name`, `confidence: medium` | your translation |

`--set-name` applies to the whole run, so a mixed show gets it once: fill `new_name` for
the rows needing a translation and leave it empty on the rest — an empty `new_name` falls
through to the filename, then to `Эпизод N`.

### Junk or a real title?

Real titles **differ per episode**; junk **repeats**. `Japanese` sits on all 163 episodes
of one show — that is an audio track name. `Эпизод 7` differs per episode but is
Jellyfin's own placeholder, so it counts as junk in any language.

`plan-template` decides this for you and prints a `NOTE:` block when most episodes carry
distinct, non-placeholder titles. Seeing it means row 4 or 5 of the table above — check
the language and either translate or leave alone. **Never let `Эпизод N` overwrite a real
title**: priority rule 2 below keys on Cyrillic, so an English title would otherwise be
thrown away.

### What `--set-name` does with an empty `new_name`

1. **`new_name`** if filled — overrides everything.
2. **The filename**, if what remains after stripping the number, brackets and tech tags
   holds Cyrillic (3+ chars) and does not just repeat the show title.
3. **`Эпизод N`** — last resort, identical to Jellyfin's own default.

| File | Resulting name |
|---|---|
| `137. Имя прародительницы - Кагоме.mkv` | `Имя прародительницы - Кагоме` |
| `Vinland_Saga_[01]_[AniLibria_TV].mkv` | `Эпизод 1` |
| `GOT.S01E01.BDRip.1080p.mkv` | `Эпизод 1` |

About translating: it is your rendering, not an official title. Mark the row `medium` and
say so in `why`, so the user can correct it from the table.

Measured across 3556 episodes: real titles from providers almost never arrive (2234 were
Jellyfin's own `Эпизод N`, the rest junk). So `Эпизод N` is the normal outcome — but read
`cur_name` before assuming it, the show at hand may be the exception.

## JellyRoller 1.1.5 limitations

All of this was established experimentally.

**`search-media` crashes on Season items** — `Unable to execute search, error decoding
response body` on an HTTP 200; the decoder cannot handle that type.

```
-m all       CRASHES if the result contains any Season   <- this is the default!
-m season    always CRASHES
-m series / episode / movie / boxset / video / folder   work
```

Always pass `-m` explicitly. Searching by a name a season shares also breaks:
`-t "InuYasha"` crashes (the season was named `Inuyasha`) while `-t "Инуяша"` works —
search by the Russian display name. `scripts/list-episodes` already handles this.

**Seasons cannot be read through the CLI at all**, and that does not matter. A Season is
virtual — Jellyfin builds it from episodes. Only `ParentIndexNumber` on the episodes
counts; set it and the season assembles correctly. An empty season nothing references
disappears on the next scan. So never edit a Season's `IndexNumber` and never try to
delete ghost seasons. `Season Unknown` in the web UI is a symptom of wrong
`ParentIndexNumber` — fix the episodes.

**`GET /Items` is requested without `fields`** — 31 non-empty fields arrive out of 151.
These come back empty no matter what the server holds:

```
Overview  Genres  Studios  Tags  People  Taglines  CustomRating
OriginalTitle  DateCreated  SortName  LockedFields  MediaStreams  ProductionLocations
```

**The JSON from `search-media` must never be sent back.** It contains OpenAPI schema
placeholders:

```json
"ProviderIds": {"property1": "", "property2": ""}
"ImageTags":   {"property1": "", "property2": ""}
```

Also `null` is normalized to `""`/`0`/`[]`. **`IndexNumber: 0` means "unset", not zero.**
Hence: build the patch from an explicit field whitelist, never by copying the item.

**Error response bodies are never shown**, even with `-v` — only `Response Status: 400`.
Causes have to be found by trial.

**Missing commands:** deleting an item, refreshing metadata for a single item
(`scan-library` hits a whole library). The repo has no `DOCS.md` either — only README
and CHANGELOG.

## Write format

`update-metadata` is a raw `POST /Items/{id}` of the file contents, unvalidated
(`src/system_actions.rs:506`). Jellyfin applies the DTO as a whole: **any field absent
from the JSON becomes null.**

Verified: a four-field patch (`Id`, `Name`, `IndexNumber`, `ParentIndexNumber`) changed
4 fields out of 151 — three intentionally, plus `OfficialRating: "PG-13" → ""` purely
because it was not in the body.

**400 Bad Request unless the body has `ProviderIds` + `Genres` + `Tags`, all three:**

```
{"IndexNumber":1}                                        -> 400
{"IndexNumber":1,"ProviderIds":{},"Genres":[]}           -> 400
{"IndexNumber":1,"Genres":[],"Tags":[]}                  -> 400
{"IndexNumber":1,"ProviderIds":{},"Genres":[],"Tags":[]} -> 200
```

Empty values are fine. `Id` in the body is optional; GUID with or without dashes both work.

`scripts/apply` already does all of this: it sends the mandatory trio and carries over
non-empty `OfficialRating`, `Overview`, `PremiereDate`, `ProductionYear`, `SortName`.

### Writing wipes episode overviews — and that is fine

Combine the two facts above: the script cannot preserve fields it cannot see. Verified —
episode 12 of Chainsaw Man lost its provider overview after `apply`.

**Overviews are secondary.** The job is episode numbers; without them the show is
unwatchable in order. An overview comes back with a single refresh from the web UI. So:
do not offer to skip the numbering to save overviews, do not invent workarounds (there
are none), mention it **once** in the report and move on.

The order where nothing is lost: download → Jellyfin identifies the show → number it →
refresh.

## What refresh does

* **Numbers survive.** Neither a library scan nor a full metadata refresh touches them.
* **`Name` gets overwritten** by the provider's value.

`Name` could in theory be protected with `LockedFields: ["Name"]`, but the skill
deliberately does not: a show is numbered once after download and nobody runs a refresh
afterwards. Anyone who wants the lock sets it in the web UI. Numbers cannot be protected
at all — the `MetadataField` enum only accepts `Cast, Genres, ProductionLocations, Name,
Overview, Runtime, Studios, Tags, OfficialRating`.

## What unparsed files look like

From a show where Jellyfin recognized no numbers at all (163 files in one folder):

* The episodes **are in the library**, visible as `Episode` with a correct `Path`.
* `IndexNumber` is null (`0` in CLI output).
* `ParentIndexNumber` is a mess: 0 on 97 of them, 1 on 65, 21 on one.
* `Name` on all of them was `Japanese`, from the audio track title.

"Jellyfin didn't parse it" ≠ "the file is missing". Check `IndexNumber`, not the presence
of the item. If the folder holds more files than the query returns, then some landed as a
separate "show" or never got imported — that one is for the web UI.

The opposite happens too: Jellyfin may have parsed everything correctly and there is no
work to do. Check `cur_s`/`cur_e` in the skeleton before writing anything.

## JellyRoller commands you need

The other 43 subcommands are irrelevant here.

```bash
jellyroller server-info                                   # connectivity, Jellyfin version
jellyroller get-libraries -o json                         # libraries (is the key admin?)
jellyroller search-media -t "Name" -m series -o json -f   # find the show -> Id
jellyroller search-media -t "" -p <seriesId> -m episode -o json -f   # episodes with paths
jellyroller update-metadata -i <itemId> -f patch.json     # write
jellyroller create-backup --skip-trickplay --skip-subtitles
jellyroller get-backups -o json
jellyroller apply-backup <filename>                       # restore (unverified)
jellyroller scan-library <libraryId> new-updated          # scan; numbers survive it
```

`search-media` flags: `-f` adds `Path`, `-o json|csv|table`, `-p` is parentId, `-c` picks
table columns (`Name`, `Id`, `Type`, `Path`, `CriticRating`, `ProductionYear`). Global
`-v` prints HTTP requests, though not error bodies.

## Report

`apply` prints how many rows were written, how many skipped and why, how many failed.
Skipped rows are what the user finishes by hand. Do not claim success before showing
that list.

## Installation

The scripts are self-contained Python 3 (see "Running the scripts" — never invoke them
with bash); no agent is required, the table can be filled by hand in any spreadsheet.
`scripts/apply --demo` self-checks the patch builder without touching network or server.

Keep the executable bit on `scripts/*` when copying the directory: `chmod +x scripts/*`.

| Agent | Where the skill directory goes |
|---|---|
| [pi](https://github.com/earendil-works/pi) | `~/.pi/agent/skills/`, `~/.agents/skills/`, or `.pi/skills/` in a project |
| Claude Code | `~/.claude/skills/` |

Both implement the [Agent Skills standard](https://agentskills.io/specification), so the
directory is copied as is. In pi the skill is invoked as
`/skill:jellyfin-episode-numbering`; instead of copying you can point settings at the
Claude Code directory: `{ "skills": ["~/.claude/skills"] }`.

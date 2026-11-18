# Shiny Box Counter for OBS

An OBS script that shows living-dex progress on stream, read straight from your Pokémon save file.
It watches a folder, opens the newest save, counts what's in the PC boxes (and party), and writes
something like `151 / 386` into a text source. Made for shiny-hunting bots that save to disk
(for example [PokéBot Gen3](https://github.com/40Cakes/pokebot-gen3)), but any Gen 3 save works.

**Games:** Ruby, Sapphire, Emerald, FireRed, LeafGreen (`.sav`, 128 KB).

## What it counts
- **Goal:** the National Dex (386) or the regional dex (Kanto 151 for FireRed/LeafGreen, Hoenn 202 for
  Ruby/Sapphire/Emerald).
- **Only shinies** on or off.
- **Pre-evolutions count.** Three Bulbasaur fill Bulbasaur, Ivysaur and Venusaur; two of them just still
  need evolving. Those are shown separately as **To evolve**. Each Pokémon fills one entry at most.
  Wurmple only counts toward the branch its personality value leads to, and one spare Nincada covers both
  Ninjask and Shedinja.
- Eggs are skipped.

## Install
1. Download `shiny-counter.lua`.
2. In OBS, add a **Text** source for the counter (style it however you like). Add a second Text source
   if you want "To evolve" shown separately.
3. **Tools → Scripts → `+`** and pick `shiny-counter.lua`. OBS ships with Lua, so nothing else needs installing.
4. In the script settings, pick the **save folder** and your text source(s).

## Settings
| Setting | Default | What it does |
|---|---|---|
| Save folder | | Folder the saves land in. The newest file (by modified time) is used. |
| File pattern | `*.sav` | Which files to look at. |
| Game | Detect from save | Override if detection guesses wrong (it only matters for the regional dex). |
| Goal | National Dex | National (386) or Regional (Kanto 151 / Hoenn 202). |
| Only count shinies | on | Off = any Pokémon counts. |
| Include the party | on | Count the 6 in the party as well as the boxes. |
| Count Pokémon that still need evolving toward {x} | on | Off = `{x}` only counts entries you already have. |
| Counter text source / format | `{x} / {y}` | |
| "To evolve" text source / format | `To evolve: {evolve}` | Optional second text. |
| Check every (seconds) | 5 | The save is only re-read when it changes. |

**Update now** forces a re-read.

### Format tokens
| Token | Meaning |
|---|---|
| `{x}` | Entries covered (owned, plus to-evolve when that setting is on) |
| `{y}` | Size of the chosen dex |
| `{done}` | Entries you already have as that exact species |
| `{evolve}` | Entries covered only by a Pokémon that still has to evolve |
| `{missing}` | Entries with nothing that can fill them |
| `{pct}` | `{x}` as a percentage |
| `{shinies}` | Shiny Pokémon in the save |
| `{total}` / `{boxed}` / `{party}` | Pokémon counted in total / in boxes / in party |
| `{evolve_names}` | e.g. `Kadabra > Alakazam, Haunter > Gengar` |
| `{missing_names}` | Names of the missing entries |
| `{game}` / `{file}` | Game name / save file name |

Use `\n` for a line break, e.g. `✨ {x} / {y}\n{pct}%`.

## Notes
- If the save is caught half-written, it's skipped and the last good numbers stay up.
- The script never writes to the save and opens it in shared mode, so the emulator or bot can keep saving.
- Windows is the main target. On Linux/macOS it falls back to `ls -t` to find the newest file.

## Development
- `tools/test.luau` runs the parser and evolution rules outside OBS with [Lune](https://github.com/lune-org/lune):
  `lune run tools/test.luau path/to/save.sav`
- `tools/gen_data.py` rebuilds the species table in `shiny-counter.lua` from the
  [pret/pokeemerald](https://github.com/pret/pokeemerald) headers.

## Credits
Made by HallucinatesTigers. Species, dex and evolution data from [pret/pokeemerald](https://github.com/pret/pokeemerald).
Pokémon is © Nintendo / Creatures / GAME FREAK. This is a fan tool and isn't affiliated with them.

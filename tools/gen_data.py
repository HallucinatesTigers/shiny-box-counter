"""Regenerate the species data block inside shiny-counter.lua.

Usage: python tools/gen_data.py <dir with pokeemerald species.h, pokedex.h, evolution.h>

The three headers come from https://github.com/pret/pokeemerald :
  include/constants/species.h, include/constants/pokedex.h, src/data/pokemon/evolution.h
"""
import re
import sys
from pathlib import Path

SPECIAL_NAMES = {
    "NIDORAN_F": "Nidoran♀",
    "NIDORAN_M": "Nidoran♂",
    "MR_MIME": "Mr. Mime",
    "FARFETCHD": "Farfetch'd",
    "HO_OH": "Ho-Oh",
}

ROOT = Path(__file__).resolve().parent.parent
TARGET = ROOT / "shiny-counter.lua"
BEGIN = "-- BEGIN GENERATED DATA"
END = "-- END GENERATED DATA"


def pretty(const):
    return SPECIAL_NAMES.get(const) or const.replace("_", " ").title()


def main(src):
    src = Path(src)
    species = {m[0]: int(m[1]) for m in re.findall(r"#define SPECIES_(\w+) (\d+)", (src / "species.h").read_text())}
    dex_text = (src / "pokedex.h").read_text()
    enums = re.findall(r"enum\s*\{(.*?)\}", dex_text, re.S)
    national = re.findall(r"NATIONAL_DEX_(\w+)", enums[0])[1:]  # drop NONE
    national = national[: national.index("DEOXYS") + 1]  # anything after is not a Gen 3 dex entry
    hoenn = re.findall(r"HOENN_DEX_(\w+)", enums[1])[1:]
    hoenn = hoenn[: hoenn.index("DEOXYS") + 1]  # the rest is the national order for the in-game dex
    assert len(national) == 386, len(national)
    assert len(hoenn) == 202, len(hoenn)
    nat_of = {name: i + 1 for i, name in enumerate(national)}

    internal_to_nat = {species[n]: nat_of[n] for n in national if species[n] > 251}

    parent = {}
    for frm, body in re.findall(r"\[SPECIES_(\w+)\]\s*=\s*\{(.*?)\}\s*\}", (src / "evolution.h").read_text(), re.S):
        for to in re.findall(r"SPECIES_(\w+)", body):
            child = nat_of[to]
            assert parent.get(child, nat_of[frm]) == nat_of[frm], to
            parent[child] = nat_of[frm]

    def lua_map(d):
        return "{" + ",".join(f"[{k}]={v}" for k, v in sorted(d.items())) + "}"

    names = ",".join('"' + pretty(n).replace('"', '\\"') + '"' for n in national)
    special = {k: nat_of[k] for k in ("WURMPLE", "SILCOON", "BEAUTIFLY", "CASCOON", "DUSTOX", "NINCADA", "NINJASK", "SHEDINJA")}
    block = "\n".join([
        BEGIN + " (tools/gen_data.py, source: pret/pokeemerald)",
        "local NAMES = {" + names + "}",
        "local INTERNAL_TO_NAT = " + lua_map(internal_to_nat),
        "local PARENT = " + lua_map(parent),
        "local HOENN_DEX = {" + ",".join(str(nat_of[n]) for n in hoenn) + "}",
        "local SP = {" + ",".join(f"{k}={v}" for k, v in special.items()) + "}",
        END,
    ])

    text = TARGET.read_text(encoding="utf-8")
    start, stop = text.index(BEGIN), text.index(END) + len(END)
    TARGET.write_text(text[:start] + block + text[stop:], encoding="utf-8", newline="\n")
    print(f"wrote {len(national)} names, {len(internal_to_nat)} index remaps, {len(parent)} evolutions, {len(hoenn)} Hoenn dex")


if __name__ == "__main__":
    main(sys.argv[1])

-- Runs the save parser outside OBS with Lune (https://github.com/lune-org/lune):
--   lune run tools/test.luau <path to .sav>
local fs = require("@lune/fs")
local luau = require("@lune/luau")
local process = require("@lune/process")

local script = fs.readFile("shiny-counter.lua")
local env = setmetatable({ bit32 = bit32 }, { __index = getfenv() })
local Core = luau.load(script, { debugName = "shiny-counter.lua", environment = env })()

local path = process.args[1]
assert(path, "usage: lune run tools/test.luau <save.sav>")
local save, err = Core.parse(fs.readFile(path), true)
assert(save, err)
print(`game {save.game}, boxed {save.boxed}, party {save.party}`)

for _, dex in { "national", "regional" } do
	for _, shiny in { true, false } do
		local r = Core.progress(save.mons, { dex = dex, game = save.game, shiny_only = shiny })
		print(`{dex}, shiny only {shiny}: ` .. Core.format("{x} / {y} ({pct}%)  done {done}  to evolve {evolve}  missing {missing}  shinies {shinies}", r))
	end
end

local r = Core.progress(save.mons, { dex = "regional", game = save.game, shiny_only = true })
local lines = {}
for _, e in r.evolve_list do
	table.insert(lines, `{Core.NAMES[e.from]} -> {Core.NAMES[e.to]}`)
end
print("To evolve (Kanto, shiny): " .. table.concat(lines, ", "))
local missing = {}
for _, n in r.missing_list do
	table.insert(missing, Core.NAMES[n])
end
print("Missing (Kanto, shiny): " .. table.concat(missing, ", "))

-- Evolution rules on made-up boxes
local function mon(nat, pid) return { nat = nat, pid = pid or 0, shiny = true } end
local function check(name, mons, want_done, want_evolve)
	local r = Core.progress(mons, { dex = "national", game = "e", shiny_only = true })
	assert(r.done == want_done and r.evolve == want_evolve,
		`{name}: got done {r.done} evolve {r.evolve}, want {want_done}/{want_evolve}`)
	print(`ok  {name}`)
end
check("3 Bulbasaur cover the whole line", { mon(1), mon(1), mon(1) }, 1, 2)
check("Ivysaur can't fill Bulbasaur", { mon(2), mon(2) }, 1, 1)
check("4 Bulbasaur still only 3 entries", { mon(1), mon(1), mon(1), mon(1) }, 1, 2)
check("Eevee x3 picks 2 of 5 eeveelutions", { mon(133), mon(133), mon(133) }, 1, 2)
check("2 Nincada give Ninjask and Shedinja", { mon(290), mon(290) }, 1, 2)
check("1 Nincada only keeps itself", { mon(290) }, 1, 0)
check("Wurmple bound for Silcoon", { mon(265), mon(265, 0), mon(265, 0) }, 1, 2)
check("Wurmple bound for Cascoon", { mon(265), mon(265, 5 * 65536), mon(265, 5 * 65536) }, 1, 2)
check("Mixed Wurmple fill one of each step", { mon(265), mon(265, 0), mon(265, 5 * 65536) }, 1, 2)
check("2 Pichu: one kept, one to evolve", { mon(172), mon(172) }, 1, 1)

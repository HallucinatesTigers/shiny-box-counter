--[[
Shiny Box Counter for OBS, by HallucinatesTigers
https://github.com/HallucinatesTigers/shiny-box-counter

Watches a folder for the newest Gen 3 Pokémon save (Ruby, Sapphire, Emerald, FireRed, LeafGreen),
reads the PC boxes and party, and writes dex progress like "212 / 386" into OBS text sources.

A Pokémon that can still evolve into a missing dex entry counts toward that entry
(three Bulbasaur cover Bulbasaur, Ivysaur and Venusaur), and the number still waiting
to be evolved can be shown on its own.

Install: OBS -> Tools -> Scripts -> "+" -> pick this file. MIT license.
]]

local bit = bit or bit32 -- LuaJIT in OBS has `bit`; the test runner (Luau) has `bit32`

-- BEGIN GENERATED DATA (tools/gen_data.py, source: pret/pokeemerald)
local NAMES = {"Bulbasaur","Ivysaur","Venusaur","Charmander","Charmeleon","Charizard","Squirtle","Wartortle","Blastoise","Caterpie","Metapod","Butterfree","Weedle","Kakuna","Beedrill","Pidgey","Pidgeotto","Pidgeot","Rattata","Raticate","Spearow","Fearow","Ekans","Arbok","Pikachu","Raichu","Sandshrew","Sandslash","Nidoran♀","Nidorina","Nidoqueen","Nidoran♂","Nidorino","Nidoking","Clefairy","Clefable","Vulpix","Ninetales","Jigglypuff","Wigglytuff","Zubat","Golbat","Oddish","Gloom","Vileplume","Paras","Parasect","Venonat","Venomoth","Diglett","Dugtrio","Meowth","Persian","Psyduck","Golduck","Mankey","Primeape","Growlithe","Arcanine","Poliwag","Poliwhirl","Poliwrath","Abra","Kadabra","Alakazam","Machop","Machoke","Machamp","Bellsprout","Weepinbell","Victreebel","Tentacool","Tentacruel","Geodude","Graveler","Golem","Ponyta","Rapidash","Slowpoke","Slowbro","Magnemite","Magneton","Farfetch'd","Doduo","Dodrio","Seel","Dewgong","Grimer","Muk","Shellder","Cloyster","Gastly","Haunter","Gengar","Onix","Drowzee","Hypno","Krabby","Kingler","Voltorb","Electrode","Exeggcute","Exeggutor","Cubone","Marowak","Hitmonlee","Hitmonchan","Lickitung","Koffing","Weezing","Rhyhorn","Rhydon","Chansey","Tangela","Kangaskhan","Horsea","Seadra","Goldeen","Seaking","Staryu","Starmie","Mr. Mime","Scyther","Jynx","Electabuzz","Magmar","Pinsir","Tauros","Magikarp","Gyarados","Lapras","Ditto","Eevee","Vaporeon","Jolteon","Flareon","Porygon","Omanyte","Omastar","Kabuto","Kabutops","Aerodactyl","Snorlax","Articuno","Zapdos","Moltres","Dratini","Dragonair","Dragonite","Mewtwo","Mew","Chikorita","Bayleef","Meganium","Cyndaquil","Quilava","Typhlosion","Totodile","Croconaw","Feraligatr","Sentret","Furret","Hoothoot","Noctowl","Ledyba","Ledian","Spinarak","Ariados","Crobat","Chinchou","Lanturn","Pichu","Cleffa","Igglybuff","Togepi","Togetic","Natu","Xatu","Mareep","Flaaffy","Ampharos","Bellossom","Marill","Azumarill","Sudowoodo","Politoed","Hoppip","Skiploom","Jumpluff","Aipom","Sunkern","Sunflora","Yanma","Wooper","Quagsire","Espeon","Umbreon","Murkrow","Slowking","Misdreavus","Unown","Wobbuffet","Girafarig","Pineco","Forretress","Dunsparce","Gligar","Steelix","Snubbull","Granbull","Qwilfish","Scizor","Shuckle","Heracross","Sneasel","Teddiursa","Ursaring","Slugma","Magcargo","Swinub","Piloswine","Corsola","Remoraid","Octillery","Delibird","Mantine","Skarmory","Houndour","Houndoom","Kingdra","Phanpy","Donphan","Porygon2","Stantler","Smeargle","Tyrogue","Hitmontop","Smoochum","Elekid","Magby","Miltank","Blissey","Raikou","Entei","Suicune","Larvitar","Pupitar","Tyranitar","Lugia","Ho-Oh","Celebi","Treecko","Grovyle","Sceptile","Torchic","Combusken","Blaziken","Mudkip","Marshtomp","Swampert","Poochyena","Mightyena","Zigzagoon","Linoone","Wurmple","Silcoon","Beautifly","Cascoon","Dustox","Lotad","Lombre","Ludicolo","Seedot","Nuzleaf","Shiftry","Taillow","Swellow","Wingull","Pelipper","Ralts","Kirlia","Gardevoir","Surskit","Masquerain","Shroomish","Breloom","Slakoth","Vigoroth","Slaking","Nincada","Ninjask","Shedinja","Whismur","Loudred","Exploud","Makuhita","Hariyama","Azurill","Nosepass","Skitty","Delcatty","Sableye","Mawile","Aron","Lairon","Aggron","Meditite","Medicham","Electrike","Manectric","Plusle","Minun","Volbeat","Illumise","Roselia","Gulpin","Swalot","Carvanha","Sharpedo","Wailmer","Wailord","Numel","Camerupt","Torkoal","Spoink","Grumpig","Spinda","Trapinch","Vibrava","Flygon","Cacnea","Cacturne","Swablu","Altaria","Zangoose","Seviper","Lunatone","Solrock","Barboach","Whiscash","Corphish","Crawdaunt","Baltoy","Claydol","Lileep","Cradily","Anorith","Armaldo","Feebas","Milotic","Castform","Kecleon","Shuppet","Banette","Duskull","Dusclops","Tropius","Chimecho","Absol","Wynaut","Snorunt","Glalie","Spheal","Sealeo","Walrein","Clamperl","Huntail","Gorebyss","Relicanth","Luvdisc","Bagon","Shelgon","Salamence","Beldum","Metang","Metagross","Regirock","Regice","Registeel","Latias","Latios","Kyogre","Groudon","Rayquaza","Jirachi","Deoxys"}
local INTERNAL_TO_NAT = {[277]=252,[278]=253,[279]=254,[280]=255,[281]=256,[282]=257,[283]=258,[284]=259,[285]=260,[286]=261,[287]=262,[288]=263,[289]=264,[290]=265,[291]=266,[292]=267,[293]=268,[294]=269,[295]=270,[296]=271,[297]=272,[298]=273,[299]=274,[300]=275,[301]=290,[302]=291,[303]=292,[304]=276,[305]=277,[306]=285,[307]=286,[308]=327,[309]=278,[310]=279,[311]=283,[312]=284,[313]=320,[314]=321,[315]=300,[316]=301,[317]=352,[318]=343,[319]=344,[320]=299,[321]=324,[322]=302,[323]=339,[324]=340,[325]=370,[326]=341,[327]=342,[328]=349,[329]=350,[330]=318,[331]=319,[332]=328,[333]=329,[334]=330,[335]=296,[336]=297,[337]=309,[338]=310,[339]=322,[340]=323,[341]=363,[342]=364,[343]=365,[344]=331,[345]=332,[346]=361,[347]=362,[348]=337,[349]=338,[350]=298,[351]=325,[352]=326,[353]=311,[354]=312,[355]=303,[356]=307,[357]=308,[358]=333,[359]=334,[360]=360,[361]=355,[362]=356,[363]=315,[364]=287,[365]=288,[366]=289,[367]=316,[368]=317,[369]=357,[370]=293,[371]=294,[372]=295,[373]=366,[374]=367,[375]=368,[376]=359,[377]=353,[378]=354,[379]=336,[380]=335,[381]=369,[382]=304,[383]=305,[384]=306,[385]=351,[386]=313,[387]=314,[388]=345,[389]=346,[390]=347,[391]=348,[392]=280,[393]=281,[394]=282,[395]=371,[396]=372,[397]=373,[398]=374,[399]=375,[400]=376,[401]=377,[402]=378,[403]=379,[404]=382,[405]=383,[406]=384,[407]=380,[408]=381,[409]=385,[410]=386,[411]=358}
local PARENT = {[2]=1,[3]=2,[5]=4,[6]=5,[8]=7,[9]=8,[11]=10,[12]=11,[14]=13,[15]=14,[17]=16,[18]=17,[20]=19,[22]=21,[24]=23,[25]=172,[26]=25,[28]=27,[30]=29,[31]=30,[33]=32,[34]=33,[35]=173,[36]=35,[38]=37,[39]=174,[40]=39,[42]=41,[44]=43,[45]=44,[47]=46,[49]=48,[51]=50,[53]=52,[55]=54,[57]=56,[59]=58,[61]=60,[62]=61,[64]=63,[65]=64,[67]=66,[68]=67,[70]=69,[71]=70,[73]=72,[75]=74,[76]=75,[78]=77,[80]=79,[82]=81,[85]=84,[87]=86,[89]=88,[91]=90,[93]=92,[94]=93,[97]=96,[99]=98,[101]=100,[103]=102,[105]=104,[106]=236,[107]=236,[110]=109,[112]=111,[117]=116,[119]=118,[121]=120,[124]=238,[125]=239,[126]=240,[130]=129,[134]=133,[135]=133,[136]=133,[139]=138,[141]=140,[148]=147,[149]=148,[153]=152,[154]=153,[156]=155,[157]=156,[159]=158,[160]=159,[162]=161,[164]=163,[166]=165,[168]=167,[169]=42,[171]=170,[176]=175,[178]=177,[180]=179,[181]=180,[182]=44,[183]=298,[184]=183,[186]=61,[188]=187,[189]=188,[192]=191,[195]=194,[196]=133,[197]=133,[199]=79,[202]=360,[205]=204,[208]=95,[210]=209,[212]=123,[217]=216,[219]=218,[221]=220,[224]=223,[229]=228,[230]=117,[232]=231,[233]=137,[237]=236,[242]=113,[247]=246,[248]=247,[253]=252,[254]=253,[256]=255,[257]=256,[259]=258,[260]=259,[262]=261,[264]=263,[266]=265,[267]=266,[268]=265,[269]=268,[271]=270,[272]=271,[274]=273,[275]=274,[277]=276,[279]=278,[281]=280,[282]=281,[284]=283,[286]=285,[288]=287,[289]=288,[291]=290,[292]=290,[294]=293,[295]=294,[297]=296,[301]=300,[305]=304,[306]=305,[308]=307,[310]=309,[317]=316,[319]=318,[321]=320,[323]=322,[326]=325,[329]=328,[330]=329,[332]=331,[334]=333,[340]=339,[342]=341,[344]=343,[346]=345,[348]=347,[350]=349,[354]=353,[356]=355,[362]=361,[364]=363,[365]=364,[367]=366,[368]=366,[372]=371,[373]=372,[375]=374,[376]=375}
local HOENN_DEX = {252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,63,64,65,290,291,292,293,294,295,296,297,118,119,129,130,298,183,184,74,75,76,299,300,301,41,42,169,72,73,302,303,304,305,306,66,67,68,307,308,309,310,311,312,81,82,100,101,313,314,43,44,45,182,84,85,315,316,317,318,319,320,321,322,323,218,219,324,88,89,109,110,325,326,27,28,327,227,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,174,39,40,349,350,351,120,121,352,353,354,355,356,357,358,359,37,38,172,25,26,54,55,360,202,177,178,203,231,232,127,214,111,112,361,362,363,364,365,366,367,368,369,222,170,171,370,116,117,230,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386}
local SP = {WURMPLE=265,SILCOON=266,BEAUTIFLY=267,CASCOON=268,DUSTOX=269,NINCADA=290,NINJASK=291,SHEDINJA=292}
-- END GENERATED DATA

local Core = { NAMES = NAMES }

------------------------------------------------------------------------------------------
-- Save reading
------------------------------------------------------------------------------------------

local SAVE_SIZE = 0x20000
local SECTOR = 0x1000
local SIGNATURE = 0x08012025
local PC_SECTOR_SIZES = { [5] = 3968, [6] = 3968, [7] = 3968, [8] = 3968, [9] = 3968,
	[10] = 3968, [11] = 3968, [12] = 3968, [13] = 2000 }
local ORDERS = { "GAEM", "GAME", "GEAM", "GEMA", "GMAE", "GMEA", "AGEM", "AGME", "AEGM", "AEMG", "AMGE", "AMEG",
	"EGAM", "EGMA", "EAGM", "EAMG", "EMGA", "EMAG", "MGAE", "MGEA", "MAGE", "MAEG", "MEGA", "MEAG" }

local function u16(s, o)
	local a, b = s:byte(o + 1, o + 2)
	return a + b * 256
end

local function u32(s, o)
	local a, b, c, d = s:byte(o + 1, o + 4)
	return a + b * 256 + c * 65536 + d * 16777216
end

local function sector_checksum(s, o, size)
	local sum = 0
	for i = 0, size - 4, 4 do
		sum = sum + u32(s, o + i)
	end
	sum = sum % 4294967296
	return (math.floor(sum / 65536) + sum % 65536) % 65536
end

-- Returns {sectorId -> byte offset} for the newest intact save slot, or nil.
local function pick_slot(s)
	local best, best_index
	for _, base in ipairs({ 0, 0xE000 }) do
		local map, index, ok = {}, nil, true
		for i = 0, 13 do
			local o = base + i * SECTOR
			if u32(s, o + 0xFF8) ~= SIGNATURE then ok = false break end
			map[u16(s, o + 0xFF4)] = o
			index = u32(s, o + 0xFFC)
		end
		for id = 0, 13 do
			if not map[id] then ok = false break end
		end
		if ok then
			for id, size in pairs(PC_SECTOR_SIZES) do
				if sector_checksum(s, map[id], size) ~= u16(s, map[id] + 0xFF6) then ok = false break end
			end
		end
		if ok and (not best_index or index > best_index) then
			best, best_index = map, index
		end
	end
	return best
end

-- Reads one Pokémon (first 80 bytes of the box/party format). Returns nil for empty slots,
-- eggs, bad eggs and anything that fails its checksum.
local function read_mon(s, o)
	local pid, otid = u32(s, o), u32(s, o + 4)
	if pid == 0 and otid == 0 then return nil end
	if bit.band(s:byte(o + 20), 1) == 1 then return nil end -- bad egg
	local key = bit.bxor(pid, otid)
	local words, sum = {}, 0
	for i = 0, 11 do
		local w = bit.bxor(u32(s, o + 32 + i * 4), key)
		words[i] = w
		sum = sum + bit.band(w, 0xFFFF) + bit.band(bit.rshift(w, 16), 0xFFFF)
	end
	if sum % 65536 ~= u16(s, o + 28) then return nil end
	local order = ORDERS[pid % 24 + 1]
	local g = (order:find("G") - 1) * 3
	local m = (order:find("M") - 1) * 3
	if bit.band(bit.rshift(words[m + 1], 30), 1) == 1 then return nil end -- egg
	local internal = bit.band(words[g], 0xFFFF)
	local nat = (internal >= 1 and internal <= 251) and internal or INTERNAL_TO_NAT[internal]
	if not nat then return nil end
	local tsv = bit.bxor(bit.band(otid, 0xFFFF), math.floor(otid / 65536))
	local psv = bit.bxor(pid % 65536, math.floor(pid / 65536))
	return { nat = nat, pid = pid, shiny = bit.bxor(tsv, psv) < 8 }
end

-- Parses a whole .sav string. Returns {game = "frlg"|"rs"|"e", mons = {...}, boxed = n, party = n}
-- or nil, reason.
function Core.parse(s, include_party)
	if type(s) ~= "string" or #s < SAVE_SIZE then return nil, "not a 128 KB Gen 3 save" end
	local map = pick_slot(s)
	if not map then return nil, "no intact save slot (save still being written?)" end

	local code = u32(s, map[0] + 0xAC)
	local game = code == 1 and "frlg" or (code == 0 and "rs" or "e")

	local pc = {}
	for id = 5, 13 do
		pc[#pc + 1] = s:sub(map[id] + 1, map[id] + PC_SECTOR_SIZES[id])
	end
	pc = table.concat(pc)

	local mons, boxed, party = {}, 0, 0
	for slot = 0, 14 * 30 - 1 do
		local mon = read_mon(pc, 4 + slot * 80)
		if mon then mons[#mons + 1] = mon; boxed = boxed + 1 end
	end
	if include_party then
		local base = map[1] + (game == "frlg" and 0x34 or 0x234)
		local n = math.min(u32(s, base), 6)
		for i = 0, n - 1 do
			local mon = read_mon(s, base + 4 + i * 100)
			if mon then mons[#mons + 1] = mon; party = party + 1 end
		end
	end
	return { game = game, mons = mons, boxed = boxed, party = party }
end

------------------------------------------------------------------------------------------
-- Dex progress
------------------------------------------------------------------------------------------

local function dex_slots(dex, game)
	local list = {}
	if dex == "regional" and game == "frlg" then
		for i = 1, 151 do list[#list + 1] = i end
	elseif dex == "regional" then
		for i, n in ipairs(HOENN_DEX) do list[i] = n end
	else
		for i = 1, 386 do list[#list + 1] = i end
	end
	return list
end

-- Wurmple's evolution is fixed by its personality value.
local function wurmple_ok(mon, target)
	local silcoon_line = target == SP.SILCOON or target == SP.BEAUTIFLY
	local cascoon_line = target == SP.CASCOON or target == SP.DUSTOX
	if not (silcoon_line or cascoon_line) then return true end
	local goes_silcoon = math.floor(mon.pid / 65536) % 10 <= 4
	return goes_silcoon == silcoon_line
end

-- Can this Pokémon still evolve into `target`?
local function can_evolve_into(mon, target)
	local p = PARENT[target]
	while p do
		if p == mon.nat then
			return mon.nat ~= SP.WURMPLE or wurmple_ok(mon, target)
		end
		p = PARENT[p]
	end
	return false
end

--[[
opts: dex = "national" | "regional", game = "frlg" | "rs" | "e", shiny_only = bool
Each owned Pokémon fills at most one dex entry: its own species first, otherwise an entry it can
still evolve into (best possible assignment). A spare Nincada also covers Shedinja, since one
Nincada evolving gives both.
]]
function Core.progress(mons, opts)
	local slots = dex_slots(opts.dex, opts.game)
	local in_dex = {}
	for _, n in ipairs(slots) do in_dex[n] = true end

	local pool, shinies = {}, 0
	for _, m in ipairs(mons) do
		if m.shiny then shinies = shinies + 1 end
		if m.shiny or not opts.shiny_only then pool[#pool + 1] = m end
	end

	-- 1. exact matches
	local done, spare, used = {}, {}, {}
	for _, m in ipairs(pool) do
		if in_dex[m.nat] and not done[m.nat] then
			done[m.nat] = true
		else
			spare[#spare + 1] = m
		end
	end

	-- 2. best matching of spare Pokémon to entries they can evolve into (augmenting paths)
	local open = {}
	for _, n in ipairs(slots) do
		if not done[n] and n ~= SP.SHEDINJA then open[#open + 1] = n end
	end
	local cands = {}
	for _, n in ipairs(open) do
		local c = {}
		for j, m in ipairs(spare) do
			if can_evolve_into(m, n) then c[#c + 1] = j end
		end
		cands[n] = c
	end
	local owner = {} -- spare index -> dex entry it is assigned to
	local function try(n, seen)
		for _, j in ipairs(cands[n]) do
			if not seen[j] then
				seen[j] = true
				if not owner[j] or try(owner[j], seen) then
					owner[j] = n
					return true
				end
			end
		end
		return false
	end
	for _, n in ipairs(open) do
		if #cands[n] > 0 then try(n, {}) end
	end
	local evolve = {} -- dex entry -> the Pokémon that will evolve into it
	for j, n in pairs(owner) do evolve[n] = spare[j] end

	-- 3. Shedinja comes free with any Nincada that isn't keeping the Nincada entry
	if in_dex[SP.SHEDINJA] and not done[SP.SHEDINJA] then
		for j, m in ipairs(spare) do
			if m.nat == SP.NINCADA and (not owner[j] or owner[j] == SP.NINJASK) then
				evolve[SP.SHEDINJA] = m
				break
			end
		end
	end

	local r = { y = #slots, done = 0, evolve = 0, missing = 0, shinies = shinies, total = #mons,
		missing_list = {}, evolve_list = {} }
	for _, n in ipairs(slots) do
		if done[n] then
			r.done = r.done + 1
		elseif evolve[n] then
			r.evolve = r.evolve + 1
			r.evolve_list[#r.evolve_list + 1] = { from = evolve[n].nat, to = n }
		else
			r.missing = r.missing + 1
			r.missing_list[#r.missing_list + 1] = n
		end
	end
	r.x = r.done + ((opts.count_evolve == false) and 0 or r.evolve)
	r.pct = r.y > 0 and math.floor(r.x / r.y * 1000 + 0.5) / 10 or 0
	return r
end

local GAME_NAMES = { frlg = "FireRed/LeafGreen", rs = "Ruby/Sapphire", e = "Emerald" }

-- Fills {tokens} in a format string. "\n" in the format becomes a line break.
function Core.format(fmt, r, extra)
	fmt = (fmt or ""):gsub("\\n", "\n")
	return (fmt:gsub("{([%w_]+)}", function(k)
		if r[k] ~= nil and type(r[k]) ~= "table" then return tostring(r[k]) end
		if extra and extra[k] ~= nil then return tostring(extra[k]) end
		if k == "game" and r.game then return GAME_NAMES[r.game] end
		return "{" .. k .. "}"
	end))
end

if not obslua then
	return Core -- loaded outside OBS (tests)
end

------------------------------------------------------------------------------------------
-- OBS
------------------------------------------------------------------------------------------

local obs = obslua
local ffi = require("ffi")
local IS_WINDOWS = ffi.os == "Windows"

local cfg = {}
local last_key -- path|mtime|size|settings of the last save shown
local last_skipped -- same, for the last save that couldn't be read (logged once)
local last_text = {}

if IS_WINDOWS then
	pcall(ffi.cdef, [[
		typedef struct {
			uint32_t attrs;
			uint32_t created_lo, created_hi, accessed_lo, accessed_hi, written_lo, written_hi;
			uint32_t size_hi, size_lo;
			uint32_t reserved0, reserved1;
			uint16_t name[260];
			uint16_t alt_name[14];
		} SBC_FIND_DATA;
		void* FindFirstFileW(const uint16_t* pattern, SBC_FIND_DATA* data);
		int FindNextFileW(void* handle, SBC_FIND_DATA* data);
		int FindClose(void* handle);
		void* CreateFileW(const uint16_t* name, uint32_t access, uint32_t share, void* sec,
			uint32_t disposition, uint32_t flags, void* template);
		int ReadFile(void* h, void* buf, uint32_t n, uint32_t* read, void* overlapped);
		int CloseHandle(void* h);
		int MultiByteToWideChar(uint32_t cp, uint32_t flags, const char* s, int n, uint16_t* out, int outn);
		int WideCharToMultiByte(uint32_t cp, uint32_t flags, const uint16_t* s, int n, char* out, int outn,
			const char* def, int* used);
	]])
end

local function invalid_handle(h)
	return h == nil or ffi.cast("intptr_t", h) == -1
end

local function to_wide(str)
	local n = ffi.C.MultiByteToWideChar(65001, 0, str, -1, nil, 0)
	local buf = ffi.new("uint16_t[?]", n)
	ffi.C.MultiByteToWideChar(65001, 0, str, -1, buf, n)
	return buf
end

local function from_wide(w)
	local n = ffi.C.WideCharToMultiByte(65001, 0, w, -1, nil, 0, nil, nil)
	local buf = ffi.new("char[?]", n)
	ffi.C.WideCharToMultiByte(65001, 0, w, -1, buf, n, nil, nil)
	return ffi.string(buf)
end

-- Newest file in `dir` matching `pattern`: returns path, stamp (mtime|size) or nil.
local function newest_file(dir, pattern)
	if IS_WINDOWS then
		local data = ffi.new("SBC_FIND_DATA")
		local h = ffi.C.FindFirstFileW(to_wide(dir .. "\\" .. pattern), data)
		if invalid_handle(h) then return nil end
		local best, best_time, best_size
		repeat
			if bit.band(data.attrs, 0x10) == 0 then
				local t = data.written_hi * 4294967296 + data.written_lo
				if not best_time or t > best_time then
					best, best_time, best_size = from_wide(data.name), t, data.size_lo
				end
			end
		until ffi.C.FindNextFileW(h, data) == 0
		ffi.C.FindClose(h)
		if best then return dir .. "\\" .. best, best_time .. "|" .. best_size end
		return nil
	end
	local p = io.popen('ls -t "' .. dir .. '"/' .. pattern .. " 2>/dev/null")
	if not p then return nil end
	local first = p:read("*l")
	p:close()
	return first, nil
end

local function read_file(path)
	if IS_WINDOWS then
		-- share read/write/delete so the emulator or bot is never blocked from saving
		local h = ffi.C.CreateFileW(to_wide(path), 0x80000000, 7, nil, 3, 0x80, nil)
		if invalid_handle(h) then return nil end
		local cap = 0x40000
		local buf = ffi.new("uint8_t[?]", cap)
		local got = ffi.new("uint32_t[1]")
		local ok = ffi.C.ReadFile(h, buf, cap, got, nil)
		ffi.C.CloseHandle(h)
		if ok == 0 then return nil end
		return ffi.string(buf, got[0])
	end
	local f = io.open(path, "rb")
	if not f then return nil end
	local s = f:read("*a")
	f:close()
	return s
end

-- Returns false if the source doesn't exist (yet), so the caller retries on the next tick.
local function set_text(source_name, text)
	if not source_name or source_name == "" or last_text[source_name] == text then return true end
	local src = obs.obs_get_source_by_name(source_name)
	if not src then return false end
	local data = obs.obs_data_create()
	obs.obs_data_set_string(data, "text", text)
	obs.obs_source_update(src, data)
	obs.obs_data_release(data)
	obs.obs_source_release(src)
	last_text[source_name] = text
	return true
end

local function refresh(force)
	if not cfg.folder or cfg.folder == "" then return end
	local path, stamp = newest_file(cfg.folder, cfg.pattern ~= "" and cfg.pattern or "*.sav")
	if not path then return end
	local key = table.concat({ path, stamp or os.time(), cfg.signature }, "|")
	if key == last_key and not force then return end

	local save, err = Core.parse(read_file(path) or "", cfg.include_party)
	if not save then
		if key ~= last_skipped then
			print("[shiny counter] skipped " .. path .. ": " .. tostring(err))
			last_skipped = key
		end
		return -- keep the last good numbers; retry next tick
	end
	local game = cfg.game == "auto" and save.game or cfg.game
	local r = Core.progress(save.mons, {
		dex = cfg.dex, game = game, shiny_only = cfg.shiny_only, count_evolve = cfg.count_evolve,
	})
	r.game = game
	local evolve_names, missing_names = {}, {}
	for _, e in ipairs(r.evolve_list) do
		evolve_names[#evolve_names + 1] = NAMES[e.from] .. " > " .. NAMES[e.to]
	end
	for _, n in ipairs(r.missing_list) do missing_names[#missing_names + 1] = NAMES[n] end
	local extra = { file = path:match("[^\\/]+$"), boxed = save.boxed, party = save.party,
		evolve_names = table.concat(evolve_names, ", "), missing_names = table.concat(missing_names, ", ") }
	local ok_main = set_text(cfg.main_source, Core.format(cfg.main_format, r, extra))
	local ok_evolve = set_text(cfg.evolve_source, Core.format(cfg.evolve_format, r, extra))
	if ok_main and ok_evolve then
		last_key = key
		print(string.format("[shiny counter] %s: %d / %d (%d to evolve)", extra.file, r.x, r.y, r.evolve))
	end
end

local function tick() refresh(false) end

function script_description()
	return [[<b>Shiny Box Counter</b> by HallucinatesTigers<br>
Reads the newest Gen 3 save in a folder and shows dex progress in text sources.<br>
Tokens: {x} {y} {done} {evolve} {missing} {pct} {shinies} {total} {boxed} {party} {game} {file}
{evolve_names} {missing_names}. Use \n for a new line.]]
end

local function add_text_sources(list)
	obs.obs_property_list_add_string(list, "(none)", "")
	local sources = obs.obs_enum_sources()
	if sources then
		for _, src in ipairs(sources) do
			local id = obs.obs_source_get_unversioned_id(src)
			if id == "text_gdiplus" or id == "text_ft2_source" then
				local name = obs.obs_source_get_name(src)
				obs.obs_property_list_add_string(list, name, name)
			end
		end
		obs.source_list_release(sources)
	end
end

function script_properties()
	local p = obs.obs_properties_create()
	obs.obs_properties_add_path(p, "folder", "Save folder", obs.OBS_PATH_DIRECTORY, nil, nil)
	obs.obs_properties_add_text(p, "pattern", "File pattern", obs.OBS_TEXT_DEFAULT)

	local game = obs.obs_properties_add_list(p, "game", "Game", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
	obs.obs_property_list_add_string(game, "Detect from save", "auto")
	obs.obs_property_list_add_string(game, "FireRed / LeafGreen", "frlg")
	obs.obs_property_list_add_string(game, "Ruby / Sapphire", "rs")
	obs.obs_property_list_add_string(game, "Emerald", "e")

	local dex = obs.obs_properties_add_list(p, "dex", "Goal", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
	obs.obs_property_list_add_string(dex, "National Dex (386)", "national")
	obs.obs_property_list_add_string(dex, "Regional Dex (Kanto 151 / Hoenn 202)", "regional")

	obs.obs_properties_add_bool(p, "shiny_only", "Only count shinies")
	obs.obs_properties_add_bool(p, "include_party", "Include the party")
	obs.obs_properties_add_bool(p, "count_evolve", "Count Pokémon that still need evolving toward {x}")

	local main = obs.obs_properties_add_list(p, "main_source", "Counter text source",
		obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
	add_text_sources(main)
	obs.obs_properties_add_text(p, "main_format", "Counter format", obs.OBS_TEXT_DEFAULT)

	local evo = obs.obs_properties_add_list(p, "evolve_source", "\"To evolve\" text source (optional)",
		obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
	add_text_sources(evo)
	obs.obs_properties_add_text(p, "evolve_format", "\"To evolve\" format", obs.OBS_TEXT_DEFAULT)

	obs.obs_properties_add_int(p, "interval", "Check every (seconds)", 1, 300, 1)
	obs.obs_properties_add_button(p, "refresh", "Update now", function()
		last_text = {}
		refresh(true)
		return false
	end)
	return p
end

function script_defaults(s)
	obs.obs_data_set_default_string(s, "pattern", "*.sav")
	obs.obs_data_set_default_string(s, "game", "auto")
	obs.obs_data_set_default_string(s, "dex", "national")
	obs.obs_data_set_default_bool(s, "shiny_only", true)
	obs.obs_data_set_default_bool(s, "include_party", true)
	obs.obs_data_set_default_bool(s, "count_evolve", true)
	obs.obs_data_set_default_string(s, "main_format", "{x} / {y}")
	obs.obs_data_set_default_string(s, "evolve_format", "To evolve: {evolve}")
	obs.obs_data_set_default_int(s, "interval", 5)
end

function script_update(s)
	cfg = {
		folder = obs.obs_data_get_string(s, "folder"),
		pattern = obs.obs_data_get_string(s, "pattern"),
		game = obs.obs_data_get_string(s, "game"),
		dex = obs.obs_data_get_string(s, "dex"),
		shiny_only = obs.obs_data_get_bool(s, "shiny_only"),
		include_party = obs.obs_data_get_bool(s, "include_party"),
		count_evolve = obs.obs_data_get_bool(s, "count_evolve"),
		main_source = obs.obs_data_get_string(s, "main_source"),
		main_format = obs.obs_data_get_string(s, "main_format"),
		evolve_source = obs.obs_data_get_string(s, "evolve_source"),
		evolve_format = obs.obs_data_get_string(s, "evolve_format"),
		interval = obs.obs_data_get_int(s, "interval"),
	}
	cfg.signature = table.concat({ cfg.game, cfg.dex, tostring(cfg.shiny_only), tostring(cfg.include_party),
		tostring(cfg.count_evolve), cfg.main_source, cfg.main_format, cfg.evolve_source, cfg.evolve_format }, "|")
	last_text = {}
	obs.timer_remove(tick)
	obs.timer_add(tick, math.max(1, cfg.interval) * 1000)
	refresh(true)
end

function script_unload()
	obs.timer_remove(tick)
end

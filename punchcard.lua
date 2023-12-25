-- TODO technic power reqs
-- TODO detect whether sent an off signal via mesecons or digilines, and respond "accordingly"

local MODNAME = minetest.get_current_modname()
local MP      = minetest.get_modpath(MODNAME)
local S       = minetest.get_translator(MODNAME)

minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
    if itemstack:get_name():sub(1, 7) ~= "iaroko:" then return nil end

    --print('old_craft_grid: ' .. dump(old_craft_grid))
    --print('craft_inv: ' .. dump(craft_inv))
    local contributors = {}
    for _, stack in ipairs(old_craft_grid) do
        local meta = stack:get_meta()
        local contrib = meta:get_string("contributors")
        contrib = minetest.deserialize(contrib)
        insert_all(contributors, contrib)
    end

    contributors[player:get_player_name()] = true

    print('contributors: ' .. dump(contributors))
    local meta = itemstack:get_meta()
    contributors = minetest.serialize(table_to_array(contributors))
    meta:set_string("contributors", contributors)
    return itemstack
end)

iaroko.register_punchcard = function(name, description, on_use)
	assert(name ~= nil)
	assert(description ~= nil)
	--assert(image ~= nil)
	--assert(on_use ~= nil)
	local def           = table.copy(minetest.registered_items["default:paper"])
	--def.name = name
	def.description     = description
	--def.groups          =  {hard = 1, metal = 1,}
	--def.tiles           = {image,}
	--def.overlay_tiles   = {}
	--def.special_tiles   = {}
	--def.wield_image     = image
	--def.inventory_image = image
	def.on_use          = on_use

	--def.groups          = {not_in_creative_inventory=1,}
	def.groups.punchcard = 1

	--minetest.register_craftitem(name, def)
	minetest.register_tool(name, def)
	-- TODO on place...
	--minetest.register_node(name, def)
end

-- TODO image
local punchcard = "iaroko:punchcard"
iaroko.register_punchcard(punchcard, S("Punch Card"), iaroko.on_use)

-- TODO fuel
minetest.register_craft({
   type         = "shaped",
   output       = punchcard..' 1',
   recipe       = {
	   { "", "default:paper", "", },
	   { "", "default:paper", "", },
	   { "", "default:paper", "", },
   },
})

iaroko.register_subroutine = function(name, description)--, on_use)
	assert(name ~= nil)
	assert(description ~= nil)
	--assert(image ~= nil)
	--assert(on_use ~= nil)
	local def           = table.copy(minetest.registered_items["default:paper"])
	--def.name = name
	def.description     = description
	--def.groups          =  {hard = 1, metal = 1,}
	--def.tiles           = {image,}
	--def.overlay_tiles   = {}
	--def.special_tiles   = {}
	--def.wield_image     = image
	--def.inventory_image = image
	--def.on_use          = on_use

	--def.groups          = {not_in_creative_inventory=1,}
	def.groups.not_in_creative_inventory = 1
	def.groups.punchcard  = 2
	def.groups.subroutine = 1

	--minetest.register_craftitem(name, def)
	minetest.register_tool(name, def)
	-- TODO on place...
	--minetest.register_node(name, def)
end

local N = 1000
for n=1,N do
	local subroutine = "iaroko:subroutine_"..n
	iaroko.register_subroutine (subroutine, S("Subroutine "..n)) -- TODO proper S-string
	iaroko.register_replacement(punchcard, subroutine, n)
end

iaroko.register_library = function(name, description)--, on_use)
	assert(name ~= nil)
	assert(description ~= nil)
	--assert(image ~= nil)
	--assert(on_use ~= nil)
	local def           = table.copy(minetest.registered_items["default:paper"])
	--def.name = name
	def.description     = description
	--def.groups          =  {hard = 1, metal = 1,}
	--def.tiles           = {image,}
	--def.overlay_tiles   = {}
	--def.special_tiles   = {}
	--def.wield_image     = image
	--def.inventory_image = image
	--def.on_use          = on_use

	--def.groups          = {not_in_creative_inventory=1,}
	def.groups.not_in_creative_inventory = 1
	def.groups.punchcard  = 3
	def.groups.subroutine = 2
	def.groups.library    = 1

	--minetest.register_craftitem(name, def)
	minetest.register_tool(name, def)
	-- TODO on place...
	--minetest.register_node(name, def)
end

--
-- Bad Libs
--

local recipe = {}
for i=1,9 do
	local library = "iaroko:library_"..i
	iaroko.register_library(library, S("Library "..i)) -- TODO proper S-string
	table.insert(recipe, "group:subroutine")
	minetest.register_craft({
		type   = "shapeless",
		output = library,
		recipe = recipe,
	})
end

--
-- Good Libs
--

function combinations(elements, r)
    if r == 0 then
        return {{}}
    end
    if #elements == 0 then
        return {}
    end

    local result = {}
    for i = 1, #elements do
        local current = elements[i]
        local remaining = {}
        for j = i + 1, #elements do
            remaining[#remaining + 1] = elements[j]
        end
        local combs = combinations(remaining, r - 1)
        for _, combination in ipairs(combs) do
            local comb = {current}
            for _, element in ipairs(combination) do
                comb[#comb + 1] = element
            end
            result[#result + 1] = comb
        end
    end
    return result
end

function generate_permutations(m)
    local grid = {}
    for i = 1, 3 do
        grid[i] = {}
        for j = 1, 3 do
            grid[i][j] = false
        end
    end

    local indices = {1, 2, 3, 4, 5, 6, 7, 8, 9}
    local combs = combinations(indices, m)
    local permutations = {}
    for _, combination in ipairs(combs) do
        for _, index in ipairs(combination) do
            local x = math.floor((index - 1) / 3) + 1
            local y = (index - 1) % 3 + 1
            grid[x][y] = true
        end
        local permutation = {}
        for i = 1, #grid do
            permutation[i] = {}
            for j = 1, #grid[i] do
                permutation[i][j] = grid[i][j]
            end
        end
        permutations[#permutations + 1] = permutation
        for _, index in ipairs(combination) do
            local x = math.floor((index - 1) / 3) + 1
            local y = (index - 1) % 3 + 1
            grid[x][y] = false
        end
    end

    return permutations
end

function generate_all_permutations()
    local all_permutations = {}
    for n = 1, 9 do
        local permutations = generate_permutations(n)
        for _, permutation in ipairs(permutations) do
            all_permutations[#all_permutations + 1] = permutation
        end
    end
    return all_permutations
end

local n_start      = 9 -- skip bad libs
local n            = n_start

local permutations = generate_all_permutations()

for _, p in ipairs(permutations) do
    n = n + 1
    local recipe = {}
    for i = 1, 3 do
        recipe[i] = {}
        for j = 1, 3 do
            if p[i][j] then
    		local m = math.random(1, N)
                recipe[i][j] = "iaroko:subroutine_" .. m
            else
                recipe[i][j] = ""
            end
        end
    end
    
    minetest.register_craft({
        type = "shaped",
        output = "iaroko:library_" .. n,
        recipe = recipe,
    })
    print('iaroko register_craft('..dump(recipe)..') ==> iaroko:library_'..n)
end

local function isUniqueCombination(a, b, c, d, e, f, g, h, i)
    local combination = {a, b, c, d, e, f, g, h, i}
    table.sort(combination)
    for j = 1, 8 do
        if combination[j] == combination[j + 1] then
            return false
        end
    end
    return true
end

-- Register goo recipe
minetest.register_craft({
    type = "shapeless",
    output = "iaroko:goo_red", -- TODO randomize output on craft
    recipe = {
        "group:library",
        "group:library",
        "group:library",
        "group:library",
        "group:library",
        "group:library",
        "group:library",
        "group:library",
        "group:library",
    },
})

-- Register library recipes
iaroko.color_descs = { -- TODO wtf
    white   = { desc = "White",   off = "red",    },
    red     = { desc = "Red",     off = "yellow", },
    yellow  = { desc = "Yellow",  off = "green",  },
    green   = { desc = "Green",   off = "cyan",   },
    cyan    = { desc = "Cyan",    off = "blue",   },
    blue    = { desc = "Blue",    off = "magenta",},
    magenta = { desc = "Magenta", off = "orange", },
    orange  = { desc = "Orange",  off = "violet", },
    violet  = { desc = "Violet",  off = "white",  },
}
assert(iaroko.color_descs ~= nil)
for color, desc in pairs(iaroko.color_descs) do
    -- Reroll random numbers if the combination is non-unique
    local a, b, c, d, e, f, g, h, i
    repeat
        a = math.random(n_start + 1, n)
        b = math.random(n_start + 1, n)
        c = math.random(n_start + 1, n)
        d = math.random(n_start + 1, n)
        e = math.random(n_start + 1, n)
        f = math.random(n_start + 1, n)
        g = math.random(n_start + 1, n)
        h = math.random(n_start + 1, n)
        i = math.random(n_start + 1, n)
    until isUniqueCombination(a, b, c, d, e, f, g, h, i)
    
    local recipe = {
            { "iaroko:library_" .. a, "iaroko:library_" .. b, "iaroko:library_" .. c },
            { "iaroko:library_" .. d, "iaroko:library_" .. e, "iaroko:library_" .. f },
            { "iaroko:library_" .. g, "iaroko:library_" .. h, "iaroko:library_" .. i },
    }
    minetest.register_craft({
        type = "shaped",
        output = "iaroko:basilisk_" .. color,
        recipe = recipe,
    })
    print('iaroko register_craft('..dump(recipe)..') ==> iaroko:basilisk_'..color)
end





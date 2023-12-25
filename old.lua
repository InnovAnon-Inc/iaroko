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

local n = 9

----
---- Row 1
----
--
--n = n + 1
--m = math.random(1,N) -- TODO correct recipe will change at every load
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "iaroko:subroutine_"..m, "",                 "", },
--		{ "",                      "",                 "", },
--		{ "",                      "",                 "", },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                 "iaroko:subroutine_"..m, "", },
--		{ "",                 "",                      "", },
--		{ "",                 "",                      "", },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                 "",                 "iaroko:subroutine_"..m, },
--		{ "",                 "",                 "", },
--		{ "",                 "",                 "", },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "iaroko:subroutine_"..m, "iaroko:subroutine_"..m, "", },
--		{ "",                      "",                      "", },
--		{ "",                      "",                      "", },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                      "iaroko:subroutine_"..m, "iaroko:subroutine_"..m, },
--		{ "",                      "",                 "", },
--		{ "",                      "",                 "", },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "iaroko:subroutine_"..m, "",                      "iaroko:subroutine_"..m, },
--		{ "",                      "",                 "", },
--		{ "",                      "",                 "", },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "iaroko:subroutine_"..m, "iaroko:subroutine_"..m, "iaroko:subroutine_"..m, },
--		{ "",                      "",                      "", },
--		{ "",                      "",                      "", },
--	},
--})
--
----
---- Row 2
----
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                      "",                      "", },
--		{ "iaroko:subroutine_"..m, "",                      "", },
--		{ "",                      "",                      "", },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                      "",                      "", },
--		{ "",                      "iaroko:subroutine_"..m, "", },
--		{ "",                      "",                      "", },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                      "",                      "", },
--		{ "",                      "",                      "iaroko:subroutine_"..m, },
--		{ "",                      "",                      "", },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                      "",                      "", },
--		{ "iaroko:subroutine_"..m, "iaroko:subroutine_"..m, "", },
--		{ "",                      "",                      "", },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                      "",                      "", },
--		{ "",                      "iaroko:subroutine_"..m, "iaroko:subroutine_"..m, },
--		{ "",                      "",                      "", },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                      "",                      "", },
--		{ "iaroko:subroutine_"..m, "",                      "iaroko:subroutine_"..m, },
--		{ "",                      "",                      "", },
--	},
--})
--
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                      "",                      "", },
--		{ "iaroko:subroutine_"..m, "iaroko:subroutine_"..m, "iaroko:subroutine_"..m, },
--		{ "",                      "",                      "", },
--	},
--})
--
----
---- Row 3
----
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                      "",                      "", },
--		{ "",                      "",                      "", },
--		{ "iaroko:subroutine_"..m, "",                      "", },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                      "",                      "", },
--		{ "",                      "",                      "", },
--		{ "",                      "iaroko:subroutine_"..m, "", },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                      "",                      "", },
--		{ "",                      "",                      "", },
--		{ "",                      "",                      "iaroko:subroutine_"..m, },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                      "",                      "", },
--		{ "",                      "",                      "", },
--		{ "iaroko:subroutine_"..m, "iaroko:subroutine_"..m, "", },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                      "",                      "", },
--		{ "",                      "",                      "", },
--		{ "",                      "iaroko:subroutine_"..m, "iaroko:subroutine_"..m, },
--	},
--})
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                      "",                      "", },
--		{ "",                      "",                      "", },
--		{ "iaroko:subroutine_"..m, "",                      "iaroko:subroutine_"..m, },
--	},
--})
--
--
--n = n + 1
--m = math.random(1,N)
--minetest.register_craft({
--	type         = "shaped",
--	output       = 'iaroko:library_'..n,
--	recipe       = {
--		{ "",                      "",                      "", },
--		{ "",                      "",                      "", },
--		{ "iaroko:subroutine_"..m, "iaroko:subroutine_"..m, "iaroko:subroutine_"..m, },
--	},
--})
--
---- row 1&2
---- row 1&3
---- row 2&3
---- row 1&2&3

-- Function to generate all permutations of recipe shapes
function permute(num_dependencies)
    -- Helper function to generate permutations
    local function generate_permutations(dependencies, current_permutation, used, result)
        -- Base case: If all dependencies have been used, add current permutation to the result
        if #current_permutation == num_dependencies then
            table.insert(result, current_permutation)
        else
            -- Recursive case: Generate all permutations
            for i = 1, num_dependencies do
                if not used[i] then
                    used[i] = true
                    table.insert(current_permutation, dependencies[i])
                    generate_permutations(dependencies, current_permutation, used, result)
                    used[i] = false
                    table.remove(current_permutation)
                end
            end
        end
    end

    -- Generate the dependencies
    local dependencies = {}
    for i = 1, num_dependencies do
        dependencies[i] = "iaroko:subroutine_" .. i
    end

    -- Generate all permutations of recipe shapes
    local result = {}
    generate_permutations(dependencies, {}, {}, result)
    return result
end

-- Usage example
--local num_dependencies = 4
--local recipe_shapes = permute(num_dependencies)

-- Number of dependencies
for num_dependencies=1,9 do

-- Generate all permutations of recipe shapes
local recipe_shapes = permute(num_dependencies)

-- Function to register craft recipes for each recipe shape
local function register_crafts(shapes)
    local n = 0
    local N = num_dependencies

    for _, shape in pairs(shapes) do
        n = n + 1
        local m = math.random(1, N)

	print(dump(shape))
	assert(shape ~= nil)
	assert(shape ~= {})

        -- Register craft recipe
        minetest.register_craft({
            type    = "shaped",
            output  = "iaroko:library_" .. n,
            recipe  = shape
        })
    end
end

-- Register craft recipes for each permutation of recipe shapes
register_crafts(recipe_shapes)

end





































minetest.register_craft({
	type   = "shapeless",
	output = "iaroko:goo_"..whatever,
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

a = math.random(9+1,n)
b = math.random(9+1,n)
c = math.random(9+1,n)
d = math.random(9+1,n)
e = math.random(9+1,n)
f = math.random(9+1,n)
g = math.random(9+1,n)
h = math.random(9+1,n)
i = math.random(9+1,n)
minetest.register_craft({
	type         = "shaped",
	output       = 'iaroko:basilisk',
	recipe       = {
		{ "iaroko:library_"..a, "iaroko:library_"..b, "iaroko:library_"..c, },
		{ "iaroko:library_"..d, "iaroko:library_"..e, "iaroko:library_"..f, },
		{ "iaroko:library_"..g, "iaroko:library_"..h, "iaroko:library_"..i, },
	},
})

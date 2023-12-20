local MODNAME = minetest.get_current_modname()
local MP      = minetest.get_modpath(MODNAME)
local S       = minetest.get_translator(MODNAME)

local dummy = function(itemstack, user, pointed_thing)
end
iadiscordia.register_stone("iaroko:test_stone_1", S("Test Stone 1"), "default_stone.png", dummy)
iadiscordia.register_stone("iaroko:test_stone_2", S("Test Stone 2"), "default_stone.png", dummy)
iadiscordia.register_stone("iaroko:test_stone_3", S("Test Stone 3"), "default_stone.png", dummy)

minetest.register_craft({
  type          = "shapeless",
  output        = 'iaroko:test_stone_2',
  recipe        = {
      'iaroko:test_stone_1',
  },
})
minetest.register_craft({
  type          = "shapeless",
  output        = 'iaroko:test_stone_3',
  recipe        = {
      'iaroko:test_stone_2',
  },
})

--local function insert_all(dest, src)
--	assert(dest ~= nil)
--	--assert(src  ~= nil)
--	if src == nil then return end
--	for _, e in ipairs(src) do
--		table.insert(dest, e)
--	end
--end
--
--minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
--	if itemstack:get_name():sub(1,7) ~= "iaroko:" then return nil end
--
--	print('old_craft_grid: '..dump(old_craft_grid))
--	print('craft_inv: '..dump(craft_inv))
--	local contributors = {}
--	for _, stack in ipairs(old_craft_grid) do
--
--	--local size = craft_inv:get_size()
--	--for index = 1,size do
--	--	local stack   = craft_inv:get_stack("main", index);
--		local meta    = stack:get_meta()
--		local contrib = meta:get_string("contributors")
--		contrib = minetest.deserialize(contrib)
--		insert_all(contributors, contrib)
--	end
--
--	table.insert(contributors, player:get_player_name())
--
--	print('contributors: '..dump(contributors))
--	local meta = itemstack:get_meta()
--	contributors = minetest.serialize(contributors)
--	meta:set_string("contributors", contributors)
--	return itemstack
--end)

--local function insert_all(dest, src)
--    assert(dest ~= nil)
--    if src == nil then return end
--    for _, e in ipairs(src) do
--        dest[e] = true -- Use a Lua table as a set to ensure no duplicates
--    end
--end
--
--minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
--    if itemstack:get_name():sub(1, 7) ~= "iaroko:" then return nil end
--
--    print('old_craft_grid: ' .. dump(old_craft_grid))
--    print('craft_inv: ' .. dump(craft_inv))
--    local contributors = {}
--    for _, stack in ipairs(old_craft_grid) do
--        local meta = stack:get_meta()
--        local contrib = meta:get_string("contributors")
--        contrib = minetest.deserialize(contrib)
--        insert_all(contributors, contrib)
--    end
--
--    contributors[player:get_player_name()] = true -- Add the current player to the contributors set
--
--    print('contributors: ' .. dump(contributors))
--    local meta = itemstack:get_meta()
--    contributors = minetest.serialize(table.keys(contributors)) -- Convert the contributors set to a table
--    meta:set_string("contributors", contributors)
--    return itemstack
--end)

local function insert_all(dest, src)
    assert(dest ~= nil)
    if src == nil then return end
    for _, e in ipairs(src) do
        dest[e] = true
    end
end

local function table_to_array(tbl)
    local result = {}
    for k, _ in pairs(tbl) do
        table.insert(result, k)
    end
    return result
end

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


--dofile(MP.."/util.lua")

print("[OK] IA Roko")


-- TODO technic power reqs

local MODNAME = minetest.get_current_modname()
local MP      = minetest.get_modpath(MODNAME)
local S       = minetest.get_translator(MODNAME)

-- Helper function to get adjacent positions of a given position
local function get_adjacent_positions(pos)
    local adjacent_positions = {}
    local offsets = {
        {x = -1, y = 0, z = 0},  -- left
        {x = 1, y = 0, z = 0},   -- right
        {x = 0, y = -1, z = 0},  -- down
        {x = 0, y = 1, z = 0},   -- up
        {x = 0, y = 0, z = -1},  -- back
        {x = 0, y = 0, z = 1}    -- front
    }

    for _, offset in ipairs(offsets) do
        local adjpos = vector.add(pos, offset)
        table.insert(adjacent_positions, adjpos)
    end

    -- TODO shuffle positions

    return adjacent_positions
end

local template = {
	--drawtype            = "allfaces_optional",
	drawtype            = "normal",
	tiles               = {
		{
			name      = "basilisk.png",
			animation = {
				type     = "vertical_frames",
				aspect_w = 288,
				aspect_h = 288,
				length   = 300, -- TODO
			},
		},
	},
	paramtype           = "light",
	sunlight_propagates = true,
	light_source        = minetest.LIGHT_MAX,
	walkable            = false,
	pointable           = false,
	diggable            = false,
	buildable_to        = false,
	floodable           = false,
	drop                = "",
	groups              = { grey_goo = 1, not_in_creative_inventory = 1}, -- TODO
	damage_per_second   = 1,
	on_construct        = function(pos)
		local time = math.random(10,90)
		minetest.get_node_timer(pos):start(time)
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local itemmeta     = itemstack:get_meta()
		local itemmode     = nil
		local itemmode_1   = nil
		local itemmode_2   = nil
		local contributors = nil
		if itemmeta   ~= nil then
			itemmode     = itemmeta:get_int("mode")
			itemmode_1   = itemmeta:get_int("mode_1")
			itemmode_2   = itemmeta:get_int("mode_2")
			contributors = itemmeta:get_string("contributors")
		end
		if itemmode   == nil then
			itemmode     = math.random(1,2)
		end
		if itemmode_1 == nil then
			itemmode_1   = 0
		end
		if itemmode_2 == nil then
			itemmode_2   = 0
		end
		if contributors ~= nil then
			contributors = minetest.deserialize(contributors)
		else
			contributors = {}
		end
		contributors[placer:get_player_name()] = true
		contributors = minetest.serialize(contributors)

		local meta = minetest.get_meta(pos)
		local mode = meta:get_int("mode")
		if mode == nil or mode == 0 then
			meta:set_int("mode",   itemmode)
			meta:set_int("mode_1", itemmode_1)
			meta:set_int("mode_2", itemmode_2)
			--meta:set_string("infotext", "Mode: "..mode)
			meta:set_string("contributors", contributors)
		end
	end,
}
for color, color_desc in pairs(iaroko.color_descs) do
	local def               = table.copy(template)
	def.color               = color:gsub("_", "")
	def.post_effect_color   = color:gsub("_", "")

--	local def_1       = table.copy(def)
--	def_1.description = S(color_desc .. " Goo (Consuming)")
--	def_1.on_timer    = function(pos)
--		local flag = false
--		local adjacent_positions = get_adjacent_positions(pos)
--		for _, adjpos in ipairs(adjacent_positions) do
--			local node = minetest.get_node(adjpos)
--			if node.name ~= "air" and minetest.get_item_group(node.name, "grey_goo") < 1 then
--				--minetest.set_node(adjpos, {name="iaroko:goo_"..color})
--				minetest.set_node(adjpos, {name="iaroko:goo_1_"..color})
--				flag = true
--				break
--			end
--		end
--		if flag then
--		--return true
--		local time = math.random(10,90)
--        	minetest.get_node_timer(pos):start(time)
--		else
--			print('goo blocked: '..dump(pos))
--		end
--		return false
--	end
--	minetest.register_node("iaroko:goo_1_"..color, def_1)
--
--	local def_2       = table.copy(def)
--	def_2.description = S(color_desc .. " Goo (Expanding)")
--	def_2.on_timer    = function(pos)
--		local flag = false
--		local adjacent_positions = get_adjacent_positions(pos)
--		for _, adjpos in ipairs(adjacent_positions) do
--			local node = minetest.get_node(adjpos)
--			if node.name == "air" --and minetest.get_item_group(node.name, "grey_goo") < 1
--			then
--				flag = true
--				minetest.set_node(adjpos, {name="iaroko:goo_2_"..color})
--			end
--		end
--		if flag then
--		--return true
--		local time = math.random(10,90)
--        	minetest.get_node_timer(pos):start(time)
--		else
--			print('goo blocked: '..dump(pos))
--		end
--		return false
--	end
--	minetest.register_node("iaroko:goo_2_"..color, def_2)

	def.description = S("Complex Machinery ("..color_desc.desc..")")--S(color_desc.desc .. " Goo")
	def.on_timer    = function(pos)
		local meta = minetest.get_meta(pos)
		local mode = meta:get_int("mode")
		if mode == nil or mode == 0 then
			mode = math.random(1,2)
			meta:set_int("mode",   mode)
			meta:set_int("mode_1", 0)
			meta:set_int("mode_2", 0)
		end
		-- TODO modes
		-- TODO - attack player somehow
		-- TODO - random walk
		-- TODO - stop button mode (shut it down)
		meta:set_string("infotext", "Mode: "..mode)
		local contrib = meta:get_string("contributors")

		local flag = false
		local adjacent_positions = get_adjacent_positions(pos)
		for _, adjpos in ipairs(adjacent_positions) do
			local node    = minetest.get_node(adjpos)
			local not_goo = minetest.get_item_group(node.name, "grey_goo") < 1
			if (mode == 1 and node.name ~= "air" and not_goo)
			or (mode == 2 and node.name == "air")
			then
				flag = true
				minetest.set_node(adjpos, {name="iaroko:goo_"..color})
				local adjmeta = minetest.get_meta(adjpos)
				--adjmeta:set_int("mode",   mode)
				adjmeta:set_int("mode_1", 0)
				adjmeta:set_int("mode_2", 0)
				adjmeta:set_string("contributors", contrib)
			--elseif (mode % nmod == 2 and not not_goo) then
			--
			end
		end

		if not flag then
			--print('goo blocked: '..dump(pos))
			if     mode == 1 then
				meta:set_int("mode_1", 1)
			elseif mode == 2 then
				meta:set_int("mode_2", 1)
			end
			local mode_1 = meta:get_int("mode_1") > 0
			local mode_2 = meta:get_int("mode_2") > 0
			if     mode_1 and     mode_2 then
				minetest.set_node(pos, {name = "iaroko:goo_"..color_desc.off})
				meta = minetest.get_meta(pos)
				meta:set_string("contributors", contrib)
				meta:set_int("mode",   3)
				meta:set_int("mode_1", 1)
				meta:set_int("mode_2", 1)
				return false
			elseif     mode_1 and not mode_2 then
				meta:set_int("mode", 2)
			elseif not mode_1 and     mode_2 then
				meta:set_int("mode", 1)
			end
		end

		local time = math.random(10,90)
        	minetest.get_node_timer(pos):start(time)
		return false
	end
	minetest.register_node("iaroko:goo_"..color, def)
end

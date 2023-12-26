-- TODO technic power reqs

local MODNAME = minetest.get_current_modname()
local MP      = minetest.get_modpath(MODNAME)
local S       = minetest.get_translator(MODNAME)

for color,color_desc in pairs(iaroko.color_descs) do
minetest.register_node("iaroko:basilisk_"..color, {
	description         = S("Complex Machinery ("..color_desc.desc..")"),--S("We Made It! ("...color_desc..")"),
	drawtype            = "allfaces_optional",
	tiles               = {
		{
			name      = "basilisk.png",
			animation = {
				type     = "vertical_frames",
				aspect_w = 288,
				aspect_h = 288,
				length   =  10, -- TODO
			},
		},
	},
        color               = color:gsub("_", ""),
        post_effect_color   = color:gsub("_", ""),
        paramtype           = "light",
        sunlight_propagates = true,
        light_source        = minetest.LIGHT_MAX,
	drop                = "",
        groups              = {
		--oddly_breakable_by_hand = 3,
		dig_immediate = 2,
		not_in_creative_inventory = 1,
		grey_goo=1,
	}, -- TODO
        --damage_per_second = 20,
	
        on_construct     = function(pos)
        	minetest.get_node_timer(pos):start(1)
	end,
        on_timer         = function(pos)
		local meta     = minetest.get_meta(pos)
        	local contrib  = meta:get_string("contributors")
		local mode     = meta:get_int("mode")
        	contrib        = minetest.deserialize(contrib)
		if mode == nil or mode == 0 then
			mode = math.random(1,2)
			meta:set_int("mode", mode)
			local info     = "???"
			if     mode == 1 then
				info = "Whitelist:"
			elseif mode == 2 then
				info = "Blacklist:"
			end
			-- TODO modes
			-- TODO - F u ==> grey goo
			-- TODO - russian roulette
			-- TODO - stop button mode (shut it down)
			if contrib ~= nil then
				for contributor,_ in pairs(contrib) do
					info   = info.."\n- "..contributor
				end
			end
			meta:set_string("infotext", info)
		end
		for _,player in ipairs(minetest.get_connected_players()) do
			local name = player:get_player_name()
			if contrib == nil
			or (mode == 1 and not contrib[name])
			or (mode == 2 and     contrib[name]) then
				local damage = 1
                    		player:punch(player, 1.0, {
                        		full_punch_interval=1.0,
                        		damage_groups={fleshy=damage},
                    		}, nil)
			end
		end
		return true
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local itemmeta = itemstack:get_meta()
		local nodemeta = minetest.get_meta(pos)
        	local contrib  = itemmeta:get_string("contributors")
		nodemeta:set_string("contributors", contrib)
		local mode     = itemmeta:get_int("mode")
		if mode == nil or mode == 0 then
			mode = math.random(1,2)
		end
		nodemeta:set_int("mode", mode)
		contrib        = minetest.deserialize(contrib)
		contrib[placer:get_player_name()] = true
		local info     = "???"
		if     mode == 1 then
			info = "Whitelist:"
		elseif mode == 2 then
			info = "Blacklist:"
		end
		if contrib ~= nil then
		for contributor,_ in pairs(contrib) do
			info   = info.."\n- "..contributor
		end
		end
		nodemeta:set_string("infotext", info)
	end,

	on_punch = function(pos, node, puncher, pointed_thing)
            -- Get the metadata of the current node
            local meta     = minetest.get_meta(pos)
            local contrib  = meta:get_string("contributors")
	    local infotext = meta:get_string("infotext")
            --contrib = minetest.deserialize(contrib)

            -- Switch to the next color node
            local next_color = color_desc.off
            local next_node = "iaroko:basilisk_"..next_color
            --minetest.set_node(pos, {name = next_node})
            minetest.swap_node(pos, {name = next_node})

            -- Call the on_construct callback to start the timer for the new node
            minetest.registered_nodes[next_node].on_construct(pos)

            -- Preserve the metadata of the current node
            local next_meta = minetest.get_meta(pos)
            next_meta:set_string("contributors", contrib)
	    next_meta:set_string("infotext",     infotext)

            -- Optionally update other metadata values or perform additional actions
        end,
})
end

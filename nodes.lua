minetest.register_node ("tardis:tardis", {
	decription        = "Time And Relative Dimension In Space" ,
	tiles             = { "tardis_exterior.png" } ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,

	-- Setup Meta, clone meta if not placed by a player
	on_place = function (itemstack, placer, pointed_thing)
		local pos    = pointed_thing.above
		local player = placer:get_player_name()
		tardis.swap_node (pos, {name = "tardis:tardis"})

		if (player == nil) then
			local meta   = minetest.get_meta (pos)
			local player = meta:get_string ("owner")
			tardis.tardises [player]["exterior"] = pos
		elseif (tardis.tardises [player] == nil) then
			tardis:spawn_interior (pos, player)
		else
			tardis.tardises [player]["exterior"] = pos
		end

		local meta = minetest.get_meta (pos)
		meta:set_string ("owner", player)
		itemstack:take_item (1)
	end ,


	-- Teleport Player
	on_rightclick = function (pos, node, player, itemstack, pointed_thing)
		local meta     = minetest.get_meta (pos)
		local owner    = meta:get_string ("owner")
		local teleport = tardis.tardises [owner]["interior"]

		player.setpos (player, teleport)
		--player.set_look_horizontal(0)
	end ,
})


-- Initialize materialization, fail if nav is not set, then swap node to off pos
minetest.register_node ("tardis:demat_lever_on", {
	tiles             = {"tardis_demat.png"} ,
	drawtype          = "mesh" ,
	mesh              = "tardis_demat_on.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,

	on_rightclick     = function (pos, node, player, itemstack, pointed_thing)
		local player_name = player:get_player_name()
		local meta        = minetest.get_meta(pos)
		local owner       = meta:get_string("owner")

		local rematted, msg = tardis.remat (owner, player:get_player_name())
		if (rematted == false) then
			minetest.chat_send_player (player_name, msg)
		else
			minetest.sound_play ("tardis_remat", {
				pos               = pos ,
				max_hear_distance = 100 ,
				gain              = 10  ,
			})	
			minetest.swap_node (pos, {name = "tardis:demat_lever_off"})
		end
	end
})


-- Initialize dematerialization, then set lever to on pos
minetest.register_node ("tardis:demat_lever_off", {
	groups            = {crumbly = 1} ,
	tiles             = {"tardis_demat.png"} ,
	drawtype          = "mesh" ,
	mesh              = "tardis_demat_off.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,

	on_rightclick     = function (pos, node, player, itemstack, pointed_thing)
		local meta  = minetest.get_meta(pos)
		local owner = meta:get_string("owner")
		
		local dematted, msg = tardis.demat (owner, player:get_player_name())

		if dematted then
			minetest.sound_play ("tardis_demat", {
				pos               = pos ,
				max_hear_distance = 10  ,
				gain              = 10  ,
			})

			minetest.swap_node (pos, {name = "tardis:demat_lever_on"})
		else
			minetest.chat_send_player(player:get_player_name(), msg)
		end
	end ,
})

minetest.register_node ("tardis:navigator", {
	groups            = {crumbly = 1} ,
	tiles             = {"tardis_navigator.png"} ,
	drawtype          = "signlike" ,
	paramtype         = "light" ,
	paramtype2        = "wallmounted" ,
	is_ground_content = true ,

	on_rightclick     = function (pos, node, player, itemstack, pointed_thing)
		local meta  = minetest.get_meta(pos)
		local owner = meta:get_string("owner")

		tardis.set_nav(player, owner)
	end ,
})


-- Teleports player to exterior is in_vortex is set to false
minetest.register_node ("tardis:interior_doors", {
	tiles             = {"tardis_exterior.png"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_interior_doors.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,

	on_rightclick = function (pos, node, player, itemstack, pointed_thing)
		local meta = minetest.get_meta (pos)
		local owner = meta:get_string ("owner")

		if (tardis.tardises == nil) or
			(tardis.tardises [owner] == nil) or
			(tardis.tardises [owner]["in_vortex"] == nil) then
			minetest.log ("error", "in_vortex not initialised for  " .. owner)
			return
		end

		if (tardis.tardises [owner]["in_vortex"] == false) then
			local teleport = tardis.tardises [owner]["exterior"]
			player:setpos (teleport)
		else
			player_name = player:get_player_name()
			minetest.chat_send_player (player_name, "The TARDIS is in the Vortex - the doors have been locked automatically.")
		end
	end
})

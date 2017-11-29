minetest.register_node("tardis:tardis", {
	decription        = "Time And Relative Dimension In Space",
	tiles             = { "tardis_exterior.png" },
	use_texture_alpha = true,
	drawtype          = "mesh",
	mesh              = "tardis_exterior.obj",
	paramtype         = "light",
	selection_box     = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}},
	collision_box     = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}},

	-- Setup Meta, clone meta if not placed by a player
	on_place = function(itemstack, placer, pointed_thing)
		local pos    = pointed_thing.above
		local name   = placer:get_player_name()
		tardis.swap_node(pos, {name = "tardis:tardis"})

		if (name) then
			tardis:spawn_interior (pos, name)
		else
			local meta = minetest.get_meta(pos)
			local owner  = meta:get_string("owner")
			if (tardis.get_interior(owner)) then
				tardis.set_exerior(pos, owner)

			else tardis.set_exterior(pos, name)
			end
		end

		local meta = minetest.get_meta(pos)
		meta:set_string ("owner", name)
		itemstack:take_item()
		return itemstack
	end,


	-- Teleport Player
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local meta     = minetest.get_meta(pos)
		local name     = meta:get_string("owner")
		local teleport = tardis.get_interior(name)
		teleport.z     = teleport.z + 1

		player.setpos(player, teleport)
	end,
})


-- Initialize materialization, fail if nav is not set, then swap node to off pos
minetest.register_node("tardis:demat_lever_on", {
	tiles               = {"tardis_demat.png"},
	drawtype            = "mesh",
	mesh                = "tardis_demat_on.obj",
	paramtype           = "light",

	on_rightclick       = function(pos, node, player, itemstack, pointed_thing)
		local name  = player:get_player_name()
		local meta  = minetest.get_meta(pos)
		local owner = meta:get_string("owner")

		if (tardis.remat(owner)) then
			minetest.sound_play ("tardis_remat", {
				pos               = pos ,
				max_hear_distance = 100 ,
				gain              = 10  ,
			})
			minetest.swap_node(pos, {name = "tardis:demat_lever_off"})
		else
			minetest.chat_send_player(name, "Failed to remat")
		end
	end
})


-- Initialize dematerialization, then set lever to on pos
minetest.register_node ("tardis:demat_lever_off", {
	tiles               = {"tardis_demat.png"},
	drawtype            = "mesh",
	mesh                = "tardis_demat_off.obj",
	paramtype           = "light",

	on_rightclick       = function(pos, node, player, itemstack, pointed_thing)
		local name  = player:get_player_name()
		local meta  = minetest.get_meta(pos)
		local owner = meta:get_string("owner")

		if (tardis.demat(owner)) then
			minetest.sound_play ("tardis_demat", {
				pos               = pos ,
				max_hear_distance = 10  ,
				gain              = 10  ,
			})

			minetest.swap_node (pos, {name = "tardis:demat_lever_on"})
		else
			minetest.chat_send_player(name, "Failed to demat")
		end
	end
})

minetest.register_node("tardis:navigator", {
	tiles               = {"tardis_navigator.png"},
	drawtype            = "signlike",
	paramtype           = "light",
	paramtype2          = "wallmounted",

	on_rightclick       = function(pos, node, player, itemstack, pointed_thing)
		local name  = player:get_player_name()
		local meta  = minetest.get_meta(pos)
		local owner = meta:get_string("owner")

		tardis.show_nav_formspec(name, owner)
	end
})


-- Teleports player to exterior is in_vortex is set to false
minetest.register_node("tardis:interior_doors", {
	tiles               = {"tardis_doors.png"},
	use_texture_alpha   = true,
	drawtype            = "mesh",
	mesh                = "tardis_interior_doors.obj",
	paramtype           = "light",
	selection_box     = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}},
	collision_box     = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}},

	on_rightclick       = function(pos, node, player, itemstack, pointed_thing)
		local name  = player:get_player_name()
		local meta  = minetest.get_meta(pos)
		local owner = meta:get_string("owner")

		if (tardis.get_vortex(owner)) then
			minetest.chat_send_player (name, "The TARDIS is in the Vortex - the doors have been locked automatically.")
		else
			local teleport = tardis.get_exterior(owner)
			teleport["z"]  = teleport["z"] - 1
			player:setpos(teleport)
		end
	end,

	on_timer = function(pos)
		local meta  = minetest.get_meta(pos)
		local owner = meta:get_string("owner")

		if (tardis.get_vortex(owner)) then -- If we're in a vortex, we must have been activated from the remat function.
			tardis.set_vortex(false, owner) -- exit it.

			tardis.swap_node((tardis.get_exterior(owner)), {name = "tardis:tardis"})
		end
	end
})

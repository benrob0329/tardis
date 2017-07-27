function tardis.remat (owner)
	if (tardis.tardises [owner]["destination"] == nil) then
		return false
	else
		local pos = tardis.tardises [owner]["destination"]

		minetest.forceload_block (pos)
		minetest.set_node (pos, {name = "tardis:tardis_remat"})

		local meta = minetest.get_meta (pos)
		meta:set_string ("owner", owner)

		tardis.tardises [owner]["exterior"] = pos

		minetest.sound_play ("tardis_remat", {
			pos               = pos ,
			max_hear_distance = 100 ,
			gain              = 10  ,
		})
	end
end


minetest.register_node ("tardis:tardis_remat", {
	tiles             = {"tardis_exterior.png^[opacity:1"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,

	on_timer = function (pos)
		tardis.swap_node (pos, {name = "tardis:tardis_remat_1"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(11)
	end ,
})

minetest.register_node ("tardis:tardis_remat_1", {
	tiles             = {"tardis_exterior.png^[opacity:25"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,
	light_source      = 7 ,


	on_timer = function (pos)
		tardis.swap_node (pos, {name = "tardis:tardis_remat_2"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1.5)
	end ,
})

minetest.register_node ("tardis:tardis_remat_2", {
	tiles             = {"tardis_exterior.png^[opacity:50"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,

	on_timer = function (pos)
		tardis.swap_node (pos, {name = "tardis:tardis_remat_3"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1)
	end ,
})

minetest.register_node ("tardis:tardis_remat_3", {
	tiles             = {"tardis_exterior.png^[opacity:75"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,
	light_source      = 10 ,

	on_timer = function (pos)
		tardis.swap_node (pos, {name = "tardis:tardis_remat_4"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1)
	end ,
})

minetest.register_node ("tardis:tardis_remat_4", {
	tiles             = {"tardis_exterior.png^[opacity:100"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,

	on_timer = function (pos)
		tardis.swap_node (pos, {name = "tardis:tardis_remat_5"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(0.5)
	end ,
})

minetest.register_node ("tardis:tardis_remat_5", {
	tiles             = {"tardis_exterior.png^[opacity:125"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,
	light_source      = 10 ,

	on_timer = function (pos)
		tardis.swap_node (pos, {name = "tardis:tardis_remat_6"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1)
	end ,
})

minetest.register_node ("tardis:tardis_remat_6", {
	tiles             = {"tardis_exterior.png^[opacity:150"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,

	on_timer = function (pos)
		tardis.swap_node (pos, {name = "tardis:tardis_remat_7"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1)
	end ,
})

minetest.register_node ("tardis:tardis_remat_7", {
	tiles             = {"tardis_exterior.png^[opacity:175"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	light_source      = 10 ,

	on_timer = function (pos)
		tardis.swap_node (pos, {name = "tardis:tardis_remat_8"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1)
	end ,
})

minetest.register_node ("tardis:tardis_remat_8", {
	tiles             = {"tardis_exterior.png^[opacity:200"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,

	on_timer = function (pos)
		tardis.swap_node (pos, {name = "tardis:tardis_remat_9"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(0.5)
	end ,
})

minetest.register_node ("tardis:tardis_remat_9", {
	tiles             = {"tardis_exterior.png^[opacity:225"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,
	light_source      = 10 ,

	on_timer = function (pos)
		tardis.swap_node (pos, {name = "tardis:tardis"})

		local meta = minetest.get_meta (pos)
		owner = meta:get_string ("owner")

		tardis.tardises [owner]["in_vortex"] = false
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1)
	end ,
})

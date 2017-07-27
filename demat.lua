function tardis.demat (owner)
	local pos = tardis.tardises [owner]["exterior"]

	minetest.set_node (pos, {name = "tardis:tardis_demat"})

	tardis.tardises [owner]["in_vortex"] = true

	minetest.sound_play ("tardis_demat", {
		pos               = pos ,
		max_hear_distance = 100 ,
		gain              = 10  ,
	})
end


minetest.register_node ("tardis:tardis_demat", {
	tiles             = {"tardis_exterior.png^[opacity:255"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,
	light_source      = 5 ,

	on_timer = function (pos)
		minetest.set_node (pos, {name = "tardis:tardis_demat_1"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(7)
	end ,
})

minetest.register_node ("tardis:tardis_demat_1", {
	tiles             = {"tardis_exterior.png^[opacity:225"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,
	light_source      = 10 ,


	on_timer = function (pos)
		minetest.set_node (pos, {name = "tardis:tardis_demat_2"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1)
	end ,
})

minetest.register_node ("tardis:tardis_demat_2", {
	tiles             = {"tardis_exterior.png^[opacity:200"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,

	on_timer = function (pos)
		minetest.set_node (pos, {name = "tardis:tardis_demat_3"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1)
	end ,
})

minetest.register_node("tardis:tardis_demat_3", {
	tiles             = {"tardis_exterior.png^[opacity:175"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,
	light_source      = 10 ,

	on_timer = function (pos)
		minetest.set_node (pos, {name = "tardis:tardis_demat_4"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1)
	end ,
})

minetest.register_node ("tardis:tardis_demat_4", {
	tiles             = {"tardis_exterior.png^[opacity:150"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,

	on_timer = function (pos)
		minetest.set_node (pos, {name = "tardis:tardis_demat_5"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(0.5)
	end ,
})

minetest.register_node ("tardis:tardis_demat_5", {
	tiles             = {"tardis_exterior.png^[opacity:125"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,
	light_source      = 10 ,

	on_timer = function (pos)
		minetest.set_node (pos, {name = "tardis:tardis_demat_6"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1)
	end ,
})

minetest.register_node ("tardis:tardis_demat_6", {
	tiles             = {"tardis_exterior.png^[opacity:100"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,

	on_timer = function (pos)
		minetest.set_node (pos, {name = "tardis:tardis_demat_7"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1)
	end ,
})

minetest.register_node ("tardis:tardis_demat_7", {
	tiles             = {"tardis_exterior.png^[opacity:75"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	light_source      = 10 ,

	on_timer = function (pos)
		minetest.set_node (pos, {name = "tardis:tardis_demat_8"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1)
	end ,
})

minetest.register_node ("tardis:tardis_demat_8", {
	tiles             = {"tardis_exterior.png^[opacity:50"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,

	on_timer = function (pos)
		minetest.set_node (pos, {name = "tardis:tardis_demat_9"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1)
	end ,
})

minetest.register_node ("tardis:tardis_demat_9", {
	tiles             = {"tardis_exterior.png^[opacity:25"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,
	light_source      = 7 ,

	on_timer = function (pos)
		minetest.set_node (pos, {name = "tardis:tardis_demat_10"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1)
	end ,
})

minetest.register_node ("tardis:tardis_demat_10", {
	tiles             = {"tardis_exterior.png^[opacity:10"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,

	on_timer = function (pos)
		minetest.set_node (pos, {name = "tardis:tardis_demat_11"})
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(0.5)
	end ,
})

minetest.register_node ("tardis:tardis_demat_11", {
	tiles             = {"tardis_exterior.png^[opacity:5"} ,
	use_texture_alpha = true ,
	drawtype          = "mesh" ,
	mesh              = "tardis_exterior.obj" ,
	paramtype         = "light" ,
	is_ground_content = true ,
	light_source      = 5 ,

	on_timer = function (pos)
		minetest.set_node (pos, {name = "air"})
		minetest.forceload_free_block (pos)
	end ,

	on_construct = function (pos)
		minetest.get_node_timer (pos):start(1)
	end ,
})

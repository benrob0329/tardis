function tardis.remat(name)
	local pos = tardis.get_nav(name)

	if (minetest.forceload_block(pos)) then
		minetest.set_node(pos, {name = "tardis:tardis_remat"})

		tardis.set_exterior(pos, name)

		local meta = minetest.get_meta(pos)
		meta:set_string("owner", name)

		minetest.get_node_timer(tardis.get_interior(name)):start(21)
		return true
	else return false

	end
end

minetest.register_node("tardis:tardis_remat", {
	tiles             = {"tardis_exterior.png^[opacity:1"},
	use_texture_alpha = true,
	drawtype          = "mesh",
	mesh              = "tardis_exterior.obj",
	paramtype         = "light",

	on_timer = function(pos)
		tardis.swap_node(pos, {name = "tardis:tardis_remat_1"})
	end,

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(11)
	end,
})

minetest.register_node("tardis:tardis_remat_1", {
	tiles             = {"tardis_exterior.png^[opacity:25"},
	use_texture_alpha = true,
	drawtype          = "mesh",
	mesh              = "tardis_exterior.obj",
	paramtype         = "light",
	light_source      = 7,

	on_timer = function(pos)
		tardis.swap_node(pos, {name = "tardis:tardis_remat_2"})
	end,

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(1.5)
	end,
})

minetest.register_node("tardis:tardis_remat_2", {
	tiles             = {"tardis_exterior.png^[opacity:50"},
	use_texture_alpha = true,
	drawtype          = "mesh",
	mesh              = "tardis_exterior.obj",
	paramtype         = "light",

	on_timer = function(pos)
		tardis.swap_node(pos, {name = "tardis:tardis_remat_3"})
	end,

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(1)
	end,
})

minetest.register_node("tardis:tardis_remat_3", {
	tiles             = {"tardis_exterior.png^[opacity:75"},
	use_texture_alpha = true,
	drawtype          = "mesh",
	mesh              = "tardis_exterior.obj",
	paramtype         = "light",
	light_source      = 10,

	on_timer = function(pos)
		tardis.swap_node(pos, {name = "tardis:tardis_remat_4"})
	end,

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(1)
	end,
})

minetest.register_node("tardis:tardis_remat_4", {
	tiles             = {"tardis_exterior.png^[opacity:100"},
	use_texture_alpha = true,
	drawtype          = "mesh",
	mesh              = "tardis_exterior.obj",
	paramtype         = "light",

	on_timer = function(pos)
		tardis.swap_node(pos, {name = "tardis:tardis_remat_5"})
	end,

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(0.5)
	end,
})

minetest.register_node("tardis:tardis_remat_5", {
	tiles             = {"tardis_exterior.png^[opacity:125"},
	use_texture_alpha = true,
	drawtype          = "mesh",
	mesh              = "tardis_exterior.obj",
	paramtype         = "light",
	light_source      = 10,

	on_timer = function(pos)
		tardis.swap_node(pos, {name = "tardis:tardis_remat_6"})
	end,

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(1)
	end,
})

minetest.register_node("tardis:tardis_remat_6", {
	tiles             = {"tardis_exterior.png^[opacity:150"},
	use_texture_alpha = true,
	drawtype          = "mesh",
	mesh              = "tardis_exterior.obj",
	paramtype         = "light",

	on_timer = function(pos)
		tardis.swap_node(pos, {name = "tardis:tardis_remat_7"})
	end,

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(1)
	end,
})

minetest.register_node("tardis:tardis_remat_7", {
	tiles             = {"tardis_exterior.png^[opacity:175"},
	use_texture_alpha = true,
	drawtype          = "mesh",
	mesh              = "tardis_exterior.obj",
	paramtype         = "light",
	light_source      = 10,

	on_timer = function(pos)
		tardis.swap_node(pos, {name = "tardis:tardis_remat_8"})
	end,

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(1)
	end,
})

minetest.register_node("tardis:tardis_remat_8", {
	tiles             = {"tardis_exterior.png^[opacity:200"},
	use_texture_alpha = true,
	drawtype          = "mesh",
	mesh              = "tardis_exterior.obj",
	paramtype         = "light",

	on_timer = function(pos)
		tardis.swap_node(pos, {name = "tardis:tardis_remat_9"})
	end,

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(0.5)
	end,
})

minetest.register_node("tardis:tardis_remat_9", {
	tiles             = {"tardis_exterior.png^[opacity:225"},
	use_texture_alpha = true,
	drawtype          = "mesh",
	mesh              = "tardis_exterior.obj",
	paramtype         = "light",
	light_source      = 10,

	on_timer = function(pos)
		tardis.swap_node(pos, {name = "tardis:tardis"})
		minetest.forceload_free_block(pos)
	end,

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(1)
	end,
})

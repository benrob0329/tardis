tardis = {}
tardis.owners = {}

modpath = minetest.get_modpath(minetest.get_current_modname())
worldpath = minetest.get_worldpath(minetest.get_worldpath())

dofile(modpath .. "/remat.lua")
dofile(modpath .. "/demat.lua")
dofile(modpath .. "/functions.lua")

local file = io.open(worldpath .. "/tardis.owners", "r")

if file then
   tardis.owners = minetest.deserialize(file:read("*all"))
   file:close()
end



minetest.register_node("tardis:tardis", {
			  groups = {crumbly = 1},
			  tiles = {"tardis_exterior.png"},
			  use_texture_alpha = true,
			  drawtype = "mesh",
			  mesh = "tardis_exterior.obj",
			  paramtype = "light",
			  is_ground_content = true,

			  on_place = function(itemstack, placer, pointed_thing)
			     local pos = pointed_thing.above
			     local player = placer:get_player_name()
			     
			     tardis.swap_node(pos, {name = "tardis:tardis"})
			     
			     if (player == nil) then
				local meta = minetest.get_meta(pos)
				local player = meta:get_string("owner")

				tardis.owners[player]["exterior"] = pos

			     elseif (tardis.owners[player] == nil) then
				tardis:spawn_interior(pos, player)
			     else
				tardis.owners[player]["exterior"] = pos
			     end
			     
			     local meta = minetest.get_meta(pos)
			     
			     meta:set_string("owner", player)
			  end,
			  
			  
			  on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			     local meta = minetest.get_meta(pos)
			     local owner = meta:get_string("owner")
			     local teleport = tardis.owners[owner]["interior"]
			     
			     player.setpos(player, teleport)
			     --player.set_look_horizontal(0)
			  end,
})


minetest.register_node("tardis:demat_lever_off", {
			  groups = {crumbly = 1},
			  tiles = {"tardis_demat.png"},
			  drawtype = "mesh",
			  mesh = "tardis_demat_off.obj",
			  paramtype = "light",
			  paramtype2 = "facedir",
			  is_ground_content = true,
			  
			  on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			     local player_name = player:get_player_name()
			     local meta = minetest.get_meta(pos)
			     local owner = meta:get_string("owner")

			     print(owner)
			     
			     tardis.demat((tardis.owners[owner]["exterior"]), owner)

			     minetest.swap_node(pos, {name = "tardis:demat_lever_on"})
			     
			     minetest.sound_play("tardis_demat", {
						    pos = pos,
						    max_hear_distance = 10,
						    gain = 10,
			     })
			  end,
})

minetest.register_node("tardis:demat_lever_on", {
			  groups = {crumbly = 1},
			  tiles = {"tardis_demat.png"},
			  drawtype = "mesh",
			  mesh = "tardis_demat_on.obj",
			  paramtype = "light",
			  paramtype2 = "facedir",
			  is_ground_content = true,

			  on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			     local player_name = player:get_player_name()

			     minetest.show_formspec(player_name, "tardis:remat_form",
						    "size[4,3]" ..
						       "field[1,1.5;3,1;coords;Co-ords;]" ..
						       "button_exit[1,2;2,1;exit;Go!]")

			     minetest.register_on_player_receive_fields(function(player, formname, fields)
				   if formname ~= "tardis:remat_form" then
				      return false
				   end

				   local coords = minetest.string_to_pos(fields.coords)
				   local meta = minetest.get_meta(pos)
				   local owner = meta:get_string("owner")

				   print(owner)

				   tardis.remat(coords, owner)
				
				   minetest.swap_node(pos, {name = "tardis:demat_lever_off"})
				   minetest.sound_play("tardis_remat", {
							  pos = pos,
							  max_hear_distance = 10,
							  gain = 10, })	       
				   return true
									end
) end, })


minetest.register_node("tardis:interior_doors", {
			  tiles = {"tardis_exterior.png"},
			  use_texture_alpha = true,
			  drawtype = "mesh",
			  mesh = "tardis_interior_doors.obj",
			  paramtype = "light",
			  is_ground_content = true,

			  on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			     local meta = minetest.get_meta(pos)
			     local owner = meta:get_string("owner")
			     
			     print(owner)
			     
			     local teleport = tardis.owners[owner]["exterior"]
			     
			     player:setpos(teleport)

			  end
})


minetest.register_on_shutdown(function()
      local file = io.open(worldpath .. "/tardis.owners", "w+")
      file:write(minetest.serialize(tardis.owners))
      file:close()
end)

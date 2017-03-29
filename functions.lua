function tardis.swap_node(pos, name)
   local meta = minetest.get_meta(pos)
   local meta_old = meta:to_table()
   
   minetest.set_node(pos, name)
   
   local meta = minetest.get_meta(pos)
   meta:from_table(meta_old)
end


function tardis:spawn_interior(pos, owner)
   local place_pos = {x = pos["x"], y = 30000, z = pos["z"]}
   local interior_doors_pos = { x = (place_pos["x"] + 5),y = (place_pos["y"] + 1),z = (place_pos["z"] +1) }
   local demat_lever_pos = {x = (place_pos["x"] + 4) , y = (place_pos["y"] + 2) , z = (place_pos["z"] + 7) }
   
   minetest.place_schematic(place_pos, modpath .. "/schematics/tardis_interior.mts")
   tardis.owners[owner] = {}
   tardis.owners[owner]["exterior"] = pos
   tardis.owners[owner]["interior"] = interior_doors_pos
   tardis.owners[owner]["in_vortex"] = false

   local demat_meta = minetest.get_meta(demat_lever_pos)
   demat_meta:set_string("owner", owner)
   
   local interior_doors_meta = minetest.get_meta(interior_doors_pos)
   interior_doors_meta:set_string("owner", owner)
   
   print(minetest.pos_to_string(tardis.owners[owner]["interior"]))

   local file = io.open(worldpath .. "/tardis.owners", "w+")
   file:write(minetest.serialize(tardis.owners))
   file:close()
end

function tardis.set_nav(player, owner)
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

	 if (coords == nil) then
	    minetest.chat_send_player(player_name, "Please Enter Valed Coords")
	 else
	    tardis.owners[owner]["destination"] = coords       
	    return true
	 end
   end)
end

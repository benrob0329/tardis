local modname   = minetest.get_current_modname()
local modpath   = minetest.get_modpath(modname)
local worldpath = minetest.get_worldpath()

-- Hacky node swap function since minetest.swap_node doesnt call any callbacks
function tardis.swap_node (pos, name)
	local meta     = minetest.get_meta (pos)
	local meta_old = meta:to_table()

	minetest.set_node (pos, name)

	local meta     = minetest.get_meta (pos)
	meta:from_table (meta_old)
end


-- Spawn a TARDIS and set the controls/doors meta with relative coordinates
function tardis:spawn_interior (pos, owner)
	local place_pos = {
		x = tardis.count * 12 ,
		y = 30000    ,
		z = 0 ,
	}
	tardis.count = tardis.count + 1
	local interior_doors_pos = {
		x = (place_pos ["x"] + 5) ,
		y = (place_pos ["y"] + 1) ,
		z = (place_pos ["z"] + 1) ,
	}
	local demat_lever_pos = {
		x = (place_pos ["x"] + 4) ,
		y = (place_pos ["y"] + 2) ,
		z = (place_pos ["z"] + 7) ,
	}
	local nav_pos = {
		x = (place_pos ["x"] + 4) ,
		y = (place_pos ["y"] + 2) ,
		z = (place_pos ["z"] + 8) ,
	}

	minetest.place_schematic (place_pos, modpath .. "/schematics/tardis_interior.mts")

	-- Add TARDIS to index
	tardis.tardises [owner]              = {}
	tardis.tardises [owner]["exterior"]  = pos
	tardis.tardises [owner]["interior"]  = interior_doors_pos
	tardis.tardises [owner]["in_vortex"] = false

	--Set meta
	local demat_meta = minetest.get_meta (demat_lever_pos)
	demat_meta:set_string ("owner", owner)
	
	local nav_meta = minetest.get_meta (nav_pos)
	nav_meta:set_string ("owner", owner)

	local interior_doors_meta = minetest.get_meta (interior_doors_pos)
	interior_doors_meta:set_string ("owner", owner)

	minetest.log("info", minetest.pos_to_string (tardis.tardises [owner]["interior"] ))

	local file = io.open (worldpath .. "/tardis.tardises", "w+")
	file:write ( minetest.serialize (tardis.tardises) )
	file:close()
end


-- Set navigation, uses a formspec
function tardis.set_nav (player, owner)
	local player_name = player:get_player_name()
	if player_name ~= owner then minetest.chat_send_player(player_name, "You don't own that TARDIS!"); return end
	if tardis.tardises[owner]["in_vortex"] == false then minetest.chat_send_player(player_name, "You must dematerialize the TARDIS first!"); return end

	minetest.show_formspec (player_name, "tardis:remat_form",
	"size[7,3]" ..
	"field[1,1.5;2,1;x;X;]" ..
	"field[3,1.5;2,1;y;Y;]" ..
	"field[5,1.5;2,1;z;Z;]" ..
	"button_exit[1,2;2,1;exit;Go!]")

	minetest.register_on_player_receive_fields (function (player, formname, fields)
		if formname ~= "tardis:remat_form" then
			return false
		end

		local coords = {x = tonumber(fields.x), y = tonumber(fields.y), z = tonumber(fields.z)}

		if (coords == nil or coords.x == nil or coords.y == nil or coords.z == nil) then
			minetest.chat_send_player (player_name, "Please enter valid coordinates.")
		else
			tardis.tardises [owner]["destination"] = coords
			return true
		end
	end)
end


-- When a player teleports into a previously generated mapblock with the TARDIS, we want it to appear.
minetest.register_on_generated(function(minp, maxp, blockseed)
	for owner,table in pairs(tardis.tardises) do
		local exterior = table["exterior"]
		if exterior.x >= minp.x and exterior.y >= minp.y and exterior.z >= minp.z and
		   exterior.x <= maxp.x and exterior.y <= maxp.y and exterior.z <= maxp.z then
			minetest.set_node(exterior, {name="tardis:tardis"})
			minetest.get_meta(exterior):set_string("owner", owner)
		end
	end
end)

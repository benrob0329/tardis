local modname     = minetest.get_current_modname()
local modpath     = minetest.get_modpath(modname)
local mod_storage = minetest.get_mod_storage()
local tardis_context = {}

-- Functions are fairly self explanitory, get or set the specified value.
function tardis.set_nav(pos, name)
	local pos_string = (minetest.pos_to_string(pos))

	if (pos_string) then
		if (mod_storage:set_string("tardis:"..name..":destination", pos_string)) then
			return true
		else return false
		end
	end
end

function tardis.get_nav(name)
	local pos = minetest.string_to_pos(mod_storage:get_string("tardis:"..name..":destination"))

	if (pos) then
		return pos
	elseif (tardis.get_exterior(name)) then
		return tardis.get_exterior(name)
	else return { x = 0, y = 0, z = 0 }
	end
end

function tardis.set_exterior(pos, name)
	local pos_string = (minetest.pos_to_string(pos))

	if (pos_string) then
		if (mod_storage:set_string("tardis:"..name..":exterior", pos_string)) then
			return true
		else return false
		end
	end
end

function tardis.get_exterior(name)
	local pos = minetest.string_to_pos(mod_storage:get_string("tardis:"..name..":exterior"))

	if (pos) then
		return pos
	else return false
	end
end

function tardis.set_interior(pos, name)
	local pos_string = (minetest.pos_to_string(pos))

	if (pos_string) then
		if (mod_storage:set_string("tardis:"..name..":interior", pos_string)) then
			return true
		else return false
		end
	end
end

function tardis.get_interior(name)
	local pos = minetest.string_to_pos(mod_storage:get_string("tardis:"..name..":interior"))

	if (pos) then
		return pos
	else return false
	end
end

function tardis.add_count()
	local current_count = tonumber(mod_storage:get_string("tardis:count"))

	if (current_count) then
		if (mod_storage:set_string("tardis:count", tostring(current_count+1))) then
			return true
		else return false
		end

	elseif (mod_storage:set_string("tardis:count", "1")) then
		return true
	else return false
	end
end

function tardis.get_count()
	local current_count = tonumber(mod_storage:get_string("tardis:count"))

	if (current_count) then
		return current_count
	else return 0
	end
end

function tardis.set_vortex(bool, name)
	if (mod_storage:set_string("tardis:"..name..":vortex", tostring(bool))) then
		return true
	else return nil
	end
end

function tardis.get_vortex(name)
	if (mod_storage:get_string("tardis:"..name..":vortex") == "true") then
		return true
	else return false
	end
end


-- Hacky node swap function since minetest.swap_node doesnt call any callbacks
function tardis.swap_node (pos, name)
	local meta     = minetest.get_meta (pos)
	local meta_old = meta:to_table()

	minetest.set_node (pos, name)

	meta     = minetest.get_meta (pos)
	meta:from_table (meta_old)
end


-- Spawn a TARDIS and set the controls/doors meta with relative coordinates
function tardis:spawn_interior (pos, name)
	local place_pos = {
		x = tardis.get_count() * 12,
		y = 30000,
		z = 0,
	}
	tardis.add_count()
	local interior_doors_pos = {
		x = (place_pos.x + 5) ,
		y = (place_pos.y + 1) ,
		z = (place_pos.z + 1) ,
	}
	local demat_lever_pos = {
		x = (place_pos.x + 4) ,
		y = (place_pos.y + 2) ,
		z = (place_pos.z + 7) ,
	}
	local nav_pos = {
		x = (place_pos.x + 4) ,
		y = (place_pos.y + 2) ,
		z = (place_pos.z + 8) ,
	}

	minetest.place_schematic(place_pos, modpath .. "/schematics/tardis_interior.mts")

	-- Add TARDIS to index
	tardis.set_exterior(pos, name)
	tardis.set_interior(interior_doors_pos, name)
	tardis.set_vortex(false, name)

	--Set meta
	local demat_meta = minetest.get_meta(demat_lever_pos)
	demat_meta:set_string("owner", name)

	local nav_meta = minetest.get_meta(nav_pos)
	nav_meta:set_string("owner", name)

	local interior_doors_meta = minetest.get_meta(interior_doors_pos)
	interior_doors_meta:set_string("owner", name)

	minetest.log("info", minetest.pos_to_string(tardis.get_interior(name)))
end


-- Set navigation, uses a formspec
function tardis.show_nav_formspec(player_name, owner_name)
	local pos = tardis.get_nav(owner_name)

	if (pos) then
		tardis_context[player_name] = owner_name
		minetest.show_formspec(player_name, "tardis:remat_form",
		"size[7,3]" ..
		"field[1,1.5;2,1;x;X;"..pos.x.."]" ..
		"field[3,1.5;2,1;y;Y;"..pos.y.."]" ..
		"field[5,1.5;2,1;z;Z;"..pos.z.."]" ..
		"button_exit[1,2;2,1;exit;Go!]")
	else return false end
end

-- Make sure TARDISes placed in ungenerated chunks exist and have meta set correctly.
minetest.register_on_generated(function(minp, maxp, blockseed)
	local table = mod_storage:to_table()

	for k, v in pairs(table.fields) do
		if (k == string.match(k, "tardis:.+:exterior")) then
			local pos = minetest.string_to_pos(v)

			if ((pos) and
			    (pos.x >= minp.x) and (pos.y >= minp.y) and (pos.z >= minp.z) and
			    (pos.x <= maxp.x) and (pos.y <= maxp.y) and (pos.z <= maxp.z)) then

				minetest.set_node(pos, {name = "tardis:tardis"})
				local meta = minetest.get_meta(minetest.string_to_pos(v))
				local owner = string.match(k, "tardis:(.+):exterior")

				meta:set_string("owner", owner)
			end
		end
	end
end)

minetest.register_on_player_receive_fields(function (player, formname, fields)
	if (formname ~= "tardis:remat_form") then
		return false
	end

	local player_name = player:get_player_name()
	local owner_name = tardis_context[player_name]

	if not owner_name then
		minetest.log("error", player_name .. " sending invalid formspec data")
		return true
	end

	local pos = tardis.get_nav(owner_name)

	if pos then
		if (tonumber(fields.x)) then pos.x = tonumber(fields.x)
			else minetest.chat_send_player(player_name, "X Coordinate Invalid") end
		if (tonumber(fields.y)) then pos.y = tonumber(fields.y)
			else minetest.chat_send_player(player_name, "Y Coordinate Invalid") end
		if (tonumber(fields.z)) then pos.z = tonumber(fields.z)
			else minetest.chat_send_player(player_name, "Z Coordinate Invalid") end
	end

	tardis_context[player_name] = nil
	tardis.set_nav(pos, owner_name)
	return true
end)

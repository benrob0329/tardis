-- Define global table and TARDIS index
tardis = {}
tardis.count = 0
tardis.tardises = {}

local modname   = minetest.get_current_modname()
local modpath   = minetest.get_modpath (modname)
local worldpath = minetest.get_worldpath()

dofile (modpath .. "/remat.lua")
dofile (modpath .. "/demat.lua")
dofile (modpath .. "/functions.lua")
dofile (modpath .. "/nodes.lua")

-- Open TARDIS index from file
local file = io.open (worldpath .. "/tardis.tardises", "r")
local count_file = io.open (worldpath .. "/tardis.count", "r")

-- If file exists, write into current index
if file then
	tardis.tardises = minetest.deserialize (file:read("*all"))
	file:close()
end

if count_file then
	tardis.count = minetest.deserialize (count_file:read("*all"))
	count_file:close()
end

-- Register chatcommand to set navigation, return a help message if user doe not own a TARDIS
minetest.register_chatcommand ("set_nav", {
	description = "Sets the navigation coordinates for your TARDIS.",
	func = function (name, param)
		if (tardis.tardises [name] == nil) then
			minetest.chat_send_player (name, "Must be owner!")
		else
			local owner = name
			local player = minetest.get_player_by_name (name)

			tardis.set_nav (player, owner)
		end
	end
})

-- Save index on shutdown
minetest.register_on_shutdown( function()
	local file = io.open (worldpath .. "/tardis.tardises", "w+")
	file:write(minetest.serialize (tardis.tardises) )
	file:close()

	local count_file = io.open(worldpath .. "/tardis.count", "w+")
	count_file:write(minetest.serialize(tardis.count))
	count_file:close()
end )

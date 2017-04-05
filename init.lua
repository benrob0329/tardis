tardis = {}
tardis.tardises = {}

local modname   = minetest.get_current_modname()
local modpath   = minetest.get_modpath (modname)
local worldpath = minetest.get_worldpath()

dofile (modpath .. "/remat.lua")
dofile (modpath .. "/demat.lua")
dofile (modpath .. "/functions.lua")
dofile (modpath .. "/nodes.lua")

local file = io.open (worldpath .. "/tardis.tardises", "r")

if file then
    tardis.tardises = minetest.deserialize (file:read("*all"))
    file:close()
end

minetest.register_chatcommand ("set_nav", {
    func = function (name, param)
        if (tardis.tardises [name] == nil) then
            name.chat_send_player (name, "Must be owner!")
        else
            local owner = name
            local player = minetest.get_player_by_name (name)

            tardis.set_nav (player, owner)
        end
    end
})

minetest.register_on_shutdown( function()
    local file = io.open (worldpath .. "/tardis.tardises", "w+")
    file:write(minetest.serialize (tardis.tardises) )
    file:close()
end )

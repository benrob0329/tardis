-- Define global table
tardis = {}
tardis.done = {}

local modname   = minetest.get_current_modname()
local modpath   = minetest.get_modpath(modname)

dofile(modpath .. "/remat.lua")
dofile(modpath .. "/demat.lua")
dofile(modpath .. "/functions.lua")
dofile(modpath .. "/nodes.lua")

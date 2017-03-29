# tardis
Pre Alpha Tardis Mod For Minetest

Do **not** use on a production server, there is no protection check or ~~error handling.~~

## Use:
Give yourself ```tardis:tardis``` and place down away from other Tardises (the interior spawns directly above it, at Y = 30000). Right click on the exterior to teleport to the interior. Right click the demat lever to dematerialise. Right click it again to remat. Use **/set_nav** to bring up a coords dialog, enter **valid** coords ~~anything else will crash the game~~ This has been fixed.

### TODO:
1. ~~Clean Up The Code, move all functions to functions.lua and node definitions to nodes.lua~~
2. Add remat pos checks (~~validity~~ and air)
3. Redo meshes, make doors open
4. Add scanner/other device to enter remat pos

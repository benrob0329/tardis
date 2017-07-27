minetest.register_node ("tardis:tardis", {
    decription        = "Time And Relative Dimention In Space" ,
    tiles             = { "tardis_exterior.png" } ,
    use_texture_alpha = true ,
    drawtype          = "mesh" ,
    mesh              = "tardis_exterior.obj" ,
    paramtype         = "light" ,
    is_ground_content = true ,

    on_place = function (itemstack, placer, pointed_thing)
        local pos    = pointed_thing.above
        local player = placer:get_player_name()
        tardis.swap_node (pos, {name = "tardis:tardis"})

        if (player == nil) then
            local meta   = minetest.get_meta (pos)
            local player = meta:get_string ("owner")
            tardis.tardises [player]["exterior"] = pos
        elseif (tardis.tardises [player] == nil) then
            tardis:spawn_interior (pos, player)
        else
            tardis.tardises [player]["exterior"] = pos
        end

        local meta = minetest.get_meta (pos)
        meta:set_string ("owner", player)
        itemstack:take_item (1)
    end ,


    on_rightclick = function (pos, node, player, itemstack, pointed_thing)
        local meta     = minetest.get_meta (pos)
        local owner    = meta:get_string ("owner")
        local teleport = tardis.tardises [owner]["interior"]

        player.setpos (player, teleport)
        --player.set_look_horizontal(0)
    end ,
})


minetest.register_node ("tardis:demat_lever_on", {
    tiles             = {"tardis_demat.png"} ,
    drawtype          = "mesh" ,
    mesh              = "tardis_demat_on.obj" ,
    paramtype         = "light" ,
    is_ground_content = true ,

    on_rightclick     = function (pos, node, player, itemstack, pointed_thing)
        local player_name = player:get_player_name()
        local meta        = minetest.get_meta(pos)
        local owner       = meta:get_string("owner")

        if (tardis.remat (owner) == false) then
            minetest.chat_send_player (player_name, "Nav Not Set!!")
        else
            minetest.sound_play ("tardis_demat", {
                pos               = pos ,
                max_hear_distance = 10 ,
                gain              = 10 ,
            })

            minetest.swap_node (pos, {name = "tardis:demat_lever_off"})
        end
    end
})


minetest.register_node ("tardis:demat_lever_off", {
    groups            = {crumbly = 1} ,
    tiles             = {"tardis_demat.png"} ,
    drawtype          = "mesh" ,
    mesh              = "tardis_demat_off.obj" ,
    paramtype         = "light" ,
    is_ground_content = true ,

    on_rightclick     = function (pos, node, player, itemstack, pointed_thing)
        local meta  = minetest.get_meta(pos)
        local owner = meta:get_string("owner")

        tardis.demat (owner)
        minetest.sound_play ("tardis_demat", {
            pos               = pos ,
            max_hear_distance = 10  ,
            gain              = 10  ,
        })

        minetest.swap_node (pos, {name = "tardis:demat_lever_on"})
    end ,
})


minetest.register_node ("tardis:interior_doors", {
    tiles             = {"tardis_exterior.png"} ,
    use_texture_alpha = true ,
    drawtype          = "mesh" ,
    mesh              = "tardis_interior_doors.obj" ,
    paramtype         = "light" ,
    is_ground_content = true ,

    on_rightclick = function (pos, node, player, itemstack, pointed_thing)
        local meta = minetest.get_meta (pos)
        local owner = meta:get_string ("owner")

        if (tardis.tardises == nil) or
           (tardis.tardises [owner] == nil) or
           (tardis.tardises [owner]["in_vortex"] == nil) then
               minetest.log ("error", "in_vortex not initialised for  " .. owner)
               return
        end

        if (tardis.tardises [owner]["in_vortex"] == false) then
            local teleport = tardis.tardises [owner]["exterior"]
            player:setpos (teleport)
        else
            player_name = player:get_player_name()
            minetest.chat_send_player (player_name, "TARDIS In Vortex, Door Locked Automaticly")
        end
    end
})

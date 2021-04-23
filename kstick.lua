local stick_knockback = 25 --how hard the stick smacks kids. recommended min: 20
local stick_pointing_distance = 5 --selecting distance of smacking
events_invincible = {}
events_timeouts = {}
events_jumpouts = {}


minetest.register_craftitem("events:knockbackstick", {
    description = "Knockback Stick",
    inventory_image = "events_kstick.png^[colorize:#F200FF:50",
    groups = {not_in_creative_inventory = 1},
    stack_max = 1,
    wield_scale = {x = 2, y = 2, z = 2},
    on_drop = function() end,
    range = stick_pointing_distance,

    on_use = function(itemstack, user, pointed_thing)

        local p_name = user:get_player_name()
        local last_push_time = events_timeouts[p_name] or 0.0
        local current_time = minetest.get_us_time()/1000000.0
        local time_from_last_push = current_time-last_push_time
        local force = stick_knockback

        if pointed_thing == nil then return end
        if pointed_thing.type == 'node' then return end
        if not pointed_thing.type == 'object' then return end

        if pointed_thing.type == 'object' then
            
            --this only works on players
            if minetest.is_player(pointed_thing.ref) == true then

                local dir = user:get_look_dir()
                local keys = user:get_player_control()
                local hitted_pos = pointed_thing.ref:get_pos()
                local hitter_pos = user:get_pos()

                if vector.distance(hitted_pos,hitter_pos) < stick_pointing_distance then

                    local pointed_name = pointed_thing.ref:get_player_name()
                    if not events_invincible[pointed_name] then
                        pointed_thing.ref:add_player_velocity(vector.multiply(dir, force))
                        events_timeouts[p_name] = current_time

                    end
                    
                end

            end
        end
    end,

})

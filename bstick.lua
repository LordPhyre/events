local stick_knockback = 40 --how hard the stick smacks kids. recommended min: 35
local stick_bounce_reach = 25 --selecting distance of bouncing
local stick_bounce_timeout = 0.1 --bounce limiter in seconds. recommended min: 0.1
events.timeouts = {}
events.jumpouts = {}


minetest.register_craftitem("events:broomstick", {
    description = "Broomstick",
    inventory_image = "events_broom.png",
    stack_max = 1,
    wield_scale = {x = 2, y = 2, z = 2},
    on_drop = function() end,
    range = stick_pointing_distance,

    on_place = function(itemstack, placer, pointed_thing)

        local p_name = placer:get_player_name()
        local last_jump_time = events.jumpouts[p_name] or 0.0
        local current_time = minetest.get_us_time()/1000000.0 --microsec converted to sec
        local time_from_last_jump = current_time-last_jump_time
        
        if pointed_thing.type == 'node' then
            if vector.distance(pointed_thing.under, placer:get_pos()) < stick_bounce_reach then

                if last_jump_time == 0.0 or time_from_last_jump >= stick_bounce_timeout then
                    local lookvect = placer:get_look_dir()
                    local pushvect = vector.normalize( {x=lookvect.x, z=lookvect.z, y= math.sqrt(1-(lookvect.y*lookvect.y))})
                    --gives a unit vector that is 90 deg offset in the vert direction
                    local force = 8 * vector.length(vector.normalize( {x=lookvect.x, z=lookvect.z, y= 0}))
                    events.jumpouts[p_name] = current_time
                    placer:add_player_velocity(vector.multiply(pushvect, force))
                end
            end
        end
        
    end,

})

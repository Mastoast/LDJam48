function init_race()
    gamestate = 1
    gtime = 0
    shake = 0
    freeze_time = 0
    gcamera = {x = 0, y = 0, facing = 3, speed_y = 2}
    objects = {}
    particles = {}
    ground_limit = 80
    finish_line = 64
    race_finished = false
    --
    current_player = create(mole, 40, 72)
    current_player.get_input = ply_input
    current_player.is_player = true
    create(mole, 64, 72)
    create(mole, 88, 72)
    create(mole, 112, 72)
    race_length = 4
    patterns = {0, 5, 5, 5, 1}
    -- spawn a worm every pattern
    for i=1,#patterns - 1 do
        create(worm, flr(rnd(120)), i * 128 + flr(rnd(120)))
    end
end

function update_race()

    for o in all(objects) do
        o:update()
        if o.destroyed then del(objects, o) end
    end

    for a in all(particles) do
        a:update()
    end

    -- Camera
    local dest = 0
    if race_finished then
        dest = (#patterns - 1) * 128
    else
        dest = (current_player.y - 64 + current_player.hit_h) + (current_player.facing == 3 and 48 or -48)
    end
    printable = race_finished

    local diff = dest - gcamera.y
    if abs(diff) > gcamera.speed_y then
        gcamera.speed_y += sgn(diff)
        gcamera.y = gcamera.y + gcamera.speed_y
    else
        gcamera.y = dest
    end
    -- clamp
    if race_finished then
        gcamera.y = min(gcamera.y, (#patterns - 1) * 128)
    else
        gcamera.y = max(current_player.y - 88, min(current_player.y - 24, gcamera.y, (#patterns - 1) * 128))
    end
end


function draw_race()
    cls((gcamera.y > 80 and 4) or 12)
    
    -- camera
    if shake > 0 then
        camera(gcamera.x - 2 + rnd(5), gcamera.y - 2 + rnd(5))
    else
        camera(gcamera.x, gcamera.y)
    end

    -- print every visible pattern
    if patterns and #patterns > 0 then
        for i=1,#patterns do
            if gcamera.y > 128 * (i - 2) and gcamera.y < 128 * (i) then
                local pattern_x, pattern_y = get_pattern(patterns[i])
                map(pattern_x, pattern_y, 0, 8 * 16 * (i - 1), 16,16)
            end
        end
    end

    for o in all(objects) do
        o:draw()
    end

    for a in all(particles) do
		a:draw()
	end
end


function get_pattern(n)
    return flr(n/4) * 16, n%4 * 16
end
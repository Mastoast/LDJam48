function _init()
    init_menu()
end

function init_menu()
    --
    gamestate = 0
    -- 0 = menu / 1 = race /
    gtime = 0
    shake = 0
    infade = 0
    printable = 0
    freeze_time = 30
    title_color = 1
    gcamera = {x = 0, y = -8*5, facing = 3, speed_y = 2}
end

function update_race()

    for o in all(objects) do
        o:update()
        if o.destroyed then del(objects, o) end
    end

    for a in all(particles) do
        a:update()
    end

    -- TODO better camera
    local dest = (current_player.y - 64 + current_player.hit_h) + (current_player.facing == 3 and 48 or -48)
    local diff = dest - gcamera.y
    if abs(diff) > gcamera.speed_y then
        gcamera.speed_y += sgn(diff)
        gcamera.y = gcamera.y + gcamera.speed_y
    else
        gcamera.y = dest
    end
    -- clamp
    gcamera.y = max(current_player.y - 88, min(current_player.y - 24, gcamera.y))
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

function update_menu()

    if freeze_time > 0 then return end

    if gtime%6 == 0 then title_color = 7 + rnd(8) end

    if gcamera.y < 53 then
        gcamera.y += (56 - gcamera.y)/8 * 0.2
        return
    end
    if btnp(4) or btnp(5) then
        init_race()
    end


end

function draw_menu()
    cls(12)

    camera(gcamera.x, gcamera.y)

    map(0, 0, 0, 0, 16, 32)
    rectfill(18, 116, 110, 128, 5)
    rectfill(20, 118, 108, 126, 6)
    print_centered("super mole racing", 0, 120, 0)
    print_centered("super mole racing", 1, 121, title_color)
    --
    if gcamera.y >= 53 then
        print_centered(" press 🅾️ or ❎ to start ", 1, 155, 1)
        print_centered(" press 🅾️ or ❎ to start ", 0, 156, 7)
    end

end

function _update()
    -- timers
    gtime += 1
    shake = max(shake - 1)
    freeze_time = max(0, freeze_time - 1)

    if gamestate == 0 then
        update_menu()
    elseif gamestate == 1 then
        update_race()
    end
end

function _draw()
    if gamestate == 0 then
        draw_menu()
    elseif gamestate == 1 then
        draw_race()
    end
    print(printable, gcamera.x + 80, gcamera.y + 120, 6)
end

-- linear interpolation
function lerp(start,finish,t)
    return mid(start,start*(1-t)+finish*t,finish)
end

-- print at center
function print_centered(str, offset_x, y, col)
    print(str, 64 - (#str * 2) + offset_x, y, col)
end
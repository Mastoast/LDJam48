function _init()
    --
    gtime = 0
    shake = 0
    infade = 0
    printable = 0
    gcamera = {x = 0, y = 0, speed = 2}
    init_race()
end

function _update()
    -- timers
    gtime += 1
    shake = max(shake - 1)

    for o in all(objects) do
        o:update()
        if o.destroyed then del(objects, o) end
    end

    for a in all(particles) do
		a:update()
	end

    -- TODO better camera
    local dest = current_player.y - 16
    local diff = dest - gcamera.y
    if abs(diff) > gcamera.speed then
        gcamera.y = gcamera.y + sgn(diff) * gcamera.speed
    else
        gcamera.y = dest
    end
    -- clamp
    gcamera.y = max(dest - 32, min(dest + 32, gcamera.y))
end

function _draw()
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

    print(printable, gcamera.x + 80, gcamera.y + 120, 6)
end

-- linear interpolation
function lerp(start,finish,t)
    return mid(start,start*(1-t)+finish*t,finish)
end
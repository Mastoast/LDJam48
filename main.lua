function _init()
    --
    gtime = 0
    shake = 0
    infade = 0
    gcamera = {x = 0, y = 0}
    create(worm, 14, 14)
    current_player = create(mole, 50, 50)
end

function _update()
    -- timers
    gtime += 1
    shake = max(shake - 1)

    for o in all(objects) do
        o:update()
    end

    -- TODO fluid camera
    gcamera.y = current_player.y - 32
end

function _draw()
    cls(12)
    
    -- camera
    if shake > 0 then
        camera(gcamera.x - 2 + rnd(5), gcamera.y - 2 + rnd(5))
    else
        camera(gcamera.x, gcamera.y)
    end

    map(0, 0, 0, 0, 16, 64)

    for o in all(objects) do
        o:draw()
    end

    print(printable, 80, 120, 6)
end

-- linear interpolation
function lerp(start,finish,t)
    return mid(start,start*(1-t)+finish*t,finish)
end
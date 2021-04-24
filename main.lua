function _init()
    --
    gtime = 0
    shake = 0
    infade = 0
    create(worm, 14, 14)
    create(mole, 50, 50)
end

function _update()
    -- timers
    gtime += 1
    shake = max(shake - 1)

    for o in all(objects) do
        o:update()
    end
end

function _draw()
    cls(12)
    
    -- camera
    if shake > 0 then
        camera(0 - 2 + rnd(5), 0 - 2 + rnd(5))
    else
        camera(0, 0)
    end

    map()

    for o in all(objects) do
        o:draw()
    end

    print(printable, 80, 120, 6)
end

-- linear interpolation
function lerp(start,finish,t)
    return mid(start,start*(1-t)+finish*t,finish)
end
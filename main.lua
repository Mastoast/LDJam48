function _init()
    --
    gtime = 0
    shake = 0
    infade = 0
end

function _update60()
    -- timers
    gtime += 1
    shake = max(shake - 1)
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

    print(printable, 80, 120, 6)
end

-- linear interpolation
function lerp(start,finish,t)
    return mid(start,start*(1-t)+finish*t,finish)
end
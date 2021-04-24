function _init()
    --
    gtime = 0
    shake = 0
    infade = 0
    printable = 0
    gcamera = {x = 0, y = 0}
    create(worm, 14, 14)
    create(worm, 64, 150)
    create(worm, 64, 200)
    create(worm, 64, 250)
    create(worm, 64, 300)
    create(worm, 64, 350)
    current_player = create(mole, 50, 50)
    current_player.get_input = ply_input
    current_player.is_player = true
    create(mole, 110, 50)
    create(mole, 30, 50)
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

    for a in all(particles) do
		a:draw()
	end

    print(printable, gcamera.x + 80, gcamera.y + 120, 6)
end

-- linear interpolation
function lerp(start,finish,t)
    return mid(start,start*(1-t)+finish*t,finish)
end
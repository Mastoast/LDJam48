function _init()
    --init_menu()
    init_race()
end

-- TODO end race + result screen
-- sfx(2, 0, 16, 8)

-- TODO start countdown + anim flags
-- sfx(2, 0, 4, 1)
-- sfx(2, 0, 6, 1)

-- SFXs
-- menu selection 0/0-1
-- menu action 0/5-2
-- menu validation 0/0-6

-- digging 1/0-32
-- getting bonus 2/0-1
-- dashing 2/8-1
-- hitting 2/2-1
-- countdow 2/4-1 + 2/6-1
-- endline 2/16-8

-- TODO musics
-- menu music
-- racing music
-- result music

-- TODO mole IA


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
    ground_limit = 80
    gcamera = {x = 0, y = -8*5, facing = 3, speed_y = 2}
    objects = {}
    particles = {}
end

function update_menu()
    if freeze_time > 0 then return end

    if gtime%6 == 0 then title_color = 7 + rnd(8) end

    if gcamera.y < 53 then
        --gcamera.y += (56 - gcamera.y)/8 * 0.2
        gcamera.y += 4
        return
    end

    for o in all(objects) do
        o:update()
    end

    for a in all(particles) do
		a:update()
	end

    -- TODO menu selections (length / difficulties)
    if btnp(2) or btnp(3) then
        sfx(0, 0, 0, 1)
    end

    if btnp(0) or btnp(1) then
        sfx(0, 0, 5, 2)
    end

    if btnp(4) or btnp(5) then
        sfx(0, 0, 0, 6)
        init_race()
    end

    -- Spawn moles
    if #objects == 0 then
        for i in all({{-50, 108},{-10, 128},{220, 148},{138, 168}}) do
            local m = create(mole, i[1], i[2])
            m.get_input = menu_input
            m.speed_x = - sgn(i[1]) * 3
            m.speed_y = 0
            m.state = 1
        end
    end

end

function draw_menu()
    cls(12)

    camera(gcamera.x, gcamera.y)

    map(0, 0, 0, 0, 16, 32)

    for o in all(objects) do
        o:draw()
    end

    for a in all(particles) do
		a:draw()
	end

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
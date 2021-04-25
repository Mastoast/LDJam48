function _init()
    race_length = 15
    init_menu()
    --init_race()
end

-- TODO musics
-- menu music
-- racing music
-- result music

-- TODO anim flags

-- SFXs
-- menu selection 0/0-1
-- menu action 0/5-2
-- menu validation 0/0-6

-- digging 1/0-32
-- getting bonus 2/0-1
-- dashing 2/8-1
-- hitting 2/2-1
-- countdow 2/4-1 + 2/6-1


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
    --
    menu_select = 0
    -- 0 = depth, 1 = tuto, 2 = instructions
end

function update_menu()
    if freeze_time > 0 then return end

    if gtime%6 == 0 then title_color = 7 + rnd(8) end

    if gcamera.y < 53 then
        gcamera.y += (56 - gcamera.y)/8 * 0.2
        --gcamera.y += 4
        return
    end

    for o in all(objects) do
        o:update()
    end

    for a in all(particles) do
		a:update()
	end

    -- menu options
    if btnp(2) then
        sfx(0, 0, 0, 1)
        menu_select = (menu_select + 1) % 2
    elseif btnp(3) then
        sfx(0, 0, 0, 1)
        menu_select = (menu_select - 1) % 2
    end

    if menu_select == 0 then
        if btnp(0) then
            sfx(0, 0, 5, 2)
            race_length = max(race_length - 1, 1)
        elseif btnp(1) then
            sfx(0, 0, 5, 2)
            race_length = min(race_length + 1, 50)
        end
    elseif menu_select == 1 then
        if btnp(1) then
            menu_select = 2
        end
    elseif menu_select == 2 then
        if btnp(0) then menu_select = 1 end
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
    if gcamera.y >= 53 then
        --⬆️⬇️➡️⬅️
        local depth_text = "race depth : "..tostr(race_length)
        if menu_select == 0 then depth_text = "⬅️ "..depth_text.." ➡️" end
        print_centered(depth_text, 1, 135, 1)
        print_centered(depth_text, 0, 136, 7)
        --
        local tuto_text = "how to play"
        if menu_select == 1 then tuto_text = tuto_text.." ➡️" end
        print_centered(tuto_text, 1, 145, 1)
        print_centered(tuto_text, 0, 146, 7)
    end

    if menu_select == 2 then
        rectfill(18, 90, 110, 160, 5)
        rectfill(20, 92, 108, 158, 6)
        print_centered("move with ⬆️⬇️➡️⬅️  ", 0, 100, 0)
        print_centered(" dash with 🅾️ and ❎ ", 0, 110, 0)
        print("⬅️ return", 22, 150, 0)
    end

    --
    print_centered(" press 🅾️ or ❎ to start ", 1, 165, 1)
    print_centered(" press 🅾️ or ❎ to start ", 0, 166, 7)

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

-- random range
function rrnd(min, max)
    return flr(min + rnd(max - min))
end
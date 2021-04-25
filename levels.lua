function init_race()
    gamestate = 1
    gtime = 0
    shake = 0
    freeze_time = 0
    gcamera = {x = 0, y = 0, facing = 3, speed_y = 2}
    objects = {}
    particles = {}
    --
    current_player = create(mole, 40, 72)
    current_player.get_input = ply_input
    current_player.is_player = true
    -- create(mole, 64, 72)
    -- create(mole, 88, 72)
    -- create(mole, 112, 72)
    race_length = 4
    patterns = {0, 4, 5, 6, 1}
    -- spawn a worm every pattern
    for i=1,#patterns - 1 do
        create(worm, flr(rnd(120)), i * 128 + flr(rnd(120)))
    end
end

function get_pattern(n)
    return flr(n/4) * 16, n%4 * 16
end
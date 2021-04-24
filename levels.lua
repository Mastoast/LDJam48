function init_race()
    gtime = 0
    shake = 0
    gcamera = {x = 0, y = 0, speed = 2}
    --
    current_player = create(mole, 40, 72)
    current_player.get_input = ply_input
    current_player.is_player = true
    create(mole, 64, 72)
    create(mole, 88, 72)
    create(mole, 112, 72)
    race_length = 4
    patterns = {0, 4, 5, 6, 1}
end

function get_pattern(n)
    return flr(n/4) * 16, n%4 * 16
end
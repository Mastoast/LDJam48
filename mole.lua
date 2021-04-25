mole = new_type(16)
mole.hit_w = 8
mole.hit_h = 8
mole.state = 1
mole.facing = 2
mole.accel_y = 0.2
mole.decel_y = 0.9
mole.accel_x = 0.2
mole.decel_x = 0.9
mole.recovery = 0
mole.is_player = false
mole.dash_force = 4
mole.dash_cd = 15
mole.last_dash = 0

function mole.init(self)
    self.get_input = cpu_input
    self.speed_y = -10
    self.state = 3
    self.recovery = 30
end

-- States
-- 1 : digging
-- 2 : stuned
-- 3 : starting
-- 4 : waiting

function mole.update(self)

    if self.state == 3 then return end

    self.attack = gtime > self.last_dash + self.dash_cd/2

    -- timers
    if self.recovery > 0 then
        self.recovery -= 1
        if self.recovery == 0 and self.state == 2 then self.state = 1 end
    end
    
    -- get inputs
    local input_x = 0
    local input_y = 0
    
    if self.state == 1 then
        input_x, input_y = self:get_input()
    end
    
    if input_x == 0 then
        self.speed_x *= 0.9
        if abs(self.speed_x) < 1 then self.speed_x = 0 end
    elseif abs(input_x) > 1 and gtime > (self.last_dash + self.dash_cd) then
        -- dash
        self.speed_x = self.dash_force * sgn(input_x)
        self:psfx(2, 0, 8, 1)
        self.last_dash = gtime
    else
        self.speed_x += input_x * self.accel_x
    end

    -- gravity
    if self.y < ground_limit - self.hit_h then input_y = 1 end
    if input_y == 0 then
        self.speed_y *= 0.9
        if abs(self.speed_y) < 1 then self.speed_y = 0 end
    else
        if sgn(self.speed_y) != sgn(input_y) then
            self.speed_y += self.decel_y * sgn(input_y)
        else
            self.speed_y += self.accel_y * sgn(input_y)
        end
        self.facing = self.speed_y > 0 and 3 or 2
    end

    -- move
    self:move_x(self.speed_x, self.collide_x)
    self:move_y(self.speed_y, self.collide_y)

    -- collisions
    if self.state == 1 then
        for o in all(objects) do
            if o.base == worm and self:overlaps(o) then
                o.destroyed = true
                self.speed_y += sgn(self.speed_y)
                spawn_particles(4 + rnd(3), 3, o.x, o.y, 8)
                self:psfx(2, 0, 0, 1)
            end
        end
    end

    -- prevent cliping
    if self:check_solid(sgn(self.speed_x), 0) then self.speed_x = 0 end
    if self:check_solid(0, sgn(self.speed_y)) then self.speed_y = 0 end

    -- trail
    if (abs(self.speed_y) > 1 or abs(self.speed_x) > 1) and self.y > ground_limit then
        spawn_trail(self.x + self.hit_w/2, self.y + self.hit_h/2)
        if self == current_player and stat(16) == -1 then
            sfx(1, 0, 0, 32)
        end
    else
        if self == current_player then sfx(-1, 0) end
    end

    if self.state == 4 then return end

    -- check finish_line
    if patterns and self.y > 128 * (#patterns - 1) + finish_line then
        self.state = 4
        self.flip_y = false
        if self == current_player then
            end_race()
        end
    end
end

function ply_input(self)
    local input_x = 0
    local input_y = 0
    if btn(0) then input_x -= 1 end
    if btn(1) then input_x += 1 end
    if btn(2) then input_y -= 1 end
    if btn(3) then input_y += 1 end
    -- dash
    if btnp(5) then
        input_x = 2
    elseif btnp(4) then
        input_x = - 2
    end
    return input_x, input_y
end

function cpu_input(self)
    local input_x = 0
    local input_y = 0
    input_y = 1

    -- dash
    if self.speed_y < 1 then
        input_x = rnd({-2,2})
    else
        -- dash to attack
        for o in all(objects) do
            if o.base == mole and o != self then
                if abs(o.y - self.y) <= 8 then
                    input_x = 2 * sgn(o.x - self.x)
                    return input_x, input_y
                end
            end
        end
    end
    --
    return input_x, input_y
end

function menu_input(self)
    local input_x = 0
    if self.x > 108 then
        input_x = -1
    elseif self.x < 20 then
        input_x = 1
    elseif abs(self.speed_x) < 3 then
        input_x = sgn(self.speed_x)
    end
    --
    if (self.y < ground_limit + 20) then
        input_y = 1
    elseif self.y > 180 then
        input_y = -1
    elseif abs(self.speed_y) < 3 then
        input_y = sgn(self.speed_y)
    end
    return input_x, input_y
    
end

function mole.draw(self)
    if self.state == 1 then
        if abs(self.speed_y) >= abs(self.speed_x) then
            self.spr = 17
            self.flip_y = self.speed_y >= 0
        else
            self.spr = 18
            self.flip_x = self.speed_x < 0
        end
    else
        self.spr = 16
        self.slip_y = false
    end

    spr(self.spr, self.x, self.y, 1, 1, self.flip_x, self.flip_y)
    pset(self.x + 2, self.y - 1 + (self.flip_y and 0 or 9), 3)
    pset(self.x + 5, self.y - 1 + (self.flip_y and 0 or 9), 3)
end

function mole.collide_x(self)
    if abs(self.speed_x) > 2 then
        if self.is_player then shake = 1 end
        self.speed_x = - self.speed_x/2
        self.speed_y = self.speed_y * 0.8
        self:psfx(2, 0, 2, 1)
    else
        self.speed_x = 0
    end
end

function mole.collide_y(self)
    if abs(self.speed_y) > 4 then
        if self.is_player then
            freeze_time = 5
            shake = 5
        end
        self.speed_y = - self.speed_y/2
        self:psfx(2, 0, 2, 1)
    else
        self.speed_y = 0
    end
end

function mole.hit(self, recovery)
    self.recovery = recovery
    self.state = 2
end

function mole.get_attacked(self)
    self.speed_y *= self.decel_y
end

function mole.psfx(self, n, channel, offset, length)
    -- play if visible on screen
    if self.y > gcamera.y and self.y < gcamera.y + 128 then
        sfx(n, channel, offset, length)
    end
end

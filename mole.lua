mole = new_type(16)
mole.hit_w = 8
mole.hit_h = 8
mole.state = 1
mole.facing = 3
mole.accel_y = 0.2
mole.decel_y = 0.9
mole.accel_x = 0.2
mole.decel_x = 0.9
mole.recovery = 0
mole.is_player = false

-- TODO add particules on win / death / movement
-- TODO SFXs
function mole.init(self)
    self.get_input = cpu_input
end

-- States
-- 1 : digging
-- 2 : stuned
-- 3 : waiting

function mole.update(self)

    -- timers
    if self.recovery > 0 then
        self.recovery -= 1
        if self.recovery == 0 then self.state = 1 end
    end
    
    printable = self.recovery
    -- get inputs
    local input_x = 0
    local input_y = 0
    
    if self.state == 1 then
        input_x, input_y = self:get_input()
    end
    
    if input_x == 0 then
        self.speed_x *= 0.9
        if abs(self.speed_x) < 1 then self.speed_x = 0 end
    else
        self.speed_x += input_x * self.accel_x
    end

    if input_y == 0 then
        self.speed_y *= 0.9
        if abs(self.speed_y) < 1 then self.speed_y = 0 end
    else
        if sgn(self.speed_y) != sgn(input_y) then
            self.speed_y += self.decel_y * sgn(input_y)
        else
            self.speed_y += self.accel_y * sgn(input_y)
        end
    end
    
    -- move
    self:move_x(self.speed_x, self.collide_x)
    self:move_y(self.speed_y, self.collide_y)

    if abs(self.speed_y) > 2 then
        spawn_particles(1, 2, self.x + self.hit_w/2, self.y + self.hit_h/2, 1)
    end

    -- collisions
    if self.state == 1 then
        for o in all(objects) do
            if o.base == worm and self:overlaps(o) then
                o.destroyed = true
                self.speed_y += sgn(self.speed_y)
                spawn_particles(4 + rnd(3), 3, o.x, o.y, 8)
            end
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
    return input_x, input_y
end

function cpu_input(self)
    local input_x = 0
    local input_y = 0
    input_y = 1
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
        self:hit(5)
    else
        self.speed_x = 0
    end
    -- sfx
end

function mole.collide_y(self)
    if abs(self.speed_y) > 2 then
        if self.is_player then
            freeze_time = 5
            shake = 5
        end
        self.speed_y = - self.speed_y/2
        self:hit(10)
    else
        self.speed_y = 0
    end
    -- sfx
end

function mole.hit(self, recovery)
    self.recovery = recovery
    self.state = 2
end

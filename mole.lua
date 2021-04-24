mole = new_type(16)
mole.hit_w = 8
mole.hit_h = 8
mole.state = 1
mole.facing = 3
mole.accel_y = 0.2
mole.decel_y = 0.9
mole.accel_x = 0.2
mole.decel_x = 0.9

-- TODO add particules on win / death / movement
-- TODO SFXs
function mole.init(self)

end

-- States
-- 1 : digging
-- 2 : stuned
-- 3 : waiting

function mole.update(self)

    -- get inputs
    local input_x = 0
    if btn(0) then input_x -= 1 end
    if btn(1) then input_x += 1 end
    if input_x == 0 then
        self.speed_x *= 0.9
        if abs(self.speed_x) < 1 then self.speed_x = 0 end
    else
        self.speed_x += input_x * self.accel_x
    end

    local input_y = 0
    if btn(2) then input_y -= 1 end
    if btn(3) then input_y += 1 end
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

    -- collisions
    if self.state == 1 then
        for o in all(objects) do
            if o.base == worm and self:overlaps(o) then
                -- eat worm
            end
        end
    end

    -- 
    if self.state == 1 then
        self.spr = 17
        self.flip_y = true
    else
        self.spr = 16
        self.slip_y = false
    end
end

function mole.draw(self)
    spr(self.spr, self.x, self.y, 1, 1, self.flip_x, self.flip_y)
end

function mole.collide_x(self)
    shake = 1
    self.speed_x = - self.speed_x/2
    -- sfx
end

function mole.collide_y(self)
    if self.speed_y > 2 then
        freeze_time = 5
        shake = 5
        self.speed_y = - self.speed_y/2
    else
        self.speed_y = - sgn(self.speed_y)
    end
    -- sfx
end

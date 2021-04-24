-- accelerators / slowers

worm = new_type(32)
worm.anim_time = 7
worm.sprs = {32, 33}
worm.speed = 1

function worm.update(self)
    -- anim
    if gtime%self.anim_time == 0 then
        self.spr = self.sprs[(self.spr + 1)%#self.sprs + 1]
    end

    -- movement
    self:move_x(self.facing * self.speed, reverse_facing)

    self.flip_x = self.facing == -1
end

function reverse_facing(self)
    self.facing *= -1
end
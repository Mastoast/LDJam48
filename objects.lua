-- accelerators / slowers

worm = new_type(48)
worm.anim_time = 7
worm.sprs = {48, 49}
worm.speed_x = 1
worm.solid = false

function worm.update(self)
    -- anim
    if gtime%self.anim_time == 0 then
        self.spr = self.sprs[(self.spr + 1)%#self.sprs + 1]
    end

    -- movement
    self:move_x(self.facing * self.speed_x, reverse_facing)

    self.flip_x = self.facing == -1
end

function reverse_facing(self)
    self.facing *= -1
end
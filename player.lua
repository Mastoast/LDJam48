mole = new_type(16)
mole.hit_w = 8
mole.hit_h = 8
mole.speed = 5
mole.state = 1

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

    -- update speed
    
    -- move

    -- collisions
    if self.state == 1 then
        for o in all(objects) do
            if o.base == worm and self:overlaps(o) then
                -- eat worm
            end
        end
    end
end

function mole.draw(self)
    spr(self.spr)
end

function mole.hit(self)
    freeze_time = 5
    shake = 5
    --sfx
end

-- constants
trail_colors = {15,13,4}

-- items
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

-- particles

particles = {}

-- number of particles
-- size
-- x / y
-- color
function spawn_particles(nb,s,x,y,c)
	for i=1,flr(nb) do
        add(particles, make_particle(s,x,y,c))
	end
end

function spawn_trail(x,y)
    
    local offset = 0
    for i=1,2 do
        add(particles, make_trail(1, x + offset,y, trail_colors[0]))
        offset += 1
    end
end

function make_particle(s,x,y,c)
	local p={
		s=s or 1,
		c=c or 7,
		x=x,y=y,k=k,
		t=0, t_max=16+flr(rnd(4)),
		dx=rnd(2)-1,dy=-rnd(3),
		ddy=0.05,
		update=update_particle,
		draw=draw_particle
	}
	return p
end

function make_trail(s,x,y,c)
    local t = {
        s = s or 1,
        c = c or 0,
        x=x,y=y,
        t=0, t_max=15+flr(rnd(8)),
        update=update_trail,
        draw=draw_particle
    }
    return t
end

function update_trail(a)
    a.c = trail_colors[flr((a.t/a.t_max) * #trail_colors) + 1]
    a.t+=1
	if (a.t==a.t_max) del(particles, a)
end

function draw_particle(a)
	circfill(a.x,a.y,a.s,a.c)
end

function update_particle(a)
	if a.s>=1 and a.t%4==0 then a.s-=1 end
	if a.t%2==0 then
		a.dy+=a.ddy
		a.x+=a.dx
		a.y+=a.dy
	end
	a.t+=1
	if (a.t==a.t_max) del(particles, a)
end
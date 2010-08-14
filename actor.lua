require("class")

Actor = Class{name="Actor", function(self, avatar, y, dir, speed)
	self.avatar = avatar
	self.x = dir > 0 and -48 or 848
	self.y = y
	self.dir = dir
	self.speed = speed
end}

function Actor:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.avatar, self.x, self.y)
end

Trickster = Class{name="Trickster", function(self, avatar, y, dir, speed)
	Actor.construct(self, avatar, y, dir, speed)
	soundmanager:play(sounds.snicker)
end}
Inherit(Trickster, Actor)

function Trickster:update(dt, words, ...)
	self.x = self.x + self.speed * dt * self.dir
	
	for _,v in ipairs(words) do
		if rectRectCollision(self.x, self.y, 48, 48, v.x, v.y, v.length*18, 18) then
			table.shuffle(v.letters)
		end
	end
end

Helper = Class{name="Helper", function(self, avatar, y, dir, speed)
	Actor.construct(self, avatar, y, dir, speed)
end}
Inherit(Helper, Actor)

function Helper:update(dt, words, removelist, explosions, score, timer)
	self.x = self.x + self.speed*dt*self.dir
	
	for i,v in ipairs(words) do
		if rectRectCollision(self.x, self.y, 48, 48, v.x, v.y, v.length*18, -18) then
			table.insert(removelist, i)
			--for each letter in the word, add an explosion
			for n,k in ipairs(v.letters) do
				table.insert(explosions, ParticleSystem(v.x+(n-1)*18, v.y, k))
			end
			--Play a sound
			soundmanager:play(sounds.swoosh)
			--Increase the player's score
			score = score + (50+timer)*v.length
		end
	end
end

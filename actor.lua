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
	self.shuffled = 0
	counter.tricksters = counter.tricksters + 1
	soundmanager:play(sounds.snicker)
end}
Inherit(Trickster, Actor)

function Trickster:update(dt, words, ...)
	self.x = self.x + self.speed * dt * self.dir
	
	for _,v in ipairs(words) do
		if rectRectCollision(self.x, self.y, 48, 48, v.x, v.y, v.length*18, 18) then
			table.shuffle(v.letters)
			v.shuffled = 2
			self.shuffled = self.shuffled +1
		end
	end
	
	if self.shuffled >= 5 then
		AwardManager:AwardTrophy("Cursed fellow")
	end
end

Helper = Class{name="Helper", function(self, avatar, y, dir, speed)
	Actor.construct(self, avatar, y, dir, speed)
	self.destroyed = 0
	counter.helpers = counter.helpers + 1
end}
Inherit(Helper, Actor)

function Helper:update(dt, words, explosions, score, timer)
	self.x = self.x + self.speed*dt*self.dir
	local removelist = {}
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
			score = score + (50+timer)*v.length*v.shuffled
			
			--increment the total score
			counter.score = counter.score+score
			
			--Increase destroyed count
			self.destroyed = self.destroyed+1
			
			--Award trophy if 4 words have been removed
			if self.destroyed == 4 then
				AwardManager:AwardTrophy("Lucky bastard")
			end
		end
	end
	
	for i,v in ipairs(removelist) do
		table.remove(words, v-i+1)
	end
end

require("class")

ParticleSystem = Class{name="ParticleSystem", function(self, x, y, l)
	self.x = x
	self.y = y
		
	self.p = love.graphics.newParticleSystem(images.letters[l], 10)
	self.p:setEmissionRate(20)
	self.p:setSpeed(100, 200)
	self.p:setGravity(100, 200)
	self.p:setSize(1, 1)
	self.p:setColor(200, 200, 200, 175, 255, 255, 255, 0)
	self.p:setPosition(self.x, self.y)
	self.p:setLifetime(0.4)
	self.p:setParticleLife(0.3)
	self.p:setDirection(180)
	self.p:setSpread(20)
	self.p:start()
end}

function ParticleSystem:update(dt)
	self.p:update(dt)
end

function ParticleSystem:isActive()
	return self.p:isActive()
end

function ParticleSystem:draw()
	love.graphics.draw(self.p, 0, 0)
end

require("gamestate")
Gamestate.intro = Gamestate.new()
local state = Gamestate.intro
local opacity = 0
local timer = 0
local curr = "in"

function state:update(dt)
	timer = timer+dt

	if curr == "in" then
		if opacity < 255 then
			opacity = opacity + 200*dt
		end
		if opacity >= 255 then
			opacity = 255
			curr = "display"
		end
	elseif curr == "display" then
		if timer >= 2.5 then
			curr = "out"
		end
	elseif curr == "out" then
		if opacity > 0 then
			opacity = opacity - 255*dt
		end
		if opacity <= 0 then
			opacity = 0
			love.graphics.setColor(255,255,255,255)
			Gamestate.switch(Gamestate.title)
		end
	end
end

function state:draw()
	love.graphics.setColor(255,255,255,255)
	--Shadows for the side of the main area
	love.graphics.draw(images.sideshadow, 37, 132)
	love.graphics.draw(images.sideshadow, 762, 132, 0, -1, 1)
	
	--Draw the main white area
	love.graphics.rectangle("fill", 50, 140, 700, 400)
	
	--The head banner
	love.graphics.draw(images.banner, 0, 10)
	
	love.graphics.setColor(255,255,255,opacity)
	love.graphics.draw(images.logos.ohso, 400-images.logos.ohso:getWidth()/2, 320-images.logos.ohso:getHeight()/2)
	
	love.graphics.setColor(42,44,46)
	--Footer
	love.graphics.rectangle("fill", 0, 530, 800, 70)
	love.graphics.setFont(fonts.bold12)
	love.graphics.setColor(184,184,184)
	love.graphics.printf("OMG! Words! is developed and designed by Tommy Brunn in cooperation with the Love community", 252, 546, 340, "center")
end

function state:mousepressed(x,y,button)
	Gamestate.switch(Gamestate.title)
end

function state:keypressed()
	Gamestate.switch(Gamestate.title)
end

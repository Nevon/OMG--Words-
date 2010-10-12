require("gamestate")
Gamestate.title = Gamestate.new()
local state = Gamestate.title

function state:enter(self)
	soundmanager:playMusic(music.introstrum1, music.introstrum3, music.introstrum2)
end

function state:update(dt)
	soundmanager:update(dt)
end	

function state:draw()
	love.graphics.setColor(255,255,255)
	--Shadows for the side of the main area
	love.graphics.draw(images.sideshadow, 37, 132)
	love.graphics.draw(images.sideshadow, 762, 132, 0, -1, 1)
	
	--Draw the main white area
	love.graphics.rectangle("fill", 50, 140, 700, 400)
	
	--The head banner
	love.graphics.draw(images.banner, 0, 10)
	
	if highscore.scores[1][2] ~= "Empty" then
		-- Current reigning champion
		love.graphics.setColor(238, 238, 238)
		love.graphics.setFont(fonts.bold14)
		love.graphics.print("Reigning champion is", 270, 81)
		love.graphics.setFont(fonts.bold28)
		love.graphics.print(highscore.scores[1][2].." at "..highscore.scores[1][1].." points", 270, 92)
	end
	
	-- The speech bubble and portrait
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(images.bubbles.intro, 221, 235)
	love.graphics.draw(images.joey, 165, 235)
	
	--The text for the speech bubble
	love.graphics.setFont(fonts.bold12)	
	love.graphics.setColor(42,44,46)
	love.graphics.printf("So you think you're good enough to write for OMG! Ubuntu!, huh?", 252, 254, 360, "left")
	love.graphics.print("Press", 252, 397)
	love.graphics.print("to start!", 335, 397)
	love.graphics.setColor(241,93, 34)
	love.graphics.print("ENTER", 290, 397)
	love.graphics.setColor(42,44,46)
	
	love.graphics.setFont(fonts.regular14)
	love.graphics.printf("Guess you'll have to prove yourself then!", 252, 296, 360, "left")
	love.graphics.printf("Type the words as you see them falling down from the top. Don't let them reach the bottom, or you'll soon fall behind on your deadline!", 252, 326, 360, "left")
	
	--Footer
	love.graphics.rectangle("fill", 0, 530, 800, 70)
	love.graphics.setFont(fonts.bold12)
	love.graphics.setColor(184,184,184)
	love.graphics.printf("OMG! Words! is developed and designed by Tommy Brunn in cooperation with the Love community", 252, 546, 340, "center")
end

function state:keypressed(key, unicode)
	if key == "escape" then
		love.event.push('q')
	elseif key == "return" then
		Gamestate.switch(Gamestate.downloading)
	end
end

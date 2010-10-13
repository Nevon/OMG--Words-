require("gamestate")

Gamestate.highscore = Gamestate.new()
local state = Gamestate.highscore
local score = 0
local resultlevel = 0
local name = ""
local highlighted = 1
local timer = 0

function state:enter(pre, s)
	score = math.floor(s)
	if score < highscore.scores[1][1] then
		Gamestate.switch(Gamestate.result, score)
	end
end

function state:update(dt)
	soundmanager:update(dt)
	timer = timer+dt
end

function state:draw()
	love.graphics.setColor(255,255,255)
	-- The shadows for the main area
	love.graphics.draw(images.sideshadow, 37, 132)
	love.graphics.draw(images.sideshadow, 762, 132, 0, -1, 1)
	
	-- Draw the main white area
	love.graphics.rectangle("fill", 50, 140, 700, 400)
	
	-- The head banner
	love.graphics.draw(images.banner, 0, 10)
	
	-- Score
	love.graphics.draw(images.score, 259, 100)
	love.graphics.setColor(238, 238, 238)
	love.graphics.setFont(fonts.bold64)
	love.graphics.print(score.."!", 365, 51)
	
	--Portrait
	love.graphics.setColor(255,255,255)
	love.graphics.draw(images.tommy, 165, 193)
	
	-- Speech bubble
	love.graphics.draw(images.bubbles.newhighscore, 222, 193)
	
	-- Text entry box
	love.graphics.draw(images.nameentry, 253, 292)
	
	-- Option pictograms
	if highlighted == 1 then
		love.graphics.draw(images.cloud_active, 335, 366)
		love.graphics.draw(images.local_inactive, 465, 366)
	else
		love.graphics.draw(images.cloud_inactive, 335, 366)
		love.graphics.draw(images.local_active, 465, 366)
	end
	
	love.graphics.setFont(fonts.bold28)
	love.graphics.setColor(42,44,46)
	
	-- text
	love.graphics.printf("New high score!", 231, 205, 404, "center")
	love.graphics.setColor(66,66,66)
	love.graphics.setFont(fonts.regular14)
	love.graphics.printf("Tell us your name so that we can enter it into the history books:", 253, 246, 323, "left")
	
	--Name
	love.graphics.setFont(fonts.bold14)	
	love.graphics.print(name, 261, 296)
	
	--blinking text mark thingy
	love.graphics.setLine(1, "smooth")
	if math.floor(timer)%2 == 0 then
		local xmark = 261+fonts.bold14:getWidth(name)+2
		love.graphics.line(xmark, 296, xmark, 313)
	end
	
	--Question
	love.graphics.print("Save to...", 254, 331)
	
	--Notice
	love.graphics.setFont(fonts.bold12)
	love.graphics.setColor(159,159,159)
	love.graphics.printf("Your score will always be saved locally (uploading is optional)", 231, 442, 404, "center")
	
	-- Footer
	love.graphics.setColor(42,44,46)
	love.graphics.rectangle("fill", 0, 530, 800, 70)
	love.graphics.setFont(fonts.bold12)
	love.graphics.setColor(184,184,184)
	love.graphics.printf("OMG! Words! is developed and designed by Tommy Brunn in cooperation with the Love community", 252, 546, 340, "center")
end

function state:keypressed(key, unicode)
	if key == "left" and highlighted == 2 then
		highlighted = 1
		return
	elseif key == "right" and highlighted == 1 then
		highlighted = 2
		return
	end
	
	if key == "backspace" then
		name = name:sub(1, -2)
		return
	else
		if #name >= 30 then return end
	end
	
	if key == " " then
		name = name..key
		return
	end
	
	if unicode >= 97 and unicode <= 122 or unicode >= 65 and unicode <= 90 then
		name = name..string.char(unicode)
	end
	
	if key == "return" then
		local n = string.lower(name)
		
		if n ~= "" then
			if n == "tux" then
				AwardManager:Register("Penguin", "I didn't know penguins could type!", 0)
				AwardManager:AwardTrophy("Penguin")
			elseif n == "mark shuttleworth" then
				AwardManager:Register("Cosmonaut", "Don't you have better things to do, Mark?", 0)
				AwardManager:AwardTrophy("Cosmonaut")
			end
			highscore.add(name, score)
			highscore.save()
			Gamestate.switch(Gamestate.result, score)
		end
	end
end

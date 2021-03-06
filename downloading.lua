require("gamestate")
Gamestate.downloading = Gamestate.new()
local state = Gamestate.downloading
database = {}
local thread = nil
local verified = false
local progress = 0

function state:update(dt)
	soundmanager:update(dt)
	
	--Once the thread has been created
	if thread ~= nil then
		local _ = thread:receive("progress")
		if _ then
			progress = _
		end
		--Try to get the post url
		local posturl = thread:receive("posturl")
		
		if posturl ~= nil and not verified then
			--If the URL is the same as the old one, don't bother to
			--download the post.
			if posturl == counter.lasturl then
				thread:send("download", false)
			else
				counter.lasturl = posturl
				thread:send("download", true)
			end
			verified = true
		end
		
		local success = thread:receive("success")
		local post = thread:receive("post")
		--Once the thread is done, check whether or not it failed
		if success ~= nil then
			progress = 1
			if not success then
				print("Failed, falling back to last downloaded post.")
				post = love.filesystem.read("lastpost.txt")
			else
				print("Success.")
				post = post:gsub("[^%a]", " ")
				love.filesystem.write("lastpost.txt", post)
			end
		
			database = Database(post)
			print ("Post read\!")
			Gamestate.switch(Gamestate.game)
		end
	end
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

	--head
	love.graphics.draw(images.tommy, 165, 287)
	--bubble
	love.graphics.draw(images.bubbles.downloading, 222, 287)

	love.graphics.setColor(66,66,66)
	love.graphics.setFont(fonts.bold12)

	love.graphics.print("Press                to download the words of the almighty. No", 252, 301)
	love.graphics.print("internet connection? Don't worry. I'll just use magic.", 252, 317)
	love.graphics.print("Press           to quit", 252, 346)

	love.graphics.setColor(241,93,34)
	love.graphics.print("ENTER", 292, 301)
	love.graphics.print("ESC", 292, 346)
	
	if thread ~= nil then
		--draw the background of our fake progress bar
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(images.progressbar, 231, 384)
		
		--Now draw the bars themselves
		local length = math.ceil(398*progress)
		love.graphics.setColor(181,62,126)
		love.graphics.rectangle("fill", 234, 386, length, 2)
		love.graphics.setColor(145, 72, 114)
		love.graphics.rectangle("fill", 234, 388, length, 1)
	end

	--Footer
	love.graphics.setColor(42,44,46)
	love.graphics.rectangle("fill", 0, 530, 800, 70)
	love.graphics.setFont(fonts.bold12)
	love.graphics.setColor(184,184,184)
	love.graphics.printf("OMG! Words! is developed and designed by Tommy Brunn in cooperation with the Love community", 252, 546, 340, "center")
end

function state:keypressed(key, unicode)
	if key == "escape" then
		love.event.push('q')
	elseif key == "return" then
		if not thread then
			thread = love.thread.newThread("workhorse", "downloader.lua")
			thread:start()
		end
	elseif key == "rctrl" then
		debug.debug()
	end
end

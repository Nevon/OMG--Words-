require("gamestate")
Gamestate.downloading = Gamestate.new()
local state = Gamestate.downloading

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

	--head
	love.graphics.draw(images.tommy, 165, 287)
	--bubble
	love.graphics.draw(images.bubbles.downloading, 222, 287)

	love.graphics.setColor(66,66,66)
	love.graphics.setFont(fonts.bold12)

	love.graphics.printf("Press                to download the words of the almighty. No internet connection? Don't worry. I'll just use magic.", 252, 315, 360, "left")
	love.graphics.print("Press          to quit", 252, 360)

	love.graphics.setColor(241,93,34)
	love.graphics.print("ENTER", 289, 315)
	love.graphics.print("ESC", 289, 360)

	--Footer
	love.graphics.setColor(42,44,46)
	love.graphics.rectangle("fill", 0, 530, 800, 70)
	love.graphics.setFont(fonts.bold12)
	love.graphics.setColor(184,184,184)
	love.graphics.printf("OMG! Words! is developed and designed by Tommy Brunn in cooperation with the Love community", 252, 560, 340, "center")
end

function state:keypressed(key, unicode)
	if key == "escape" then
		love.event.push('q')
	elseif key == "return" then
		print("Attemping to download latest post from http://omgubuntu.co.uk")
		downloadWords()
	end
end

database = {}
function downloadWords()
	local http = require("socket.http")
	http.TIMEOUT = 5
	local success, post = pcall(function ()
		local a = http.request("http://omgubuntu.co.uk/")
		local b = http.request(a:match("<h3 class='post%-title entry%-title'>\n<a href='([^']+)"))
		return b:match("<div class='post%-body entry%-content'>(.+)</div>\n<div class='post%-footer'"):gsub("&nbsp;", " "):gsub("<a[^>]+>[^<]+</a>", ""):gsub("<[^>]+>", "")
	end)

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

require("gamestate")
require("soundmanager")
require("utils")
require("database")
require("comments")
require("title")
require("downloading")
require("game")
require("result")
require("words")
require("explosion")
require("actor")
require("sick")
require("highscore")

function love.load()
	love.graphics.setBackgroundColor(247, 246, 245)

	love.filesystem.setIdentity("omgwords")
	
	highscore.set("highscore", 1, "Empty", 0)
	highscore.save()
	
	--get us a randomseed before generating random data
	math.randomseed(love.timer.getMicroTime()*1000000)

	--load the images
	images = {}
	loadfromdir(images, "gfx", "png", love.graphics.newImage)
	--load the sound (effects)
	sounds = {}
	loadfromdir(sounds, "snd/sfx", "ogg", love.sound.newSoundData)

	--and the music
	music = {}
	loadfromdir(music, "snd/music", "ogg", love.audio.newSource)

	--load fonts
	fonts = {
		bold12 = love.graphics.newFont("gfx/fonts/NimbusSansL-Bold.ttf", 12),
		bold14 = love.graphics.newFont("gfx/fonts/NimbusSansL-Bold.ttf", 14),
		regular14 = love.graphics.newFont("gfx/fonts/NimbusSansL-Regular.ttf", 14),
		bold64 = love.graphics.newFont("gfx/fonts/NimbusSansL-Bold.ttf", 64),
		bold28 = love.graphics.newFont("gfx/fonts/NimbusSansL-Bold.ttf", 28),
		bold24 = love.graphics.newFont("gfx/fonts/NimbusSansL-Bold.ttf", 24),
		mono28 = love.graphics.newFont("gfx/fonts/NimbusMonoL-Bold.ttf", 28)
	}
	
	--Move trophies if needed
	local lfs = love.filesystem
	local trophytable = lfs.enumerate("gfx/trophies/")
	if not lfs.exists("trophies") then
		lfs.mkdir("trophies")
	end
	
	for i,v in ipairs(trophytable) do
		print("File "..v.." found.")
		local name = string.gsub(v, "[ -]", "_")
		local name = string.lower(name)
		print("Corresponds with "..name)
		local src = "gfx/trophies/"..v
		local dest = "trophies/"..name
		if not lfs.exists(dest) then
			print(dest.." doesn't seem to exist")
			if not lfs.write(dest, lfs.read(src)) then
				print("Writing to "..dest.." worked!")
			else
				print("Writing to "..dest.." failed.")
			end
		end
	end
	
	require("achievements")
	Gamestate.registerEvents()
	Gamestate.switch(Gamestate.title)
end

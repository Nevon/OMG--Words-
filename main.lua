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
require("achievements")

function love.load()
	love.graphics.setBackgroundColor(247, 246, 245)

	love.filesystem.setIdentity("omgwords")
	
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
		regular14 = love.graphics.newFont("gfx/fonts/NimbusSansL-Regular.ttf", 14),
		bold64 = love.graphics.newFont("gfx/fonts/NimbusSansL-Bold.ttf", 64),
		bold28 = love.graphics.newFont("gfx/fonts/NimbusSansL-Bold.ttf", 28),
		bold24 = love.graphics.newFont("gfx/fonts/NimbusSansL-Bold.ttf", 24),
		mono28 = love.graphics.newFont("gfx/fonts/NimbusMonoL-Bold.ttf", 28)
	}

	Gamestate.registerEvents()
	Gamestate.switch(Gamestate.title)
end

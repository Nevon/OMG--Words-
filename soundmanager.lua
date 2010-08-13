soundmanager = {}
soundmanager.queue = {}
soundmanager.playlist = {}
soundmanager.currentsong = -1

local function shuffle(a, b)
	return math.random(1, 2) == 1
end

--do the magic
function soundmanager:play(sndData)
	--make a source out of the sound data
	local src = love.audio.newSource(sndData, "static")
	--put it in the queue
	table.insert(self.queue, src)
	--and play it
	love.audio.play(src)
end

function soundmanager:stop()
	--stop all currently playing music
	for i, v in ipairs(soundmanager.playlist) do
		love.audio.stop(v)
	end
end

--do the music magic
function soundmanager:playMusic(first, ...)
	soundmanager:stop()
	--decide if we were passed a table or a vararg,
	--and assemble the playlist
	if type(first) == "table" then
		self.playlist = first
	else
		self.playlist = {first, ...}
	end
	self.currentsong = 1
	--play
	love.audio.play(self.playlist[1])
end

--do some shufflin'
function soundmanager:shuffle(first, ...)
	local playlist
	if type(first) == "table" then
		playlist = first
	else
		playlist = {first, ...}
	end
	table.sort(playlist, shuffle)
	return unpack(playlist)
end

--update
function soundmanager:update(dt)
	--check which sounds in the queue have finished, and remove them
	local removelist = {}
	for i, v in ipairs(self.queue) do
		if v:isStopped() then
			table.insert(removelist, i)
		end
	end
	--we can't remove them in the loop, so use another loop
	for i, v in ipairs(removelist) do
		table.remove(self.queue, v-i+1)
	end
	--advance the playlist if necessary
	if self.currentsong ~= -1 and self.playlist and self.playlist[self.currentsong]:isStopped() then
		self.currentsong = self.currentsong + 1
		if self.currentsong > #self.playlist then
			self.currentsong = 1
		end
		love.audio.play(self.playlist[self.currentsong])
	end
end

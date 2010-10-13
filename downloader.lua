require("love.filesystem")
local t = love.thread.getThread()
local http = require("socket.http")
http.TIMEOUT = 5
t:send("progress", 0.1)
local success, post = pcall(function ()
	local url = "http://www.omgubuntu.co.uk/"
	print("Attempting to contact "..url)
	local a = http.request(url)
	t:send("progress", 0.3)
	local posturl = a:match(('entry%-title"><a href="([^"]+)'))
	t:send("posturl", posturl)
	local download = t:demand("download")
	if download == true then
		t:send("progress", 0.6)
		print("Attempting to download post from "..posturl)
		local b = http.request(posturl)
		t:send("progress", 0.8)
		return b:match('<div class="entry%-content">(.+)</div><div class="entry%-utility">'):gsub("<[^>]+>", ""):gsub("&#8217;", "'"):gsub("&nbsp;", " "):gsub("<a[^>]+>[^<]+</a>", "")
	else
		t:send("progress", 0.8)
		print("No new post. Falling back to old one.")
		return love.filesystem.read("lastpost.txt")
	end
end)
t:send("success", success)
t:send("post", post)

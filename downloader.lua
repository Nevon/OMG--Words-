require("love.filesystem")
local t = love.thread.getThread()
local http = require("socket.http")
http.TIMEOUT = 5
local success, post = pcall(function ()
	local url = "http://www.omgubuntu.co.uk/"
	print("Attempting to contact "..url)
	local a = http.request(url)
	local posturl = a:match(('entry%-title"><a href="([^"]+)'))
	t:send("posturl", posturl)
	local download = t:demand("download")
	if download then
		print("Attempting to download post from "..posturl)
		local b = http.request(posturl)
		return b:match('<div class="entry%-content">(.+)</div><div class="entry%-utility">'):gsub("<[^>]+>", ""):gsub("&#8217;", "'"):gsub("&nbsp;", " "):gsub("<a[^>]+>[^<]+</a>", "")
	else
		print("No new post. Falling back to old one.")
		return love.filesystem.read("lastpost.txt")
	end
end)
t:send("success", success)
t:send("post", post)

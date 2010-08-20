function string:split(sSeparator, nMax, bRegexp)
	assert(nMax == nil or nMax >= 1)
	
	local aRecord = {}
	
	if sSeparator == '' then
		aRecord = {} 
		for n=1,#self do 
			if self:sub(n,n) ~= nil then
				aRecord[n] = self:sub(n,n)
			end
		end
		return aRecord
	end

	if self:len() > 0 then
		local bPlain = not bRegexp
		nMax = nMax or -1

		local nField=1 nStart=1
		local nFirst,nLast = self:find(sSeparator, nStart, bPlain)
		while nFirst and nMax ~= 0 do
			aRecord[nField] = self:sub(nStart, nFirst-1)
			nField = nField+1
			nStart = nLast+1
			nFirst,nLast = self:find(sSeparator, nStart, bPlain)
			nMax = nMax-1
		end
		aRecord[nField] = self:sub(nStart)
	end

	return aRecord
end

function table.shuffle(list)
	local n = #list
	while n > 1 do
		k = math.random(n)
		if k ~= n then
			list[n], list[k] = list[k], list[n]
		end
		n = n - 1
	end
end

function rectRectCollision(box1x, box1y, box1w, box1h, box2x, box2y, box2w, box2h)
	if box1x > box2x + box2w - 1 or -- Is box1 on the right side of box2?
	   box1y > box2y + box2h - 1 or -- Is box1 under box2?
	   box2x > box1x + box1w - 1 or -- Is box2 on the right side of box1?
	   box2y > box1y + box1h - 1	-- Is b2 under b1?
	then
		return false				-- No collision. Yay!
	else
		return true				 -- Yes collision. Ouch!
	end
end

-- Taehl's serializer v1

-- Usage: loadstring("tablename="..TSerialize(table))
function TSerialize(t)
	assert(type(t) == "table", "Can only TSerialize tables.")
	if not t then return nil end
	local s = "return {"
	for k, v in pairs(t) do
		if type(k) == "string" then k = k
		elseif type(k) == "number" then k = "["..k.."]"
		else error("Attempted to Tserialize a table with an invalid key: "..tostring(k))
		end
		if type(v) == "string" then v = "\""..v.."\""			
		elseif type(v) == "table" then v = Tserialize(v)
		elseif type(v) == "boolean" then v = v and "true" or "false"
		elseif type(v) == "userdata" then v = ("%q"):format(tostring(v))
		end
		s = s..k.."="..v..","
	end
	return s.."}"
end


--[[ The following function is Copyright (c) 2010 Bart van Strien

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE. ]]--

--recursively load all files in the a dir and run them through a function
function loadfromdir(targettable, path, extension, func)
	local extmatch = "%." .. extension .. "$"
	for i, v in ipairs(love.filesystem.enumerate(path)) do
		if love.filesystem.isDirectory(path .. "/" .. v) then
			targettable[v] = {}
			loadfromdir(targettable[v], path .. "/" .. v, extension, func)
		elseif v:match(extmatch) then
			targettable[v:sub(1, -5)] = func(path .. "/" .. v)
		end
	end
end

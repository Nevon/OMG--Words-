require("class")

Word = Class{name="Word", function(self, l, x)
	--Split the letter into a table
	self.letters = string.split(l,'')
	--Get the length of the word. Might be good for points and stuff
	self.length = #self.letters
	self.x = x
	self.y = 80
	--This is how many characters have been typed in by the user
	self.typed = 0
	--has the word been shuffled? (1=no, 2=yes)
	self.shuffled = 1
end}

function Word:update(dt, speed)
	--Move it down the game field
	self.y = self.y+speed*dt
end

function Word:draw()
	--first we draw the orange bits
	love.graphics.setFont(fonts.mono28)
	if self.typed > 0 then
		love.graphics.setColor(241,94, 34)
		for i=1, self.typed do
			love.graphics.print(string.upper(self.letters[i]), self.x + 18*(i-1), self.y)
		end
	end
	
	--and then the rest
	love.graphics.setColor(42,44,46)
	
	for i=self.typed+1, self.length do
		love.graphics.print(string.upper(self.letters[i]), self.x+((i-1)*18), self.y)
	end
end

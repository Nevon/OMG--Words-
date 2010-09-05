require("class")

Database = Class{name=Database, function(self, post)
	self.datatable = {}
	for word in post:gmatch("%w+") do table.insert(self.datatable, string.lower(word)) end
	local removetable = {}
	for i,v in ipairs(self.datatable) do
		if #v == 1 then
			table.insert(removetable, i)
		elseif v == 'll' or v == 'isn' or v == 'doesn' or v == 're' or v == 'hasn' then
			table.insert(removetable, i)
		end
	end
	for i,v in ipairs(removetable) do
		table.remove(self.datatable, v-i+1)
	end
end}

function Database:getWord()
	return self.datatable[math.random(1, #self.datatable)]
end



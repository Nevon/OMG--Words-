local luomg_available, luomg = pcall(require, "luomg")
local application = "application://omgwords.desktop"
local set_name = "Games"
local userdir = love.filesystem.getUserDirectory()

AwardManager = {}

function AwardManager:Register(title, description, priority)
	if not luomg_available then return false end
	
	local icon = string.gsub(title, "[ -]", "_")
	icon = string.lower(icon)..".svg"
	
	if not love.filesystem.exists("trophies/"..icon) then
		icon = "/usr/share/icons/hicolor/scalable/apps/omgwords.svg"
	else
		icon = userdir..".love/omgwords/trophies/"..icon
	end
	
	local trophy_file = ([[
<?xml version="1.0" encoding="utf-8"?>
<Trophy xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <ID>%s</ID>
  <Title>%s</Title>
  <Description>
    <LocalizableType Language="en-us">%s</LocalizableType>
   </Description>
   <IconPath>%s</IconPath>
   <SetName>%s</SetName>
   <Application>%s</Application>
   <ApplicationFriendlyName>OMG! Words!</ApplicationFriendlyName>
   <Priority>%d</Priority>
   <SetIcon/>
   <StockIcon/>
</Trophy>
	]]):format(self:GenerateID(title), title, description, icon, set_name, application, priority)
	
	if not self:Write(title, trophy_file) then print("Failed to open/create omgwords-"..title..".trophy") end
end

function AwardManager:Write(title, content)
	local success, file = pcall(io.open, userdir..".local/share/omg/trophy/omgwords-"..title..".trophy", "w")
	if not success then return false end
	file:write(content)
	file:close()
	return true
end

function AwardManager:GenerateID(title)
	return ("%s/%s/%s"):format(application, set_name, title)
end

function AwardManager:AwardTrophy(title)
	if not luomg_available then return false end
	
	local try = pcall(luomg.AwardTrophy, self:GenerateID(title), set_name)
	
	if not try then
		print("Failed to award trophy "..title.. ". Sorry!")
	end
end

function AwardManager:DeleteTrophy(title)
	if not luomg_available then return false end
	
	local try = pcall(luomg.DeleteTrophy, self:GenerateID(title), set_name)
	
	if not try then
		print("Failed to remove trophy "..title)
	end
end

AwardManager:Register("Grandma", "Got the worst possible evaluation", 0)
AwardManager:Register("Amateur blogger", "Got a score over 25000", 1)
AwardManager:Register("World-class typist", "Got the best possible evaluation", 2)
AwardManager:Register("Lucky bastard", "Had a single Helper remove 4 words", 0)
AwardManager:Register("Marathon man", "Survived the onslaught for over 3.5 minutes", 1)
AwardManager:Register("Threesome", "Cleared three or more words at the same time", 1)
AwardManager:Register("Cursed fellow", "Had a Trickster shuffle 5 or more words", 1)
AwardManager:Register("Mr Meticulous", "Achieved a combo of 500 letters.", 2)
AwardManager:Register("Word junkie", "Played a 100 rounds.", 2)

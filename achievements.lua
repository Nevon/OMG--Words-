local luomg_available, luomg = pcall(require, "luomg")
local application = "application://omgwords.desktop"
--local icon = "/usr/share/icons/hicolor/scalable/apps/omgwords.svg"

AwardManager = {}

function AwardManager:Register(title, description, priority)
	if not luomg_available then return false end
	
	local icon = string.gsub(title, "[ -]", "_")
	icon = string.lower(icon)..".svg"
	
	if not love.filesystem.exists("trophies/"..icon) then
		icon = "/usr/share/icons/hicolor/scalable/apps/omgwords.svg"
	else
		icon = love.filesystem.getSaveDirectory().."/trophies/"..icon
	end
	
	local try = pcall(luomg.RegisterTrophy, title, description, application, icon, priority)
	if not try then
		print("Failed to register trophy "..title)
	end
end

function AwardManager:AwardTrophy(title)
	if not luomg_available then return false end
	
	local try = pcall(luomg.AwardTrophy, title, application)
	
	if not try then
		print("Failed to award trophy "..title.. ". Sorry!")
	end
end

function AwardManager:DeleteTrophy(title)
	if not luomg_available then return false end
	
	local try = pcall(luomg.DeleteTrophy, title, application)
	
	if not try then
		print("Failed to remove trophy "..title)
	end
end

AwardManager:Register("Grandma", "Got the worst possible evaluation", 0)
AwardManager:Register("Amateur blogger", "Got a score over 25000", 0)
AwardManager:Register("World-class typist", "Got the best possible evaluation", 2)

--[[
	players.lua
		Utility methods for player display operations
--]]

local ADDON, Addon = ...
local ALTERNATIVE_ICONS = 'Interface/CharacterFrame/TEMPORARYPORTRAIT-%s-%s'
local ICONS = 'Interface/Icons/Achievement_Character_%s_%s'
local CLASS_COLOR = '|cff%02x%02x%02x'

function Addon:HasMultiplePlayers()
	local players = LibStub('LibItemCache-2.0'):IterateOwners()
	return players() and players() -- more than one
end

function Addon:GetPlayerIcon(player)
	if not player.race then
		return
	end

	local gender = player.gender == 3 and 'Female' or 'Male'
	local race = player.race

	if race ~= 'Worgen' and race ~= 'Goblin' and (race ~= 'Pandaren' or player.gender == 3) then
		if race == 'Scourge' then
			race = 'Undead'
		end

		return ICONS:format(race, gender)
	end

	return ALTERNATIVE_ICONS:format(gender, race)
end

function Addon:GetPlayerColorString(player)
	local color = self:GetPlayerColor(player)
	local brightness = color.r + color.g + color.b
	local scale = max(1.8 / brightness, 1.0) * 255

	return CLASS_COLOR:format(min(color.r * scale, 255), min(color.g * scale, 255), min(color.b * scale, 255)) .. '%s|r'
end

function Addon:GetPlayerColor(player)
	return (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[player.class or 'PRIEST']
end

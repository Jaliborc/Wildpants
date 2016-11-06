--[[
	settings.lua
		Methods for initializing and sharing settings between characters
--]]

local ADDON, Addon = ...
local SETS = ADDON .. '_Sets'
local CURRENT_VERSION = GetAddOnMetadata(ADDON, 'Version')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)

local function SetDefaults(target, defaults)
	defaults.__index = nil

	for k, v in pairs(defaults) do
		if type(v) == 'table' then
			target[k] = SetDefaults(target[k] or {}, v)
		end
	end
	
	defaults.__index = defaults
	return setmetatable(target, defaults)
end

local FrameDefaults = {
	enabled = true,
	money = true, broker = true,
	bagFrame = true, sort = true, search = true, options = true,

	strata = 'HIGH',
	scale = 1, alpha = 1,
	color = {0, 0, 0, 0.5},
	width = 512, height = 512,
	x = 0, y = 0,

	itemScale = 1, spacing = 2,
	brokerObject = 'BagnonLauncher',
	hiddenBags = {},
}

local ProfileDefaults = {
	inventory = SetDefaults({
		borderColor = {1, 1, 1, 1},
		leftSideFilter = true,
		point = 'BOTTOMRIGHT',
		x = -50, y = 100,
		columns = 8,
		width = 384,
	}, FrameDefaults),

	bank = SetDefaults({
		borderColor = {1, 1, 0, 1},
		point = 'LEFT',
		columns = 12,
		x = 95
	}, FrameDefaults),

	vault = SetDefaults({
		borderColor = {1, 0, 0.98, 1},
		point = 'LEFT',
		columns = 8,
		x = 95
	}, FrameDefaults),

	guild = SetDefaults({
		borderColor = {0, 1, 0, 1},
		point = 'CENTER',
		columns = 7,
	}, FrameDefaults)
}


--[[ Settings ]]--

function Addon:StartupSettings()
	_G[SETS] = SetDefaults(_G[SETS] or {}, {
		version = CURRENT_VERSION,
		global = SetDefaults({}, ProfileDefaults),
		players = {},

		resetPlayer = true,
		displayBank = true, closeBank = true, displayAuction = true, displayGuild = true, displayMail = true, displayTrade = true, displayCraft = true,
		flashFind = true, tipCount = true, fading = true,

		glowAlpha = 0.5,
		glowQuality = true, glowNew = true, glowQuest = true, glowSets = true, glowUnusable = true,

		emptySlots = true, colorSlots = true,
		leatherColor = {1, .6, .45},
		enchantColor = {0.64, 0.83, 1},
		inscribeColor = {.64, 1, .82},
		engineerColor = {.68, .63, .25},
		tackleColor = {0.42, 0.59, 1},
		refrigeColor = {1, .5, .5},
		gemColor = {1, .65, .98},
		mineColor = {1, .81, .38},
		herbColor = {.5, 1, .5},
		reagentColor = {1, .87, .68},
		normalColor = {1, 1, 1},
	})

	self.sets = _G[SETS]
	self:UpdateSettings()
	
	for _, player in self.Cache:IteratePlayers() do
		self:StartupProfile(player)
	end

	self.profile = self:GetProfile()
end

function Addon:UpdateSettings()
	local expansion, patch, release = strsplit('.', self.sets.version)
	local version = tonumber(expansion) * 10000 + tonumber(patch or 0) * 100 + tonumber(release or 0)

	if self.sets.frames then
		for frame, sets in pairs(self.sets.frames) do
			self.sets.global[frame] = SetDefaults(sets, self.sets.global[frame])
		end

		self.sets.frames = nil
	end

	if self.sets.version ~= CURRENT_VERSION then
		self.sets.version = CURRENT_VERSION
		self:Print(format(L.Updated, self.sets.version))
	end
end


--[[ Profiles ]]--

function Addon:StartupProfile(player)
	local realm, name = self.Cache:GetPlayerAddress(player)
	self.sets.players[realm]  = self.sets.players[realm] or {}
	self:SetProfile(self.sets.players[realm][name], player)
end

function Addon:SetProfile(profile, player)
	local realm, name = self.Cache:GetPlayerAddress(player)
	self.sets.players[realm][name] = profile and SetDefaults(profile, ProfileDefaults)
end

function Addon:GetProfile(player)
	return self:GetSpecificProfile(player) or self.sets.global
end

function Addon:GetSpecificProfile(player)
	local realm, name = self.Cache:GetPlayerAddress(player)
	return self.sets.players[realm][name]
end
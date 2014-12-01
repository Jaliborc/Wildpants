--[[
	settings.lua
		Methods for initializing and sharing settings between characters
--]]

local ADDON, Addon = ...
local SETS = ADDON .. '_Sets'
local CURRENT_VERSION = GetAddOnMetadata(ADDON, 'Version')

local function SetDefaults(target, defaults)
	for k, v in pairs(defaults) do
		if type(v) == 'table' then
			target[k] = SetDefaults(target[k] or {}, v)
		end
	end
	
	defaults.__index = defaults
	return setmetatable(target, defaults)
end


--[[ Settings ]]--

function Addon:StartupSettings()
	_G[SETS] = SetDefaults(_G[SETS] or {},
		version = CURRENT_VERSION,
		players = {},
		frames = {}
	})

	self.sets = _G[SETS]
	self:UpdateSettings()
	self.sets.version = self:GetVersion()
	
	for player in Cache:IteratePlayers() do
		self:StartupProfile(player)
	end

	self.profile = self:GetProfile()
end

function Addon:UpdateSettings()
	local expansion, patch, release = strsplit('.', self.sets.version)
	local version = tonumber(expansion) * 10000 + tonumber(patch or 0) * 100 + tonumber(release or 0)

	-- nothing to do, yay!

	self.sets.version = CURRENT_VERSION
	self:Print(format(L.Updated, self.db.version))
end


--[[ Profiles ]]--

function Addon:StartupProfile(player)
	local realm, player = Cache:GetPlayerAddress(player)
	self.sets.players[realm] = self.sets.players[realm] or {}
	self.sets.players[realm][player] = SetDefaults(self.sets.players[realm][player] or {}, self:GetBaseProfile())
end

function Addon:GetProfile(player)
	local realm, player = Cache:GetPlayerAddress(player)
	return self.sets.players[realm][player]
end

function Addon:GetBaseProfile()
	return {
		inventory = {
			position = {'RIGHT'},
			showBags = false,
			leftSideFilter = true,
			w = 384,
			h = 512,
		},

		bank = {
			showBags = false,
			w = 512,
			h = 512,
		}
	}
end
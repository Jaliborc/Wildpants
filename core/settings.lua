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
		frames = {
			inventory = {
				bags = {BACKPACK_CONTAINER, 1, 2, 3, 4},
				point = {'RIGHT'},
				layer = 'HIGH',
				spacing = 2,
				color = {0, 0, 0, 0.5},
				borderColor = {1, 1, 1, 1},
			},

			bank = {
				bags = {BANK_CONTAINER, 5, 6, 7, 8, 9, 10, 11, REAGENTBANK_CONTAINER},
				layer = 'HIGH',
				spacing = 2,
				color = {0, 0, 0, 0.5},
				borderColor = {1, 1, 0, 1},
			}
		},

		flashFind = true,
    	tipCount = true,
		fading = true,

		glowAlpha = 0.5,
		glowQuality = true, glowNew = true, glowQuest = true, glowSets = true, glowUnusable = true,

		colorSlots = true,
		emptySlots = true,
		slotColors = {
			leather = {1, .6, .45},
			enchant = {0.64, 0.83, 1},
			inscri = {.64, 1, .82},
			engineer = {.68, .63, .25},
			tackle = {0.42, 0.59, 1},
			cooking = {1, .5, .5},
			gem = {1, .65, .98},
			mine = {1, .81, .38},
			herb = {.5, 1, .5},
			reagent = {1, .87, .68},
			normal = {1, 1, 1},
		}
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
			hiddenBags = {},
			leftSideFilter = true,
			itemScale = 1,
			columns = 8,
			width = 384,
			height = 512,
		},

		bank = {
			hiddenBags = {},
			itemScale = 0.8,
			columns = 16,
			width = 512,
			height = 512,
		}
	}
end
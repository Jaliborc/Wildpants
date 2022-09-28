--[[
	frameDisplay.lua
		Handles when to display the different mod frames and when to keep the blizzard ones hidden. Not pretty.
--]]

local ADDON, Addon = ...
local AutoDisplay = Addon:NewModule('AutoDisplay')
local Interactions = Enum.PlayerInteractionType or {}


--[[ Startup ]]--

function AutoDisplay:OnEnable()
	setmetatable(self, {__index = function(t,k)
		if Addon.Frames[k] then
			t[k] = function(t, ...)
				local args = {...}
				return function() return Addon.Frames[k](Addon.Frames, unpack(args)) end
			end
			return t[k]
		end
	end})

	self:RegisterGameEvents()
	self:HookBaseUI()
end

function AutoDisplay:HookBaseUI()
	-- bag APIs
	self:StopIf(_G, 'OpenAllBags', self:Show('inventory'))
	self:StopIf(_G, 'OpenAllBags', self:Toggle('inventory'))
	self:StopIf(_G, 'OpenBackpack', self:ToggleBag('inventory', BACKPACK_CONTAINER))
	self:StopIf(_G, 'ToggleBackpack', self:ToggleBag('inventory', BACKPACK_CONTAINER))

	self:StopIf(_G, 'ToggleBag', self:Do([[ToggleBag(this:Bag2Frame(arg))]]))
	self:StopIf(_G, 'OpenBag', self:Do([[ShowBag(this:Bag2Frame(arg))]]))

	-- user frames
	CharacterFrame:HookScript('OnShow', self:Do([[Show('inventory') ? displayPlayer]]))
	CharacterFrame:HookScript('OnHide', self:Do([[Hide('inventory') ? displayPlayer]]))
	WorldMapFrame:HookScript('OnShow', self:Do([[Hide('inventory', true) ? closeMap]]))

	-- banking frames
	if C_PlayerInteractionManager then
		self:StopIf(PlayerInteractionFrameManager, 'ShowFrame', function(manager, type)
			return type == Interactions.Banker and Addon.Frames:Show('bank') or
						 type == Interactions.GuildBanker and Addon.Frames:Show('guild') or
						 type == Interactions.VoidStorageBanker and Addon.Frames:Show('vault')
		end)
	end
end

function AutoDisplay:Bag2Frame(bag)
	return Addon:IsBankBag(bag) and 'bank' or 'inventory', bag
end


--[[ Game Events ]]--

function AutoDisplay:RegisterGameEvents()
	self:UnregisterAllEvents()
	self:UnregisterAllMessages()
	self:RegisterMessage(ADDON .. 'UPDATE_ALL', 'RegisterGameEvents')

	if C_PlayerInteractionManager then
		self.Interact = {}
		self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_SHOW', function(_, type)
			if bit.band(self.Interact[type] or 0, 0x1) > 0 then
				Addon.Frames:Show('inventory')
			end
		end)

		self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_HIDE', function(_, type)
			if bit.band(self.Interact[type] or 0, 0x2) > 0 then
				Addon.Frames:Hide('inventory')
			end
		end)
	else
		if Addon.Frames:IsEnabled('bank') then
			self:RegisterMessage('CACHE_BANK_OPENED', self:Show('bank'))
			self:RegisterMessage('CACHE_BANK_CLOSED', self:Hide('bank'))

			BankFrame:UnregisterAllEvents()
		else
			BankFrame:RegisterEvent('BANKFRAME_OPENED')
			BankFrame:RegisterEvent('BANKFRAME_CLOSED')
		end
	end

	self:RegisterDisplayEvents('displayAuction', 'AUCTION_HOUSE_SHOW', 'AUCTION_HOUSE_CLOSED', Interactions.Auctioneer)
	self:RegisterDisplayEvents('displayBank', 'BANKFRAME_OPENED', 'BANKFRAME_CLOSED', Interactions.Banker)
	self:RegisterDisplayEvents('displayCraft', 'TRADE_SKILL_SHOW', 'TRADE_SKILL_CLOSE')
	self:RegisterDisplayEvents('displayTrade', 'TRADE_SHOW', 'TRADE_CLOSED')

	self:RegisterDisplayEvents('closeVendor', nil, 'MERCHANT_CLOSED', Interactions.Merchant)
	self:RegisterDisplayEvents('closeCombat', nil, 'PLAYER_REGEN_DISABLED')

	if not Addon.sets.displayMail then  -- reverse behaviour
		self:RegisterEvent('MAIL_SHOW', self:Hide('inventory'))
	end

	if C_ScrappingMachineUI then
		self:RegisterDisplayEvents('displayScrapping', 'SCRAPPING_MACHINE_SHOW', 'SCRAPPING_MACHINE_CLOSE', Interactions.ScrappingMachine)
	end

	if CanUseVoidStorage then
		self:RegisterDisplayEvents('displayVault', 'VOID_STORAGE_OPEN', 'VOID_STORAGE_CLOSE', Interactions.VoidStorageBanker)
	end

	if CanGuildBankRepair then
		self:RegisterDisplayEvents('displayGuild', 'GUILDBANKFRAME_OPENED', 'GUILDBANKFRAME_CLOSED', Interactions.GuildBanker)
	end

	if HasVehicleActionBar then
		self:RegisterDisplayEvents('closeVehicle', nil, 'UNIT_ENTERED_VEHICLE')
	end

	if C_ItemSocketInfo then
		self:RegisterDisplayEvents('displayGems', 'SOCKET_INFO_UPDATE')
	end
end

function AutoDisplay:RegisterDisplayEvents(setting, showEvent, hideEvent, frameType)
	if Addon.sets[setting] then
		if C_PlayerInteractionManager and frameType then
			self.Interact[frameType] = (showEvent and 0x1) + (hideEvent and 0x2)
		else
			if showEvent then
					self:RegisterEvent(showEvent, self:Show('bank'))
			end
			if hideEvent then
				self:RegisterEvent(hideEvent, self:Hide('inventory'))
			end
		end
	end
end


--[[ Function Generation API ]]--

function AutoDisplay:StopIf(domain, name, hook)
	local original = domain[name]
	domain[name] = function(...)
		if not hook(...) then
			return original(...)
		end
	end
end

function AutoDisplay:Do(code)
	local task, condition = strsplit('?', code)
	local func = 'return Addon.Frames:' .. strtrim(task)
	if condition then
		func = 'if Addon.sets.' .. strtrim(condition) .. ' then ' .. func .. ' end'
	end

	return setfenv(loadstring('return function(arg)'..func..' end'), {this=self, Addon=Addon})()
end

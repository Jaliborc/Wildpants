--[[
	autoDisplay.lua
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
	self:StopIf(_G, 'CloseAllBags', self:Hide('inventory'))
	self:StopIf(_G, 'ToggleAllBags', self:Toggle('inventory'))
	self:StopIf(_G, 'OpenBackpack', self:ShowBag('inventory', BACKPACK_CONTAINER))
	self:StopIf(_G, 'CloseBackpack', self:HideBag('inventory', BACKPACK_CONTAINER))
	self:StopIf(_G, 'ToggleBackpack', self:ToggleBag('inventory', BACKPACK_CONTAINER))
	self:StopIf(_G, 'ToggleBag', function(bag) return Addon.Frames:ToggleBag(self:Bag2Frame(bag)) end)
	self:StopIf(_G, 'OpenBag', function(bag) return Addon.Frames:ShowBag(self:Bag2Frame(bag)) end)

	-- user frames
	CharacterFrame:HookScript('OnShow', self:If('displayPlayer', self:Show('inventory')))
	CharacterFrame:HookScript('OnHide', self:If('displayPlayer', self:Hide('inventory')))
	WorldMapFrame:HookScript('OnShow', self:If('closeMap', self:Hide('inventory', true)))

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

function AutoDisplay:If(setting, func)
	return function(...) if Addon.sets[setting] then return func(...) end end
end

function AutoDisplay:StopIf(domain, name, hook)
	local original = domain[name]
	domain[name] = function(...)
		if not hook(...) then
			return original(...)
		end
	end
end


--[[ Game Events ]]--

function AutoDisplay:RegisterGameEvents()
	self:UnregisterAllEvents()
	self:UnregisterAllMessages()
	self:RegisterMessage(ADDON .. 'UPDATE_ALL', 'RegisterGameEvents')

	-- essential
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

	-- optional additions
	self:RegisterDisplayEvents('closeCombat', nil, 'PLAYER_REGEN_DISABLED')
	self:RegisterDisplayEvents('displayTrade', 'TRADE_SHOW', 'TRADE_CLOSED')
	self:RegisterDisplayEvents('displayCraft', 'TRADE_SKILL_SHOW', 'TRADE_SKILL_CLOSE')
	self:RegisterDisplayEvents(HasVehicleActionBar and 'closeVehicle', nil, 'UNIT_ENTERED_VEHICLE')
	self:RegisterDisplayEvents(C_ItemSocketInfo and 'displaySocket', 'SOCKET_INFO_UPDATE', 'SOCKET_INFO_CLOSE')
	self:RegisterDisplayEvents('displayBank', 'BANKFRAME_OPENED', 'BANKFRAME_CLOSED', Interactions.Banker)


	--[[self:RegisterDisplayEvents('displayAuction', 'AUCTION_HOUSE_SHOW', 'AUCTION_HOUSE_CLOSED', Interactions.Auctioneer)
	self:RegisterDisplayEvents(C_ScrappingMachineUI and 'displayScrapping', 'SCRAPPING_MACHINE_SHOW', 'SCRAPPING_MACHINE_CLOSE', Interactions.ScrappingMachine)
	self:RegisterDisplayEvents(CanUseVoidStorage and 'displayVault', 'VOID_STORAGE_OPEN', 'VOID_STORAGE_CLOSE', Interactions.VoidStorageBanker)
	self:RegisterDisplayEvents(CanGuildBankRepair and 'displayGuild', 'GUILDBANKFRAME_OPENED', 'GUILDBANKFRAME_CLOSED', Interactions.GuildBanker)
	self:RegisterBorkenEvents('closeVendor', 'MERCHANT_CLOSED', Interactions.Merchant)
	self:RegisterBorkenEvents('closeMail', 'MAIL_CLOSED', Interactions.MailInfo)--]]

	-- optional override

end

function AutoDisplay:RegisterDisplayEvents(setting, showEvent, hideEvent, frameType)
	if setting and Addon.sets[setting] then
		if C_PlayerInteractionManager and frameType then
			self.Interact[frameType] = (showEvent and 0x1) + (hideEvent and 0x2)
		else
			self:RegisterEventIf(showEvent, self:Show('inventory'))
			self:RegisterEventIf(hideEvent, self:Hide('inventory'))
		end
	end
end



function AutoDisplay:RegisterEventIf(event, ...)
	if event then
		self:RegisterEvent(event, ...)
	end
end

--[[
	autoDisplay.lua
		Handles when to display the different mod frames and when to keep the blizzard ones hidden. Not pretty.
--]]

local ADDON, Addon = ...
local AutoDisplay = Addon:NewModule('AutoDisplay')


--[[ Startup ]]--

function AutoDisplay:OnEnable()
	self:RegisterMessage(ADDON .. 'UPDATE_ALL', 'RegisterGameEvents')
	self:RegisterMessage('CACHE_BANK_OPENED', 'ShowBank')
	self:RegisterMessage('CACHE_BANK_CLOSED', 'HideBank')

	self:RegisterGameEvents()
	self:HookFrameDisplay()
	self:HookBagAPIs()
end


--[[ Game Events ]]--

function AutoDisplay:RegisterGameEvents()
	self.Interactions = {}
	self:UnregisterAllEvents()
	self:RegisterDisplayEvents('displayAuction', 'AUCTION_HOUSE_SHOW', 'AUCTION_HOUSE_CLOSED', 'Auctioneer')
	self:RegisterDisplayEvents('displayCraft', 'TRADE_SKILL_SHOW', 'TRADE_SKILL_CLOSE')
	self:RegisterDisplayEvents('displayTrade', 'TRADE_SHOW', 'TRADE_CLOSED')

	self:RegisterDisplayEvents('closeCombat', nil, 'PLAYER_REGEN_DISABLED')
	self:RegisterDisplayEvents('closeVendor', nil, 'MERCHANT_CLOSED')

	if CanGuildBankRepair then
		self:RegisterDisplayEvents('displayGuild', 'GUILDBANKFRAME_OPENED', 'GUILDBANKFRAME_CLOSED', 'GuildBanker')
	end

	if HasVehicleActionBar then
		self:RegisterDisplayEvents('closeVehicle', nil, 'UNIT_ENTERED_VEHICLE')
	end

	if C_ItemSocketInfo then
		self:RegisterDisplayEvents('displayGems', 'SOCKET_INFO_UPDATE')
	end

	if C_ScrappingMachineUI then
		self:RegisterDisplayEvents('displayScrapping', 'SCRAPPING_MACHINE_SHOW', 'SCRAPPING_MACHINE_CLOSE', 'ScrappingMachine')
	end

	if not Addon.sets.displayMail then  -- reverse behaviour
		self:RegisterEvent('MAIL_SHOW', 'HideInventory')
	end

	if C_PlayerInteractionManager then
		self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_SHOW', function(_, type)
			if self.Interactions[type] then
				self:ShowInventory()
			end
		end)

		self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_HIDE', function(_, type)
			if self.Interactions[type] then
				self:HideInventory()
			end
		end)
	end
end

function AutoDisplay:RegisterDisplayEvents(setting, showEvent, hideEvent, interaction)
	if Addon.sets[setting] then
		if C_PlayerInteractionManager and interaction then
			self.Interactions[Enum.PlayerInteractionType[interaction]] = true
		else
			if showEvent then
				self:RegisterEvent(showEvent, 'ShowInventory')
			end

			if hideEvent then
				self:RegisterEvent(hideEvent, 'HideInventory')
			end
		end
	end
end

function AutoDisplay:ShowInventory()
	Addon.Frames:Show('inventory')
end

function AutoDisplay:HideInventory()
	Addon.Frames:Hide('inventory')
end

function AutoDisplay:ShowBank()
	local bank = Addon.Frames:Show('bank')
	if bank then
		bank:SetOwner(nil)
	end

	if Addon.sets.displayBank then
		Addon.Frames:Show('inventory')
	end
end

function AutoDisplay:HideBank()
	Addon.Frames:Hide('bank')

	if Addon.sets.closeBank then
		Addon.Frames:Hide('inventory')
	end
end


--[[ Interface Behavior ]]--

function AutoDisplay:HookFrameDisplay()
	-- bank frame
	if C_PlayerInteractionManager then
		self:StopIf(PlayerInteractionFrameManager, 'ShowFrame', function(manager, type)
			return type == Enum.PlayerInteractionType.Banker and Addon.Frames:Show('bank')
		end)
	else
		if Addon.Frames:IsEnabled('bank') then
			BankFrame:UnregisterAllEvents()
		else
			BankFrame:RegisterEvent('BANKFRAME_OPENED')
			BankFrame:RegisterEvent('BANKFRAME_CLOSED')
		end
	end

	-- character frame
	CharacterFrame:HookScript('OnShow', function()
		if Addon.sets.displayPlayer then
			Addon.Frames:Show('inventory')
		end
	end)

	CharacterFrame:HookScript('OnHide', function()
		if Addon.sets.displayPlayer then
			Addon.Frames:Hide('inventory')
		end
	end)

	-- merchant frame
	local canHide = true
	local onMerchantHide = MerchantFrame:GetScript('OnHide')
	local hideInventory = function()
		if canHide then
			Addon.Frames:Hide('inventory')
		end
	end

	MerchantFrame:SetScript('OnHide', function(...)
		canHide = false
		onMerchantHide(...)
		canHide = true
	end)

	hooksecurefunc('CloseBackpack', hideInventory)
	hooksecurefunc('CloseAllBags', hideInventory)

	-- world map
	WorldMapFrame:HookScript('OnShow', function()
		if Addon.sets.closeMap then
			Addon.Frames:Hide('inventory', true)
		end
	end)
end

function AutoDisplay:HookBagAPIs()
	self:StopIf(_G, 'OpenAllBags', function(bag) return Addon.Frames:Show('inventory') end)
	self:StopIf(_G, 'ToggleAllBags', function(bag) return Addon.Frames:Toggle('inventory') end)

	self:StopIf(_G, 'ToggleBag', function(bag) return Addon.Frames:ToggleBag(self:Bag2Frame(bag)) end)
	self:StopIf(_G, 'OpenBag', function(bag) return Addon.Frames:ShowBag(self:Bag2Frame(bag)) end)

	self:StopIf(_G, 'ToggleBackpack', function(bag) return Addon.Frames:ToggleBag('inventory', BACKPACK_CONTAINER) end)
	self:StopIf(_G, 'OpenBackpack', function(bag) return Addon.Frames:ShowBag('inventory', BACKPACK_CONTAINER) end)
end

function AutoDisplay:StopIf(domain, name, hook)
	local original = domain[name]
	domain[name] = function(...)
		if not hook(...) then
			return original(...)
		end
	end
end

function AutoDisplay:Bag2Frame(bag)
	return Addon:IsBankBag(bag) and 'bank' or 'inventory', bag
end

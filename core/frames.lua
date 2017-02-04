--[[
	frames.lua
		Methods for managing frame creation and display
--]]

local ADDON, Addon = ...


--[[ Frame Display ]]--

function Addon:UpdateFrames()
	self:SendMessage('UPDATE_ALL')
	self:UpdateEvents()
end

function Addon:ToggleFrame(id)
	if self:IsFrameShown(id) then
		return self:HideFrame(id, true)
	else
		return self:ShowFrame(id)
	end
end

function Addon:ShowFrame(id)
	local frame = self:CreateFrame(id)
	if frame then
		frame:ShowFrame()
	end
	return frame
end

function Addon:HideFrame(id, force)
	local frame = self:GetFrame(id)
	if frame then
		frame:HideFrame(force)
	end
	return frame
end

function Addon:IsFrameShown(id)
	local frame = self:GetFrame(id)
	return frame and frame:IsShown()
end

function Addon:CreateFrame(id)
	if self:IsFrameEnabled(id) then
 		self.frames[id] = self.frames[id] or self[id:gsub('^.', id.upper) .. 'Frame']:New(id)
 		return self.frames[id]
 	end
end

function Addon:AreBasicFramesEnabled()
	return self:IsFrameEnabled('inventory') and self:IsFrameEnabled('bank')
end

function Addon:IsFrameEnabled(id)
	return self.profile[id].enabled
end

function Addon:GetFrame(id)
	return self.frames[id]
end

function Addon:IterateFrames()
	return pairs(self.frames)
end


--[[ Bag Display ]]--

function Addon:ToggleBag(frame, bag)
	if self:IsBagControlled(frame, bag) then
		return self:ToggleFrame(frame)
	end
end

function Addon:ShowBag(frame, bag)
	if self:IsBagControlled(frame, bag) then
		return self:ShowFrame(frame)
	end
end

function Addon:IsBagControlled(frame, bag)
	return not Addon.sets.displayBlizzard or self:IsFrameEnabled(frame) and not self.profile[frame].hiddenBags[bag]
end

function Addon:IsBagShown(frame, bag)
	local hidden = frame:GetProfile().hiddenBags
	if not frame:GetProfile().exclusiveReagent or bag == REAGENTBANK_CONTAINER or hidden[REAGENTBANK_CONTAINER] then
		return not hidden[bag]
	end
end


--[[ Blizzard Functions Hooks ]]--

function Addon:HookDefaultDisplayFunctions()
	-- inventory
	local canHide = true
	local onMerchantHide = MerchantFrame:GetScript('OnHide')
	local hideInventory = function()
		if canHide then
			self:HideFrame('inventory')
		end
	end

	MerchantFrame:SetScript('OnHide', function(...)
		canHide = false
		onMerchantHide(...)
		canHide = true
	end)

	hooksecurefunc('CloseBackpack', hideInventory)
	hooksecurefunc('CloseAllBags', hideInventory)

	-- backpack
	local oToggleBackpack = ToggleBackpack
	ToggleBackpack = function()
		if not self:ToggleBag('inventory', BACKPACK_CONTAINER) then
			oToggleBackpack()
		end
	end

	local oOpenBackpack = OpenBackpack
	OpenBackpack = function()
		if not self:ShowBag('inventory', BACKPACK_CONTAINER) then
			oOpenBackpack()
		end
	end

	-- single bag
	local oToggleBag = ToggleBag
	ToggleBag = function(bag)
		local frame = self:IsBankBag(bag) and 'bank' or 'inventory'
		if not self:ToggleBag(frame, bag) then
			oToggleBag(bag)
		end
	end

	local oOpenBag = OpenBag
	OpenBag = function(bag)
		local frame = self:IsBankBag(bag) and 'bank' or 'inventory'
		if not self:ShowBag(frame, bag) then
			oOpenBag(bag)
		end
	end

	-- all bags
	local oOpenAllBags = OpenAllBags
	OpenAllBags = function(frame)
		if not self:ShowFrame('inventory') then
			oOpenAllBags(frame)
		end
	end

	if ToggleAllBags then
		local oToggleAllBags = ToggleAllBags
		ToggleAllBags = function()
			if not self:ToggleFrame('inventory') then
				oToggleAllBags()
			end
		end
	end

	local function checkIfInventoryShown(button)
		if self:IsFrameEnabled('inventory') then
			button:SetChecked(self:IsFrameShown('inventory'))
		end
	end

	hooksecurefunc('BagSlotButton_UpdateChecked', checkIfInventoryShown)
	hooksecurefunc('BackpackButton_UpdateChecked', checkIfInventoryShown)
end
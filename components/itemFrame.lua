--[[
	itemFrame.lua
		An item slot container template
--]]

local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-1.1')
local ItemFrame = Addon:NewClass('ItemFrame', 'Frame')
ItemFrame.Button = Addon.ItemSlot


--[[ Constructor ]]--

function ItemFrame:New(parent, bags)
	local f = self:Bind(CreateFrame('Frame', nil, parent))
	f:SetScript('OnHide', f.UnregisterEvents)
	f:SetScript('OnShow', f.Update)
	f.bags, f.buttons = bags, {}
	f:RequestLayout()
	f:SetSize(1,1)

	return f
end

function ItemFrame:Update()
	self:RequestLayout()
	self:RegisterEvents()
end


--[[ Events ]]--

function ItemFrame:RegisterEvents()
	self:UnregisterEvents()
	self:RegisterMessage('UPDATE_ALL', 'RequestLayout')
	self:RegisterFrameMessage('FILTERS_CHANGED', 'RequestLayout')
	self:RegisterFrameMessage('PLAYER_CHANGED', 'Update')

	if not self:IsCached() then
		self:RegisterMessage('BAG_UPDATE_SIZE')
		self:RegisterMessage('BAG_UPDATE_CONTENT')
		self:RegisterEvent('UNIT_QUEST_LOG_CHANGED')
		self:RegisterEvent('ITEM_LOCK_CHANGED')

		self:RegisterEvent('BAG_UPDATE_COOLDOWN', 'ForAll', 'UpdateCooldown')
		self:RegisterEvent('BAG_NEW_ITEMS_UPDATED', 'ForAll', 'UpdateBorder')
		self:RegisterEvent('EQUIPMENT_SETS_CHANGED', 'ForAll', 'UpdateBorder')
		self:RegisterEvent('QUEST_ACCEPTED', 'ForAll', 'UpdateBorder')

		self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED', 'ForAll', 'UpdateUpgradeIcon')
		self:RegisterEvent('UNIT_INVENTORY_CHANGED', 'ForAll', 'UpdateUpgradeIcon')
	else
		self:RegisterEvent('GET_ITEM_INFO_RECEIVED', 'ForAll', 'Update')
		self:RegisterMessage('BANK_OPENED', 'RegisterEvents')
	end
end

function ItemFrame:BAG_UPDATE_SIZE(_,bag)
	if self.bags[bag] then
		self:RequestLayout()
	end
end

function ItemFrame:BAG_UPDATE_CONTENT(_,bag)
	self:ForBag(bag, 'Update')
end

function ItemFrame:ITEM_LOCK_CHANGED(_,bag, slot)
	if not self:PendingLayout() then
		bag = self.bagButtons[bag]
		slot = bag and bag[slot]

		if slot then
			slot:UpdateLocked()
		end
	end
end

function ItemFrame:UNIT_QUEST_LOG_CHANGED(_,unit)
	if unit == 'player' then
		self:ForAll('UpdateBorder')
	end
end


--[[ Management ]]--

function ItemFrame:RequestLayout()
	self:SetScript('OnUpdate', self.Layout)
end

function ItemFrame:PendingLayout()
	return self:GetScript('OnUpdate')
end

function ItemFrame:Layout()
	self:SetScript('OnUpdate', nil)
	self:ForAll('Release')
	self.buttons = {}

	-- Acquire slots
	for bag in ipairs(self.bags) do
		if self:IsShowingBag(bag) then
			self.buttons[bag] = {}

			for slot = 1, self:NumSlots(bag) do
				if self:IsShowingItem(bag, slot) then
					self.buttons[bag][slot] = self.Button:New(self, bag, slot)
				end
			end
		end
	end

	-- Position slots
	local profile =  self:GetProfile()
	local columns, scale = self:LayoutTraits()
	local size = self:GetButtonSize()

	local revBags, revSlots = profile.reverseBags, profile.reverseSlots
	local x, y = 0,0

	for k = revBags and #self.bags or 1, revBags and 1 or #self.bags, revBags and -1 or 1 do
		local bag = self.bags[k]
		local slots = self.buttons[bag]

		if slots then
			for slot = revSlots and #slots or 1, revSlots and 1 or #slots, revSlots and -1 or 1 do
				local button = slots[slot]
				if button then
					if x == columns then
						y = y + 1
						x = 0
					end

					button:ClearAllPoints()
					button:SetPoint('TOPLEFT', self, 'TOPLEFT', size * (self.Transposed and y or x), -size * (self.Transposed and x or y))
					button:SetScale(scale)

					x = x + 1
				end
			end

			if self:BagBreak() and x > 0 then
				y = y + 1
				x = 0
			end
		end
	end

	-- Resize frame
	if x > 0 then
		y = y + 1
	end

	local width, height = max(columns * size * scale, 1), max(y * size * scale, 1)
	self:SetSize(self.Transposed and height or width, self.Transposed and width or height)
	self:SendFrameMessage('ITEM_FRAME_RESIZED')
end

function ItemFrame:ForAll(method, ...)
	if not self:PendingLayout() then
		for i, button in ipairs({self:GetChildren()}) do
			button[method](button, ...)
		end
	end
end

function ItemFrame:ForBag(bag, method, ...)
	if self:CanUpdate(bag) then
		for slot, button in pairs(self.bagButtons[bag]) do
			button[method](button, ...)
		end
	end
end

function ItemFrame:CanUpdate(bag)
	return not self:PendingLayout() and self.bagButtons[bag]
end


--[[ Proprieties ]]--

function ItemFrame:IsShowingBag(bag)
	return self:GetFrame():IsShowingBag(bag)
end

function ItemFrame:IsShowingItem(bag, slot)
	return self:GetFrame():IsShowingItem(bag, slot)
end

function ItemFrame:NumSlots(bag)
	return Addon:GetBagSize(self:GetPlayer(), bag)
end

function ItemFrame:NumButtons()
	return self.numButtons
end

function ItemFrame:GetButtonSize()
	return 37 + self:GetProfile().spacing
end

function ItemFrame:BagBreak()
	return self:GetProfile().bagBreak
end

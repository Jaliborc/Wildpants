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
	f:SetScript('OnShow', f.OnShow)
	f.bags, f.buttons = bags, {}
	f:SetSize(1,1)
	f:OnShow()

	return f
end

function ItemFrame:OnShow()
	self:RequestLayout()
	self:RegisterEvents()
end


--[[ Events ]]--

function ItemFrame:RegisterEvents()
	self:UnregisterEvents()
	self:RegisterMessage(self:GetFrameID() .. '_PLAYER_CHANGED', 'OnShow')
	self:RegisterMessage('UPDATE_ALL', 'RequestLayout')
	self:RegisterMessage('BAG_TOGGLED')
	self:RegisterMessage('FOCUS_BAG')

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
	if self:CanUpdate(bag) then
		self:ForBag(bag, 'Update')
	end
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

function ItemFrame:BAG_TOGGLED(_,bag)
	if self:CanUpdate(bag) then
		self:RequestLayout()
	end
end

function ItemFrame:FOCUS_BAG(_,bag)
	for _, id in ipairs(self.bags) do
		self:ForBag(id, 'SetHighlight', id == bag)
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
	self.bagButtons = {}

	local x, y, i = 0,0,1
	local columns, size, scale = self:LayoutTraits()
	local reverseBags, reverseSlots = self:GetProfile().reverseBags, self:GetProfile().reverseSlots

	local first, last, step
	if reverseSlots then
		last, step = 1, -1
	else
		first, step = 1, 1
	end

	for k = reverseBags and #self.bags or 1, reverseBags and 1 or #self.bags, reverseBags and -1 or 1 do
		local bag = self.bags[k]
		self.bagButtons[bag] = {}

		if self:IsShowing(bag) then
			if reverseSlots then
				first = self:NumSlots(bag)
			else
				last = self:NumSlots(bag)
			end

			for slot = first, last, step do
				if x == columns then
					y = y + 1
					x = 0
				end

				local button = self.buttons[i] or self.Button:New()
				button:ClearAllPoints()
				button:SetTarget(self, bag, slot)
				button:SetScale(scale)

				if self.TransposeLayout then
					button:SetPoint('TOPLEFT', self, 'TOPLEFT', size * y, -size * x)
				else
					button:SetPoint('TOPLEFT', self, 'TOPLEFT', size * x, -size * y)
				end

				self.bagButtons[bag][slot] = button
				self.buttons[i] = button

				i = i + 1
				x = x + 1
			end

			if self:BagBreak() and x > 0 then
				y = y + 1
				x = 0
			end
		end
	end

	if x > 0 then
		y = y + 1
	end

	for k = i, #self.buttons do
		tremove(self.buttons):Free()
	end

	local width, height = max(columns * size * scale, 1), max(y * size * scale, 1)
	if self.TransposeLayout then
		self:SetSize(height, width)
	else
		self:SetSize(width, height)
	end

	self:GetParent():UpdateSize()
end

function ItemFrame:CanUpdate(bag)
	return not self:PendingLayout() and self.bagButtons[bag]
end

function ItemFrame:ForAll(method, ...)
	if not self:PendingLayout() then
		for i, button in pairs(self.buttons) do
			button[method](button, ...)
		end
	end
end

function ItemFrame:ForBag(bag, method, ...)
	for slot, button in pairs(self.bagButtons[bag]) do
		button[method](button, ...)
	end
end


--[[ Proprieties ]]--

function ItemFrame:IsShowing(bag)
	return Addon:IsBagShown(self, bag)
end

function ItemFrame:NumSlots(bag)
	return Addon:GetBagSize(self:GetPlayer(), bag)
end

function ItemFrame:BagBreak()
	return self:GetProfile().bagBreak
end

function ItemFrame:LayoutTraits()
	local profile = self:GetProfile()
	return profile.columns, (37 + profile.spacing), profile.itemScale
end
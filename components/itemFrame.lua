--[[
	itemFrame.lua
		An item slot container template
--]]

local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-1.1')
local ItemFrame = Addon:NewClass('ItemFrame', 'Frame')
ItemFrame.Button = Addon.ItemSlot


--[[ Constructor ]]--

function ItemFrame:New(parent, resizable)
	local f = self:Bind(CreateFrame('Frame', nil, parent))
	f:SetScript('OnHide', f.UnregisterEvents)
	f:SetScript('OnShow', f.RegisterEvents)
	f.resizable, f.buttons = resizable, {}
	f:RegisterEvents()
	f:SetSize(1,1)

	return f
end


--[[ Events ]]--

function ItemFrame:RegisterEvents()
	if not self:IsCached() then
		self:RegisterMessage('BAG_UPDATE_SIZE')
		self:RegisterMessage('BAG_UPDATE_CONTENT')
		self:RegisterEvent('BAG_UPDATE_COOLDOWN')
		self:RegisterEvent('UNIT_QUEST_LOG_CHANGED')
		self:RegisterEvent('ITEM_LOCK_CHANGED')

		self:RegisterEvent('QUEST_ACCEPTED', 'ForAll', 'UpdateBorder')
		self:RegisterEvent('BAG_NEW_ITEMS_UPDATED', 'ForAll', 'UpdateBorder')
		self:RegisterEvent('EQUIPMENT_SETS_CHANGED', 'ForAll', 'UpdateBorder')
	else
		self:RegisterEvent('GET_ITEM_INFO_RECEIVED', 'ForAll', 'Update')
	end

	self:RegisterMessage('UPDATE_ALL', 'RequestLayout')
	self:RegisterMessage('BAG_TOGGLED')
	self:RegisterMessage('FOCUS_BAG')
	self:RequestLayout()
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

function ItemFrame:BAG_UPDATE_COOLDOWN(_,bag)
	if self:CanUpdate(bag) then
		self:ForBag(bag, 'UpdateCooldown')
	end
end

function ItemFrame:UNIT_QUEST_LOG_CHANGED(_,unit)
	if unit == 'player' then
		self:ForAll('UpdateBorder')
	end
end

function ItemFrame:ITEM_LOCK_CHANGED(_,bag, slot)
	if not self:PendingLayout() then
		bag = self.bags[bag]
		slot = bag and bag[slot]

		if slot then
			slot:UpdateLocked()
		end
	end
end

function ItemFrame:BAG_TOGGLED(_,bag)
	if self:CanUpdate(bag) then
		self:RequestLayout()
	end
end

function ItemFrame:FOCUS_BAG(_,bag)
	for id in pairs(self.bags) do
		self:ForBag(id, 'SetHighlight', id == bag)
	end
end


--[[ Update ]]--

function ItemFrame:RequestLayout()
	self:SetScript('OnUpdate', self.Layout)
end

function ItemFrame:PendingLayout()
	return self:GetScript('OnUpdate')
end

function ItemFrame:Layout()
	self:SetScript('OnUpdate', nil)
	self.bags = {}

	local x, y, i = 0,0,1
	local columns, size, scale = self:LayoutTraits()
	local reverse, start, finish, step = self:GetSettings().reverseSlots

	for _, bag in self:IterateBags() do
		self.bags[bag] = {}

		if self:IsShowing(bag) then
			if reverse then
				start, finish, step = self:NumSlots(bag), 1, -1
			else
				start, finish, step = 1, self:NumSlots(bag), 1
			end

			for slot = start, finish, step do
				if x == columns then
					y = y + 1
					x = 0
				end

				local button = self.buttons[i] or self.Button:New()
				button:ClearAllPoints()
				button:SetTarget(self, bag, slot)
				button:SetPoint('TOPLEFT', self, 'TOPLEFT', size * x, -size * y)
				button:SetScale(scale)

				self.bags[bag][slot] = button
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

	self:SetSize(columns * size * scale, y * size * scale)
	self:OnLayout()
end

function ItemFrame:CanUpdate(bag)
	return not self:PendingLayout() and self.bags[bag]
end

function ItemFrame:ForAll(method, ...)
	if not self:PendingLayout() then
		for i, button in pairs(self.buttons) do
			button[method](button, ...)
		end
	end
end

function ItemFrame:ForBag(bag, method, ...)
	for slot, button in pairs(self.bags[bag]) do
		button[method](button, ...)
	end
end


--[[ Proprieties ]]--

function ItemFrame:IterateBags()
	return ipairs(self:GetFrame().Bags)
end

function ItemFrame:IsShowing(bag)
	return not self:GetProfile().hiddenBags[bag] 
end

function ItemFrame:IsCached()
	return Cache:IsPlayerCached(self:GetPlayer())
end

function ItemFrame:NumSlots(bag)
	return Addon:GetBagSize(self:GetPlayer(), bag)
end

function ItemFrame:BagBreak()
	return self:GetSettings().bagBreak
end

function ItemFrame:LayoutTraits()
	local profile = self:GetProfile()
	if self.resizable then
		return profile.columns, (37 + profile.spacing), profile.itemScale
	else

	end
end
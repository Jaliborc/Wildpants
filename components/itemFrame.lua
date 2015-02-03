--[[
	itemFrame.lua
		An item slot container template
--]]

local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-1.1')
local ItemFrame = Addon:NewClass('ItemFrame', 'Frame')


--[[ Constructor ]]--

function ItemFrame:New(parent)
	local f = self:Bind(CreateFrame('Frame', nil, parent))
	f:SetScript('OnHide', f.UnregisterAllMessages)
	f:SetScript('OnShow', f.RegisterEvents)
	f:RegisterEvents()
	f:SetSize(1,1)
	f.buttons = {}

	return f
end


--[[ Events ]]--

function ItemFrame:BAG_UPDATE_SIZE(bag)
	if self:IsShowing(bag) then
		self:RequestLayout()
	end
end

function ItemFrame:BAG_UPDATE_CONTENT(bag)
	if not self:PendingLayout() then
		self:ForBag(bag, 'Update')
	end
end

function ItemFrame:BAG_UPDATE_COOLDOWN(bag)
	if not self:PendingLayout() then
		self:ForBag(bag, 'UpdateCooldown')
	end
end


--[[ Update ]]--

function ItemFrame:RegisterEvents()
	self:RegisterMessage('BAG_UPDATE_SIZE')
	self:RegisterMessage('BAG_UPDATE_CONTENT')
	self:RegisterMessage('BAG_UPDATE_COOLDOWN')
	self:RequestLayout()
end

function ItemFrame:RequestLayout()
	self:SetScript('OnUpdate', self.Layout)
end

function ItemFrame:Layout()
	self:SetScript('OnUpdate', nil)
	self.bags = {}

	local x, y, i = 0,0,1
	local columns, size = self:NumColumns(), self:ButtonSize()

	for _, bag in self:IterateBags() do
		if self:IsBagVisible(bag) then
			self.bags[bag] = {}

			for slot = 1, self:NumSlots(bag) do
				if x == columns then
					y = y + 1
					x = 0
				end

				local button = self:GetButton(i)
				button:ClearAllPoints()
				button:SetTarget(self, bag, slot)
				button:SetPoint('TOPLEFT', self, 'TOPLEFT', size * x, -size * y)

				i = i + 1
				x = x + 1

				self.bags[bag][slot] = button
			end

			if self:BagBreak() and x > 0 then
				y = y + 1
				x = 0
			end
		end
	end

	for k = i, #self.buttons do
		tremove(self.buttons):Free()
	end

	self:SetSize(columns * size, y * size)
end

function ItemFrame:ForBag(bag, method, ...)
	for slot, button in pairs(self.bags[bag] or {}) do
		button[method](button, ...)
	end
end


--[[ Misc ]]--

function ItemFrame:GetButton(i)
	if not self.buttons[i] then
		self.buttons[i] = self.Button:New()
	end
	return self.buttons[i]
end

function ItemFrame:IterateBags()
	return ipairs(self:GetFrame().Bags)
end

function ItemFrame:BagBreak()
	return self:GetSettings().bagBreak
end

function ItemFrame:NumSlots(bag)
	return Addon:GetBagSize(self:GetPlayer(), bag)
end


--[[ Specifics ]]--

function ItemFrame:IsBagVisible(bag)
	return not self:GetProfile().hiddenBags[bag] 
end

function ItemFrame:NumColumns()
	return self:GetProfile().columns
end

function ItemFrame:ButtonSize()
	return 36
end

ItemFrame.Button = Addon.ItemSlot
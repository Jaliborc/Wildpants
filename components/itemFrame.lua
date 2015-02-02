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
	f:SetScript('OnShow', f.RequestLayout)
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

function ItemFrame:RequestLayout()
	self:SetScript('OnUpdate', self.Layout)
end

function ItemFrame:Layout()
	self:SetScript('OnUpdate', nil)
	self.bags = {}

	local x, y, i = 0,0,0
	for bag in self:VisibleBags() do
		self.bags[bag] = {}

		for slot = 1, self:NumSlots(bag) do
			if x == self:NumColumns() then
				y = y + 1
				x = 0
			end

			local button = self:GetButton(i)
			button:ClearAllPoints()
			button:SetTarget(bag, slot)
			button:SetPoint('TOPLEFT', self, 'TOPLEFT', size * (x - 1), -size * (y - 1))
			i = i + 1

			self.bags[bag][slot] = button
		end

		if self:HasBagBreak() and x > 0 then
			y = y + 1
			x = 0
		end
	end

	for k = i, #self.buttons do
		tremove(self.buttons):Free()
	end
end

function ItemFrame:ForBag(bag, method, ...)
	for slot, button in pairs(self.bags[bag] or {}) do
		button[method](button, ...)
	end
end


--[[ Buttons ]]--

function ItemFrame:GetButton(i)
	if not self.buttons[i] then
		self.buttons[i] = self.Button:New(self)
	end
	return self.buttons[i]
end
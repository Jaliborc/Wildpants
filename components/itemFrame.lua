--[[
	itemFrame.lua
		An item slot container template
--]]

local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-1.1')
local ItemFrame = Addon:NewClass('ItemFrame', 'Frame')


--[[ Constructor ]]--

function ItemFrame:New(parent)
	local f = self:Bind(CreateFrame('ScrollFrame', nil, parent))
	f:SetScript('OnVerticalScroll', self.Reposition)
	f:SetScript('OnHide', f.UnregisterAllMessages)
	f:SetScript('OnShow', f.RequestLayout)
	f:SetSize(1,1)
	f.buttons = {}

	return f
end

function ItemFrame:OnScroll()
	self:Reposition()
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
	self.rows = {{}}

	local row
	for bag in self:VisibleBags() do
		for slot = 1, self:NumSlots(bag) do
			row = self.rows[#self.rows]
			tinsert(row, {bag, slot})

			if #row == self:NumColumns() then
				tinsert(self.rows, {})
			end
		end

		if self:HasBagBreak() and #row > 0 then
			tinsert(self.rows, {})
		end
	end

	self:Reposition()
end

function ItemFrame:Reposition()
	local size = 36 + self:GetPadding()
	local startRow = 0
	local i = 1

	for x = startRow, min(startRow + self:NumRows(), #self.rows) do
		for y = 1, #self.rows[x] do
			local button = self:GetButton(i)
			button:ClearAllPoints()
			button:SetTarget(unpack(self.rows[x][y])
			button:SetPoint('TOPLEFT', self, 'TOPLEFT', size * (x - 1), -size * (y - 1))
			i = i + 1
		end
	end

	for k = i, #self.buttons do
		self:RemoveButton()
	end
end

function ItemFrame:ForBag(bag, method, ...)
	for _, i in self:IterateBag(bag) do
		local button = self:GetButton(i)
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

function ItemFrame:RemoveButton()
	tremove(self.buttons):Free()
end
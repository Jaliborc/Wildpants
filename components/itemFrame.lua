--[[
	itemFrame.lua
		An item slot container template
--]]

local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-1.1')
local ItemFrame = Addon:NewClass('ItemFrame', 'Frame')
ItemFrame.ITEM_SIZE = 39
ItemFrame.COLUMN_OFF = 0

local function ToIndex(bag, slot)
	return (bag<0 and bag*100 - slot) or (bag*100 + slot)
end

local function ToBag(index)
	return (index > 0 and floor(index/100)) or ceil(index/100)
end


--[[ Constructor ]]--

function ItemFrame:New(parent, ...)
	local f = self:Bind(CreateFrame('Frame', nil, parent))
	f:SetScript('OnHide', f.UnregisterAllMessages)
	f:SetScript('OnShow', f.Update)
	f:SetSize(1,1)

	f.args = {...}
	f.slots = {}

	return f
end


--[[ Custom Events ]]--

function ItemFrame:ITEM_ADD(bag, slot)
	if self:ShowingBag(bag) then
		self:AddSlot(bag, slot)
	end
end

function ItemFrame:ITEM_REMOVE(bag, slot)
	if self:ShowingBag(bag) then
		self:RemoveSlot(bag, slot)
	end
end

function ItemFrame:ITEM_LOCK_UPDATE(bag, slot)
	local slot = self:GetSlot(bag, slot)
	if slot then
		slot:UpdateLock()
	end
end

function ItemFrame:ITEM_COOLDOWN_UPDATE(bag, slot)
	local slot = self:GetSlot(bag, slot)
	if slot then
		slot:UpdateCooldown()
	end
end

function ItemFrame:BAG_TOGGLE(bag)
	if self:ShowingBag(bag) then
		self:AddBag(bag)
	else
		self:RemoveBag(bag)
	end
end

function ItemFrame:BAG_UPDATE_TYPE(bag, type)
	if self:IsBagShown(bag) then
		self:UpdateBacks(bag)
	end
end

function ItemFrame:UNIT_QUEST_LOG_CHANGED(unit)
	if unit == 'player' then
		self:UpdateBorders()
	end
end

ItemFrame.EQUIPMENT_SETS_CHANGED = ItemFrame.UpdateBorders
ItemFrame.QUEST_ACCEPTED = ItemFrame.UpdateBorders


--[[ Update ]]--

function ItemFrame:Update()
	self:UpdateEvents()

	if self:IsVisible() then
		self:ReloadSlots()
		self:RequestLayout()
	end
end

function ItemFrame:UpdateEvents()
	self:UnregisterAllMessages()

	if self:IsVisible() then
		if not self:IsCached() then
			self:RegisterEvent('ITEM_LOCK_CHANGED')
      		self:RegisterEvent('QUEST_ACCEPTED')
      		self:RegisterEvent('UNIT_QUEST_LOG_CHANGED')
      		self:RegisterEvent('EQUIPMENT_SETS_CHANGED')

			self:RegisterItemEvent('ITEM_SLOT_ADD')
			self:RegisterItemEvent('ITEM_SLOT_REMOVE')
			self:RegisterItemEvent('ITEM_SLOT_UPDATE', 'HandleSpecificItemEvent')
			self:RegisterItemEvent('ITEM_SLOT_UPDATE_COOLDOWN', 'HandleSpecificItemEvent')
			self:RegisterItemEvent('BAG_UPDATE_TYPE')

			if self:HasBankBags() then
				self:RegisterItemEvent('BANK_OPENED')
				self:RegisterItemEvent('BANK_CLOSED')
				self:RegisterEvent('REAGENTBANK_PURCHASED')
			end
		else
			self:RegisterEvent('GET_ITEM_INFO_RECEIVED')
		end

		self:RegisterMessage('BAG_SLOT_SHOW')
		self:RegisterMessage('BAG_SLOT_HIDE')
		self:RegisterMessage('PLAYER_UPDATE')
		self:RegisterMessage('SLOT_ORDER_UPDATE')
		self:RegisterMessage('ITEM_FRAME_BAG_BREAK_UPDATE')
		self:RegisterMessage('BAG_DISABLE_UPDATE')
		self:RegisterGlobalItemEvents()
	end
end


--[[ Item Slot Management ]]--

function ItemFrame:AddItemSlot(bag, slot)
	if self:IsBagShown(bag) and not self:GetItemSlot(bag, slot) then
		local button = Addon.ItemSlot:New()
		button:Set(self, bag, slot)

		self.slots[ToIndex(bag, slot)] = button
		self:RequestLayout()
	end
end

function ItemFrame:RemoveItemSlot(bag, slot)
	local itemSlot = self:GetItemSlot(bag, slot)
	if itemSlot then
		itemSlot:Free()
		self.slots[ToIndex(bag, slot)] = nil
		self:RequestLayout()
	end
end

function ItemFrame:UpdateItemSlot(bag, slot)
	local itemSlot = self:GetItemSlot(bag, slot)
	if itemSlot then
		itemSlot:Update()
	end
end

function ItemFrame:GetItemSlot(bag, slot)
	return self.slots[ToIndex(bag, slot)]
end

function ItemFrame:GetAllItemSlots()
	return pairs(self.slots)
end

function ItemFrame:AddAllItemSlotsForBag(bag)
	for slot = 1, self:GetBagSize(bag) do
		self:AddItemSlot(bag, slot)
	end
end

function ItemFrame:RemoveAllItemSlotsForBag(bag)
	for slot = 1, self:GetBagSize(bag) do
		self:RemoveItemSlot(bag, slot)
	end
end

function ItemFrame:UpdateAllItemSlotsForBag(bag)
	for slot = 1, self:GetBagSize(bag) do
		self:UpdateItemSlot(bag, slot)
	end
end

function ItemFrame:ReloadAllItemSlots()
	for i, button in pairs(self.slots) do
		local used = self:IsBagShown(button:GetBag()) and (button:GetID() <= self:GetBagSize(button:GetBag()))
		if not used then
			button:Free()
			self.slots[i] = nil
			self:RequestLayout()
		end
	end

	for _, bag in self:GetVisibleBags() do
		for slot = 1, self:GetBagSize(bag) do
			local button = self:GetItemSlot(bag, slot)
			if not button then
				self:AddItemSlot(bag, slot)
			else
				button:Update()
			end
		end
	end
end


--[[ Layout Methods ]]--

function ItemFrame:Layout()
	self.needsLayout = nil

	if self.HasRowLayout then
		self:Layout_NoBag()
	elseif self:IsBagBreakEnabled() then
		self:Layout_BagBreak()
	else
		self:Layout_Default()
	end
end

function ItemFrame:Layout_Default()
	local columns = self:NumColumns()
	local spacing = self:GetSpacing()
	local effItemSize = self.ITEM_SIZE + spacing

	local i = 0
	for _, bag in self:GetVisibleBags() do
		local first, last, step = 1, self:GetBagSize(bag), 1
		if self:GetSettings():IsSlotOrderReversed() then
			first, last, step = last, 1, -1
		end

		for slot = first, last, step do
			local itemSlot = self:GetItemSlot(bag, slot)
			if itemSlot then
				i = i + 1
				local row = (i - 1) % columns
				local col = ceil(i / columns) - 1
				itemSlot:ClearAllPoints()
				itemSlot:SetPoint('TOPLEFT', self, 'TOPLEFT', effItemSize * row, -effItemSize * col)
			end
		end
	end

	local width = effItemSize * min(columns, i) - spacing
	local height = effItemSize * ceil(i / columns) - spacing
	self:SetSize(width, height)
end

function ItemFrame:Layout_BagBreak()
	local columns = self:NumColumns()
	local spacing = self:GetSpacing()
	local effItemSize = self.ITEM_SIZE + spacing

	local rows = 1
	local col = 1
	local maxCols = 0

	for _, bag in self:GetVisibleBags() do
		local bagSize = self:GetBagSize(bag)
		for slot = 1, bagSize do
			local itemSlot = self:GetItemSlot(bag, slot)

			itemSlot:ClearAllPoints()
			itemSlot:SetPoint('TOPLEFT', self, 'TOPLEFT', effItemSize * (col - 1), -effItemSize * (rows - 1))

			if col == columns then
				col = 1
				if slot < bagSize then
					rows = rows + 1
				end
			else
				col = col + 1
				maxCols = max(maxCols, col)
			end
		end

		rows = rows + 1
		col = 1
	end

	local width = effItemSize * maxCols - spacing*2
	local height = effItemSize * (rows - 1) - spacing*2
	self:SetSize(width, height)
end

function ItemFrame:Layout_NoBag()
	local numSlots = self:GetNumSlots()
	if numSlots == 0 then
		return
	end
	
	local numCol = min(self:NumColumns() - self.COLUMN_OFF, numSlots)
	local numRows = ceil(numSlots / numCol)
	
	local useRows = self:HasRowLayout()
	local limit = useRows and numCol or numRows
	
	local spacing = self:GetSpacing()
	local itemSize = self.ITEM_SIZE + spacing

	local a, b = 0, 0
	for i, slot in self:GetAllItemSlots() do
		if a == limit then
			a = 0
			b = b + 1
		end
	
		slot:ClearAllPoints()
		if useRows then
			slot:SetPoint('TOPLEFT', self, 'TOPLEFT', itemSize * a, -itemSize * b)
		else
			slot:SetPoint('TOPLEFT', self, 'TOPLEFT', itemSize * b, -itemSize * a)
		end
		
		a = a + 1
	end

	local width = itemSize * numCol - spacing
	local height = itemSize * numRows - spacing
	self:SetSize(width, height)
end


--request a layout update on this frame
function ItemFrame:RequestLayout()
	self.needsLayout = true
	self.throttledUpdater:Show()
end

--returns true if the frame should have its layout updated, and false otherwise
function ItemFrame:NeedsLayout()
	return self.needsLayout
end


--[[ Frame Properties ]]--

--frameID
function ItemFrame:SetFrameID(frameID)
	if self:GetFrameID() ~= frameID then
		self.frameID = frameID
		self:UpdateEverything()
	end
end

function ItemFrame:GetFrameID()
	return self.frameID
end

--frame settings
function ItemFrame:GetSettings()
	return Addon.FrameSettings:Get(self:GetFrameID())
end

--player info
function ItemFrame:GetPlayer()
	return self:GetSettings():GetPlayerFilter()
end

function ItemFrame:IsCached()
	return Cache:IsPlayerCached(self:GetPlayer())
end

--bag info
function ItemFrame:HasBag(bag)
	return self:GetSettings():HasBagSlot(slot)
end

function ItemFrame:GetBagSize(bag)
	return Addon:GetBagSize(self:GetPlayer(), bag)
end

function ItemFrame:IsBagShown(bag)
	return self:GetSettings():IsBagSlotShown(bag)
end

function ItemFrame:IsBagSlotCached(bag)
	return Addon:IsBagCached(self:GetPlayer(), bag)
end

function ItemFrame:GetVisibleBags()
	return self:GetSettings():GetVisibleBagSlots()
end

function ItemFrame:HasBankBags()
	for _, bag in self:GetVisibleBags() do
		if Addon:IsBank(bag) or Addon:IsBankBag(bag) then
			return true
		end
	end
	return false
end

--layout info
function ItemFrame:NumColumns()
	return self:GetSettings():GetItemFrameColumns()
end

function ItemFrame:GetSpacing()
	return self:GetSettings():GetItemFrameSpacing()
end

function ItemFrame:IsBagBreakEnabled()
	return self:GetSettings():IsBagBreakEnabled()
end
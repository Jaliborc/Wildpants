--[[
	events.lua
		Events for accessing and updating item information

	ITEM_ADD
	args:		bag, slot, link, count, locked, coolingDown
		called when a new slot becomes available to the player

	ITEM_REMOVE
	args:		bag, slot
		called when an item slot is removed from being in use

	ITEM_UPDATE
	args:		bag, slot, link, count, locked, coolingDown
		called when an item slot's item or item count changes

	ITEM_COOLDOWN_UPDATE
	args:		bag, slot, coolingDown
		called when an item's cooldown starts/ends

	ITEM_LOCK_UPDATE
	args:		bag, slot, locked
		called when an item's locked status changes

	BAG_UPDATE_TYPE
	args:		bag, type
		called when the type of a bag changes

	BANK_OPENED
	args:		none
		called when the bank has opened and all of the events have sent messages

	BANK_CLOSED
	args:		none
		called when the bank is closed and all of the events have sent messages
--]]


local _, Addon = ...
local Events = CreateFrame('Frame')

local slots = {}
local bagTypes = {}

local function ToIndex(bag, slot)
	return (bag < 0 and bag*100 - slot) or bag*100 + slot
end


--[[ Startup ]]--

function Events:OnLoad()
	self.atBank = false
	self.firstVisit = true
	self:SetScript('OnEvent', self.OnEvent)
	self:RegisterEvent('PLAYER_LOGIN')
end

function Events:OnEvent(event, ...)
	if self[event] then
		self[event](self, event, ...)
	end		
end


--[[ Events ]]--

function Events:PLAYER_LOGIN()
	self:RegisterEvent('BAG_UPDATE')
	self:RegisterEvent('BAG_UPDATE_COOLDOWN')
	self:RegisterEvent('PLAYERBANKSLOTS_CHANGED')
	self:RegisterEvent('PLAYERREAGENTBANKSLOTS_CHANGED')
	self:RegisterEvent('BANKFRAME_OPENED')
	self:RegisterEvent('BANKFRAME_CLOSED')

	self:UpdateBagSize(BACKPACK_CONTAINER)
	self:UpdateItems(BACKPACK_CONTAINER)
end

function Events:BAG_UPDATE(event, bag)
	self:UpdateBagTypes()
	self:UpdateBagSizes()
	self:UpdateItems(bag)
end

function Events:PLAYERBANKSLOTS_CHANGED()
	self:UpdateBagTypes()
	self:UpdateBagSizes()
	self:UpdateItems(BANK_CONTAINER)
end

function Events:PLAYERREAGENTBANKSLOTS_CHANGED()
	self:UpdateItems(REAGENTBANK_CONTAINER)
end

function Events:BANKFRAME_OPENED()
	self.atBank = true

	if self.firstVisit then
		self.firstVisit = nil

		self:UpdateBagSize(BANK_CONTAINER)
		self:UpdateBagSize(REAGENTBANK_CONTAINER)
		self:UpdateBagTypes()
		self:UpdateBagSizes()
	end

	Addon:SendMessage('BANK_OPENED')
end

function Events:BANKFRAME_CLOSED()
	self.atBank = false
	Addon:SendMessage('BANK_CLOSED')
end

function Events:BAG_UPDATE_COOLDOWN()
	self:UpdateCooldowns(BACKPACK_CONTAINER)
		
	for bag = 1, NUM_BAG_SLOTS do
		self:UpdateCooldowns(bag)
	end
end


--[[ Update Functions ]]--

--entire item
function Events:AddItem(bag, slot)
	local index = ToIndex(bag,slot)
	if not slots[index] then slots[index] = {} end

	local data = slots[index]
	local texture, count, locked, quality, readable, lootable, link = GetContainerItemInfo(bag, slot)
	local start, duration, enable = GetContainerItemCooldown(bag, slot)
	local onCooldown = (start > 0 and duration > 0 and enable > 0)

	data[1] = link
	data[2] = count
	data[3] = locked
	data[4] = onCooldown

	Addon:SendMessage('ITEM_SLOT_ADD', bag, slot, link, count, locked, onCooldown)
end

function Events:RemoveItem(bag, slot)
	local data = slots[ToIndex(bag, slot)]

	if data and next(data) then
		local prevLink = data[1]
		for i in pairs(data) do
			data[i] = nil
		end

		Addon:SendMessage('ITEM_SLOT_REMOVE', bag, slot, prevLink)
	end
end

function Events:UpdateItems(bag)
	for slot = 1, GetContainerNumSlots(bag) do
		self:UpdateItem(bag, slot)
	end
end

function Events:UpdateItem(bag, slot)
	local data = slots[ToIndex(bag, slot)]

	if data then
		local prevLink = data[1]
		local prevCount = data[2]

		local texture, count, locked, quality, readable, lootable, link = GetContainerItemInfo(bag, slot)
		local start, duration, enable = GetContainerItemCooldown(bag, slot)
		local onCooldown = (start > 0 and duration > 0 and enable > 0)

		if not(prevLink == link and prevCount == count) then
			data[1] = link
			data[2] = count
			data[3] = locked
			data[4] = onCooldown

			Addon:SendMessage('ITEM_SLOT_UPDATE', bag, slot, link, count, locked, onCooldown)
		end
	end
end


--cooldowns
function Events:UpdateCooldown(bag, slot)
	local data = slots[ToIndex(bag,slot)]

	if data and data[1] then
		local start, duration, enable = GetContainerItemCooldown(bag, slot)
		local onCooldown = (start > 0 and duration > 0 and enable > 0)

		if data[4] ~= onCooldown then
			data[4] = onCooldown
			Addon:SendMessage('ITEM_SLOT_UPDATE_COOLDOWN', bag, slot, onCooldown)
		end
	end
end

function Events:UpdateCooldowns(bag)
	for slot = 1, GetContainerNumSlots(bag) do
		self:UpdateCooldown(bag, slot)
	end
end

--bag sizes
function Events:UpdateBagSize(bag)
	local prevSize = slots[bag*100] or 0
	local newSize = GetContainerNumSlots(bag) or 0
	slots[bag*100] = newSize

	if prevSize > newSize then
		for slot = newSize+1, prevSize do
			self:RemoveItem(bag, slot)
		end
	elseif prevSize < newSize then
		for slot = prevSize+1, newSize do
			self:AddItem(bag, slot)
		end
	end
end

function Events:UpdateBagType(bag)
	local _, newType = GetContainerNumFreeSlots(bag)
	local prevType = bagTypes[bag]

	if newType ~= prevType then
		bagTypes[bag] = newType
		Addon:SendMessage('BAG_UPDATE_TYPE', bag, newType)
	end
end


function Events:UpdateBagSizes()
	if self.atBank then
		for bag = 1, NUM_BAG_SLOTS + GetNumBankSlots() do
			self:UpdateBagSize(bag)
		end
	else
		for bag = 1, NUM_BAG_SLOTS do
			self:UpdateBagSize(bag)
		end
	end
end

function Events:UpdateBagTypes()
	if self.atBank then
		for bag = 1, NUM_BAG_SLOTS + GetNumBankSlots() do
			self:UpdateBagType(bag)
		end
	else
		for bag = 1, NUM_BAG_SLOTS do
			self:UpdateBagType(bag)
		end
	end
end

Events:OnLoad()
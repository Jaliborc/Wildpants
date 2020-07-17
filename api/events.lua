--[[
	events.lua
		Custom ace item events for better performance

	BAG_UPDATE_SIZE
	args: bag
		called when the size of a bag changes, bag itself probably also has changed

	BAG_UPDATE_CONTENT
	args: bag
		called when the items of a bag change
--]]

local ADDON, Addon = ...
local Events = Addon:NewModule('Events')


--[[ Events ]]--

function Events:OnEnable()
	self.firstVisit = true
	self.sizes, self.types, self.queue = {}, {}, {}

	if REAGENTBANK_CONTAINER then
		self:RegisterEvent('PLAYERREAGENTBANKSLOTS_CHANGED')
		self:RegisterEvent('REAGENTBANK_PURCHASED', 'PLAYERREAGENTBANKSLOTS_CHANGED')
	end

	self:RegisterEvent('BAG_UPDATE')
	self:RegisterEvent('BAG_CLOSED', 'BAG_UPDATE')
	self:RegisterEvent('BAG_UPDATE_DELAYED')
	self:RegisterEvent('PLAYERBANKSLOTS_CHANGED')
	self:RegisterEvent('BANKFRAME_OPENED')
	self:UpdateBags()
end

function Events:BAG_UPDATE(event, bag)
	self.queue[bag] = true
end

function Events:BAG_UPDATE_DELAYED()
	for bag in pairs(self.queue) do
		self:UpdateBag(bag)
	end

	self.queue = {}
end

function Events:PLAYERBANKSLOTS_CHANGED()
	self:UpdateContent(BANK_CONTAINER)
end

function Events:PLAYERREAGENTBANKSLOTS_CHANGED()
	self:UpdateContent(REAGENTBANK_CONTAINER)
end

function Events:BANKFRAME_OPENED()
	if self.firstVisit then
		self.firstVisit = nil
		self:UpdateBankBags()
	end
end


--[[ API ]]--

function Events:UpdateBags()
	for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		self:UpdateBag(bag)
	end
end

function Events:UpdateBankBags()
	self:UpdateContent(BANK_CONTAINER)

	for bag = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
		self:UpdateBag(bag)
	end

	if REAGENTBANK_CONTAINER then
		self:UpdateContent(REAGENTBANK_CONTAINER)
	end
end

function Events:UpdateBag(bag)
	self:UpdateSize(bag)
	self:UpdateType(bag)
	self:UpdateContent(bag)
end

function Events:UpdateSize(bag)
	local old = self.sizes[bag]
	local new = GetContainerNumSlots(bag) or 0

	if old ~= new then
		self.sizes[bag] = new
		self:SendSignal('BAG_UPDATE_SIZE', bag)
		return true
	end

	return false
end

function Events:UpdateType(bag)
	self.types[bag] = select(2, GetContainerNumFreeSlots(bag))
end

function Events:UpdateContent(bag)
	self:SendSignal('BAG_UPDATE_CONTENT', bag)
end

--[[
	sort.lua
		Implements a client side bag sorting algorithm
--]]

local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-2.0')
local Sort = Addon:NewModule('Sort', 'AceEvent-3.0')

local ITEM_PROPS = {'class', 'subclass', 'quality', 'level', 'id', 'count'}

function Sort:Start(bags)
  self.spaces = {}
  self.sorted = {}

  for _, bag in ipairs(bags) do
    local numSlots = Cache:GetBagInfo(nil, bag).count
    for slot = 1, (numSlots or 0) do
      local item = Cache:GetItemInfo(nil, bag, slot)
      if item.id then
        local _,_,_, level, _,_,_,_,_,_,_, class, subclass = GetItemInfo(item.id)
        item.level = level
        item.class = class
        item.subclass = subclass
        tinsert(self.sorted, item)
      end

      tinsert(self.spaces, {bag = bag, slot = slot, item = item})
      item.position = #self.spaces
    end
  end

  sort(self.sorted, function(a, b)
    for _,prop in ipairs(ITEM_PROPS) do
      if a[prop] ~= b[prop] then
        return a[prop] > b[prop]
      end
    end
  end)

  self:Iteration(1)
end

function Sort:Iteration(index)
  for goal = index, #self.sorted do
    local item = self.sorted[goal]
    if item.position ~= goal then
      self:Swap(item.position, goal)

      if goal <= #self.sorted then
        self:RegisterEvent('BAG_UPDATE_DELAYED', 'Iteration', goal+1)
      else
        self:UnregisterEvent('BAG_UPDATE_DELAYED')
      end

      return
    end
  end
end

function Sort:Swap(a, b)
  local from = self.spaces[a]
  local to = self.spaces[b]

  PickupContainerItem(from.bag, from.slot)
  PickupContainerItem(to.bag, to.slot)

  local temp = from.item
  from.item = to.item
  from.item.position = a
  to.item = temp
  to.item.position = b
end

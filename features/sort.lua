--[[
	sort.lua
		Implements a client side bag sorting algorithm
--]]

local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-2.0')
local Sort = Addon:NewModule('Sort', 'AceEvent-3.0')

local ITEM_PROPS = {'class', 'subclass', 'quality', 'level', 'name', 'id', 'count'}


--[[ Startup ]]--

function Sort:Start(bags)
  self:ComputeDomain(bags)
  self:Stacking(1)
end

function Sort:ComputeDomain(bags)
  self.spaces = {}

  for _, bag in ipairs(bags) do
    local numSlots = Cache:GetBagInfo(nil, bag).count
    for slot = 1, (numSlots or 0) do
      local item = Cache:GetItemInfo(nil, bag, slot)
      if item.id then
        local name,_,_, level, _,_,_, stack,_,_,_, class, subclass = GetItemInfo(item.id)
        item.name, item.level, item.stack, item.class, item.subclass = name, level, stack, class, subclass
      end

      tinsert(self.spaces, {bag = bag, slot = slot, item = item})
      item.position = #self.spaces
    end
  end
end

function Sort:ComputeOrder()
  self.sorted = {}

  for _, space in pairs(self.spaces) do
    if space.item.id then
      tinsert(self.sorted, space.item)
    end
  end

  sort(self.sorted, function(a, b)
    for _,prop in ipairs(ITEM_PROPS) do
      if a[prop] ~= b[prop] then
        return a[prop] > b[prop]
      end
    end
    return a.position < b.position
  end)
end


--[[ Steps ]]--

function Sort:Stacking(progress)
  for target = progress, #self.spaces do
    local item = self.spaces[target].item
    if item.id and item.count < item.stack then
      for other = target+1, #self.spaces do
        local extra = self.spaces[other].item
        if item.id == extra.id and extra.count < extra.stack then
          self:Move(other, target)
          self:RegisterEvent('BAG_UPDATE_DELAYED', 'Stacking', target)

          return
        end
      end
    end
  end

  self:ComputeOrder()
  self:Ordering(1)
end

function Sort:Ordering(progress)
  for goal = progress, #self.sorted do
    local item = self.sorted[goal]
    if item.position ~= goal then
      self:Move(item.position, goal)
      self:RegisterEvent('BAG_UPDATE_DELAYED', 'Ordering', goal+1)

      return
    end
  end

  self:UnregisterEvent('BAG_UPDATE_DELAYED')
end


--[[ Movements ]]--

function Sort:Move(a, b)
  local from, to = self.spaces[a], self.spaces[b]
  if from.item.id ~= to.item.id then
    self:Swap(a, b)
  else
    self:Stack(a, b)
  end

  PickupContainerItem(from.bag, from.slot)
  PickupContainerItem(to.bag, to.slot)
end

function Sort:Swap(a, b)
  local from, to = self.spaces[a], self.spaces[b]
  local temp = from.item

  from.item = to.item
  from.item.position = a
  to.item = temp
  to.item.position = b
end

function Sort:Stack(a, b)
  local from, to = self.spaces[a], self.spaces[b]
  local moved = min(to.item.stack - to.item.count, from.item.count)

  from.item.count = from.item.count - moved
  to.item.count = to.item.count + moved

  if from.item.count <= 0 then
    from.item.id = nil
  end
end

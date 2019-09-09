--[[
	sort.lua
		Implements a client side bag sorting algorithm
--]]

local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-2.0')
local Sort = Addon:NewModule('Sort', 'AceEvent-3.0')

local ITEM_PROPRIETIES = {'class', 'subclass', 'quality', 'level', 'name', 'id', 'count'}


--[[ Process ]]--

function Sort:Start(bags)
  self.bags = bags
  self:Stacking()
end

function Sort:Stacking()
  local spaces = self:ComputeSpaces()

  for target, space in pairs(spaces) do
    local item = space.item
    if item.id and item.count < item.stack then
      for other = target+1, #spaces do
        local extra = spaces[other].item
        if item.id == extra.id and extra.count < extra.stack then
          self:Move(spaces, other, target)
          self:RegisterEvent('BAG_UPDATE_DELAYED', 'Stacking')

          return
        end
      end
    end
  end

  self:Ordering()
end

function Sort:Ordering()
  local spaces = self:ComputeSpaces()
  local order = self:ComputeOrder(spaces)

  for goal, item in pairs(order) do
    if item.position ~= goal then
      self:Move(spaces, item.position, goal)
      self:RegisterEvent('BAG_UPDATE_DELAYED', 'Ordering')

      return
    end
  end

  self:UnregisterEvent('BAG_UPDATE_DELAYED')
end


--[[ API ]]--

function Sort:ComputeSpaces()
  local spaces = {}

  for _, bag in ipairs(self.bags) do
    local container = Cache:GetBagInfo(nil, bag)
    local family = GetItemFamily(container.id) or 0

    for slot = 1, (container.count or 0) do
      local item = Cache:GetItemInfo(nil, bag, slot)
      if item.id then
        local name,_,_, level, _,_,_, stack,_,_,_, class, subclass = GetItemInfo(item.id)
        item.name, item.level, item.stack, item.class, item.subclass = name, level, stack, class, subclass
      end

      tinsert(spaces, {bag = bag, slot = slot, family = family, item = item})
      item.position = #spaces
    end
  end

  return spaces
end

function Sort:ComputeOrder(spaces)
  local order = {}
  for _, space in pairs(spaces) do
    if space.item.id then
      tinsert(order, space.item)
    end
  end

  sort(order, function(a, b)
    for _,prop in ipairs(ITEM_PROPRIETIES) do
      if a[prop] ~= b[prop] then
        return a[prop] > b[prop]
      end
    end
    return a.position < b.position
  end)

  return order
end

function Sort:Move(spaces, a, b)
  Cache:PickupItem(nil, spaces[a].bag, spaces[a].slot)
  Cache:PickupItem(nil, spaces[b].bag, spaces[b].slot)
end

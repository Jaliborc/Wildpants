--[[
	sorting.lua
		Method for a client side bag sorting algorithm
--]]

local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-2.0')
local Search = LibStub('LibItemSearch-1.2')
local Sort = Addon:NewClass('Sorting')

Sort.Proprieties = {
  'class', 'subclass', 'equip',
  'quality',
  'icon',
  'level', 'name', 'id',
  'count'
}


--[[ Process ]]--

function Sort:Start(owner, bags, event)
  if InCombatLockdown() or UnitIsDead('player') or GetCursorInfo() then
    return
  end

  self.owner, self.bags, self.event = owner, bags, event
  self:RegisterEvent('PLAYER_REGEN_DISABLED', 'Stop')
  self:SendSignal('SORTING_STATUS', owner, bags)
  self:Stacking()
end

function Sort:Stop()
  self:SendSignal('SORTING_STATUS')
  self:UnregisterAllEvents()
end

function Sort:Stacking()
  local spaces = self:GetSpaces()

  for k, target in pairs(spaces) do
    local item = target.item
    if item.id and (item.count or 1) < item.stack then
      for j = k+1, #spaces do
        local from = spaces[j]
        local other = from.item

        if item.id == other.id and (other.count or 1) < other.stack then
          self:Move(from, target)
          self:RegisterEvent(self.event, function() self:After(0.01, 'Stacking') end)

          return
        end
      end
    end
  end

  self:Ordering()
end

function Sort:Ordering()
  local spaces = self:GetSpaces()
  local families = self:GetFamilies(spaces)

  for _, family in pairs(families) do
    local spaces, order = self:GetOrder(spaces, family)

    for index = 1, min(#spaces, #order) do
      local goal, item = spaces[index], order[index]
      if item.space ~= goal then
        self:Move(item.space, goal)
        self:RegisterEvent(self.event, function() self:After(0.01, 'Ordering') end)

        return
      else
        item.placed = true
      end
    end
  end

  self:Stop()
end


--[[ Data Structures ]]--

function Sort:GetSpaces()
  local spaces = {}

  for _, bag in pairs(self.bags) do
    local container = Cache:GetBagInfo(self.owner, bag)
    local family = GetItemFamily(container.id) or 0

    for slot = 1, (container.count or 0) do
      local item = Cache:GetItemInfo(self.owner, bag, slot)
      if item.link then
        local name,_,_, level, _,_,_, stack, equip,_,_, class, subclass = GetItemInfo(item.link)

        item.name, item.level, item.stack, item.equip, item.subclass = name, level, stack, equip, subclass
        item.class = Search:ForQuest(item.link) and LE_ITEM_CLASS_QUESTITEM or class
        item.icon = GetItemIcon(item.id)
      end

      tinsert(spaces, {index = #spaces, bag = bag, slot = slot, family = family, item = item})
      item.space = spaces[#spaces]
    end
  end

  return spaces
end

function Sort:GetFamilies(spaces)
  local families = {}
  for _, space in pairs(spaces) do
    families[space.family] = true
  end

  local sorted = {}
  for family in pairs(families) do
    tinsert(sorted, family)
  end

  sort(sorted, function(a, b) return a > b end)
  return sorted
end

function Sort:GetOrder(spaces, family)
  local slots, order = {}, {}

  for _, space in pairs(spaces) do
    local item = space.item
    if item.id and not item.placed and self:FitsIn(item.id, family) then
      tinsert(order, space.item)
    end

    if space.family == family then
      tinsert(slots, space)
    end
  end

  sort(order, self.Rule)
  return slots, order
end


--[[ API ]]--

function Sort:FitsIn(id, family)
  return
    family == 0 or
    (Addon.IsRetail and bit.band(GetItemFamily(id), family) > 0 or GetItemFamily(id) == family) and
    select(9, GetItemInfo(id)) ~= 'INVTYPE_BAG'
end

function Sort.Rule(a, b)
  for _,prop in pairs(Sort.Proprieties) do
    if a[prop] ~= b[prop] then
      return a[prop] > b[prop]
    end
  end

  return a.space.index < b.space.index
end

function Sort:Move(from, to)
  Cache:PickupItem(self.owner, from.bag, from.slot)
  Cache:PickupItem(self.owner, to.bag, to.slot)
end

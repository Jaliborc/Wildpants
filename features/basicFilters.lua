--[[
	basicFilters.lua
		Basic item filters based on item classes
--]]


local ADDON, Addon = ...

local Normal = VOICE_CHAT_NORMAL
local Reagents = MINIMAP_TRACKING_VENDOR_REAGENT
local Equipment = BAG_FILTER_EQUIPMENT
local Weapon = GetItemClassInfo(LE_ITEM_CLASS_WEAPON)
local Armor = GetItemClassInfo(LE_ITEM_CLASS_ARMOR)
local Trinket = INVTYPE_TRINKET
local Container = GetItemClassInfo(LE_ITEM_CLASS_CONTAINER)
local Consumable = GetItemClassInfo(LE_ITEM_CLASS_CONSUMABLE)
local ItemEnhance = GetItemClassInfo(LE_ITEM_CLASS_ITEM_ENHANCEMENT)
local TradeGoods = GetItemClassInfo(LE_ITEM_CLASS_TRADEGOODS)
local Recipe = GetItemClassInfo(LE_ITEM_CLASS_RECIPE)
local Gem = GetItemClassInfo(LE_ITEM_CLASS_GEM)
local Glyph = GetItemClassInfo(LE_ITEM_CLASS_GLYPH)
local Quest = GetItemClassInfo(LE_ITEM_CLASS_QUESTITEM)
local Misc = GetItemClassInfo(LE_ITEM_CLASS_MISCELLANEOUS)

local function ClassFilter(id, name, icon, classes)
	local filter = function(item)
		if item then
			local _,_,_,_,_, itemclass = GetItemInfo(item)
			for i, class in ipairs(classes) do
				if itemclass == class then
					return true
				end
			end
		end
	end

	Addon.Filters:New(id, name, icon, filter)
	Addon.Filters:New(id..'/all', ALL, nil, filter)
end

local function ClassSubfilter(id, class)
	Addon.Filters:New(id, class, nil, function(item)
		if item then
			local _,_,_,_,_, itemclass = GetItemInfo(item)
			return itemclass == class
		end
	end)
end


--[[ Bag Types ]]--

Addon.Filters:New('all', ALL, 'Interface/Icons/INV_Misc_EngGizmos_17')
Addon.Filters:New('all/all', ALL)
Addon.Filters:New('all/normal', Normal, nil, function(_,_, bag) return bag == 0 end)
Addon.Filters:New('all/trade', TRADE, nil, function(_,_, bag) return bag > 0 end)
Addon.Filters:New('all/reagent', Reagents, nil, function(_,_, bag) return bag == -1 end)


--[[ Simple Categories ]]--

ClassFilter('contain', Container, 'Interface/Icons/inv_misc_bag_29', {Container})
ClassFilter('quest', Quest, 'Interface/QuestFrame/UI-QuestLog-BookIcon', {Quest})
ClassFilter('misc', Misc, 'Interface/Icons/INV_Misc_Rune_01', {Misc})

ClassFilter('use', USABLE_ITEMS, 'Interface/Icons/INV_Potion_93', {Consumable, ItemEnhance})
ClassSubfilter('use/consume', Consumable)
ClassSubfilter('use/enhance', ItemEnhance)

ClassFilter('trade', TRADE, 'Interface/Icons/INV_Fabric_Silk_02', {TradeGoods, Recipe, Gem, Glyph})
ClassSubfilter('trade/goods', TradeGoods)
ClassSubfilter('trade/recipe', Recipe)
ClassSubfilter('trade/gem', Gem)
ClassSubfilter('trade/glyph', Glyph)


--[[ Equipment ]]--

ClassFilter('equip', Equipment, 'Interface/Icons/INV_Chest_Chain_04', {Armor, Weapon})
ClassSubfilter('equip/weapon', Weapon)

Addon.Filters:New('equip/armor', Armor, nil, function(item)
	if item then
		local _,_,_,_,_, class, _, equipSlot = GetItemInfo(item)
		return class == Armor and equipSlot ~= 'INVTYPE_TRINKET'
	end
end)

Addon.Filters:New('equip/trinket', Trinket, nil, function(item)
	if item then
		local _,_,_,_,_,_,_, equipSlot = GetItemInfo(item)
		return equipSlot == 'INVTYPE_TRINKET'
	end
end)
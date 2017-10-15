--[[
	tooltipCounts.lua
		Adds item counts to tooltips
]]--

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)

local SILVER = '|cffc7c7cf%s|r'
local HEARTHSTONE = tostring(HEARTHSTONE_ITEM_ID)
local TOTAL = SILVER:format(L.Total)

local Cache = LibStub('LibItemCache-2.0')
local ItemText, ItemCount, Hooked = {}, {}


--[[ Adding Text ]]--

local function FormatCounts(color, ...)
	local places = 0
	local total = 0
	local text = ''

	for i = 1, select('#', ...) - (Addon.sets.countGuild and 1 or 0) do
		local count = select(i, ...)
		if count > 0 then
			text = text .. L.TipDelimiter .. L['TipCount' .. i]:format(count)
			total = total + count
			places = places + 1
		end
	end

	text = text:sub(#L.TipDelimiter + 1)
	if places > 1 then
		text = color:format(total) .. ' ' .. SILVER:format('('.. text .. ')')
	else
		text = color:format(text)
	end

	return total, total > 0 and text
end

local function AddOwners(tooltip, link)
	if not Addon.sets.tipCount or tooltip.__tamedCounts then
		return
	end

	local id = link and GetItemInfo(link) and link:match('item:(%d+)') -- Blizzard doing craziness when doing GetItemInfo
	if not id or id == HEARTHSTONE then
		return
	end

	local players = 0
	local total = 0

	for name in Cache:IterateOwners() do
		local player = Cache:GetOwnerInfo(name)
		local color = Addon:GetPlayerColorString(player)
		local countText = ItemText[name][id]
		local count = ItemCount[name][id]

		if countText == nil then
			--count, countText = FormatCounts(color, Cache:GetItemCounts(player, id))

			if player.cached then
				ItemText[name][id] = countText or false
				ItemCount[name][id] = count
			end
		end

		if countText then
			tooltip:AddDoubleLine(color:format(player), countText)
			total = total + count
			players = players + 1
		end
	end

	if players > 1 and total > 0 then
		tooltip:AddDoubleLine(TOTAL, SILVER:format(total))
	end

	tooltip.__tamedCounts = true
	tooltip:Show()
end


--[[ Hooking ]]--

local function OnItem(tooltip)
	local name, link = tooltip:GetItem()
	if name ~= '' then -- Blizzard broke tooltip:GetItem() in 6.2
		AddOwners(tooltip, link)
	end
end

local function OnTradeSkill(tooltip, recipe, reagent)
    if reagent then
        AddOwners(tooltip, C_TradeSkillUI.GetRecipeReagentItemLink(recipe, reagent))
    else
        AddOwners(tooltip, C_TradeSkillUI.GetRecipeItemLink(recipe))
    end
end

local function OnQuest(tooltip, type, quest)
	AddOwners(tooltip, GetQuestItemLink(type, quest))
end

local function OnClear(tooltip)
	tooltip.__tamedCounts = false
end

local function HookTip(tooltip)
	tooltip:HookScript('OnTooltipCleared', OnClear)
	tooltip:HookScript('OnTooltipSetItem', OnItem)

  hooksecurefunc(tooltip, 'SetRecipeReagentItem', OnTradeSkill)
  hooksecurefunc(tooltip, 'SetRecipeResultItem', OnTradeSkill)
	hooksecurefunc(tooltip, 'SetQuestItem', OnQuest)
	hooksecurefunc(tooltip, 'SetQuestLogItem', OnQuest)
end


--[[ Public Methods ]]--

function Addon:HookTooltips()
	if self:HasMultiplePlayers() and self.sets.tipCount then
		if not Hooked then
			for owner in Cache:IterateOwners() do
				ItemCount[owner] = {}
				ItemText[owner] = {}
			end

			HookTip(GameTooltip)
			HookTip(ItemRefTooltip)
			Hooked = true
		end
	end
end

--[[
	sortButton.lua
		A style agnostic item sorting button
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local SortButton = Addon:NewClass('SortButton', 'CheckButton')


--[[ Constructor ]]--

function SortButton:New(parent)
	local b = self:Bind(CreateFrame('CheckButton', nil, parent, ADDON .. self.Name .. 'Template'))
	b:RegisterSignal('SORTING_STATUS')
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:RegisterForClicks('anyUp')

	return b
end

function SortButton:SORTING_STATUS(_,_, bags)
	self:SetChecked(self:GetParent().Bags == bags)
end


--[[ Interaction ]]--

function SortButton:OnClick(button)
	if button == 'RightButton' and DepositReagentBank then
		return DepositReagentBank()
	end

	local frame = self:GetParent()
	if not frame:IsCached() then
		frame:SortItems()
	end
end

function SortButton:OnEnter()
	GameTooltip:SetOwner(self, self:GetRight() > (GetScreenWidth() / 2) and 'ANCHOR_LEFT' or 'ANCHOR_RIGHT')

	--[[if self:GetParent():IsBank() then
		GameTooltip:SetText(L.TipManageBank)
		GameTooltip:AddLine(L.TipDepositReagents, 1,1,1)
		GameTooltip:AddLine(L.TipCleanBank, 1,1,1)
	else
		GameTooltip:SetText(L.TipCleanBags)
 	end]]--

	GameTooltip:SetText(L.TipCleanBags)
	GameTooltip:Show()
end

function SortButton:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end

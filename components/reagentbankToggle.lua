--[[
	reagentbankToggle.lua
		A style agnostic reagent bank toggle button
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local ReagentbankToggle = Addon:NewClass('ReagentbankToggle', 'CheckButton')


--[[ Constructor ]]--

function ReagentbankToggle:New(parent)
	local b = self:Bind(CreateFrame('CheckButton', nil, parent, ADDON .. self.Name .. 'Template'))
	b:SetScript('OnHide', b.UnregisterSignals)
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:SetScript('OnShow', b.OnShow)
	b:RegisterForClicks('anyUp')
	b:Update()

	return b
end


--[[ Events ]]--

function ReagentbankToggle:OnShow()
	self:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	self:RegisterEvent('REAGENTBANK_PURCHASED', 'Update')
	self:Update()
end

function ReagentbankToggle:OnClick(button)
	if button == 'LeftButton' then
		local reagentBagButton = _G[(ADDON .. "Bag" .. REAGENTBANK_CONTAINER)]
		reagentBagButton:Click(button)
		self:Update()
	else
		DepositReagentBank()
	end
end

function ReagentbankToggle:OnEnter()
	local reagentBagButton = _G[(ADDON .. "Bag" .. REAGENTBANK_CONTAINER)]
	reagentBagButton:SetFocus(true)

	GameTooltip:SetOwner(self, self:GetRight() > (GetScreenWidth() / 2) and 'ANCHOR_LEFT' or 'ANCHOR_RIGHT')
	GameTooltip:SetText(REAGENT_BANK, 1, 1, 1)
	if reagentBagButton:IsPurchasable() then
		GameTooltip:AddLine(L.TipPurchaseBag)
		SetTooltipMoney(GameTooltip, reagentBagButton:GetCost())
	else
		GameTooltip:AddLine(reagentBagButton:IsHidden() and L.TipShowBag or L.TipHideBag)
		GameTooltip:AddLine(L.TipDepositReagents, 1,1,1)
	end

	GameTooltip:Show()
end

function ReagentbankToggle:OnLeave()
	local reagentBagButton = _G[(ADDON .. "Bag" .. REAGENTBANK_CONTAINER)]
	reagentBagButton:SetFocus(false)

	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end


--[[ API ]]--

function ReagentbankToggle:OpenFrame(id, addon, owner)
	if not addon or LoadAddOn(addon) then
		Addon:CreateFrame(id):SetOwner(owner or self:GetOwner())
		Addon:ShowFrame(id)
	end
end

function ReagentbankToggle:Update()
	self:SetChecked(self:IsReagentbagShown())

	local reagentBagButton = _G[(ADDON .. "Bag" .. REAGENTBANK_CONTAINER)]
	-- Unfortunately, LibItemCache-2.0 does not yet allow to check 'owned' status of cached bags.
	-- So we assume cached bags as owned like the rest of Bagnon does.
	if reagentBagButton and reagentBagButton:IsPurchasable() then
		self.BagnonReagentbankToggleTexture:SetVertexColor(1,0.1,0.1)
	else
		self.BagnonReagentbankToggleTexture:SetVertexColor(1,1,1)
	end
end

function ReagentbankToggle:IsReagentbagShown()
	local profile = self:GetProfile()
	return not profile.hiddenBags[REAGENTBANK_CONTAINER]
end

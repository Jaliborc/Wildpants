--[[
	currencyDisplay.lua
		Shows tracked currencies
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local MoneyFrame = Addon.Tipped:NewClass('CurrencyDisplay', 'Button')


--[[ Construct ]]--

function MoneyFrame:New(parent)
	local f = self:Super(MoneyFrame):New(parent)
  local text = f:CreateFontString()
  text:SetFontObject('NumberFontNormalRight')
  text:SetPoint('RIGHT', -8,-1)
  f.Text = text

  f:SetScript('OnShow', f.RegisterEvents)
  f:SetScript('OnHide', f.UnregisterAll)
  f:SetScript('OnClick', f.OnClick)
  f:SetScript('OnEnter', f.OnEnter)
  f:SetScript('OnLeave', f.OnLeave)
  f:RegisterEvents()
  f:SetHeight(24)

  hooksecurefunc(C_CurrencyInfo, 'SetCurrencyBackpack', function()
    if f:IsVisible() then
        f:Update()
    end
  end)
	return f
end

function MoneyFrame:RegisterEvents()
	self:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	self:RegisterEvent('CURRENCY_DISPLAY_UPDATE', 'Update')
	self:Update()
end

function MoneyFrame:Update()
  local v = ''
  for i=1, MAX_WATCHED_TOKENS do
    local data = C_CurrencyInfo.GetBackpackCurrencyInfo(i)
    if data then
      v = v .. data.quantity .. '|T' .. data.iconFileID .. ':15:15:2:0|t  '
    end
  end

  self.Text:SetText(v)
	local width = self.Text:GetStringWidth()
  self:SetWidth(width > 2 and (width + 16) or 2)
end


--[[ Interaction ]]--

function MoneyFrame:OnClick()
	if not self:IsCached() then
    ToggleCharacter('TokenFrame')
	end
end

function MoneyFrame:OnEnter()
end

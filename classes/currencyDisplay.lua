--[[
	currencyDisplay.lua
		Shows tracked currencies
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local CurrencyDisplay = Addon.Parented:NewClass('CurrencyDisplay', 'Frame')

if BackpackTokenFrame then
	for _,k in ipairs {'SetCurrencyBackpack', 'GetBackpackCurrencyInfo', 'GetCurrencyLink'} do
		C_CurrencyInfo[k] = C_CurrencyInfo[k] or _G[k]
	end

	function BackpackTokenFrame:GetMaxTokensWatched()
		return 30
	end
end


--[[ Construct ]]--

function CurrencyDisplay:New(parent)
	local f = self:Super(CurrencyDisplay):New(parent)
	f.Buttons = {}
	f:SetScript('OnShow', f.RegisterEvents)
	f:SetScript('OnHide', f.UnregisterAll)
	f:RegisterEvents()
  f:SetHeight(24)

  hooksecurefunc(C_CurrencyInfo, 'SetCurrencyBackpack', function()
    if f:IsVisible() then
        f:Update()
    end
  end)
	return f
end

function CurrencyDisplay:RegisterEvents()
	self:RegisterEvent('CURRENCY_DISPLAY_UPDATE', 'Update')
	self:RegisterFrameSignal('OWNER_CHANGED', 'Layout')
	self:Layout()
end


--[[ Update ]]--

function CurrencyDisplay:Update()
	self:Layout()
	self:SendFrameSignal('ELEMENT_RESIZED')
end

function CurrencyDisplay:Layout()
	for _,button in ipairs(self.Buttons) do
		button:Hide()
	end

	local w = 0
	for i = 1, BackpackTokenFrame:GetMaxTokensWatched() do -- safety limit
    local data = C_CurrencyInfo.GetBackpackCurrencyInfo(i)
    if data then
			self.Buttons[i] = self.Buttons[i] or Addon.Currency(self)
			self.Buttons[i]:SetPoint('LEFT', self.Buttons[i-1] or self, i > 1 and 'RIGHT' or 'LEFT')
			self.Buttons[i]:Set(data)

			w = w + self.Buttons[i]:GetWidth()
		else
			break
    end
  end

	self:SetWidth(max(w, 2))
end

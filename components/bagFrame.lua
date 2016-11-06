--[[
	bagFrame.lua
		A container frame for bags
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local BagFrame = Addon:NewClass('BagFrame', 'Frame')
BagFrame.Button = Addon.Bag

function BagFrame:New(parent, from, x, y)
	local f = self:Bind(CreateFrame('Frame', nil, parent))
	local button, k

	for i, bag in ipairs(parent.Bags) do
		k = i-1
		button = f.Button:New(f, bag)
		button:SetPoint(from, x*k, y*k)
	end

	f:SetSize(k * x + button:GetWidth(), k * y + button:GetHeight())
	return f
end
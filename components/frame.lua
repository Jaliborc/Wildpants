--[[
	frame.lua
		Base useful functionality for any frame object
--]]


local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Frame = Addon:NewClass('Frame', 'Frame')
Frame.OpenSound = 'igBackPackOpen'
Frame.CloseSound = 'igBackPackClose'


--[[ Visibility ]]--

function Frame:UpdateShown()
	if self:IsFrameShown() then
		self:Show()
	else
		self:Hide()
	end
end

function Frame:ShowFrame()
	self.shownCount = self.shownCount + 1
	self:Show()
end

function Frame:HideFrame(force) -- if a frame was manually opened, then it should only be closable manually
	self.shownCount = self.shownCount - 1

	if force or self.shownCount <= 0 then
		self.shownCount = 0
		self:Hide()
	end
end

function Frame:IsFrameShown()
	return self.shownCount > 0
end


--[[ Frame Events ]]--

function Frame:OnShow()
	PlaySound(self.OpenSound)
	self:RegisterMessages()
	self:Update()
end

function Frame:OnHide()
	PlaySound(self.CloseSound)
	self:UnregisterMessages()

	if self:IsFrameShown() then
		self:HideFrame()
	end

	if Addon.sets.resetPlayer then
		self.player = nil
	end
end


--[[ Shared ]]--

function Frame:GetProfile()
	return Addon:GetProfile(self.player)[self.frameID]
end

function Frame:IsCached()
	return Addon:IsBagCached(self.player, self.Bags[1])
end

function Frame:GetPlayer()
	return self.player or UnitName('player')
end

function Frame:GetFrameID()
	return self.frameID
end

function Frame:IsBank()
	return false
end
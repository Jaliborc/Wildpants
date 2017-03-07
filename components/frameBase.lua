--[[
	frameBase.lua
		Useful methods to implement frame objects.
--]]


local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Frame = Addon:NewClass('Frame', 'Frame')
Frame.OpenSound = 'igBackPackOpen'
Frame.CloseSound = 'igBackPackClose'


--[[ Frame Events ]]--

function Frame:OnShow()
	PlaySound(self.OpenSound)
	self:RegisterMessages()
end

function Frame:OnHide()
	PlaySound(self.CloseSound)
	self:UnregisterMessages()

	if Addon.sets.resetPlayer then
		self.player = nil
	end
end


--[[ Settings ]]--

function Frame:UpdateSettings()
	self:ClearAllPoints()
	self:SetPoint(self:GetPosition())
	self:SetAlpha(self.profile.alpha)
	self:SetScale(self.profile.scale)
end

function Frame:RecomputePosition()
	local x, y = self:GetCenter()
	if x and y then
		local scale = self:GetScale()
		local h = UIParent:GetHeight() / scale
		local w = UIParent:GetWidth() / scale
		local xPoint, yPoint

		if x > w/2 then
			x = self:GetRight() - w
			xPoint = 'RIGHT'
		else
			x = self:GetLeft()
			xPoint = 'LEFT'
		end

		if y > h/2 then
			y = self:GetTop() - h
			yPoint = 'TOP'
		else
			y = self:GetBottom()
			yPoint = 'BOTTOM'
		end

		self:SetPosition(yPoint..xPoint, x, y)
	end
end

function Frame:SetPosition(point, x, y)
	self.profile.x, self.profile.y = x, y
	self.profile.point = point
end

function Frame:GetPosition()
	return self.profile.point, self.profile.x, self.profile.y
end


--[[ Shared ]]--

function Frame:IsShowingBag(bag)
	return not self:GetProfile().hiddenBags[bag]
end

function Frame:IsBank()
	return false
end

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
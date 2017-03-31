--[[
	classes.lua
		Base class used by all UI components and custom event broadcast system
--]]

local ADDON, Addon = ...
local CreateClass = LibStub('Poncho-1.0')
local Base = CreateClass()

LibStub('AceAddon-3.0'):NewAddon(Addon, ADDON, 'AceEvent-3.0')
Addon.SendCall = LibStub('CallbackHandler-1.0'):New(Addon, 'RegisterCall', 'UnregisterCall', 'UnregisterCalls').Fire
Addon.Cache = LibStub('LibItemCache-1.1')

function Addon:NewClass(name, type, xml, parent)
	local class = CreateClass(type, ADDON .. className, nil, xml, parent or Base)
	self[name] = class
	return class
end


--[[ Base Methods ]]--

function Base:UnregisterEvents()
	self:UnregisterAllEvents()
	self:UnregisterCalls()
end

function Base:RegisterFrameCall (msg, ...)
	self:RegisterCall(self:GetFrameID() .. msg, ...)
end

function Base:UnregisterFrameCall (msg, ...)
	self:UnregisterCall(self:GetFrameID() .. msg, ...)
end

function Base:SendFrameCall (msg, ...)
	self:SendCall(self:GetFrameID() .. msg, ...)
end

function Base:GetFrameID ()
	local frame = self:GetFrame()
	return frame and frame.frameID
end

function Base:GetProfile ()
	local frame = self:GetFrame()
	return frame and frame:GetProfile()
end

function Base:GetPlayer ()
	local frame = self:GetFrame()
	return frame and frame:GetPlayer()
end

function Base:IsCached ()
	local frame = self:GetFrame()
	return frame and frame:IsCached()
end

function Base:GetFrame ()
	if not self.frame then -- loop of doom, do only once
		local parent = self:GetParent()
		while parent and not parent.frameID do
			parent = parent:GetParent()
		end

		self.frame = parent
	end
	return self.frame
end

Base.SendCall = Addon.SendCall
Base.RegisterCall = Addon.RegisterCall
Base.UnregisterCall = Addon.UnregisterCall
Base.UnregisterCalls = Addon.UnregisterCalls

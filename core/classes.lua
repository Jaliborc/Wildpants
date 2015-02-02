--[[
	classes.lua
		Utility method for constructing object classes
--]]

local _, Addon = ...
Addon.SendMessage = LibStub('CallbackHandler-1.0'):New(Addon, 'RegisterMessage', 'UnregisterMessage', 'UnregisterAllMessages').Fire

function Addon:NewClass(name, type, parent)
	local class = CreateFrame(type)
	class.__index = class
	class.Name = name
  	class:Hide()
  
	if parent then
		class = setmetatable(class, parent)
		class.super = parent
	else
		class.Bind = function(self, obj)
			return setmetatable(obj, self)
		end

		class.GetSettings = function(self)
			local parent = self:GetParent()
			return parent and parent.GetSettings and parent:GetSettings()
		end

		class.GetProfile = function(self)
			local parent = self:GetParent()
			return parent and parent.GetProfile and parent:GetProfile()
		end

		class.GetPlayer = function(self)
			local parent = self:GetParent()
			return parent and parent.GetPlayer and parent:GetPlayer()
		end

		class.GetFrameID = function(self)
			local parent = self:GetParent()
			return parent and parent.GetFrameID and parent:GetFrameID()
		end

		class.RegisterMessage = Addon.RegisterMessage
		class.SendMessage = Addon.SendMessage
		class.UnregisterMessage = Addon.UnregisterMessage
		class.UnregisterAllMessages = Addon.UnregisterAllMessages
	end

	self[name] = class
	return class
end
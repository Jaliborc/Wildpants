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
			return self:GetFrame():GetSettings()
		end

		class.GetProfile = function(self)
			return self:GetFrame():GetProfile()
		end

		class.GetPlayer = function(self)
			return self:GetFrame():GetPlayer()
		end

		class.GetFrameID = function(self)
			return self:GetFrame():GetFrameID()
		end

		class.GetFrame = function(self)
			local parent = self:GetParent()
			while parent and not parent.frameID do
				parent = parent:GetParent()
			end

			return parent
		end

		class.RegisterMessage = Addon.RegisterMessage
		class.SendMessage = Addon.SendMessage
		class.UnregisterMessage = Addon.UnregisterMessage
		class.UnregisterAllMessages = Addon.UnregisterAllMessages
	end

	self[name] = class
	return class
end
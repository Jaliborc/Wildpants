--[[
	classes.lua
		Utility method for constructing object classes
--]]

local _, Addon = ...

function Addon:NewClass(name, type, parent)
	local class = CreateFrame(type)
	class.mt = {__index = class}
	class.Name = name
  	class:Hide()
  
	if parent then
		class = setmetatable(class, {__index = parent})
		class.super = parent
	end

	class.Bind = function(self, obj)
		return setmetatable(obj, self.mt)
	end

	class.GetSettings = function(self)
		local parent = self:GetParent()
		return parent and parent.GetSettings and parent:GetSettings()
	end

	class.GetPlayer = function(self)
		local parent = self:GetParent()
		return parent and parent.GetPlayer and parent:GetPlayer()
	end

	class.RegisterMessage = Addon.RegisterMessage
	class.SendMessage = Addon.SendMessage
	class.UnregisterMessage = Addon.UnregisterMessage
	class.UnregisterAllMessages = Addon.UnregisterAllMessages

	self[name] = class
	return class
end
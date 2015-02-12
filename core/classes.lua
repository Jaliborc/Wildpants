--[[
	classes.lua
		Utility method for constructing object classes and messaging between them
--]]

local ADDON, Addon = ...
local Mixins = {'RegisterEvent', 'UnregisterEvent', 'UnregisterEvents', 'RegisterMessage', 'UnregisterMessage', 'UnregisterMessages', 'SendMessage'}
local Messages = {}

LibStub('AceAddon-3.0'):NewAddon(Addon, ADDON, 'AceEvent-3.0', 'AceConsole-3.0')
Addon.SendMessage = LibStub('CallbackHandler-1.0'):New(Messages, 'RegisterMessage', 'UnregisterMessage', 'UnregisterMessages').Fire -- we only send internal messages

for key, func in pairs(Messages) do
	Addon[key] = func
end


--[[ API ]]--

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

		for i, func in ipairs(Mixins) do
			class[func] = self[func]
		end
	end

	self[name] = class
	return class
end

function Addon:UnregisterEvents()
	Addon.UnregisterAllEvents(self)
	Addon.UnregisterMessages(self)
end
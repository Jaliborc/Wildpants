--[[
	rules.lua
		Methods for creating and browsing item rulesets.
		See ??? for details.
--]]


local ADDON, Addon = ...
local Rules = Addon:NewClass('Rules', 'Frame')
Rules.registry = {}


--[[ Public API ]]--

function Rules:New(id, name, icon, func)
	assert(type(id) == 'string', 'Unique ID must be a string')

	local parent, id = self:SplitID(id)
	local registry = self.registry

	if parent then
		parent = self:Get(parent)
		assert(parent, 'Specified parent item ruleset is not know')
		registry = parent.children
	end

	local rule = registry[id] or {children = {}}
	rule.name = name or id
	rule.icon = icon
	rule.func = func
	registry[id] = rule

	self:SetScript('OnUpdate', self.BroadcastAddition)
end

function Rules:Get(id)
	if type(id) == 'string' then
		local parent, id = self:SplitID(id)
		if parent then
			parent = self:Get(parent)
			return parent and parent.children[id]
		else
			return self.registry[id]
		end
	end
end

function Rules:Iterate()
	return pairs(self.registry)
end


--[[ Additional Methods ]]--

function Rules:SplitID(id)
	local parent, child = id:match('^(.+)/(.-)$')
	if parent then
		return parent, child
	else
		return nil, id
	end
end

function Rules:BroadcastAddition()
	self:SetScript('OnUpdate', nil)
	self:SendMessage('RULES_LOADED')
end
--[[
	frames.lua
		Methods for managing frame creation and display
--]]

local ADDON, Addon = ...
Addon.frames = {}


--[[ Frame Control ]]--

function Addon:UpdateFrames()
	self:SendMessage('UPDATE_ALL')
end

function Addon:ToggleFrame(id)
	if self:IsFrameShown(id) then
		return self:HideFrame(id, true)
	else
		return self:ShowFrame(id)
	end
end

function Addon:ShowFrame(id)
	local frame = self:CreateFrame(id)
	if frame then
		frame:ShowFrame()
	end
	return frame
end

function Addon:HideFrame(id, force)
	local frame = self:GetFrame(id)
	if frame then
		frame:HideFrame(force)
	end
	return frame
end

function Addon:IsFrameShown(id)
	local frame = self:GetFrame(id)
	return frame and frame:IsShown()
end

function Addon:CreateFrame(id)
	if self:IsFrameEnabled(id) then
 		self.frames[id] = self.frames[id] or self[id:gsub('^.', id.upper) .. 'Frame']:New(id)
 		return self.frames[id]
 	end
end

function Addon:CreateFrameLoader(module, method)
	local addon = ADDON .. '_' .. module
	if GetAddOnEnableState(UnitName('player'), addon) >= 2 then
		_G[method] = function()
			if LoadAddOn(addon) then
				self:GetModule(module):OnOpen()
			end
		end
	end
end

function Addon:AreBasicFramesEnabled()
	return self:IsFrameEnabled('inventory') and self:IsFrameEnabled('bank')
end

function Addon:IsFrameEnabled(id)
	return self.profile[id].enabled
end

function Addon:GetFrame(id)
	return self.frames[id]
end

function Addon:IterateFrames()
	return pairs(self.frames)
end


--[[ Bag's Frame Control ]]--

function Addon:ToggleBag(frame, bag)
	if self:IsBagControlled(frame, bag) then
		return self:ToggleFrame(frame)
	end
end

function Addon:ShowBag(frame, bag)
	if self:IsBagControlled(frame, bag) then
		return self:ShowFrame(frame)
	end
end

function Addon:IsBagControlled(frame, bag)
	return not Addon.sets.displayBlizzard or self:IsFrameEnabled(frame) and not self.profile[frame].hiddenBags[bag]
end

function Addon:IsBagShown(frame, bag)
	local hidden = frame:GetProfile().hiddenBags
	if not frame:GetProfile().exclusiveReagent or bag == REAGENTBANK_CONTAINER or hidden[REAGENTBANK_CONTAINER] then
		return not hidden[bag]
	end
end
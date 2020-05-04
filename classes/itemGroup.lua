--[[
	itemGroup.lua
		An item slot container template
--]]

local ADDON, Addon = ...
local Items = Addon.Parented:NewClass('ItemGroup', 'Frame')
Items.Button = Addon.Item


--[[ Construct ]]--

function Items:New(parent, bags)
	local f = self:Super(Items):New(parent)
	f.buttons, f.order = {}, {}
	f.bags = {}

	for i, bag in ipairs(bags) do
		f.bags[i] = CreateFrame('Frame', nil, f)
		f.bags[i]:SetID(tonumber(bag) or 1)
		f.bags[i].id = bag
	end

	f:SetScript('OnHide', f.UnregisterAll)
	f:SetScript('OnShow', f.Update)
	f:SetSize(1,1)
	f:Update()
	return f
end

function Items:Update()
	self:RegisterEvents()
	self:RequestLayout()
end


--[[ Events ]]--

function Items:RegisterEvents()
	self:UnregisterAll()
	self:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	self:RegisterFrameSignal('FILTERS_CHANGED', 'RequestLayout')
	self:RegisterSignal('UPDATE_ALL', 'RequestLayout')
	self:RegisterEvent('GET_ITEM_INFO_RECEIVED')

	if not self:IsCached() then
		self:RegisterSignal('BAG_UPDATE_SIZE')
		self:RegisterSignal('BAG_UPDATE_CONTENT')
		self:RegisterEvent('UNIT_QUEST_LOG_CHANGED')
		self:RegisterEvent('ITEM_LOCK_CHANGED')

		self:RegisterEvent('UNIT_INVENTORY_CHANGED', 'ForAll', 'UpdateUpgradeIcon')
		self:RegisterEvent('BAG_UPDATE_COOLDOWN', 'ForAll', 'UpdateCooldown')
		self:RegisterEvent('BAG_NEW_ITEMS_UPDATED', 'ForAll', 'UpdateBorder')
		self:RegisterEvent('QUEST_ACCEPTED', 'ForAll', 'UpdateBorder')

		if C_EquipmentSet then
			self:RegisterEvent('EQUIPMENT_SETS_CHANGED', 'ForAll', 'UpdateBorder')
		end
		if C_SpecializationInfo then
			self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED', 'ForAll', 'UpdateUpgradeIcon')
		end
	else
		self:RegisterMessage('CACHE_BANK_OPENED', 'RegisterEvents')
	end
end

function Items:BAG_UPDATE_SIZE(_, bag)
	for i, frame in ipairs(self.bags) do
		if frame.id == bag then
			return self:RequestLayout()
		end
	end
end

function Items:BAG_UPDATE_CONTENT(_, bag)
	self:ForBag(bag, 'Update')
end

function Items:ITEM_LOCK_CHANGED(_, bag, slot)
	if not self:Delaying('Layout') then
		bag = self.buttons[bag]
		slot = bag and bag[slot]
		if slot then
			slot:UpdateLocked()
		end
	end
end

function Items:GET_ITEM_INFO_RECEIVED(_,itemID)
	if not self:Delaying('Layout') then
		for i, button in ipairs(self.order) do
			if button.info.id == itemID then
				button:Update()
			end
		end
	end
end

function Items:UNIT_QUEST_LOG_CHANGED(_,unit)
	if unit == 'player' then
		self:ForAll('UpdateBorder')
	end
end


--[[ Management ]]--

function Items:RequestLayout()
	self:Delay(0.01, 'Layout')
end

function Items:Layout()
	self:ForAll('Release')
	self.buttons, self.order = {}, {}

	-- Acquire slots
	for i, frame in ipairs(self.bags) do
		local bag = frame.id
		if self:IsShowingBag(bag) then
			local numSlots = self:NumSlots(bag)
			for slot = 1, numSlots do
				if self:IsShowingItem(bag, slot) then
					local button = self.Button(frame, bag, slot)
					self.buttons[bag] = self.buttons[bag] or {}
					self.buttons[bag][slot] = button
					tinsert(self.order, button)
				end
			end
		end
	end

	-- Position slots
	local profile = self:GetProfile()
	local columns, scale = self:LayoutTraits()
	local size = self:GetButtonSize()

	local revBags, revSlots = profile.reverseBags, profile.reverseSlots
	local x, y = 0,0

    -- Calculate Offset
    totalSlots = 0
    if (self.frame.frameID == "bank") then
        local bankstart = (BACKPACK_CONTAINER + NUM_BAG_SLOTS + 1)
        if not profile.hiddenBags[REAGENTBANK_CONTAINER] and profile.exclusiveReagent then
            totalSlots = 0
        else
            totalSlots = self:NumSlots(BANK_CONTAINER)
            for j = bankstart, bankstart - 1 + NUM_BANKBAGSLOTS do
                if(profile.hiddenBags[j] ~= true) then
                    totalSlots = totalSlots + self:NumSlots(j)
                end
            end
        end
        if REAGENTBANK_CONTAINER and not profile.hiddenBags[REAGENTBANK_CONTAINER] then
            totalSlots = totalSlots + self:NumSlots(REAGENTBANK_CONTAINER)
        end
    elseif (self.frame.frameID == "inventory") then
        for j = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
            if (profile.hiddenBags[j] ~= true) then
                totalSlots = totalSlots + self:NumSlots(j)
            end
        end
    end
    local offset = self:calcOffset(columns,totalSlots)

    -- This should set the offset when all bags are displayed without breaks
    if profile.emptyOnTop and not self:BagBreak() then
        x = offset
    end

	for k = revBags and #self.bags or 1, revBags and 1 or #self.bags, revBags and -1 or 1 do
		local bag = self.bags[k].id
		local slots = self.buttons[bag]

        -- This should set the offset for each bag individually when displayed with breaks
        -- I need better documentation on what this one does vs the below 
        if profile.emptyOnTop and self:BagBreak() then
            x = self:calcOffset(columns,self:NumSlots(k-1))
        end

		if slots then
			local numSlots = self:NumSlots(bag)
			for slot = revSlots and numSlots or 1, revSlots and 1 or numSlots, revSlots and -1 or 1 do
				local button = slots[slot]
				if button then
					if x == columns then
						y = y + 1
						x = 0
					end

					button:ClearAllPoints()
					button:SetPoint('TOPLEFT', self, 'TOPLEFT', size * (self.Transposed and y or x), -size * (self.Transposed and x or y))
					button:SetScale(scale)

					x = x + 1
				end
			end

			if self:BagBreak() and x > 0 then
				y = y + 1
                -- This should set the offset for each bag individually when displayed with breaks
                -- I need better documentation on what this one does vs the above
                if profile.emptyOnTop then
                    x = self:calcOffset(columns,self:NumSlots(k-1))
                else
                    x = 0
                end
			end
		end
	end

	-- Resize frame
	if x > 0 then
		y = y + 1
	end

	local width, height = max(columns * size * scale, 1), max(y * size * scale, 1)
	self:SetSize(self.Transposed and height or width, self.Transposed and width or height)
	self:SendFrameSignal('ITEM_FRAME_RESIZED')
end

-- This function calculates what the offset should be to put the blanks before the slots
function Items:calcOffset(columns,slots)
    local offset = columns - (slots % columns) 
    if (offset == columns) then
        return 0
    else
        return offset
    end
end

function Items:ForAll(method, ...)
	if not self:Delaying('Layout') then
		for i, button in ipairs(self.order) do
			button[method](button, ...)
		end
	end
end

function Items:ForBag(bag, method, ...)
	if self:CanUpdate(bag) then
		for slot, button in pairs(self.buttons[bag]) do
			button[method](button, ...)
		end
	end
end

function Items:CanUpdate(bag)
	return not self:Delaying('Layout') and self.buttons[bag]
end


--[[ Proprieties ]]--

function Items:IsShowingItem(bag, slot)
	return self:GetFrame():IsShowingItem(bag, slot)
end

function Items:IsShowingBag(bag)
	return self:GetFrame():IsShowingBag(bag)
end

function Items:NumSlots(bag)
	local info = Addon:GetBagInfo(self:GetOwner(), bag)
	return info.owned and info.count or 0
end

function Items:NumButtons()
	return #self.order
end

function Items:GetButtonSize()
	return 37 + self:GetProfile().spacing
end

function Items:BagBreak()
	return self:GetProfile().bagBreak
end

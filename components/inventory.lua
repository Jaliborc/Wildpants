--[[
	inventory.lua
		A specialized version of the standard frame for the inventory
--]]

local ADDON, Addon = ...
local Frame = Addon:NewClass('InventoryFrame', 'Frame', Addon.Frame)
Frame.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBags
Frame.Bags = {BACKPACK_CONTAINER, 1, 2, 3, 4}

local function setChecked(itemSlot, checked)
	if checked then
		itemSlot.SlotHighlightTexture:Show()
	else
		itemSlot.SlotHighlightTexture:Hide()
	end
end

function Frame:OnShow()
	Addon.Frame.OnShow(self)
	self:CheckBagButtons(true)
end

function Frame:OnHide()
	Addon.Frame.OnHide(self)
	self:CheckBagButtons(false)
end

function Frame:CheckBagButtons(checked)
	setChecked(MainMenuBarBackpackButton, checked)
	setChecked(CharacterBag0Slot, checked)
	setChecked(CharacterBag1Slot, checked)
	setChecked(CharacterBag2Slot, checked)
	setChecked(CharacterBag3Slot, checked)
end
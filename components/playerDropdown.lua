--[[
  playerDropdown.lua
	A player selector dropdown
--]]

local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-2.0')
local CurrentFrame
local Dropdown

local function SetPlayer(self)
	CurrentFrame:SetOwner(self.value)
	CloseDropDownMenus()
end

local function DeletePlayer(self)
	for i, frame in Addon:IterateFrames() do
		if self.value == frame:GetOwner() then
			frame.owner = nil
			frame:SendFrameMessage('OWNER_CHANGED')
		end
	end

	--Cache:DeleteOwner(self.value)
	CloseDropDownMenus()
end

local function ListPlayer(name)
	local owner = Cache:GetOwnerInfo(name)
	if not owner.isguild then
		UIDropDownMenu_AddButton {
			text = format('|T%s:14:14:-3:0|t', Addon:GetCharacterIcon(owner)) .. Addon:GetCharacterColorString(owner):format(name),
	    checked = name == CurrentFrame:GetOwner(),
			hasArrow = owner.cached,
			func = SetPlayer,
			value = name
		}
	end
end

local function UpdateDropdown(self, level)
	if level == 2 then
		UIDropDownMenu_AddButton({
			text = REMOVE,
			notCheckable = true,
			value = UIDROPDOWNMENU_MENU_VALUE,
			func = DeletePlayer
		}, 2)
	else
		ListPlayer(UnitName('player'))

		for name in Cache:IterateOwners() do
			if name ~= UnitName('player') then
				ListPlayer(name)
		  end
		end
	end
end

local function Startup()
	Dropdown = CreateFrame('Frame', 'BagnonPlayerDropdown', UIParent, 'UIDropDownMenuTemplate')
  Dropdown.initialize = UpdateDropdown
  Dropdown.displayMode = 'MENU'
  Dropdown:SetID(1)

	return Dropdown
end


--[[ Public Method ]]--

function Addon:TogglePlayerDropdown(anchor, frame, offX, offY)
	if self:MultipleOwnersFound() then
		CurrentFrame = frame
		ToggleDropDownMenu(1, nil, Dropdown or Startup(), anchor, offX, offY)
	end
end

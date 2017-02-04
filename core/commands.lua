--[[
	commands.lua
		Sets up slash commands and keybindings
--]]


local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)


--[[ Keybindings ]]--

do
	local ADDON_UPPER = ADDON:upper()
	_G['BINDING_HEADER_' .. ADDON_UPPER] = ADDON
	_G['BINDING_NAME_' .. ADDON_UPPER .. '_TOGGLE'] = L.ToggleBags
	_G['BINDING_NAME_' .. ADDON_UPPER .. '_BANK_TOGGLE'] = L.ToggleBank
	_G['BINDING_NAME_' .. ADDON_UPPER .. '_VAULT_TOGGLE'] = L.ToggleVault
	_G['BINDING_NAME_' .. ADDON_UPPER .. '_GUILD_TOGGLE'] = L.ToggleGuild
end


--[[ Slash Commands ]]--

function Addon:AddSlashCommands(...)
	for i = 1, select('#', ...) do
		self:RegisterChatCommand(select(i, ...), 'HandleSlashCommand')
	end
end

function Addon:HandleSlashCommand(cmd)
	cmd = cmd and cmd:lower() or ''
	
	if cmd == 'bank' then
		self:ToggleFrame('bank')
	elseif cmd == 'bags' or cmd == 'inventory' then
		self:ToggleFrame('inventory')
	elseif cmd == 'guild' and LoadAddOn(ADDON .. '_GuildBank')then
		self:ToggleFrame('guild')
	elseif cmd == 'vault' and LoadAddOn(ADDON .. '_VoidStorage') then
		self:ToggleFrame('vault')
	elseif cmd == 'version' then
		self:Print(GetAddOnMetadata(ADDON, 'Version'))
	elseif cmd == '?' or cmd == 'help' or not self:ShowOptions() and cmd ~= 'config' and cmd ~= 'options' then
		self:PrintHelp()
	end
end

function Addon:PrintHelp()
	local function PrintCmd(cmd, desc, addon)
		if not addon or GetAddOnEnableState(UnitName('player'), addon) >= 2 then
			print(format(' - |cFF33FF99%s|r: %s', cmd, desc))
		end
	end

	self:Print(L.Commands)
	PrintCmd('bags', L.CmdShowInventory)
	PrintCmd('bank', L.CmdShowBank)
	PrintCmd('guild', L.CmdShowGuild, ADDON .. '_GuildBank')
	PrintCmd('vault', L.CmdShowVault,  ADDON .. '_VoidStorage')
	PrintCmd('version', L.CmdShowVersion)
end
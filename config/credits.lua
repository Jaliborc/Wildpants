--[[
	display.lua
		Automatic display settings menu
--]]

local CONFIG = ...
local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]
local PATRONS = {{title='Jenkins',people={'Gnare'}},{},{title='Ambassador',people={'Fernando Bandeira','Julia F','Lolari ','Owen Pitcairn','Rafael Lins','Mediocre Monk','Joanie Nelson','David A. Smith','Nitro '}}} -- generated patron list

local Credits = LibStub('Sushi-3.1').CreditsGroup(Addon.GeneralOptions, PATRONS, 'Patrons |TInterface/Addons/Bagnon/common/Wildpants/libs/Sushi-3.1/art/Patreon:13:13:0:0:64:64:10:54:10:54|t')
Credits:SetSubtitle(ADDON .. ' is distributed for free and supported trough donations. These are the people currently supporting development. Become a patron too |cFFF96854@patreon/jaliborc|r.', 'http://www.patreon.com/jaliborc')
Credits:SetFooter('By João Cardoso and Jason Greer')

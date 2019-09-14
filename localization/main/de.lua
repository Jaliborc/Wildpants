--[[
	German Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'deDE')
if not L then return end

--keybindings
L.ToggleBags = 'Inventar umschalten'
L.ToggleBank = 'Bank umschalten'
L.ToggleGuild = 'Gildenbank umschalten'
L.ToggleVault = 'Leerenlager umschalten'

--terminal
L.Commands = 'Befehlsliste'
L.CmdShowInventory = 'Schaltet das Inventar um'
L.CmdShowBank = 'Schaltet die Bank um'
L.CmdShowGuild = 'Schaltet die Gildenbank um'
L.CmdShowVault = 'Schaltet das Leerenlager um'
L.CmdShowVersion = 'Zeigt die aktuelle Version an'
L.Updated = 'Aktualisiert auf v%s'

--frames
L.TitleBags = 'Inventar von %s'
L.TitleBank = 'Bank von %s'
L.TitleVault = 'Leerenlager von %s'

--interactions
L.Click = 'Click'
L.Drag = '<Ziehen>'
L.LeftClick = '<Klicken>'
L.RightClick = '<Rechtsklick>'
L.DoubleClick = '<Doppelklick>'
L.ShiftClick = '<Shift-Klick>'

--tooltips
L.TipChangePlayer = 'um die Gegenst\195\164nde anderer Charaktere anzuzeigen.'
L.TipCleanBags = 'um die Taschen aufräumen.'
L.TipCleanBank = 'um die Bank aufzuräumen.'
L.TipDepositReagents = 'um alle Reagenzien einzulagern.'
L.TipFrameToggle = 'um andere Fenster umzuschalten.'
L.TipGoldOnRealm = 'Auf %s gesamt'
L.TipHideBag = 'um diese Tasche zu verstecken.'
L.TipHideBags = 'um die Taschenanzeige zu verstecken.'
L.TipHideSearch = 'um das Suchfenster zu verstecken.'
L.PurchaseBag = 'um das Bankfach zu kaufen.'
L.TipResetPlayer = 'um auf den aktuellen Charakter zurücksetzen.'
L.TipShowBag = 'um diese Taschen anzuzeigen.'
L.TipShowBags = 'um das Taschenfenster anzuzeigen.'
L.TipShowMenu = 'um das Fenster zu konfigurieren.'
L.TipShowSearch = 'zum Suchen.'
L.TipShowFrameConfig = 'um dieses Fenster zu konfigurieren.'
L.Total = 'Gesamt'

--itemcount tooltips
L.TipCount1 = 'Angelegt: %d'
L.TipCount2 = 'Taschen: %d'
L.TipCount3 = 'Bank: %d'
L.TipCount4 = 'Leerenlager: %d'
L.TipDelimiter = '|'

--databroker plugin tooltips
L.TipShowBank = 'um die Bank umzuschalten'
L.TipShowInventory = 'um das Inventar umzuschalten'
L.TipShowOptions = 'um das Konfigurationsmen\195\188 anzuzeigen'

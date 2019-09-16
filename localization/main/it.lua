--[[
	Italian Localization
]]--

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'itIT')
if not L then return end

--keybindings
L.ToggleBags = "Attiva l'Inventario"
L.ToggleBank = 'Attiva la Banca'
L.ToggleVault = 'Attiva la Banca Eterea'

--terminal
L.Commands = 'Comandi:'
L.CmdShowInventory = 'Mostra il tuo Inventario'
L.CmdShowBank = 'Mostra la tua Banca'
L.CmdShowVersion = 'Mostra la versione attuale'
L.Updated = 'Aggiornato alla v%s'

--frame titles
L.TitleBags = 'Inventario di %s'
L.TitleBank = 'Banca di %s'

--interactions
L.Click = 'Clicca'
L.Drag = '<Trascina>'
L.LeftClick = '<Clic Sinistro>'
L.RightClick = '<Clic Destro>'
L.DoubleClick = '<Doppio Clic>'
L.ShiftClick = '<Shift+Clic>'

--tooltips
L.TipBags = 'Borse'
L.TipChangePlayer = 'per vedere gli oggetti di un altro personaggio.'
L.TipCleanBags = 'per mettere in ordine le borse.'
L.TipCleanBank = 'per mettere in ordine la Banca.'
L.TipDepositReagents = 'per depositare tutti i reagenti.'
L.TipFrameToggle = "per attivare un'altra finestra."
L.TipGoldOnRealm = 'Totali di %s'
L.TipHideBag = 'per nascondere questa borsa.'
L.TipHideBags = 'per nascondere il riquadro delle borse.'
L.TipHideSearch = 'per nascondere la barra di ricerca.'
L.TipManageBank = 'Gestisci Banca'
L.PurchaseBag = 'per comprare questo spazio di Banca.'
L.TipShowBag = 'per mostrare questa borsa.'
L.TipShowBags = 'per mostrare il riquadro delle borse.'
L.TipShowMenu = 'per configurare questa finestra.'
L.TipShowSearch = 'per cercare.'
L.TipShowFrameConfig = 'per configurare questa finestra.'
L.TipMove = 'per muovere.'
L.Total = 'Totali'

--itemcount tooltips
L.TipCount1 = 'Equipaggiati: %d'
L.TipCount2 = 'Borse: %d'
L.TipCount3 = 'Banca: %d'
L.TipCount4 = 'Banca Eterea: %d'
L.TipDelimiter = '|'

--databroker tooltips
L.TipShowBank = 'per mostrare la Banca.'
L.TipShowInventory = 'per mostrare il tuo Inventario.'
L.TipShowOptions = 'per mostrare le opzioni del menù.'

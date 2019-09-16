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
L.TipChangePlayer = '%s per vedere gli oggetti di un altro personaggio.'
L.TipCleanBags = '%s per mettere in ordine le borse.'
L.TipCleanBank = '%s per mettere in ordine la Banca.'
L.TipDepositReagents = '%s per depositare tutti i reagenti.'
L.TipFrameToggle = "per attivare un'altra finestra."
L.TipGoldOnRealm = 'Totali di %s'
L.TipHideBag = '%s per nascondere questa borsa.'
L.TipHideBags = '%s per nascondere il riquadro delle borse.'
L.TipHideSearch = '%s per nascondere la barra di ricerca.'
L.TipManageBank = 'Gestisci Banca'
L.PurchaseBag = '%s per comprare questo spazio di Banca.'
L.TipShowBag = '%s per mostrare questa borsa.'
L.TipShowBags = '%s per mostrare il riquadro delle borse.'
L.TipShowMenu = '%s per configurare questa finestra.'
L.TipShowSearch = '%s per cercare.'
L.TipShowFrameConfig = '%s per configurare questa finestra.'
L.TipMove = '%s per muovere.'
L.Total = 'Totali'

--itemcount tooltips
L.TipCount1 = 'Equipaggiati: %d'
L.TipCount2 = 'Borse: %d'
L.TipCount3 = 'Banca: %d'
L.TipCount4 = 'Banca Eterea: %d'
L.TipDelimiter = '|'

--databroker tooltips
L.TipShowBank = '%s per mostrare la Banca.'
L.TipShowInventory = '%s per mostrare il tuo Inventario.'
L.TipShowOptions = '%s per mostrare le opzioni del menù.'

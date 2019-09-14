--[[
    Spanish Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'esES') or LibStub('AceLocale-3.0'):NewLocale(ADDON, 'esMX')
if not L then return end

--keybindings
L.ToggleBags = 'Abrir mochila'
L.ToggleBank = 'Abrir banco'

--terminal
L.Commands = 'Comandos:'
L.CmdShowInventory = 'Abre la mochila'
L.CmdShowBank = 'Abre la banco'
L.CmdShowVersion = 'Muestra la versión actual'

--frame titles
L.TitleBags = 'Mochila de %s'
L.TitleBank = 'Banco de %s'

--interactions
L.Click = 'Clic'
L.Drag = '<Arrastra>'
L.LeftClick = '<Clic Izquierdo>'
L.RightClick = '<Clic Derecho>'
L.DoubleClick = '<Doble Clic>'
L.ShiftClick = '<Shift+Clic>'

--tooltips
L.TipBags = 'Mochila'
L.TipBank = 'Banco'
L.TipBankToggle = 'para abrir el banco.'
L.TipChangePlayer = 'para ver los objetos de tus personajes.'
L.TipGoldOnRealm = 'Total en %s'
L.TipHideBag = 'para ocultar la bolsa.'
L.TipHideBags = 'para ocultar las bolsas.'
L.TipHideSearch = 'para ocultar el campo de búsqueda.'
L.TipInventoryToggle = 'para abrir la mochila.'
L.PurchaseBag = 'para comprar una ranura en el banco.'
L.TipResetPlayer = 'para volver al personaje actual.'
L.TipShowBag = 'para mostrar la bolsa.'
L.TipShowBags = 'para mostrar las bolsas.'
L.TipShowMenu = 'para configurar esta ventana.'
L.TipShowSearch = 'para buscar.'
L.TipShowFrameConfig = 'para configurar esta ventana.'
L.ToggleVault = 'Abrir depósito del vacío'
L.TipCleanBags = 'para limpiar las bolsas.'
L.TipCleanBank = 'para limpiar el banco.'
L.TipDepositReagents = 'para depositar todos los componentes.'
L.TipFrameToggle = 'para abrir/ocultar otras ventanas.'
L.TipShowBank = 'para abrir el banco.'
L.TipShowInventory = 'para abrir la mochila.'
L.TipShowOptions = 'para abrir el menú de opciones.'

--itemcount tooltips
L.TipCount1 = 'Equipado: %d'
L.TipCount2 = 'Mochila: %d'
L.TipCount3 = 'Banco: %d'
L.TipCount4 = 'Cámara: %d'

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
--L.TipBags = 'Mochila'
--L.TipBank = 'Banco'
L.TipBankToggle = '%s para abrir el banco.'
L.TipChangePlayer = '%s para ver los objetos de tus personajes.'
L.TipCleanItems = '%s para limpiar objetos.'
L.TipGoldOnRealm = 'Total en %s'
L.TipHideBag = '%s para ocultar la bolsa.'
L.TipHideBags = '%s para ocultar las bolsas.'
L.TipHideSearch = '%s para ocultar el campo de búsqueda.'
L.TipInventoryToggle = '%s para abrir la mochila.'
L.PurchaseBag = '%s para comprar una ranura en el banco.'
L.TipResetPlayer = '%s para volver al personaje actual.'
L.TipShowBag = '%s para mostrar la bolsa.'
L.TipShowBags = '%s para mostrar las bolsas.'
L.TipShowMenu = '%s para configurar esta ventana.'
L.TipShowSearch = '%s para buscar.'
L.TipShowFrameConfig = '%s para configurar esta ventana.'
L.ToggleVault = 'Abrir depósito del vacío'
L.TipCleanBags = '%s para limpiar las bolsas.'
L.TipCleanBank = '%s para limpiar el banco.'
L.TipDepositReagents = '%s para depositar todos los componentes.'
L.TipFrameToggle = '%s para abrir/ocultar otras ventanas.'
L.TipShowBank = '%s para abrir el banco.'
L.TipShowInventory = '%s para abrir la mochila.'
L.TipShowOptions = '%s para abrir el menú de opciones.'

--itemcount tooltips
L.TipCountEquip = 'Equipado: %d'
L.TipCountBags = 'Bolsas: %d'
L.TipCountBank = 'Banco: %d'
L.TipCountVault = 'Cámara: %d'
L.TipCountGuild = 'Hermandad: %d'
L.TipDelimiter = '|'

--dialogs
L.ConfirmTransfer = 'Depositar estos objetos eliminará todas las modificaciones y las hará no intercambiables y no reembolsables.|n|n¿Desea continuar?'
L.PurchaseVault = '¿Desea desbloquear el servicio de almacenamiento vacío?|n|n|cffffd200Costo:|r %s'
L.CannotPurchaseVault = 'No tiene suficiente dinero para desbloquear el servicio de almacenamiento vacío|n|n|cffff2020Costo: %s|r'
L.AskMafia = 'Pregunta a la Mafia'

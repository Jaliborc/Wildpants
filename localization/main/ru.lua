--[[
	Russian Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'ruRU')
if not L then return end

--keybindings
L.ToggleBags = 'Переключить инвентарь'
L.ToggleBank = 'Переключить банк'
L.ToggleVault = 'Переключить Хранилище Бездны'

--terminal
L.Commands = 'Команды:'
L.CmdShowInventory = 'Открыть/закрыть инвентарь'
L.CmdShowBank = 'Открыть/закрыть банк'
L.CmdShowVersion = 'Сообщить текущую версию модификации'
L.Updated = 'Обновлено до v%s'

--frame titles
L.TitleBags = 'Инвентарь |3-1(%s)'
L.TitleBank = 'Банк |3-1(%s)'

--interactions
L.Click = 'Клик'
L.Drag = '<Двигать>'
L.LeftClick = '<Левый-клик>'
L.RightClick = '<Правый-клик>'
L.DoubleClick = '<Двойной-клик>'
L.ShiftClick = '<Shift-Клик>'

--tooltips
L.TipBags = 'Сумки'
L.TipBank = 'Банк'
L.TipChangePlayer = '%s просмотр предметов другого персонажа.'
L.TipGoldOnRealm = 'Всего денег на %s'
L.TipHideBag = '%s скрыть эту сумку.'
L.TipHideBags = '%s скрыть область сумок.'
L.TipHideSearch = '%s скрыть область поиска.'
L.TipFrameToggle = '%s переключить другие окна.'
L.PurchaseBag = '%s купить банковскую ячейку.'
L.TipShowBag = '%s показать эту сумку.'
L.TipShowBags = '%s показать область сумок.'
L.TipShowMenu = '%s настроить это окно.'
L.TipShowSearch = '%s поиск.'
L.TipShowFrameConfig = '%s настроить это окно.'
L.Total = 'Всего'

--itemcount tooltips
L.TipCountEquip = 'Надето: %d'
L.TipCountBags = 'Сумки: %d'
L.TipCountBank = 'Банк: %d'
L.TipCountVault = 'Бездна: %d'
L.TipCountGuild = 'Гильдия: %d'
L.TipDelimiter = '|'

--databroker tooltips
L.TipShowBank = '%s переключить ваш банк.'
L.TipShowInventory = '%s переключить инвентарь.'
L.TipShowOptions = '%s открыть меню опций.'

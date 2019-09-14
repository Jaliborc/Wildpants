--[[
	Brasilian Portuguese Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'ptBR')
if not L then return end

--keybindings
L.ToggleBags = 'Abrir mochila'
L.ToggleBank = 'Abrir banco'

--terminal
L.Commands = 'Commandos:'
L.CmdShowInventory = 'Abre a sua mochila'
L.CmdShowBank = 'Abre o seu banco'
L.CmdShowVersion = 'Mostra a versão atual'
L.Updated = 'Atualizado para versão %s'

--frame titles
L.TitleBags = 'Mochila de %s'
L.TitleBank = 'Banco de %s'

--interactions
L.Click = 'Click'
L.Drag = '<Arraste>'
L.LeftClick = '<Clique Esquerdo>'
L.RightClick = '<Clique Direito>'
L.DoubleClick = '<Clique Duplo>'
L.ShiftClick = '<Shift+Clique>'

--tooltips
L.TipBags = 'Mochila'
L.TipBank = 'Banco'
L.TipBankToggle = 'para abrir o banco.'
L.TipChangePlayer = 'para ver os itens das suas personagens.'
L.TipGoldOnRealm = '%s no Total'
L.TipHideBag = 'para esconder o saco.'
L.TipHideBags = 'para esconder os sacos.'
L.TipHideSearch = 'para esconder o campo de pesquisa.'
L.TipInventoryToggle = 'para abrir a mochila.'
L.PurchaseBag = 'para comprar uma ranhura no banco.'
L.TipShowBag = 'para mostrar o bag.'
L.TipShowBags = 'para mostrar os sacos.'
L.TipShowMenu = 'para configurar esta janela.'
L.TipShowSearch = 'para pesquisar.'
L.TipShowFrameConfig = 'para configurar esta janela.'
L.TipMove = 'para mover.'
L.TipShowBank = 'para abrir o banco.'
L.TipShowInventory = 'para abrir a mochila.'
L.TipShowOptions = 'para abrir o menu de configuração.'

--itemcount tooltips
L.TipCount1 = 'Equipado: %d'
L.TipCount2 = 'Mochila: %d'
L.TipCount3 = 'Banco: %d'
L.TipCount4 = 'Cofre: %d'

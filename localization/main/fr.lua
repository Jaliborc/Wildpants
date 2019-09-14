--[[
	French Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'frFR')
if not L then return end

--keybindings
L.ToggleBags = 'Afficher votre inventaire'
L.ToggleBank = 'Afficher votre banque'
L.ToggleGuild = 'Afficher votre banque de guilde'
L.ToggleVault = 'Afficher votre chambre du Vide'

--terminal
L.Commands = 'Liste des commandes :'
L.CmdShowInventory = 'Affiche ou cache votre inventaire'
L.CmdShowBank = 'Affiche ou cache votre banque'
L.CmdShowGuild = 'Affiche ou cache votre banque de guilde'
L.CmdShowVault = 'Affiche ou cache votre chambre du Vide'
L.CmdShowVersion = 'Affiche la version actuelle'
L.CmdShowOptions = 'Ouvre le menu de configuration'
L.Updated = 'Mise à jour vers la v%s'

--frames
L.TitleBags = 'Inventaire |2 %s'
L.TitleBank = 'Banque |2 %s'
L.TitleVault = 'Chambre du Vide |2 %s'

--interactions
L.Click = 'Cliquez'
L.Drag = '<Saisir>'
L.LeftClick = '<Clic Gauche>'
L.RightClick = '<Clic Droit>'
L.DoubleClick = '<Double Clic>'
L.ShiftClick = '<Shift+Clic>'

--tooltips
L.TipChangePlayer = 'pour afficher les objets d\'un autre personnage.'
L.TipCleanBags = 'pour ranger vos sacs.'
L.TipCleanBank = 'pour ranger votre banque.'
L.TipDepositReagents = 'pour déposer tous les composants.'
L.TipFrameToggle = 'pour afficher d\'autres fenêtres.'
L.TipGoldOnRealm = '%s Totals'
L.TipHideBag = 'pour cacher ce sac.'
L.TipHideBags = 'pour cacher l\'affichage des sac.'
L.TipHideSearch = 'pour cacher le champ de recherche.'
L.TipResetPlayer = 'pour retourner sur le personnage actuel.'
L.PurchaseBag = 'pour acheter cet emplacement de sac.'
L.TipShowBag = 'pour afficher ce sac.'
L.TipShowBags = 'pour afficher la fenêtre de vos sacs.'
L.TipShowBank = 'pour afficher/cacher votre banque.'
L.TipShowInventory = 'pour afficher/cacher votre inventaire.'
L.TipShowMenu = 'pour configurer cette fenêtre.'
L.TipShowOptions = 'pour ouvrir le menu des options.'
L.TipShowSearch = 'pour rechercher.'
L.TipShowFrameConfig = 'pour configurer cette fenêtre.'
L.TipDeposit = 'pour déposer.'
L.TipWithdrawRemaining = 'pour retirer (%s encore possible).'
L.TipWithdraw = 'pour retirer (no remaining).'
L.NumWithdraw = '%d |4retrait:retraits;'
L.NumDeposit = '%d |4dépôt:dépôts;'
L.GuildFunds = 'Guild Funds'
L.Total = 'Total'

--itemcount tooltips
L.TipCountEquip = 'Équipé : %d'
L.TipCountBags = 'Sacs : %d'
L.TipCountBank = 'Banque : %d'
L.TipCountVault = 'Chambre : %d'
L.TipCountGuild = 'Guilde : %d'
L.TipDelimiter = '|'

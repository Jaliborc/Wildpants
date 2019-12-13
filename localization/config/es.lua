--[[
    Spanish Localization
		Credits/Blame: Phanx, Woopy
--]]

local CONFIG, Config = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'esES') or LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'esMX')
if not L then return end

-- general
L.GeneralOptionsDesc = 'Funciones generales que se puedan activados o desactivados como tu prefieras.'
L.Locked = 'Bloquear posiciones de marcos'
L.Fading = 'Activar efeitos de desaparición'
L.TipCount = 'Mostrar recuento de objetos en tooltips'
L.FlashFind = 'Activar Flash Find'
L.EmptySlots = 'Mostrar un fondo para las ranuras de objetos vacías'
L.DisplayBlizzard = 'Mostrar ventanas de Blizzard para bolsas desactivadas'
L.ConfirmGlobals = '¿Estás seguro de que deseas desactivar configuraciones específicas para este personaje? Se perderán todas las configuraciones específicas.'

-- frame
L.FrameOptions = 'Opciones de ventana'
L.FrameOptionsDesc = 'Opciones específicas para una ventana de ADDON'
L.Frame = 'Ventana'
L.Enabled = 'Activar esta ventana'
L.CharacterSpecific = 'Ajustes del personaje'
L.ExclusiveReagent = 'Banco de componentes independiente'
L.ActPanel = 'Actuar como panel estándar'
L.ActPanelTip = [[
Si está activado, este panel se posicionará automáticamente
a sí mismo como lo hacen los estándares, como el |cffffffffLibro de hechizos|r
o el |cffffffffBuscador de mazmorras|r, y no será movible.]]

L.BagToggle = 'Bolsas'
L.Money = 'Dinero'
L.Broker = 'DataBroker'
L.Sort = 'Botón para ordenar'
L.Search = 'Botón para buscar'
L.Options = 'Botón de opciones'
L.LeftTabs = 'Reglas a la izquierda'
L.LeftTabsTip = [[
Si está activado, las pestañas laterales serán
se muestra en el lado izquierdo del panel.]]


L.Appearance = 'Apariencia'
L.Layer = 'Estrato'
L.BagBreak = 'Descansos entre bolsas'
L.ReverseBags = 'Bolsas al revés'
L.ReverseSlots = 'Ranuras al revés'

L.Color = 'Color del fondo'
L.BorderColor = 'Color del borde'

L.Strata = 'Estrato'
L.Columns = 'Columnas'
L.Scale = 'Escala'
L.ItemScale = 'Escala de objetos'
L.Spacing = 'Espacio'
L.Alpha = 'Opacidad'

-- auto display
L.DisplayOptions = 'Exhibición automática'
L.DisplayOptionsDesc = 'Estas opciones te permite configurar si tu inventario se muestra o se oculta automáticamente en repuesta a ciertos eventos.'
L.DisplayInventory = 'Mostrar inventario'
L.CloseInventory = 'Ocultar inventario'

L.DisplayBank = 'al visitar el banco'
L.DisplayAuction = 'al visitar a la casa de subastas'
L.DisplayTrade = 'cuando el comercio'
L.DisplayScrapping = 'Equipo de basura'
L.DisplayCraft = 'al abrir la ventana de profesión'
L.DisplayMail = 'al visitar la buzón'
L.DisplayGuildbank = 'al visitar el banco de hermandad'
L.DisplayPlayer = 'al abrir el panel del personaje'
L.DisplayGems = 'al insertar gemas'

L.CloseCombat = 'al entrar en combate'
L.CloseVehicle = 'al entrar en un vehículo'
L.CloseBank = 'al salir del banco'
L.CloseVendor = 'al salir de un vendedor'
L.CloseMap = 'al abrir el mapa del mundo'

-- colors
L.ColorOptions = 'Opciones de color'
L.ColorOptionsDesc = 'Estas opciones te permite cambiar cómo se coloren las ranuras para facilitar la identificación.'
L.GlowQuality = 'Resalte objetos por calidad'
L.GlowNew = 'Resalte objetos nuevos' 
L.GlowQuest = 'Resalte objetos de misiones'
L.GlowUnusable = 'Resalte objetos inutilizables'
L.GlowSets = 'Resalte objetos en equipamientos'
L.ColorSlots = 'Colorear ranuras vacías por tipo de bolsa'

L.NormalColor = 'Bolsas normales'
L.QuiverColor = 'Bolsas de carcaj'
L.SoulColor = 'Bolsas de almas'
L.LeatherColor = 'Bolsas de peletería'
L.InscribeColor = 'Bolsas de inscripción'
L.HerbColor = 'Bolsas de hierbas'
L.EnchantColor = 'Bolsas de encantamiento'
L.EngineerColor = 'Bolsas de ingeniería'
L.GemColor = 'Bolsas de gemas'
L.MineColor = 'Bolsas de minería'
L.TackleColor = 'Caja de aparejos'
L.RefrigeColor = 'Bolsas de cocina'
L.ReagentColor = 'Banco de componentes'
L.GlowAlpha = 'Opacidad del resaltado'

-- rulesets
L.RuleSettings = 'Reglas de Objetos'
L.RuleSettingsDesc = 'Esta configuración le permite elegir qué conjuntos de reglas de objetos mostrar y en qué orden.'

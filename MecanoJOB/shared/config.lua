-- Config.Lua

Config = {

    esxGetter = "::{korioz#0110}::esx:getSharedObject", 
    esxnotify = "::{korioz#0110}::esx:showAdvancedNotification",
    esxnotify2 = "::{korioz#0110}::esx:showNotification",

    -- Text 
    CoffreTextYnS = "Appuyez sur ~r~[E] ~s~pour accèder au ~r~coffre ~s~ !", -- Text Menu Coffre
    BossTextYnS = "Appuyez sur ~r~[E] ~s~pour accèder à ~r~l'action patron ~s~ !", -- Text Menu Patron
    TextGarageVehYnS = "Appuyez sur ~r~[E] ~s~pour accèder au ~r~garage ~s~ !", -- Text Menu Garage
    AccueilYnS = "Appuyez sur ~r~[E] ~s~pour parler au secrétaire ~s~ !", -- Text Menu Accueil
    VestiareTextYnS = "Appuyez sur ~r~[E] ~s~pour vous changer~s~ !", -- Text Menu Accueil

    -- Vehicles
    MecanoVehicle = {
        {YnSbutton = "FlatBed", rightlabel = "→→", spawnname = "flatbed", spawnzone = vector3(-30.88, -1016.92, 28.89), headingspawn = 70.93}, -- Garage Voiture
        {YnSbutton = "Dépanneuse", rightlabel = "→→", spawnname = "towtruck", spawnzone = vector3(-30.88, -1016.92, 28.89), headingspawn = 70.93}, -- Garage Limousine
        {YnSbutton = "Dépanneuse2", rightlabel = "→→", spawnname = "towtruck2", spawnzone = vector3(-30.88, -1016.92, 28.89), headingspawn = 70.93}, -- Garage Camion
},

PositionYnS = {
        BossYnS = {vector3(-16.95, -1055.98, 32.4)}, -- Position du Point BossMenu
        CoffreYnS = {vector3(-24.98, -1051.77, 32.4)}, -- Position du Point CoffreMenu
        AccueilYnS = {vector3(-28.53, -1049.38, 28.4)}, -- Position du Point AccueilMenu
        GarageVehYnS = {vector3(-19.58, -1021.31, 28.91)}, -- Position du Point GarageMenu
        VestiareYnS = {vector3(-40.6, -1055.75, 28.4)}, -- Position du Point GarageMenu
    }
}


-- Created By Yanis (YnS)
-- Merci de ne pas s'approprier le script 
-- Discord : https://discord.gg/GT765cYycx
-- Discord : https://discord.gg/GT765cYycx
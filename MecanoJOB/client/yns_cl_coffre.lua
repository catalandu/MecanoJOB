-- yns_cl_coffre.lua
TriggerEvent(Config.esxGetter, function(obj) ESX = obj end)

-- [Menu RageUi V2]
local YnSCoffre = RageUI.CreateMenu("Coffre", "Mécano",0,100,nil,nil)
local YnSCoffre2 = RageUI.CreateSubMenu(YnSCoffre, nil, "mecano")
local YnSCoffre3 = RageUI.CreateSubMenu(YnSCoffre, nil, "mecano")

local open = false

YnSCoffre:DisplayGlare(false)
YnSCoffre.Closed = function()
    open = false
end

-- [Fonction du Menu]
all_items = {}
function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    blockinput = true 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Somme", ExampleText, "", "", "", MaxStringLenght) 
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end 
         
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

function ChestMecano() 
    if open then 
		open = false
		RageUI.Visible(YnSCoffre, false)
		return
	else
		open = true 
		RageUI.Visible(YnSCoffre, true)
		    CreateThread(function()
		    while open do 
       
        RageUI.IsVisible(YnSCoffre, function()
            RageUI.Button("Prendre un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                getStock()
            end},YnSCoffre3);

            RageUI.Button("Déposer un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                getInventory()
            end},YnSCoffre2);
         end)

        RageUI.IsVisible(YnSCoffre3, function()
           for k,v in pairs(all_items) do
                RageUI.Button(v.label, nil, {RightLabel = "~o~x"..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput("Combien voulez vous en déposer",nil,10)
                    count = tonumber(count)
                    if count <= v.nb then
                        TriggerServerEvent("YnS:takeStockItems",v.item, count)
                    else
                        ESX.ShowNotification("~r~Vous n'en avez pas assez sur vous")
                    end
                    getStock()
                end});
             end
         end)

        RageUI.IsVisible(YnSCoffre2, function()
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, nil, {RightLabel = "~r~x"..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput("Combien voulez vous en déposer",nil,10)
                    count = tonumber(count)
                    TriggerServerEvent("YnS:putStockItems",v.item, count)
                    getInventory()
                end});
               end
             end)
         Wait(0)
       end
     end)
   end
 end

function getInventory()
    ESX.TriggerServerCallback('YnS:playerinventory', function(inventory)                          
        all_items = inventory
     end)
  end

function getStock()
    ESX.TriggerServerCallback('YnS:getStockItems', function(inventory)                         
        all_items = inventory  
    end)
  end

-- Ouverture du Menu
Citizen.CreateThread(function()
    while true do
      local wait = 750
        for k in pairs(Config.PositionYnS.CoffreYnS) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mecano' then 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.PositionYnS.CoffreYnS[k].x, Config.PositionYnS.CoffreYnS[k].y, Config.PositionYnS.CoffreYnS[k].z)
            if dist <= 8.0 then
            wait = 0
            DrawMarker(22, -24.98, -1051.77, 32.4, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)          
            if dist <= 1.0 then
               wait = 0
                Visual.Subtitle(Config.CoffreTextYnS, 1) 
                if IsControlJustPressed(1,51) then
                ChestMecano()
            end
        end
    end
    end
    Citizen.Wait(wait)
    end
end
end)

-- Created By Yanis (YnS)
-- Merci de ne pas s'approprier le script 
-- Discord : https://discord.gg/GT765cYycx
-- Discord : https://discord.gg/GT765cYycx
-- yns_cl_garage.lua
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.esxGetter, function(obj) ESX = obj end)
		Citizen.Wait(6000)
	end
  while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then
  ESX.PlayerData = ESX.GetPlayerData()
  end
end)

RegisterNetEvent('::{korioz#0110}::esx:playerLoaded')
AddEventHandler('::{korioz#0110}::esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('::{korioz#0110}::esx:setJob')
AddEventHandler('::{korioz#0110}::esx:setJob', function(job)
    ESX.PlayerData.job = job
end)


-- Menu RageUI V2
local open = false
local YnSMecanoGarage = RageUI.CreateMenu("Garage", "Benny\'s", 0, 100, nil, nil)
YnSMecanoGarage.Display.Header = true
YnSMecanoGarage.Closed = function()
    open = false
end

-- Fonction du Menu
function OpenMenuGarageMecanoYnS()
    if open then 
        open = false
        RageUI.Visible(YnSMecanoGarage, false) 
        return
    else
        open = true 
        RageUI.Visible(YnSMecanoGarage, true)
        CreateThread(function()
        while open do 
        RageUI.IsVisible(YnSMecanoGarage, function()

            RageUI.Button("Ranger votre véhicule", nil, {RightLabel = "→→"}, true , {
                onSelected = function()
                  local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                  if dist4 < 4 then
                      DeleteEntity(veh)
                      RageUI.CloseAll()
                  end
                end})

              RageUI.Separator("~h~↓ Véhicules ↓")
                for k,v in pairs(Config.MecanoVehicle) do
                RageUI.Button(v.YnSbutton, nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
                        if not ESX.Game.IsSpawnPointClear(vector3(v.spawnzone.x, v.spawnzone.y, v.spawnzone.z), 10.0) then
                        ESX.ShowNotification("~g~Mecano\n~r~Point de spawn bloquée")
                        else
                        local model = GetHashKey(v.spawnname)
                        RequestModel(model)
                        while not HasModelLoaded(model) do Wait(10) end
                        local YnSveh = CreateVehicle(model, v.spawnzone.x, v.spawnzone.y, v.spawnzone.z, v.headingspawn, true, false)
                        SetVehicleNumberPlateText(YnSveh, "Mecano"..math.random(50, 999))
                        SetVehicleFixed(YnSveh)
                        TaskWarpPedIntoVehicle(PlayerPedId(),  YnSveh,  -1)
                        SetVehRadioStation(YnSveh, 0)
                        RageUI.CloseAll()
                      end
                    end})
                  end
               end)
            Wait(0)
          end
       end)
    end
 end

-- Ouverture du Menu
Citizen.CreateThread(function()
    while true do
      local wait = 750
        for k in pairs(Config.PositionYnS.GarageVehYnS) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mecano' then 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.PositionYnS.GarageVehYnS[k].x, Config.PositionYnS.GarageVehYnS[k].y, Config.PositionYnS.GarageVehYnS[k].z)
            if dist <= 8.0 then
            wait = 0
            DrawMarker(22, -19.58, -1021.31, 28.91, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)          
            if dist <= 1.0 then
               wait = 0
                Visual.Subtitle(Config.TextGarageVehYnS, 1) 
                if IsControlJustPressed(1,51) then
                OpenMenuGarageMecanoYnS()
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
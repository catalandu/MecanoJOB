CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.esxGetter, function(obj) ESX = nil end)
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

-- Menu RageUI V2
local open = false
local YnSMecanoMenuRageUIV2 = RageUI.CreateMenu("Mécano", "Menu", 0, 100, nil, nil)
local YnSMecanoSubMenuRageUIV2  = RageUI.CreateSubMenu(YnSMecanoMenuRageUIV2, nil, "mecano")
local YnSMecanosubmenurageuiv22 = RageUI.CreateSubMenu(YnSMecanoSubMenuRageUIV2, nil, "mecano")
YnSMecanoMenuRageUIV2.Display.Header = true 
YnSMecanoMenuRageUIV2.Closed = function()
  open = false
end

-- Fonction du Menu
function OpenMenuMecanoYnS()
	if open then 
		open = false
		RageUI.Visible(YnSMecanoMenuRageUIV2, false)
		return
	else
		open = true 
		RageUI.Visible(YnSMecanoMenuRageUIV2, true)
		CreateThread(function()
		while open do 
		   RageUI.IsVisible(YnSMecanoMenuRageUIV2,function()
			RageUI.Checkbox("Prendre votre service", nil, serviceYnSMecano, {}, {
                onChecked = function(index, items)
                    serviceYnSMecano = true
					ESX.ShowNotification("~g~Vous avez pris votre service !")
                    TriggerServerEvent('YnS:prisedeservice')
                end,
                onUnChecked = function(index, items)
                    serviceYnSMecano = false
					ESX.ShowNotification("~r~Vous avez quitter votre service !")
                    TriggerServerEvent('YnS:quitteleservice')
                end})
	if serviceYnSMecano then

           RageUI.Separator("~o~↓ Annonces ↓")

            RageUI.Button("Annonces Mécano", nil, {RightLabel = "→→"}, true , {
                  onSelected = function()
                end}, YnSMecanoSubMenuRageUIV2 )      
            
                RageUI.Button("Dépannage", nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
                  end}, YnSMecanosubmenurageuiv22)    
           
            RageUI.Button("Faire une Facture", nil, {RightLabel = "→→"}, true , {
                onSelected = function()
                    amount = KeyboardInput("Montant de la facture",nil,3)
                    amount = tonumber(amount)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if player ~= -1 and distance <= 3.0 then
                    if amount == nil then
                        ESX.ShowNotification("~r~Problèmes~s~: Montant invalide")
                    else
                        local playerPed        = PlayerPedId() 
                        Citizen.Wait(5000)
                        TriggerServerEvent('::{korioz#0110}::esx_billing:sendBill', GetPlayerServerId(player), 'society_mecano', ('mecano'), amount)
                        Citizen.Wait(100)
                        ESX.ShowNotification("~g~Vous avez bien envoyer la facture")
                    end
                    else
                    ESX.ShowNotification("~r~Problèmes~s~: Aucun joueur à proximitée")
                    end
                end});
             end
        end)

    RageUI.IsVisible(YnSMecanoSubMenuRageUIV2 ,function() 

           RageUI.Button("Annonce ~g~[Ouvertures]", nil, {RightLabel = "→"}, true , {
			onSelected = function()
				TriggerServerEvent('Ouvre:YnSMecano')
			end
		})

		RageUI.Button("Annonce ~r~[Fermetures]", nil, {RightLabel = "→"}, true , {
			onSelected = function()
				TriggerServerEvent('Ferme:YnSMecano')
			end
		})

		RageUI.Button("Annonce ~y~[Recrutement]", nil, {RightLabel = "→"}, true , {
			onSelected = function()
				TriggerServerEvent('Recru:YnSMecano')
			end
		})
    end)


        RageUI.IsVisible(YnSMecanosubmenurageuiv22,function() 

			RageUI.Button("Réparer le véhicule", nil, {RightLabel = "→→"}, true, {
				onSelected = function()
					local playerPed = PlayerPedId()
					local vehicle   = ESX.Game.GetVehicleInDirection()
					local coords    = GetEntityCoords(playerPed)
		
					if IsPedSittingInAnyVehicle(playerPed) then
						ESX.ShowNotification('Sortez de la voiture')
						return
					end
		
					if DoesEntityExist(vehicle) then
						isBusy = true
						TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
						Citizen.CreateThread(function()
							Citizen.Wait(20000)
		
							SetVehicleFixed(vehicle)
							SetVehicleDeformationFixed(vehicle)
							SetVehicleUndriveable(vehicle, false)
							SetVehicleEngineOn(vehicle, true, true)
							ClearPedTasksImmediately(playerPed)
		
							ESX.ShowNotification('la voiture est réparer')
							isBusy = false
						end)
					else
						ESX.ShowNotification('Aucun véhicule à proximiter')
					end
		 
				end,}) 
				
				RageUI.Button("Nettoyer véhicule", nil, {RightLabel = "→→"}, true , {
					onSelected = function()
						local playerPed = PlayerPedId()
						local vehicle   = ESX.Game.GetVehicleInDirection()
						local coords    = GetEntityCoords(playerPed)
			
						if IsPedSittingInAnyVehicle(playerPed) then
							ESX.ShowNotification('Sortez de la voiture')
							return
						end
			
						if DoesEntityExist(vehicle) then
							isBusy = true
							TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
							Citizen.CreateThread(function()
								Citizen.Wait(10000)
			
								SetVehicleDirtLevel(vehicle, 0)
								ClearPedTasksImmediately(playerPed)
			
								ESX.ShowNotification('Voiture nettoyée')
								isBusy = false
							end)
						else
							ESX.ShowNotification('Aucun véhicule trouvée')
						end
						end,})

								RageUI.Button("Crocheter véhicule", nil, {RightLabel = "→→"}, true , {
				onSelected = function()
						local playerPed = PlayerPedId()
						local vehicle = ESX.Game.GetVehicleInDirection()
						local coords = GetEntityCoords(playerPed)
			
						if IsPedSittingInAnyVehicle(playerPed) then
							ESX.ShowNotification('Action impossible')
							return
						end
			
						if DoesEntityExist(vehicle) then
							isBusy = true
							TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
							Citizen.CreateThread(function()
								Citizen.Wait(10000)
			
								SetVehicleDoorsLocked(vehicle, 1)
								SetVehicleDoorsLockedForAllPlayers(vehicle, false)
								ClearPedTasksImmediately(playerPed)
			
								ESX.ShowNotification('Véhicule déverrouillé')
								isBusy = false
							end)
						else
							ESX.ShowNotification('Aucune voiture autour')
						end
				end,})
						
				   RageUI.Button("Mettre véhicule en fourriere", nil, {RightLabel = "→→"}, true , {
					onSelected = function()
						local playerPed = PlayerPedId()

						if IsPedSittingInAnyVehicle(playerPed) then
							local vehicle = GetVehiclePedIsIn(playerPed, false)
			
							if GetPedInVehicleSeat(vehicle, -1) == playerPed then
								ESX.ShowNotification('la voiture a été mis en fourrière')
								ESX.Game.DeleteVehicle(vehicle)
							   
							else
								ESX.ShowNotification('Sortez de la voiture')
							end
						else
							local vehicle = ESX.Game.GetVehicleInDirection()
			
							if DoesEntityExist(vehicle) then
								TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
							Citizen.CreateThread(function()
								Citizen.Wait(10000)
								ClearPedTasks(playerPed)
                                Citizen.Wait(5000)
								ESX.ShowNotification('La voiture à été placer en fourrière')
								ESX.Game.DeleteVehicle(vehicle)
								end)
							else
								ESX.ShowNotification('Aucune voiture autour')
							end
						 end
				    end,})
                 end)
           Wait(0)
         end
      end)
    end
 end



        -- [Ouverture du Menu]
Keys.Register('F6', 'mecano', 'Ouvrir le menu Mécano', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mecano' then
        OpenMenuMecanoYnS()
	end
end)

--- Blips

local pos = vector3(-363.9, -116.72, 38.7)
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(pos)

	SetBlipSprite (blip, 446)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.6)
	SetBlipColour (blip, 51)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("~r~[Job] ~w~Mécano")
	EndTextCommandSetBlipName(blip)
end)
-- Created By Yanis (YnS)
-- Merci de ne pas s'approprier le script 
-- Discord : https://discord.gg/GT765cYycx
-- Discord : https://discord.gg/GT765cYycx
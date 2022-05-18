-- yns_cl_boss.lua

ESX = nil
societyYnSMecano = nil

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

-- Menu RageUi V2
local open = false 
local YnSMecanoBoss = RageUI.CreateMenu("Boss", "Mécano",0,100,nil,nil)
YnSMecanoBoss.Display.Header = true 
YnSMecanoBoss.Closed = function()
  open = false
end

-- Fonction du Menu

function BossYnS()
    TriggerEvent('YnSMecanoBossesx_society:openBossMenu', 'mecano', function(data, menu)
        menu.close()
    end, {wash = false})
end

function BossYnSMecano()
	if open then 
		open = false
		RageUI.Visible(YnSMecanoBoss, false)
		return
	else
		open = true 
		RageUI.Visible(YnSMecanoBoss, true)
		CreateThread(function()
		while open do 
		   RageUI.IsVisible(YnSMecanoBoss,function() 
            
			if societyYnSMecano ~= nil then
                RageUI.Button('Argent de la société :', nil, {RightLabel = "~r~"..societyYnSMecano.."$"}, true, {onSelected = function()end});   
            end

            RageUI.Separator("~r~↓ Mécano ↓")
            
            RageUI.Button('Retirer de l\'argent.', nil, {RightLabel = ">"}, true, {onSelected = function()
                local money = KeyboardInput('Combien voulez vous retirer :', '', 10)
                TriggerServerEvent("::{korioz#0110}::withdrawMoney","society_"..ESX.PlayerData.job.name ,money)
                RefreshMoney()
            end});   

            RageUI.Button('Déposer de l\'argent.', nil, {RightLabel = ">"}, true, {onSelected = function()
                local money = KeyboardInput('Combien voulez vous retirer :', '', 10)
                TriggerServerEvent("::{korioz#0110}::depositMoney","society_"..ESX.PlayerData.job.name ,money)
                RefreshMoney()
            end});  

            RageUI.Button('Rafraichir le compte.', nil, {RightLabel = ">"}, true, {onSelected = function()
                RefreshMoney()
            end}); 

            RageUI.Button('Accéder aux actions de Management.', nil, {RightLabel = ">"}, true, {onSelected = function()
                BossYnS()
                RageUI.CloseAll()
            end}); 

          end)
		 Wait(0)
		end
	 end)
  end
end

function RefreshMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('::{korioz#0110}::getSocietyMoney', function(money)
            societyYnSMecano = money
        end, "society_"..ESX.PlayerData.job.name)
    end
end

function UpdatessocietyYnSMecanomoney(money)
    societyYnSMecano = ESX.Math.GroupDigits(money)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true
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


-- Ouverture du Menu
Citizen.CreateThread(function()
    while true do
      local wait = 750
        for k in pairs(Config.PositionYnS.BossYnS) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mecano' then 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.PositionYnS.BossYnS[k].x, Config.PositionYnS.BossYnS[k].y, Config.PositionYnS.BossYnS[k].z)
            if dist <= 8.0 then
            wait = 0
            DrawMarker(22, -16.95, -1055.98, 32.4, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)          
            if dist <= 1.0 then
               wait = 0
                Visual.Subtitle(Config.BossTextYnS, 1) 
                if IsControlJustPressed(1,51) then
                    BossYnSMecano()
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
-- yns_cl_vestiare.lua
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.esxGetter, function(obj) ESX = obj end)
		Citizen.Wait(10)
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

-- Function du menu

function MecanoVestiareYnS()
  local model = GetEntityModel(GetPlayerPed(-1))
  TriggerEvent('::{korioz#0110}::skinchanger:getSkin', function(skin)
      if model == GetHashKey("mp_m_freemode_01") then
          clothesSkin = {
			['tshirt_1'] = 51,  ['tshirt_2'] = 0,
			['torso_1'] = 196,   ['torso_2'] = 1,
			['arms'] = 0,
			['pants_1'] = 73,   ['pants_2'] = 1,
			['shoes_1'] = 45,   ['shoes_2'] = 0,
			['bproof_1'] =3, ['bproof_2'] =3,
			['helmet_1'] = 109, ['helmet_2'] = 4,
          }
      else
          clothesSkin = {
			['tshirt_1'] = 26,  ['tshirt_2'] = 0,
			['torso_1'] = 56,   ['torso_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 58,   ['pants_2'] = 0,
			['shoes_1'] = 4,   ['shoes_2'] = 0
          }
      end
      TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', skin, clothesSkin)
  end)
end



function MecanoVestiareCivilYnS()
    ESX.TriggerServerCallback('::{korioz#0110}::esx_skin:getPlayerSkin', function(skin, jobSkin)
        TriggerEvent('::{korioz#0110}::skinchanger:loadSkin', skin)
    end)
end

-- Menu Fonction Rageui v2

local open = false 
local YnSMecanoVRageUIV2 = RageUI.CreateMenu('Vestaire', 'Ouverture du cassier..')
YnSMecanoVRageUIV2.Display.Header = true 
YnSMecanoVRageUIV2.Closed = function()
  open = false
end

function OpenVestiaire()
     if open then 
         open = false
         RageUI.Visible(YnSMecanoVRageUIV2, false)
         return
     else
         open = true 
         RageUI.Visible(YnSMecanoVRageUIV2, true)
         CreateThread(function()
         while open do 
            RageUI.IsVisible(YnSMecanoVRageUIV2,function() 

              RageUI.Separator("↓ ~y~   Vestiaire  ~s~↓")

              RageUI.Button("Mettre sa tenue : ~r~Civile", nil, {RightLabel = "→→"}, true , {
                onSelected = function()
                    MecanoVestiareCivilYnS()
                  end
                })	

               RageUI.Button("Mettre sa tenue : ~g~Mécano", nil, {RightLabel = "→→"}, true , {
                  onSelected = function()
                    MecanoVestiareYnS()
                    end
                  })	
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
        for k in pairs(Config.PositionYnS.VestiareYnS) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mecano' then 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.PositionYnS.VestiareYnS[k].x, Config.PositionYnS.VestiareYnS[k].y, Config.PositionYnS.VestiareYnS[k].z)
            if dist <= 10.0 then
            wait = 0
            DrawMarker(22, -40.6, -1055.75, 28.4, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)          
            if dist <= 1.0 then
               wait = 0
                Visual.Subtitle(Config.VestiareTextYnS, 1) 
                if IsControlJustPressed(1,51) then
                OpenVestiaire()
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

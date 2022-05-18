-- yns_cl_ped.lua


-- Ped Accueil

Citizen.CreateThread(function()
    RequestAnimDict("mini@strip_club@idles@bouncer@base")
    while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
        Wait(1)
    end
    local hash = GetHashKey("ig_benny")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
      Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVMALE", "ig_benny", -28.53, -1049.38, 27.4, 79.57, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end)
    
    -- Created By Yanis (YnS)
-- Merci de ne pas s'approprier le script 
-- Discord : https://discord.gg/GT765cYycx
-- Discord : https://discord.gg/GT765cYycx
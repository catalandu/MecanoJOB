-- yns_sv_mecano.lua
ESX = nil
local playerHealing, deadPlayers = {}, {}

TriggerEvent(Config.esxGetter, function(obj) ESX = obj end)
TriggerEvent('::{korioz#0110}::esx:esx_society:registerSociety', 'mecano', 'mecano', 'society_mecano', 'society_mecano', 'society_mecano', {type = 'public'})

-- Annonce Ouverture Mécano
RegisterServerEvent('Ouvre:YnSMecano')
AddEventHandler('Ouvre:YnSMecano', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent(Config.esxnotify, xPlayers[i], "Mécano", '~r~Annonce', "Le Mécano est désormais ~g~Ouvert~s~ !", 'CHAR_CARSITE3', 8)
	end
end)

-- Annonce Fermeture Mécano
RegisterServerEvent('Ferme:YnSMecano')
AddEventHandler('Ferme:YnSMecano', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent(Config.esxnotify, xPlayers[i], "Mécano", '~o~Annonce', "Le Mécano est désormais ~r~Fermer~s~ !", 'CHAR_CARSITE3', 8)
	end
end)

-- Annonce Recrutement Mécano
RegisterServerEvent('Recru:YnSMecano')
AddEventHandler('Recru:YnSMecano', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent(Config.esxnotify, xPlayers[i], "Mécano", '~o~Annonce', "Le Mécano ~y~recrute~w~ faites chauffés vos cv !", 'CHAR_CARSITE3', 8)
	end
end)

-- Coffre
ESX.RegisterServerCallback('YnS:playerinventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory
	local all_items = {}
	
	for k,v in pairs(items) do
		if v.count > 0 then
			table.insert(all_items, {label = v.label, item = v.name,nb = v.count})
		end
	end
  cb(all_items)
end)

ESX.RegisterServerCallback('YnS:getStockItems', function(source, cb)
	local all_items = {}
	TriggerEvent('::{korioz#0110}::esx_addoninventory:getSharedInventory', 'society_mecano', function(inventory)
		for k,v in pairs(inventory.items) do
			if v.count > 0 then
				table.insert(all_items, {label = v.label,item = v.name, nb = v.count})
			end
		end
     end)
  cb(all_items)
end)

RegisterServerEvent('YnS:putStockItems')
AddEventHandler('YnS:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item_in_inventory = xPlayer.getInventoryItem(itemName).count

	TriggerEvent('::{korioz#0110}::esx_addoninventory:getSharedInventory', 'society_mecano', function(inventory)
		if item_in_inventory >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent(Config.esxnotify2, xPlayer.source, "~r~Dépot\n~s~~r~Item ~s~: "..itemName.."\n~s~~r~Quantitée ~s~: "..count.."")
            PerformHttpRequest("https://discord.com/api/webhooks/923404316897849406/kUnglkE4FPZM-0pn4yUjbcjMSTBPIVtNOPL6ioeaDoKffn-F-DYPrgMiWqGdfnFD_r2-", function(err, text, headers) end, 'POST', json.encode({username = "Dépot Item", content = "__**Un nouveau Dépot a été effectué**__\n\nLa personne : " .. GetPlayerName(source) .. "\nà déposer : x" .. count .. " un(e) " .. itemName}), { ['Content-Type'] = 'application/json' })
		else
			TriggerClientEvent(Config.esxnotify2, xPlayer.source, "~r~Erreur~s~ : Vous n'en avez pas assez sur vous")
		end
	end)
end)

RegisterServerEvent('YnS:takeStockItems')
AddEventHandler('YnS:takeStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('::{korioz#0110}::esx_addoninventory:getSharedInventory', 'society_mecano', function(inventory)
			xPlayer.addInventoryItem(itemName, count)
			inventory.removeItem(itemName, count)
			TriggerClientEvent(Config.esxnotify2, xPlayer.source, "~r~Retrait\n~s~~r~Item ~s~: "..itemName.."\n~s~~r~Quantitée ~s~: "..count.."")
        PerformHttpRequest('https://discord.com/api/webhooks/923404316897849406/kUnglkE4FPZM-0pn4yUjbcjMSTBPIVtNOPL6ioeaDoKffn-F-DYPrgMiWqGdfnFD_r2-', function(err, text, headers) end, 'POST', json.encode({username = "Retrait Item", content = "__**Un nouveau Retrait a été effectué**__\n\nLa personne : " .. GetPlayerName(source) .. "\nà retirer : x" .. count .. " un(e) " .. itemName}), { ['Content-Type'] = 'application/json' })
	end)
end)

-- Menu Boss Mécano
RegisterServerEvent('::{korioz#0110}::withdrawMoney')
AddEventHandler('::{korioz#0110}::withdrawMoney', function(society, amount, money_soc)
	local xPlayer = ESX.GetPlayerFromId(source)
	local src = source 
	TriggerEvent('::{korioz#0110}::esx_addonaccount:getSharedAccount', society, function(account)
	  if account.money >= tonumber(amount) then
        account.removeMoney(amount)
        xPlayer.addAccountMoney('cash', amount)
		  TriggerClientEvent(Config.esxnotify2, src, "~r~Retiré \n~s~~s~Somme : "..amount.."$")
	  else
		    TriggerClientEvent(Config.esxnotify2, src, "~r~Erreur \n~s~~r~Pas assez d'argent")
	    end
    end)
end)

RegisterServerEvent('::{korioz#0110}::depositMoney')
AddEventHandler('::{korioz#0110}::depositMoney', function(society, amount)

	local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getAccount('cash').money
	local src = source
  
	TriggerEvent('::{korioz#0110}::esx_addonaccount:getSharedAccount', society, function(account)
        if money >= tonumber(amount) then
			xPlayer.removeAccountMoney('cash', amount)
            account.addMoney(amount)
		  TriggerClientEvent(Config.esxnotify2, src, "~r~Déposé \n~s~~s~Somme : "..amount.."$")
	  else
		  TriggerClientEvent(Config.esxnotify2, src, "~r~Erreur \n~s~~r~Pas assez d'argent")
	  end
	end)	
end)

ESX.RegisterServerCallback('::{korioz#0110}::getSocietyMoney', function(source, cb, soc)
	local money = nil
		MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @society ', {
			['@society'] = soc,
		}, function(data)
			for _,v in pairs(data) do
				money = v.money
			end
			cb(money)
		end)
end)

-- Prise de serive & Fin de Service
function sendToDiscordWithSpecialURL(name,message,color,url)
    local DiscordWebHook = url
	local embeds = {
		{
			["title"]=message,
			["type"]="rich",
			["color"] =color,
		}
	}
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest("https://discord.com/api/webhooks/923404316897849406/kUnglkE4FPZM-0pn4yUjbcjMSTBPIVtNOPL6ioeaDoKffn-F-DYPrgMiWqGdfnFD_r2-", function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('YnS:prisedeservice')
AddEventHandler('YnS:prisedeservice', function()
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	sendToDiscordWithSpecialURL("Prise de service",xPlayer.getName().." à prise son service au Mécano", 9999999, "https://discord.com/api/webhooks/923404316897849406/kUnglkE4FPZM-0pn4yUjbcjMSTBPIVtNOPL6ioeaDoKffn-F-DYPrgMiWqGdfnFD_r2-")
end)

RegisterNetEvent('YnS:quitteleservice')
AddEventHandler('YnS:quitteleservice', function()
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	sendToDiscordWithSpecialURL("Fin de service",xPlayer.getName().." à quitter son service au Mécano", 9999999, "https://discord.com/api/webhooks/923404316897849406/kUnglkE4FPZM-0pn4yUjbcjMSTBPIVtNOPL6ioeaDoKffn-F-DYPrgMiWqGdfnFD_r2-")
end)

-- [Accueil]

-- [Accueil]
local function sendToDiscordWithSpecialURL(Color, Title, Description)
	local Content = {
	        {
	            ["color"] = Color,
	            ["title"] = Title,
	            ["description"] = Description,    
	        }
	    }
	PerformHttpRequest("https://discord.com/api/webhooks/923404316897849406/kUnglkE4FPZM-0pn4yUjbcjMSTBPIVtNOPL6ioeaDoKffn-F-DYPrgMiWqGdfnFD_r2-", function(err, text, headers) end, 'POST', json.encode({username = Name, embeds = Content}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("Rdv:YnSMecano")
AddEventHandler("Rdv:YnSMecano", function(nomprenom, numero, heurerdv, rdvmotif)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local ident = ESX.GetIdentifierFromId(source)
	local date = os.date('*t')
    if date.day < 10 then date.day = '' .. tostring(date.day) end
	if date.month < 10 then date.month = '' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '' .. tostring(date.hour) end
	if date.min < 10 then date.min = '' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '' .. tostring(date.sec) end
    if ident == 'steam:11' then
	else 
		sendToDiscordWithSpecialURL(9999999, "__**Nouveau Rendez-Vous :**__\n\n **Nom :** "..nomprenom.."\n\n**Numéro de Téléphone:** "..numero.."\n\n**Heure du Rendez Vous** : " ..heurerdv.."\n\n**Motif du Rendez-vous :** " ..rdvmotif.. "\n\n**Date :** " .. date.day .. "." .. date.month .. "." .. date.year .. " | " .. date.hour .. " h " .. date.min .. " min " .. date.sec)
	end
end)

RegisterServerEvent('YnS:AppelMecano')
AddEventHandler('YnS:AppelMecano', function()
   	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'mecano' then
		TriggerClientEvent(Config.esxnotify, xPlayers[i], 'Secrétaire Mecano', '~r~Accueil', 'Un employer du Mecano est appelé à l\'accueil !', 'CHAR_CARSITE3', 8)
        end
    end
end)

-- Created By Yanis (YnS)
-- Merci de ne pas s'approprier le script 
-- Discord : https://discord.gg/GT765cYycx
-- Discord : https://discord.gg/GT765cYycx
if Config.Inventory ~= 'lj' then return end
ps.debug('lj inventory is archived and outdated, please use ps-inventory')
if IsDuplicityVersion() then
    function ps.removeItem(identifier, item, amount, slot, reason)
        local Player = ps.getPlayer(identifier)
         if not identifier or not item then return end
        if not amount then amount = 1 end
        if not slot then slot = false end
        if not reason then reason = 'ps_lib Remove Item' end
        return Player.Functions.RemoveItem(item, amount, slot, reason)
    end
     
    function ps.addItem(identifier, item, amount, meta, slot, reason)
        local Player = ps.getPlayer(identifier)
        if not identifier or not item then return end
        if not amount then amount = 1 end
        if not slot then slot = false end
        if not reason then reason = 'ps_lib Add Item' end
        return Player.Functions.AddItem(item, amount, slot, meta, reason)
    end
    function ps.openStash(source, identifier, data)
        if not data.label then data.label = identifier end
        if not data.maxweight then data.maxweight = 100000 end
        if not data.slots then data.slots = 50 end
        TriggerClientEvent('lj-inventory:client:openInventoryBackWards', source, identifier, data)
    end

    function ps.hasItem(identifier, item, amount)
        if not identifier or not item then return end
        if not amount then amount = 1 end
        local Player = ps.getPlayer(identifier)
        return Player.Functions.GetItemByName(item).amount >= amount
    end
    function ps.getFreeWeight(identifier)
        if not identifier then return end
        local Player = ps.getPlayer(identifier)
        return Player.Functions.GetFreeWeight()
    end
    function ps.openInventoryById(source, playerid)
        if not playerid then playerid = false end
        TriggerServerEvent('lj-inventory:server:SearchPlayer', source)
    end
else
    RegisterNetEvent('lj-inventory:client:openInventoryBackWards', function(name, data)
        TriggerEvent("inventory:client:SetCurrentStash", name)
	    TriggerServerEvent("inventory:server:OpenInventory", "stash", name, {
			maxweight = data,
			slots = data.slots,
		})
    end)
    RegisterNetEvent('lj-inventory:server:SearchPlayer', function(name, data)
        local player, distance = QBCore.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 2.5 then
            local playerId = GetPlayerServerId(player)
            TriggerServerEvent('inventory:server:OpenInventory', 'otherplayer', playerId)
            TriggerServerEvent('police:server:SearchPlayer', playerId)
        else
            QBCore.Functions.Notify(Lang:t('error.none_nearby'), 'error')
        end
    end)
    function ps.getImage(item)
        local itemData = QBCore.Shared.Items[item].image
        if itemData then
            return 'nui://lj-inventory/html/images/' .. itemData
        else
            return nil
        end
    end
    function ps.getLabel(item)
        local itemData = QBCore.Shared.Items[item]
        if itemData then
            return itemData.label or item
        else
            return nil
        end
    end
    function ps.hasItem(item, amount)
        if not item then return end
        if not amount then amount = 1 end
        return QBCore.Functions.HasItem(item, amount)
    end
end
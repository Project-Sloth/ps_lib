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

RegisterNetEvent('ps_lib:client:createShop', function(shopData)
    if not shopData.name then shopData.name = 'Shop' end
    if not shopData.slots then shopData.slots = 50 end
    if not shopData.maxweight then shopData.maxweight = 100000 end
     TriggerServerEvent("inventory:server:OpenInventory", "shop", "Shop"..math.random(1, 99), shopData)
end)
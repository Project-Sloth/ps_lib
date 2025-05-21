if Config.Inventory ~= 'qb' then return end
ps.debug('qb-inventory loaded')
if IsDuplicityVersion() then
    function ps.removeItem(identifier, item, amount, slot, reason)
        if not identifier or not item then return end
        if not amount then amount = 1 end
        if not slot then slot = false end
        if not reason then reason = 'ps_lib Remove Item' end
        TriggerClientEvent('qb-inventory:client:ItemBox', identifier, QBCore.Shared.Items[item], "remove", amount)
        return exports['qb-inventory']:RemoveItem(identifier, item, amount, slot, reason)
    end
    function ps.addItem(identifier, item, amount,meta, slot, reason)
        if not identifier or not item then return end
        if not amount then amount = 1 end
        if not slot then slot = false end
        if not reason then reason = 'ps_lib Add Item' end
        TriggerClientEvent('qb-inventory:client:ItemBox', identifier, QBCore.Shared.Items[item], "add", amount)
        return exports['qb-inventory']:AddItem(identifier, item, amount, slot, meta, reason)
    end
    function ps.openStash(source, identifier, data)
        if not data.label then data.label = identifier end
        if not data.maxweight then data.maxweight = 100000 end
        if not data.slots then data.slots = 50 end
        exports['qb-inventory']:OpenInventory(source, identifier, data)
    end

    function ps.hasItem(identifier, item, amount)
        if not identifier or not item then return end
        if not amount then amount = 1 end
        return exports['qb-inventory']:HasItem(identifier, item, amount)
    end
    function ps.getFreeWeight(identifier)
        if not identifier then return end
        return exports['qb-inventory']:GetFreeWeight(identifier)
    end
    function ps.openInventoryById(source, playerid)
        exports['qb-inventory']:OpenInventory(source, playerid)
    end
else
    function ps.getImage(item)
        local itemData = QBCore.Shared.Items[item].image
        if itemData then
            return 'nui://qb-inventory/html/images/' .. itemData
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
        return exports['qb-inventory']:HasItem(item, amount)
    end
end
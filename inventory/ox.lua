if Config.Inventory ~= 'ox' then return end

if IsDuplicityVersion() then
    function ps.CanCarryItem(source, item, amount)
        if not source or not item then return end
        if not amount then amount = 1 end
        return exports.ox_inventory:CanCarryItem(source, item, amount)
    end
    function ps.removeItem(identifier, item, amount, slot, reason)
        if not identifier or not item then return end
        if not amount then amount = 1 end
        if not slot then slot = false end
        if not reason then reason = 'ps_lib Remove Item' end
        return exports.ox_inventory:RemoveItem(identifier, item, amount, slot, reason)
    end
    
    function ps.addItem(identifier, item, amount, meta, slot, reason)
        if not ps.CanCarryItem(identifier, item, amount) then return end
        if not identifier or not item then return end
        if not amount then amount = 1 end
        if not slot then slot = false end
        if not reason then reason = 'ps_lib Add Item' end
        return exports.ox_inventory:AddItem(identifier, item, amount, meta, slot, reason)
    end

    function ps.openStash(source, identifier, data)
        if not data.label then data.label = identifier end
        if not data.maxweight then data.maxweight = 100000 end
        if not data.slots then data.slots = 50 end
        exports.ox_inventory:RegisterStash(identifier, identifier, data.slots, data.maxweight)
        Wait(100)
        TriggerClientEvent('ox_inventory:openInventory', source, 'stash', identifier, data)
    end
    function ps.hasItem(identifier, item, amount)
        if not identifier or not item then return end
        if not amount then amount = 1 end
        return exports.ox_inventory:GetItemCount(identifier, item) >= amount
    end
    function ps.openInventoryById(source, playerid)
        if not playerid then playerid = false end
        TriggerServerEvent('ps_lib:client:openInventoryox', source)
    end
else
    RegisterNetEvent('ps_lib:client:openInventory', function(name)
        exports.ox_inventory:openInventory(name)
    end)
    RegisterNetEvent('ps_lib:client:openInventoryox', function(name, data)
        exports.ox_inventory:openNearbyInventory()
    end)
    function ps.getImage(item)
       local Items = exports['ox_inventory']:Items()
		if not Items[item] then ps.debug(' You Are Missing: ' .. item .. ' From Your ox items.lua') return end
        local itemClient = Items[item] and Items[item]['client']
        if itemClient and itemClient['image'] then
            return itemClient['image']
        else
            return "nui://ox_inventory/web/images/" .. item .. '.png'
        end
    end
    function ps.getLabel(item)
        local Items = exports['ox_inventory']:Items()
        if Items[item] then
            return Items[item]['label'] or item
        else
            ps.debug(' You Are Missing: ' .. item .. ' From Your ox items.lua')
            return 'missing: ' .. item
        end
    end
    function ps.hasItem(item, amount)
        if not item then return end
        if not amount then amount = 1 end
        ps.debug('Checking for item: ' .. item .. ' amount: ' .. amount, exports.ox_inventory:GetItemCount(item), amount)
        if exports.ox_inventory:GetItemCount(item) <= amount then
            ps.notify('You need ' ..amount - exports.ox_inventory:GetItemCount(item) .. ' more ' .. ps.getLabel(item), 'error')
            return false
        end
        return true
    end
end

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
    return exports.ox_inventory:AddItem(identifier, item, amount, meta, slot)
end

function ps.openStash(source, identifier, data)
    if not data.label then data.label = identifier end
    if not data.maxweight then data.maxweight = 100000 end
    if not data.slots then data.slots = 50 end
    exports.ox_inventory:RegisterStash(identifier, identifier, data.slots, data.maxweight)
    Wait(100)
    TriggerClientEvent('ps_lib:client:openInventory', source, 'stash', identifier, data)
end

function ps.hasItem(identifier, item, amount)
    if not identifier or not item then return end
    if not amount then amount = 1 end
    return exports.ox_inventory:GetItemCount(identifier, item) >= amount
end

function ps.openInventoryById(source, playerid)
    if not playerid then playerid = false end
    TriggerClientEvent('ps_lib:client:openInventoryox', source)
end

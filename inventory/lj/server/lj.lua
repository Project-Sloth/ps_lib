ps.warn('lj inventory is archived and outdated, please use ps-inventory')

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
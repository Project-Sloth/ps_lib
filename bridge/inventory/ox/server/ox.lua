
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

function ps.clearInventory(source, identifier)
    if not identifier then return end
    exports.ox_inventory:ClearInventory(identifier, '')
end

function ps.clearStash(source, identifier)
    if not identifier then return end
    exports.ox_inventory:ClearInventory(identifier, '')
end

function ps.getItemCount(source, item)
    if not source or not item then return end
    return exports.ox_inventory:GetItemCount(source, item)
end

function ps.getItemByName(source, item)
    if not source or not item then return end
    return exports.ox_inventory:GetItem(source, item)
end

function ps.getItemsByNames(source, items)
    if not source or not items then return end
    local itemList = {}
    for _, item in ipairs(items) do
        local itemData = exports.ox_inventory:GetItem(source, item)
        if itemData then
            itemList[item] = itemData
        end
    end
    return itemList
end

function ps.createShop(source, shopData)
    if not shopData.name then shopData.name = 'Shop' end
    if not shopData.slots then shopData.slots = 50 end
    if not shopData.maxweight then shopData.maxweight = 100000 end
    exports.ox_inventory:RegisterShop(shopData.name, {
        name = shopData.name,
        inventory = shopData.items or {},
    })
    TriggerClientEvent('ps_lib:client:createShop', source, shopData.name)
end

function ps.verifyRecipe(source, recipe)
    if not source or not recipe then return false end
    local requiredItems = recipe.requiredItems or {}
    for item, amount in pairs(requiredItems) do
        if not ps.hasItem(source, item, amount) then
            ps.notify(source, 'You need ' .. amount .. ' ' .. ps.getLabel(item) .. ' to craft this.', 'error')
            return false
        end
    end
    return true
end

function ps.craftItem(source, recipe)
    if not source or not recipe then return false end
    local itemChecks = ps.verifyRecipe(source, recipe.take)

    if not itemChecks then return false end

    for item, amount in pairs(recipe.take) do
        ps.removeItem(source, item, amount)
    end

    for k, v in pairs(recipe.give) do
        if not ps.addItem(source, k, v) then
            ps.notify(source, 'Failed to add ' .. v .. ' ' .. ps.getLabel(k), 'error')
            return false
        end
    end
    return true
end
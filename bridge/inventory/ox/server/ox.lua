
local function CanCarryItem(source, item, amount)
    if not source or not item then return end
    if not amount then amount = 1 end
    local can = exports.ox_inventory:CanCarryItem(source, item, amount)
    return can
end

function ps.removeItem(identifier, item, amount, slot, reason)
    if not identifier or not item then return end
    if not amount then amount = 1 end
    if not slot then slot = false end
    if not reason then reason = 'ps_lib Remove Item' end
    return exports.ox_inventory:RemoveItem(identifier, item, amount, slot, reason)
end

function ps.addItem(identifier, item, amount, meta, slot, reason)
    if not CanCarryItem(identifier, item, amount) then return end
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
    exports.ox_inventory:RegisterStash(identifier, data.label, data.slots, data.maxweight)
    TriggerClientEvent('ps_lib:client:openInventory', source, identifier)
end

function ps.hasItem(identifier, item, amount)
    if not identifier or not item then return end
    if not amount then amount = 1 end
    return exports.ox_inventory:GetItemCount(identifier, item) >= amount
end

function ps.getFreeWeight(source)
    return true
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
    local need, have = 0,0
    for k, v in pairs (recipe) do
        if ps.getItemCount(source, k) >= v then
            have = have + 1
        end
        need = need + 1
    end
    return have >= need
end

function ps.craftItem(source, recipe)
    if not source or not recipe then return false end
    local itemChecks = ps.verifyRecipe(source, recipe.take)

    if not itemChecks then return false end

    for item, amount in pairs(recipe.take) do
       if not  ps.removeItem(source, item, amount) then
           ps.notify(source, ps.lang('noItem', amount, ps.getLabel(item)), "error")
            return false
       end
    end
    for k, v in pairs(recipe.give) do
        if not ps.addItem(source, k, v) then
            return false
        end
    end
    return true
end

exports('removeItem', ps.removeItem)
exports('addItem', ps.addItem)
exports('openStash', ps.openStash)
exports('hasItem', ps.hasItem)
exports('getFreeWeight', ps.getFreeWeight)
exports('openInventoryById', ps.openInventoryById)
exports('clearInventory', ps.clearInventory)
exports('clearStash', ps.clearStash)
exports('getItemCount', ps.getItemCount)
exports('getItemByName', ps.getItemByName)
exports('getItemsByNames', ps.getItemsByNames)
exports('createShop', ps.createShop)
exports('verifyRecipe', ps.verifyRecipe)
exports('craftItem', ps.craftItem)
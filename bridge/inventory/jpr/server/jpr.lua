
function ps.removeItem(identifier, item, amount, slot, reason)
    if not identifier or not item then return end
    if not amount then amount = 1 end
    if not slot then slot = false end
    if not reason then reason = 'ps_lib Remove Item' end
    TriggerClientEvent('jpr-inventory:client:ItemBox', identifier, QBCore.Shared.Items[item], "remove", amount)
    return exports['jpr-inventory']:RemoveItem(identifier, item, amount, slot, reason)
end

function ps.addItem(identifier, item, amount,meta, slot, reason)
    if not identifier or not item then return end
    if not amount then amount = 1 end
    if not slot then slot = false end
    if not reason then reason = 'ps_lib Add Item' end
    TriggerClientEvent('jpr-inventory:client:ItemBox', identifier, QBCore.Shared.Items[item], "add", amount)
    return exports['jpr-inventory']:AddItem(identifier, item, amount, slot, meta, reason)
end

function ps.openStash(source, identifier, data)
    if not data.label then data.label = identifier end
    if not data.maxweight then data.maxweight = 100000 end
    if not data.slots then data.slots = 50 end
    exports['jpr-inventory']:OpenInventory(source, identifier, data)
end

function ps.hasItem(identifier, item, amount)
    if not identifier or not item then return end
    if not amount then amount = 1 end
    return exports['jpr-inventory']:HasItem(identifier, item, amount)
end

function ps.getFreeWeight(identifier)
    if not identifier then return end
    return exports['jpr-inventory']:GetFreeWeight(identifier)
end

function ps.openInventoryById(source, playerid)
    exports['jpr-inventory']:OpenInventory(source, playerid)
end

function ps.clearInventory(source, identifier)
    if not identifier then return end
    exports['jpr-inventory']:ClearInventory(source, identifier)
end

function ps.clearStash(source, identifier)
    if not identifier then return end
    exports['jpr-inventory']:ClearStash(source, identifier)
end

function ps.getItemCount(identifier, item)
    if not identifier or not item then return end
    return exports['jpr-inventory']:GetItemCount(identifier, item)
end

function ps.getItemByName(identifier, item)
    if not identifier or not item then return end
    return exports['jpr-inventory']:GetItemByName(identifier, item)
end

function ps.getItemsByNames(identifier, items)
    if not identifier or not items then return end
    local itemList = {}
    for _, item in ipairs(items) do
        local itemData = exports['jpr-inventory']:GetItemByName(identifier, item)
        if itemData then
            itemList[item] = itemData
        end
    end
    return itemList
end

function ps.createShop(source, shopData)
    if not shopData.name then shopData.name = 'Shop' end
    if not shopData.items then shopData.items = {} end
    if not shopData.slots then shopData.slots = #shopData.items end
    if not shopData.label then shopData.label = shopData.name end
    exports['jpr-inventory']:CreateShop(source, shopData.name, shopData.items)
    exports['jpr-inventory']:OpenShop(source, shopData.name)
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
    local src = source
    local itemChecks = ps.verifyRecipe(src, recipe.take)
    if not itemChecks then return false end
    for k, v in pairs(recipe.take) do
        if not ps.removeItem(src, k, v) then
            ps.notify(src, ps.lang('noItem', v, k), "error")
            return false
        end
    end
    for k, v in pairs(recipe.give) do
        if not ps.addItem(src, k, v) then
            ps.notify(src, ps.lang('noItem', v, k), "error")
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


-- @param identifier number|string i.e. source or CitizenID
-- @param item string
-- @param amount number
-- @param slot number|boolean i.e. false for auto slot ** optional
-- @param reason string ** optional
-- @return boolean
-- example: ps.removeItem(source, 'bread', 1, false, 'ps_lib Remove Item')
function ps.removeItem(identifier, item, amount, slot, reason)
    if not identifier or not item then return end
    if not amount then amount = 1 end
    if not slot then slot = false end
    if not reason then reason = 'ps_lib Remove Item' end
    if exports['qb-inventory']:RemoveItem(identifier, item, amount, slot, reason) then
        TriggerClientEvent('qb-inventory:client:ItemBox', identifier, QBCore.Shared.Items[item], "remove", amount)
        return true
    end
    return false
end


-- @param identifier number|string i.e. source or CitizenID
-- @param item string
-- @param amount number
-- @param meta table ** optional
-- @param slot number|boolean i.e. false for auto slot ** optional
-- @param reason string ** optional
-- @return boolean
-- example: ps.addItem(source, 'bread', 1, {quality = 100}, false, 'ps_lib Add Item')
function ps.addItem(identifier, item, amount,meta, slot, reason)
    if not identifier or not item then return end
    if not amount then amount = 1 end
    if not slot then slot = false end
    if not reason then reason = 'ps_lib Add Item' end
    if exports['qb-inventory']:AddItem(identifier, item, amount, slot, meta, reason) then
        TriggerClientEvent('qb-inventory:client:ItemBox', identifier, QBCore.Shared.Items[item], "add", amount)
        return true
    end
    return false
end


-- @param source number|string i.e. source or CitizenID
-- @param identifier string i.e. stash name
-- @param data table i.e. {label = 'Stash', maxweight = 100000, slots = 50} ** optional
-- example: ps.openStash(source, 'my_stash', {label = 'My Stash', maxweight = 100000, slots = 50})
function ps.openStash(source, identifier, data)
    if not data.label then data.label = identifier end
    if not data.maxweight then data.maxweight = 100000 end
    if not data.slots then data.slots = 50 end
    exports['qb-inventory']:OpenInventory(source, identifier, data)
end

-- @param identifier number|string i.e. source or CitizenID
-- @param item string
-- @param amount number
-- @return boolean
-- example: ps.hasItem(source, 'bread', 1)
function ps.hasItem(identifier, item, amount)
    if not identifier or not item then return end
    if not amount then amount = 1 end
    return exports['qb-inventory']:HasItem(identifier, item, amount)
end

-- @param identifier number|string i.e. source
-- @return number
-- example: ps.getFreeWeight(source)
function ps.getFreeWeight(identifier)
    if not identifier then return end
    return exports['qb-inventory']:GetFreeWeight(identifier)
end

-- @param source number|string i.e. source
-- @param playerid number|string i.e. target player id or CitizenID
function ps.openInventoryById(source, playerid)
    exports['qb-inventory']:OpenInventory(source, playerid)
end

-- @param source number|string i.e. source
-- @param identifier string i.e. Target Players CitizenID

function ps.clearInventory(source, identifier)
    if not identifier then return end
    exports['qb-inventory']:ClearInventory(source, identifier)
end

-- @param source number|string i.e. source
-- @param identifier string i.e. Stash Name
-- example: ps.clearStash(source, 'my_stash')
function ps.clearStash(source, identifier)
    if not identifier then return end
    exports['qb-inventory']:ClearStash(source, identifier)
end


-- @param identifier number|string i.e. source
-- @param item string
-- @return number
-- example: ps.getItemCount(identifier, 'bread')
function ps.getItemCount(identifier, item)
    if not identifier or not item then return end
    return exports['qb-inventory']:GetItemCount(identifier, item)
end

-- @param identifier number|string i.e. source
-- @param item string
-- @return table|nil
-- example: ps.getItemByName(identifier, 'bread')
function ps.getItemByName(identifier, item)
    if not identifier or not item then return end
    return exports['qb-inventory']:GetItemByName(identifier, item)
end

-- @param identifier number|string i.e. source
-- @param items table i.e. {'bread', 'water'}
-- @return table|nil
-- example: ps.getItemsByNames(identifier, {'bread', 'water'})

function ps.getItemsByNames(identifier, items)
    if not identifier or not items then return end
    local itemList = {}
    for _, item in ipairs(items) do
        local itemData = exports['qb-inventory']:GetItemByName(identifier, item)
        if itemData then
            itemList[item] = itemData
        end
    end
    return itemList
end

-- @param source number|string i.e. source
-- @param shopData table i.e. {name = 'Shop', items = {}, slots = 10, label = 'Shop'}
-- example: ps.createShop(source, {name = 'Shop', items = {}, slots = 10, label = 'Shop'})
function ps.createShop(source, shopData)
    if not shopData.name then shopData.name = 'Shop' end
    if not shopData.items then shopData.items = {} end
    if not shopData.slots then shopData.slots = #shopData.items end
    if not shopData.label then shopData.label = shopData.name end
    exports['qb-inventory']:CreateShop(source, shopData.name, shopData.items)
    exports['qb-inventory']:OpenShop(source, shopData.name)
end

-- @param source number|string i.e. source
-- @param recipe table i.e. {take = {bread = 1, water = 1}, give = {sandwich = 1}}
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

-- @param source number|string i.e. source
-- @param recipe table i.e. {take = {bread = 1, water = 1}, give = {sandwich = 1}}
-- @return boolean
-- example: ps.craftItem(source, {take = {bread = 1, water = 1}, give = {sandwich = 1}})
function ps.craftItem(source, recipe)
    local src = source
    local itemChecks = ps.verifyRecipe(src, recipe.take)
    if not itemChecks then return false end
    for k, v in pairs(recipe.take) do
        if not ps.removeItem(src, k, v) then
            ps.notify(src, ps.lang("noItem", v, k), "error")
            return false
        end
    end
    for k, v in pairs(recipe.give) do
        if not ps.addItem(src, k, v) then
            ps.notify(src, ps.lang("noItem", v, k), "error")
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
--- function to remove item needs return true
ps.success('Inventory Module Loaded: Custom Inventory')
function ps.removeItem(identifier, item, amount, slot, reason)
    if not identifier or not item then return end
    if not amount then amount = 1 end
    if not slot then slot = false end
    if not reason then reason = 'ps_lib Remove Item' end
    --TriggerClientEvent('qb-inventory:client:ItemBox', identifier, QBCore.Shared.Items[item], "remove", amount)
    --return exports['qb-inventory']:RemoveItem(identifier, item, amount, slot, reason)
end

-- function to add item needs return true
function ps.addItem(identifier, item, amount,meta, slot, reason)
    if not identifier or not item then return end
    if not amount then amount = 1 end
    if not slot then slot = false end
    if not reason then reason = 'ps_lib Add Item' end
    --TriggerClientEvent('qb-inventory:client:ItemBox', identifier, QBCore.Shared.Items[item], "add", amount)
    --return exports['qb-inventory']:AddItem(identifier, item, amount, slot, meta, reason)
end

-- function to open stash
function ps.openStash(source, identifier, data)
    --if not data.label then data.label = identifier end
    --if not data.maxweight then data.maxweight = 100000 end
    --if not data.slots then data.slots = 50 end
    --exports['qb-inventory']:OpenInventory(source, identifier, data)
end

-- checks if you have item and amount in inventory
function ps.hasItem(identifier, item, amount)
    --if not identifier or not item then return end
    --if not amount then amount = 1 end
    --return exports['qb-inventory']:HasItem(identifier, item, amount)
end

-- returns free weight in inventory
function ps.getFreeWeight(identifier)
   -- if not identifier then return end
   -- return exports['qb-inventory']:GetFreeWeight(identifier)
end

-- opens inventory by player ID
function ps.openInventoryById(source, playerid)
    
end

-- clears inventory for a player
function ps.clearInventory(source, identifier)
   
end

-- clears stash for a player
function ps.clearStash(source, identifier)
   
end

-- returns item count for a player
function ps.getItemCount(identifier, item)

end

-- returns item data for a player
function ps.getItemByName(identifier, item)
   
end

-- returns items by names for a table
function ps.getItemsByNames(identifier, items)
    
end

-- creates a shop 
function ps.createShop(source, shopData)

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
            ps.notify(src, ps.lang("error.no_item", k), "error")
            return false
        end
    end
    for k, v in pairs(recipe.give) do
        if not ps.addItem(src, k, v) then
            ps.notify(src, ps.lang("error.no_item", k), "error")
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
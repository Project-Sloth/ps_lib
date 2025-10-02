RegisterNetEvent('ps_lib:client:openInventory', function(name)
    exports.ox_inventory:openInventory('stash', name)
end)

RegisterNetEvent('ps_lib:client:openInventoryox', function(name, data)
    exports.ox_inventory:openNearbyInventory()
end)

function ps.getImage(item)
   local Items = exports['ox_inventory']:Items()
	if not Items[item] then ps.debug(' You Are Missing: ' .. item .. ' From Your ox items.lua') return 'https://avatars.githubusercontent.com/u/99291234?s=280&v=4' end
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
    if exports.ox_inventory:GetItemCount(item) < amount then
        return false
    end
    return true
end

function ps.hasItems(items)
    if not items then return false end
    for k, v in pairs(items) do
        if not ps.hasItem(k, v) then
            return false
        end
    end
    return true
end

function ps.getItemCount(item)
    if not item then return end
    return exports.ox_inventory:Search('count', item)
end

RegisterNetEvent('ps_lib:client:createShop', function(shopData)
    if not shopData then shopData.name = 'Shop' end
    exports.ox_inventory:openInventory('shop', { type = shopData, id = shopData })
end)

exports('getImage', ps.getImage)
exports('getLabel', ps.getLabel)
exports('hasItem', ps.hasItem)
exports('hasItems', ps.hasItems)

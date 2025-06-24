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
    if exports.ox_inventory:GetItemCount(item) < amount then
        ps.notify('You need ' ..amount - exports.ox_inventory:GetItemCount(item) .. ' more ' .. ps.getLabel(item), 'error')
        return false
    end
    return true
end

RegisterNetEvent('ps_lib:client:createShop', function(shopData)
    if not shopData.name then shopData.name = 'Shop' end
    if not shopData.slots then shopData.slots = 50 end
    if not shopData.maxweight then shopData.maxweight = 100000 end
    exports.ox_inventory:RegisterShop(shopData.name, {
        name = shopData.name,
        slots = shopData.slots,
        maxweight = shopData.maxweight,
        items = shopData.items or {},
    })
    exports.ox_inventory:openInventory('shop', { type = shopData, id = shopData })
end)
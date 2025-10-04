
function ps.getImage(item)
    local itemData = QBCore.Shared.Items[item]
    if itemData then
        return 'nui://jpr-inventory/html/images/' .. itemData.image
    else
        return 'https://avatars.githubusercontent.com/u/99291234?s=280&v=4'
    end
end
function ps.getLabel(item)
    local itemData = QBCore.Shared.Items[item]
    if itemData then
        return itemData.label or item
    else
        return 'Missing Item'
    end
end
function ps.hasItem(item, amount)
    if not item then return false end
    if not amount then amount = 1 end

    return exports['jpr-inventory']:HasItem(item, amount)
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

exports('getImage', ps.getImage)
exports('getLabel', ps.getLabel)
exports('hasItem', ps.hasItem)
exports('hasItems', ps.hasItems)

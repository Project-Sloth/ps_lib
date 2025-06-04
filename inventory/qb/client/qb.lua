
function ps.getImage(item)
    local itemData = QBCore.Shared.Items[item].image
    if itemData then
        return 'nui://qb-inventory/html/images/' .. itemData
    else
        return nil
    end
end
function ps.getLabel(item)
    local itemData = QBCore.Shared.Items[item]
    if itemData then
        return itemData.label or item
    else
        return nil
    end
end
function ps.hasItem(item, amount)
    if not item then return end
    if not amount then amount = 1 end
    return exports['qb-inventory']:HasItem(item, amount)
end
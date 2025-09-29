

--@param item string
-- @return string
-- example: ps.getImage('bread')
function ps.getImage(item)
    local itemData = QBCore.Shared.Items[item]
    if itemData then
        return 'nui://qb-inventory/html/images/' .. itemData.image
    else
        return 'https://avatars.githubusercontent.com/u/99291234?s=280&v=4'
    end
end
-- @param item string
-- @return string
-- example: ps.getLabel('bread')
function ps.getLabel(item)
    local itemData = QBCore.Shared.Items[item]
    if itemData then
        return itemData.label or item
    else
        return 'Missing Item'
    end
end

--param item string
--param amount number
-- @return boolean
-- example: ps.hasItem('bread', 1)
function ps.hasItem(item, amount)
    if not item then return false end
    if not amount then amount = 1 end

    return exports['qb-inventory']:HasItem(item, amount)
end

--@param items table
--@return boolean
-- example: ps.hasItems({['bread'] = 1, ['water'] = 2})
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
    local amount = 0
    for k, v in pairs (ps.getPlayerData().items) do
        if v.name == item then
            amount = amount + v.amount
        end
    end
    return amount
end
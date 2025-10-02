

--@param item string
-- @return string
-- example: ps.getImage('bread')
function ps.getImage(item)
    local itemData = exports["tgiann-inventory"]:Items()
    itemData = itemData[item]

    if itemData then
        return 'nui://tgg-inventory/html/images/' .. itemData.image
    else
        return 'https://avatars.githubusercontent.com/u/99291234?s=280&v=4'
    end
end
-- @param item string
-- @return string
-- example: ps.getLabel('bread')
function ps.getLabel(item)
    local itemData = exports["tgiann-inventory"]:GetItemLabel(item)
    if itemData then
        return itemData
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

    return exports["tgiann-inventory"]:HasItem(item, amount)
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
    return exports["tgiann-inventory"]:GetItemCount(item, nil, nil)
end
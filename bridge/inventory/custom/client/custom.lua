-- returns path for image like nui://qb-inventory/html/images/item_image.png
function ps.getImage(item)
    
end

-- returns label for item like 'Water Bottle'
function ps.getLabel(item)
    
end

-- returns if you have item and amount in inventory
function ps.hasItem(item, amount)
    if not item then return false end
    if not amount then amount = 1 end

end

-- returns if you have all items and amounts in inventory
-- items is a table like {item1 = amount1, item2 = amount2}
function ps.hasItems(items)
    if not items then return false end
    for k, v in pairs(items) do
        if not ps.hasItem(k, v) then
            return false
        end
    end
    return true
end


function ps.addAccountMoney(id, amount, reason)
    if not id then 
        return false
    end
    if not amount or amount < 0 then 
        return false
    end
    exports['Renewed-Banking']:addAccountMoney(id, amount)
    return true
end

function ps.removeAccountMoney(id, amount, reason)
    if not id then
        return false
    end
    if not amount or amount < 0 then 
        return false
    end
    if exports['Renewed-Banking']:removeAccountMoney(id, amount) then
        return true
    end
    return false
end

function ps.getAccountMoney(id)
    if not id then
        return 0
    end
    local money = exports['Renewed-Banking']:getAccountMoney(id)
    if money then
        return money
    end
    return 0
end
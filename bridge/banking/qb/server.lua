
function ps.addAccountMoney(id, amount, reason)
    if not id then 
        return false
    end
    if not amount or amount < 0 then 
        return false
    end
    if not reason then
        reason = ""
    end
    exports['qb-banking']:AddMoney(id, amount, reason)
    return true
end

function ps.removeAccountMoney(id, amount, reason)
    if not id then
        return false
    end
    if not amount or amount < 0 then 
        return false
    end
    if not reason then
        reason = ""
    end
    if exports['qb-banking']:RemoveMoney(id, amount, reason) then
        return true
    end
    return false
end

function ps.getAccountMoney(id)
    if not id then
        return 0
    end
    local money = exports['qb-banking']:GetBalance(id)
    if money then
        return money
    end
    return 0
end
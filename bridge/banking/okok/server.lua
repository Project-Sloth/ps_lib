ps.success('Banking Module Loaded: OKOK Banking')
function ps.addAccountMoney(id, amount, reason)
    if not id then 
        return false
    end
    if not amount or amount < 0 then 
        return false
    end
    exports['okokBanking']:AddMoney(id, amount)
    return true
end

function ps.removeAccountMoney(id, amount, reason)
    if not id then
        return false
    end
    if not amount or amount < 0 then 
        return false
    end
    if exports['okokBanking']:RemoveMoney(id, amount) then
        return true
    end
    return false
end

function ps.getAccountMoney(id)
    if not id then
        return 0
    end
    local money = exports['okokBanking']:GetAccount(id)
    if money then
        return money
    end
    return 0
end
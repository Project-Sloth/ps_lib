local MySQL = require('oxmysql')

function ps.ORM.find(table, conditions)
    local query = 'SELECT * FROM ' .. table .. ' WHERE '
    local params = {}
    for key, value in pairs(conditions) do
        table.insert(params, value)
        query = query .. key .. ' = ? AND '
    end
    query = query:sub(1, -5) -- Remove the last ' AND '
    return MySQL.Async.fetchAll(query, params)
end

function ps.ORM.create(table, data)
    local columns = ''
    local placeholders = ''
    local params = {}
    for key, value in pairs(data) do
        columns = columns .. key .. ', '
        placeholders = placeholders .. '?, '
        table.insert(params, value)
    end
    columns = columns:sub(1, -3) -- Remove the last ', '
    placeholders = placeholders:sub(1, -3) -- Remove the last ', '
    local query = 'INSERT INTO ' .. table .. ' (' .. columns .. ') VALUES (' .. placeholders .. ')'
    return MySQL.Async.execute(query, params)
end

function  ps.ORM.update(table, data, conditions)
    local setClause = ''
    local params = {}
    for key, value in pairs(data) do
        setClause = setClause .. key .. ' = ?, '
        table.insert(params, value)
    end
    setClause = setClause:sub(1, -3) -- Remove the last ', '
    for key, value in pairs(conditions) do
        table.insert(params, value)
        setClause = setClause .. ' AND ' .. key .. ' = ?'
    end
    local query = 'UPDATE ' .. table .. ' SET ' .. setClause
    return MySQL.Async.execute(query, params)
end

function  ps.ORM.delete(table, conditions)
    local query = 'DELETE FROM ' .. table .. ' WHERE '
    local params = {} 
    for key, value in pairs(conditions) do
        table.insert(params, value)
        query = query .. key .. ' = ? AND '
    end
    query = query:sub(1, -5) -- Remove the last ' AND '

    return MySQL.Async.execute(query, params)
end

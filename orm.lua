ps.ORM = {}

--- Fetch all rows that match the condition asynchronously.
--- Or fetch all rows if `conditions == nil`.
---@param table string
---@param conditions table|nil
---@param cb function
function ps.ORM.find(table, conditions, cb)
    local query = 'SELECT * FROM ' .. table .. ' WHERE '
    local params = {}
    if conditions then
        for key, value in pairs(conditions) do
            params[#params + 1] = value
            query = query .. key .. ' = ? AND '
        end
        query = query:sub(1, -5)     -- Remove the last ' AND '
    else
        query = query:sub(1, -7)     -- Remove ' WHERE '
    end
    return MySQL.query(query, params, cb)
end

function ps.ORM.findOrderedLimited(table, conditions, orderBy, orderDirection, limit, cb)
    local query = 'SELECT * FROM ' .. table .. ' WHERE '
    local params = {}
    if conditions then
        for key, value in pairs(conditions) do
            params[#params + 1] = value
            query = query .. key .. ' = ? AND '
        end
        query = query:sub(1, -5) -- Remove the last ' AND '
    else
        query = query:sub(1, -7) -- Remove ' WHERE '
    end
    query = query .. ' ORDER BY ' .. orderBy .. ' ' .. orderDirection
    query = query .. ' LIMIT ' .. limit
    return MySQL.query(query, params, cb)
end

--- Create new rows in a table asynchronously.
---@param table string
---@param data table
---@param cb function
function ps.ORM.create(table, data, cb)
    local columns = ''
    local placeholders = ''
    local params = {}
    for key, value in pairs(data) do
        columns = columns .. key .. ', '
        placeholders = placeholders .. '?, '
        params[#params+1]=value
    end
    columns = columns:sub(1, -3) -- Remove the last ', '
    placeholders = placeholders:sub(1, -3) -- Remove the last ', '
    local query = 'INSERT INTO ' .. table .. ' (' .. columns .. ') VALUES (' .. placeholders .. ')'
    return MySQL.insert(query, params, cb)
end

--- Update fields in a table based on conditions asynchronously.
---@param table string
---@param data table
---@param conditions table
---@param cb function
function ps.ORM.update(table, data, conditions, cb)
    local setClause = ''
    local params = {}
    for key, value in pairs(data) do
        setClause = setClause .. key .. ' = ?, '
        params[#params + 1] = value
    end
    setClause = setClause:sub(1, -3) .. ' WHERE ' -- Remove the last ', '
    for key, value in pairs(conditions) do
        params[#params + 1] = value
        setClause = setClause .. key .. ' = ? AND '
    end
    setClause = setClause:sub(1, -5) -- Remove the last ' AND '
    local query = 'UPDATE ' .. table .. ' SET ' .. setClause
    return MySQL.update(query, params, cb)
end

--- Delete rows based on conditions asynchronously.
---@param table string
---@param data table
---@param conditions table
---@param cb function
function  ps.ORM.delete(table, conditions, cb)
    local query = 'DELETE FROM ' .. table .. ' WHERE '
    local params = {}
    for key, value in pairs(conditions) do
        params[#params + 1] = value
        query = query .. key .. ' = ? AND '
    end
    query = query:sub(1, -5) -- Remove the last ' AND '
    return MySQL.rawExecute(query, params, cb)
end

ps.ORM = {}
local cacheStore = {}

function ps.ORM.enableCache(table, opts)
    cacheStore[table] = {
        ttl = opts.ttl or 60,
        store = {}
    }
end

local function getCacheKey(table, conditions)
    return table .. ':' .. json.encode(conditions or {})
end

local function buildWhereClause(conditions)
    local query = ''
    local params = {}

    if conditions and next(conditions) then
        query = ' WHERE '
        for k, v in pairs(conditions) do
            query = query .. k .. ' = ? AND '
            table.insert(params, v)
        end
        query = query:sub(1, -5) -- Remove trailing AND sequence
    end

    return query, params
end


function ps.ORM.find(table, conditions, cb)
    local useCache = cacheStore[table]
    local cacheKey = getCacheKey(table, conditions)
    local whereClause, params = buildWhereClause(conditions)

    if useCache and useCache.store[cacheKey] then
        local entry = useCache.store[cacheKey]
        if os.time() < entry.expire then
            return cb(entry.data, params)
        else
            useCache.store[cacheKey] = nil
        end
    end

    local query = 'SELECT * FROM ' .. table .. whereClause

    MySQL.query(query, params, function(result)
        if useCache then
            useCache.store[cacheKey] = { data = result, expire = os.time() + useCache.ttl }
        end
        cb(result, params)
    end)
end

-- SELECT * FROM table WHERE ... LIMIT 1
function ps.ORM.findOne(table, conditions, cb)
    ps.ORM.find(table, conditions, function(results, params)
        cb(results and results[1], params)
    end)
end


function ps.ORM.count(table, conditions, cb)
    local whereClause, params = buildWhereClause(conditions)
    local query = 'SELECT COUNT(*) as count FROM ' .. table .. whereClause

    MySQL.scalar(query, params, function(result)
        cb(result, params)
    end)
end


function ps.ORM.update(table, data, conditions, cb)
    local setClause = ''
    local params = {}

    for k, v in pairs(data) do
        setClause = setClause .. k .. ' = ?, '
        table.insert(params, v)
    end
    setClause = setClause:sub(1, -3)

    local whereClause, whereParams = buildWhereClause(conditions)
    for _, v in ipairs(whereParams) do table.insert(params, v) end

    local query = 'UPDATE ' .. table .. ' SET ' .. setClause .. whereClause

    MySQL.update(query, params, function(affectedRows)
        cb(affectedRows, params)
    end)
end


function ps.ORM.create(table, data, cb)
    local fields, values, params = '', '', {}

    for k, v in pairs(data) do
        fields = fields .. k .. ', '
        values = values .. '?, '
        table.insert(params, v)
    end

    fields = fields:sub(1, -3)
    values = values:sub(1, -3)

    local query = 'INSERT INTO ' .. table .. ' (' .. fields .. ') VALUES (' .. values .. ')'

    MySQL.insert(query, params, function(insertId)
        cb(insertId, params)
    end)
end


function ps.ORM.delete(table, conditions, cb)
    local whereClause, params = buildWhereClause(conditions)
    local query = 'DELETE FROM ' .. table .. whereClause

    MySQL.update(query, params, function(affectedRows)
        cb(affectedRows, params)
    end)
end

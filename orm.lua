ps.ORM = {}  -- Main ORM table containing all database operations.

local cacheStore = {} -- Holds cache configurations and cached data per table.

-- Enables caching for a specific table with given options (e.g., TTL).
function ps.ORM.enableCache(table, opts)
    cacheStore[table] = {
        ttl = opts.ttl or 60, -- Time-to-live for cache entries, defaults to 60 seconds.
        store = {} -- Stores cached query results indexed by cache key.
    }
end

-- Generates a unique cache key based on table name and query conditions.
local function getCacheKey(table, conditions)
    return table .. ':' .. json.encode(conditions or {})
end

-- Builds a SQL WHERE clause and parameters from a conditions table.
local function buildWhereClause(conditions)
    local query = ''
    local params = {}

    if conditions and next(conditions) then
        query = ' WHERE '
        for k, v in pairs(conditions) do
            query = query .. k .. ' = ? AND '
            table.insert(params, v)
        end
        query = query:sub(1, -5) -- Remove trailing ' AND '.
    end

    return query, params
end

--- Retrieves multiple records from a table matching conditions, with optional caching.
---@param table string
---@param conditions table
---@param cb function
function ps.ORM.find(table, conditions, cb)
    local useCache = cacheStore[table]
    local cacheKey = getCacheKey(table, conditions)
    local whereClause, params = buildWhereClause(conditions)

    if useCache and useCache.store[cacheKey] then
        local entry = useCache.store[cacheKey]
        if os.time() < entry.expire then
            -- Return cached data if still valid.
            return cb(entry.data, params)
        else
            -- Cache expired, remove entry.
            useCache.store[cacheKey] = nil
        end
    end

    local query = 'SELECT * FROM ' .. table .. whereClause

    MySQL.query(query, params, function(result)
        if useCache then
            -- Cache the result with expiration.
            useCache.store[cacheKey] = { data = result, expire = os.time() + useCache.ttl }
        end
        cb(result, params)
    end)
end

--- Retrieves a single record matching conditions.
---@param table string
---@param conditions table
---@param cb function
function ps.ORM.findOne(table, conditions, cb)
    ps.ORM.find(table, conditions, function(results, params)
        cb(results and results[1], params)
    end)
end

--- Counts the number of records matching conditions.
---@param table string
---@param conditions table
---@param cb function
function ps.ORM.count(table, conditions, cb)
    local whereClause, params = buildWhereClause(conditions)
    local query = 'SELECT COUNT(*) as count FROM ' .. table .. whereClause

    MySQL.scalar(query, params, function(result)
        cb(result, params)
    end)
end

--- Updates records matching conditions with the given data.
---@param table string
---@param data table
---@param conditions table
---@param cb function
function ps.ORM.update(table, data, conditions, cb)
    local setClause = ''
    local params = {}

    for k, v in pairs(data) do
        setClause = setClause .. k .. ' = ?, '
        table.insert(params, v)
    end
    setClause = setClause:sub(1, -3) -- Remove trailing comma and space.

    local whereClause, whereParams = buildWhereClause(conditions)
    for _, v in ipairs(whereParams) do
        table.insert(params, v)
    end

    local query = 'UPDATE ' .. table .. ' SET ' .. setClause .. whereClause

    MySQL.update(query, params, function(affectedRows)
        cb(affectedRows, params)
    end)
end

--- Inserts a new record into a table.
---@param table string
---@param data table
---@param cb function
function ps.ORM.create(table, data, cb)
    local fields, values, params = '', '', {}

    for k, v in pairs(data) do
        fields = fields .. k .. ', '
        values = values .. '?, '
        table.insert(params, v)
    end

    fields = fields:sub(1, -3) -- Remove trailing comma and space.
    values = values:sub(1, -3)

    local query = 'INSERT INTO ' .. table .. ' (' .. fields .. ') VALUES (' .. values .. ')'

    MySQL.insert(query, params, function(insertId)
        cb(insertId, params)
    end)
end

--- Deletes records matching conditions.
---@param table string
---@param conditions table
---@param cb function
function ps.ORM.delete(table, conditions, cb)
    local whereClause, params = buildWhereClause(conditions)
    local query = 'DELETE FROM ' .. table .. whereClause

    MySQL.update(query, params, function(affectedRows)
        cb(affectedRows, params)
    end)
end

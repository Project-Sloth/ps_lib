--- Main ORM table containing all database operations.
---@class ORM
ps.ORM = {}

local cacheStore = {} -- Holds cache configurations and cached data per table.
local tableLocks = {} -- Simple lock table for race condition protection.

--- Acquires a lock for a table. Waits if already locked.
---@param table string
local function acquireLock(table)
    while tableLocks[table] do
        Citizen.Wait(0) -- Yield until lock is released (FiveM safe)
    end
    tableLocks[table] = true
end

--- Releases a lock for a table.
---@param table string
local function releaseLock(table)
    tableLocks[table] = nil
end

--- Enables caching for a specific table with given options (e.g., TTL).
---@param table string The table name to enable caching for.
---@param opts table Table of options (e.g., { ttl = number }).
function ps.ORM.enableCache(table, opts)
    acquireLock(table)
    cacheStore[table] = {
        ttl = opts.ttl or 60, -- Time-to-live for cache entries, defaults to 60 seconds.
        store = {} -- Stores cached query results indexed by cache key.
    }
    releaseLock(table)
end

--- Generates a unique cache key based on table name and query conditions.
---@param table string The table name.
---@param conditions table Query conditions.
---@return string cacheKey The generated cache key.
local function getCacheKey(table, conditions)
    return table .. ':' .. json.encode(conditions or {})
end

--- Builds a SQL WHERE clause and parameters from a conditions table.
---@param conditions table Query conditions.
---@return string whereClause The SQL WHERE clause.
---@return table params The parameters for the query.
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
--- Race condition safe for cache access.
---@param table string Table name.
---@param conditions table Query conditions.
---@param cb fun(results: table, params: table) Callback function.
function ps.ORM.find(table, conditions, cb)
    local useCache = cacheStore[table]
    local cacheKey = getCacheKey(table, conditions)
    local whereClause, params = buildWhereClause(conditions)

    if useCache then acquireLock(table) end
    if useCache and useCache.store[cacheKey] then
        local entry = useCache.store[cacheKey]
        if os.time() < entry.expire then
            if useCache then releaseLock(table) end
            return cb(entry.data, params)
        else
            useCache.store[cacheKey] = nil
        end
    end
    if useCache then releaseLock(table) end

    local query = 'SELECT * FROM ' .. table .. whereClause

    MySQL.query(query, params, function(result)
        if useCache then
            acquireLock(table)
            useCache.store[cacheKey] = { data = result, expire = os.time() + useCache.ttl }
            releaseLock(table)
        end
        cb(result, params)
    end)
end

--- Retrieves a single record matching conditions.
---@param table string Table name.
---@param conditions table Query conditions.
---@param cb fun(result: table, params: table) Callback function.
function ps.ORM.findOne(table, conditions, cb)
    ps.ORM.find(table, conditions, function(results, params)
        cb(results and results[1], params)
    end)
end

--- Counts the number of records matching conditions.
---@param table string Table name.
---@param conditions table Query conditions.
---@param cb fun(count: number, params: table) Callback function.
function ps.ORM.count(table, conditions, cb)
    local whereClause, params = buildWhereClause(conditions)
    local query = 'SELECT COUNT(*) as count FROM ' .. table .. whereClause

    MySQL.scalar(query, params, function(result)
        cb(result, params)
    end)
end

--- Updates records matching conditions with the given data.
--- Race condition safe for write operations.
---@param table string Table name.
---@param data table Data to update.
---@param conditions table Query conditions.
---@param cb fun(affectedRows: number, params: table) Callback function.
function ps.ORM.update(table, data, conditions, cb)
    acquireLock(table)
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
        releaseLock(table)
        cb(affectedRows, params)
    end)
end

--- Inserts a new record into a table.
--- Race condition safe for write operations.
---@param table string Table name.
---@param data table Data to insert.
---@param cb fun(insertId: number, params: table) Callback function.
function ps.ORM.create(table, data, cb)
    acquireLock(table)
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
        releaseLock(table)
        cb(insertId, params)
    end)
end

--- Deletes records matching conditions.
--- Race condition safe for write operations.
---@param table string Table name.
---@param conditions table Query conditions.
---@param cb fun(affectedRows: number, params: table) Callback function.
function ps.ORM.delete(table, conditions, cb)
    acquireLock(table)
    local whereClause, params = buildWhereClause(conditions)
    local query = 'DELETE FROM ' .. table .. whereClause

    MySQL.update(query, params, function(affectedRows)
        releaseLock(table)
        cb(affectedRows, params)

local function handleException(reason, value)
    if type(value) == 'function' then return tostring(value) end
    return reason
end
local resources = {}
---@param ... any
---@return string
local function formatArgs(...)
    local args = {...}
    local formatted = {}
    local jsonOptions = { sort_keys = true, indent = true, exception = handleException }


    for k, v in ipairs(args) do
        if type(v) == "table" then
            table.insert(formatted, json.encode(v, jsonOptions))
        elseif type(v) == "boolean" then
            table.insert(formatted, tostring(v))
        elseif v == nil then
            table.insert(formatted, 'nil')
        else
            table.insert(formatted, tostring(v))
        end
    end

    return table.concat(formatted, ' ')
end

-- TODO: convar for setting print levels

function ps.debug(...)
    local resource = GetInvokingResource() or 'ps_lib'
    if not resources[resource] then
        resources[resource] = {}
        resources[resource].debug = true
    end
    if not resources[resource].debug then
        return
    end
    print('^6[DEBUG]^0 ' .. formatArgs(...))
end

function ps.info(...)
    local resource = GetInvokingResource() or 'ps_lib'
    if not resources[resource] then
        resources[resource] = {}
        resources[resource].info = true
    end
    if not resources[resource].info then
        return
    end
    print('^4[INFO]^0 ' .. formatArgs(...))
end

function ps.error(...)
    local resource = GetInvokingResource() or 'ps_lib'
    if not resources[resource] then
        resources[resource] = {}
        resources[resource].error = true
    end
    if not resources[resource].error then
        return
    end
    print('^1[ERROR]^0 ' .. formatArgs(...))
end

function ps.warn(...)
    local resource = GetInvokingResource() or 'ps_lib'
    if not resources[resource] then
        resources[resource] = {}
        resources[resource].warn = true
    end
    if not resources[resource].warn then
        return
    end
    print('^3[WARNING]^0 ' .. formatArgs(...))
end

function ps.success(...)
    local resource = GetInvokingResource() or 'ps_lib'
    if not resources[resource] then
        resources[resource] = {}
        resources[resource].success = true
    end
    if not resources[resource].success then
        return
    end
    print('^2[SUCCESS]^0 ' .. formatArgs(...))
end

local function display(script)
    ps.debug(script .. ' debugs are active')
    ps.info(script .. ' infos are active')
    ps.error(script .. ' errors are active')
    ps.warn(script .. ' warnings are active')
    ps.success(script .. ' success are active')
end

local function adjustPrint(resource, type)
        if not resources[resource] then
            resources[resource] = {}
            resources[resource].debug = false
            resources[resource].info = false
            resources[resource].error = false
            resources[resource].warn = false
            resources[resource].success = false
        end
        if type == 'all' then
            resources[resource].debug = not resources[resource].debug
            resources[resource].info = not resources[resource].info
            resources[resource].error = not resources[resource].error
            resources[resource].warn = not resources[resource].warn
            resources[resource].success = not resources[resource].success
        end
        resources[resource][type] = not resources[resource][type]
    end
if IsDuplicityVersion() then
    RegisterNetEvent('ps_lib:print', function(resource, type)
       adjustPrint(resource, type)
       display(resource)
    end)
else
    RegisterNetEvent('ps_lib:client:print', function(key, resource, type)
        local can = ps.callback('ps_lib:print', key)
        if not can then
            return
        end
        adjustPrint(resource, type)
        display(resource)
    end)
end
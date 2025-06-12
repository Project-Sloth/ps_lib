
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
    --local resource = GetInvokingResource() or 'ps_lib'
    --if not resources[resource] then
    --    resources[resource] = {}
    --    resources[resource].debug = true
    --end
    --if not resources[resource].debug then
    --    return
    --end
    print('^6[DEBUG]^0 ' .. formatArgs(...))
end

function ps.info(...)
    --local resource = GetInvokingResource() or 'ps_lib'
    --if not resources[resource] then
    --    resources[resource] = {}
    --    resources[resource].info = true
    --end
    --if not resources[resource].info then
    --    return
    --end
    print('^4[INFO]^0 ' .. formatArgs(...))
end

function ps.error(...)
    --local resource = GetInvokingResource() or 'ps_lib'
    --if not resources[resource] then
    --    resources[resource] = {}
    --    resources[resource].error = true
    --end
    --if not resources[resource].error then
    --    return
    --end
    print('^1[ERROR]^0 ' .. formatArgs(...))
end

function ps.warn(...)
    --local resource = GetInvokingResource() or 'ps_lib'
    --if not resources[resource] then
    --    resources[resource] = {}
    --    resources[resource].warn = true
    --end
    --if not resources[resource].warn then
    --    return
    --end
    print('^3[WARNING]^0 ' .. formatArgs(...))
end

function ps.success(...)
    --local resource = GetInvokingResource() or 'ps_lib'
    --if not resources[resource] then
    --    resources[resource] = {}
    --    resources[resource].success = true
    --end
    --if not resources[resource].success then
    --    return
    --end
    print('^2[SUCCESS]^0 ' .. formatArgs(...))
end

if IsDuplicityVersion() then
    RegisterCommand('psprints', function(source, args, rawCommand)
        if not IsPlayerAceAllowed(source, 'command') then 
            print('You do not have permission to use this command.')
            return
        end
        local resource = args[1]
        if not resources[resource] then
            return
        end
        if args[2] == 'debug' then
            if resources[resource].debug then
                resources[resource].debug = true
                print('Debug mode for resource ' .. resource .. ' is now disabled')
            else
                resources[resource].debug = true
                ps.debug('Debug mode for resource ' .. resource .. ' is now enabled')
            end
            ps.success('Debug mode for resource ' .. resource .. ' is now ' .. (resources[resource].debug and 'enabled' or 'disabled'))
        elseif args[2] == 'info' then
            if resources[resource].info then
                resources[resource].info = true
                print('Info mode for resource ' .. resource .. ' is now disabled')
            else
                resources[resource].info = true
                ps.info('Info mode for resource ' .. resource .. ' is now enabled')
            end
        elseif args[2] == 'error' then
            if resources[resource].error then
                resources[resource].error = true
                print('Error mode for resource ' .. resource .. ' is now disabled')
            else
                resources[resource].error = true
                ps.error('Error mode for resource ' .. resource .. ' is now enabled')
            end
        elseif args[2] == 'warn' then
            if resources[resource].warn then
                resources[resource].warn = true
                print('Warning mode for resource ' .. resource .. ' is now disabled')
            else
                resources[resource].warn = true
                ps.warn('Warning mode for resource ' .. resource .. ' is now enabled')
            end
        elseif args[2] == 'success' then
            if resources[resource].success then
                resources[resource].success = true
                print('Success mode for resource ' .. resource .. ' is now disabled')
            else
                resources[resource].success = true
                ps.success('Success mode for resource ' .. resource .. ' is now enabled')
            end
        else
            ps.error('Invalid command. Use: psprints <resource> <debug|info|error|warn|success>')
        end
    end, false)
end
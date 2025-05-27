---@param ... any
---@return string
local function formatArgs(...)
    local args = {...}
    local formatted = {}

    for k, v in ipairs(args) do
        if type(v) == "table" then
            table.insert(formatted, json.encode(v))
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
    print('^6[DEBUG]^0 ' .. formatArgs(...))
end

function ps.info(...)
    print('^4[INFO]^0 ' .. formatArgs(...))
end

function ps.error(...)
    print('^1[ERROR]^0 ' .. formatArgs(...))
end

function ps.warn(...)
    print('^3[WARNING]^0 ' .. formatArgs(...))
end

function ps.success(...)
    print('^2[SUCCESS]^0 ' .. formatArgs(...))
end
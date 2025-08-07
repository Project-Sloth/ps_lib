if not Config.ConvertQBMenu then
    return
end
local function getType(eventType)
    if eventType then
        return 'server'
    else
        return 'client'
    end
end

local function convertToPs(data)
    local psData, title = {}, nil
    for k,v in pairs(data) do
        if v.isMenuHeader then
            title = v.header
            goto continue
        end
        psData[#psData + 1] = {
            title = v.header or '',
            description = v.txt or '',
            icon = v.icon or nil,
            disabled = v.disabled or false,
            action = v.action or (v.params and v.params.isAction) or nil,
            event = v.params and v.params.event or nil,
            args = v.params and v.params.args or nil,
            type = getType(v.params and v.params.isServer) or nil,
        }
        ::continue::
    end
    exports['ps-ui']:showContext({
        name = title,
        items = psData
    })
end

ps.exportChange('qb-menu', 'openMenu', convertToPs)
ps.exportChange('qb-menu', 'closeMenu', function()
    exports['ps-ui']:HideMenu()
end)

ps.exportChange('qb-menu', 'showHeader', function(data)
    local title = data[1].header
    local psData = {}
    for k,v in pairs(data) do
        if v.isMenuHeader then
            title = v.header
            goto continue
        end
        psData[#psData + 1] = {
            title = v.header or '',
            description = v.txt or '',
            icon = v.icon or nil,
            disabled = v.disabled or false,
            action = v.action or (v.params and v.params.isAction) or nil,
            event = v.params and v.params.event or nil,
            args = v.params and v.params.args or nil,
            type = getType(v.params and v.params.isServer) or nil,
        }
        ::continue::
    end
    exports['ps-ui']:showContext({
        name = title,
        items = psData
    })
end)

local function convertOptionsInput(data)
    local options = {}
    for k, v in pairs(data) do
        options[k] = {
            label = v.text or nil,
            value = v.value or nil,
        }
    end
    return options
end

local function overWriteInput(data)
    local name = data.header or 'Input'
    local options, tabl = {}, {}
    for k, v in pairs(data.inputs) do
        options[#options + 1] = {
            id = k,
            name = v.name or k,
            title = v.text or nil,
            type = v.type or 'input',
            description = v.txt or nil,
            placeholder = v.default or nil,
            options = convertOptionsInput(v.options or {}),
            required = v.isRequired or false,
            min = v.min or nil,
            max = v.max or nil,
        }
        tabl[v.name] = v.default or nil
    end
    local result = exports.ps_lib:input(name, options)
    if not result or not result[1] then
        return nil
    end
    for k, v in pairs (options) do
        if v.id == k then
            tabl[v.name] = result[k]
        end
    end
   return tabl
end

ps.exportChange('qb-input', 'ShowInput', overWriteInput)

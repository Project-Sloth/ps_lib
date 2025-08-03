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


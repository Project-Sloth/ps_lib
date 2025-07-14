if not Config.QBMenuOverride then
    return
end
ps.exportChange('qb-menu', 'openMenu', function(data)
    local newMenu = {}
    newMenu.items = {}
    newMenu.name = 'Context Menu'
    for k, v in pairs(data) do
        if v.isMenuHeader then 
            newMenu.name = v.header or 'Missing Name'
        end
        table.insert(newMenu.items, {
            title = v.header or 'Missing Title',
            icon = v.icon or nil,
            description = v.txt or '',
            action = v.action or nil,
            event = v.event or (v.params and v.params.event) or nil,
            type = v.type or 'client',
            args = v.args or (v.params and v.params.args) or {},
        })
    end
    exports['ps-ui']:showContext(newMenu)
end)

ps.exportChange('qb-menu', 'closeMenu', function()
    exports['ps-ui']:HideMenu()
end)

ps.exportChange('qb-input', 'ShowInput', function(data)
    local newInput = {}
    for k, v in pairs(data) do
        table.insert(newInput, {
            title = v.title or '',
            type = v.type or 'text',
            description = v.description or '',
            placeholder = v.placeholder or '',
            options = v.options or nil,
            required = v.isRequired or false,
        })
    end
    local test = exports['ps-ui']:input('input', newInput)
    return test
end)
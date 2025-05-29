
ps.exportChange('qb-menu', 'openMenu', function(data)
    local newMenu = {}
    for k, v in pairs(data) do
        table.insert(newMenu, {
            id =  k,
            header = v.header or '',
            text = v.txt or nil,
            icon = v.icon or nil,
            event = v.params and v.params.event or nil,
            args = v.params and v.params.args or {},
            server = v.params and v.params.server or false,
            action = v.action or nil
        })
    end
    exports['ps-ui']:CreateMenu(newMenu)
end)

ps.exportChange('qb-menu', 'closeMenu', function()
    exports['ps-ui']:HideMenu()
end)

ps.exportChange('qb-input', 'ShowInput', function(data)
    local newInput = {}
    for k, v in pairs(data.inputs) do
        table.insert(newInput, {
            id = v.name or k,
            label = v.header or '',
            type = v.type or 'text',
            icon = v.icon or nil,
        })
    end
    local test = exports['ps-ui']:Input(newInput)
end)

RegisterCommand("qb-menu", function()
    local input = exports['ps-ui']:Input({
        title = "Test",
        inputs = {
            {
                type = "checkbox",
                placeholder = "test2"
            },
            {
                type = "password",
                placeholder = "password"
            },
            {
                type = "checkbox",
                placeholder = "666"
            },
        }
    })
    ps.debug(input)
end)
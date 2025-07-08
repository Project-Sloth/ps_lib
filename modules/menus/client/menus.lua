--if not Config.QBMenuOverride then
--    return
--end
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
            description = v.txt or nil,
            action = v.action or nil,
            event = v.event or nil,
            type = v.type or 'client', -- default to client if not specified
            args = v.args or {}, -- default to empty table if not specified
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
            options = v.options or nil, -- options for select, checkbox, etc.
        })
    end
    local test = exports['ps-ui']:input('input', newInput)
    return test
end)

RegisterCommand('Tesat', function()
    exports['qb-menu']:openMenu({
    { 
        header = "First Item", 
        icon = ps.getImage('lockpick'), 
        txt = "Description",
        isMenuHeader = false,
        disabled = false,
        hidden = false,
        params = {
            event = "event:name",
            args = { arg1 = "value1" },
            isServer = false,
            isCommand = false,
            isQBCommand = false,
            isAction = false
        }
    },
    { 
        header = "Second Item", 
        txt = "Another description",
        isMenuHeader = false,
        disabled = true,
        hidden = false
    },
    {
        header = "Third Item", 
        txt = "Another description",
        action = function()
           print('You selected the Third Item')
        end
    }
})end, false)

RegisterCommand('TestInput', function()
    local value = exports['qb-input']:ShowInput({
            {
                title = "Name",
                type = "text",
                description = "Enter your name",
                placeholder = "John Doe"
            },
            {
                title = "Age",
                type = "number",
                description = "Enter your age",
                placeholder = "30"
            },
            {
                title = "Gender",
                type = "select",
                description = "Select your gender",
                placeholder = "Select...",
                options = {
                    { label = "Male", value = "male" },
                    { label = "Female", value = "female" },
                    { label = "Other", value = "other" }
                }
            }
        }
    
    )
    ps.debug('Input Result:', value)
end, false)
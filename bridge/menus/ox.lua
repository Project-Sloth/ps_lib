

function ps.menu(name, label, data)
    local options = {}
    for k, v in pairs (data or {}) do
        local serverEvent, event = nil, nil
        if v.isServer then
            serverEvent = v.event
        else
            event = v.event
        end
        options[k] = {
            title = v.title or '',
            description = v.description or '',
            icon = v.icon or nil,
            disabled = v.disabled or nil,
            onSelect = v.action or nil,
            event = event,
            args = v.args or nil,
            serverEvent = serverEvent
        }
    end
    lib.registerContext({
        id = name,
        title = label or 'Context Menu',
        options = options,
    })
    lib.showContext(name)
end

function ps.closeMenu()
    lib.hideContext()
end

function ps.input(label, data)
    local options = {}

    for k, v in pairs(data or {}) do
        if v.type == 'text' then
            v.type = 'input'
        end
        options[k] = {
            label = v.title or nil,
            type = v.type or 'input',
            description = v.description or nil,
            placeholder = v.placeholder or nil,
            options = v.options or nil,
            required = v.required or false,
            min = v.min or nil,
            max = v.max or nil,
        }
    end

    local result = lib.inputDialog(label, options)
    if result and result[1] then
        return result
    else
        return nil
    end
end
exports('menu', ps.menu)
exports('closeMenu', ps.closeMenu)
exports('input', ps.input)
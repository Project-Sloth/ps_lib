

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
    exports.lation_ui:registerMenu({
        id = name,
        title = label or 'Context Menu',
        options = options,
    })
    exports.lation_ui:showMenu(name)
end

function ps.closeMenu()
    exports.lation_ui:hideMenu()
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

    local result = exports.lation_ui:input({
        title = label,
        options = options
    })
    if result and result[1] then
        return result
    else
        return nil
    end
end
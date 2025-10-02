

function ps.menu(name, label, data)
    local options = {}
    for k, v in ipairs(data or {}) do
        local type = nil
        if v.isServer then
            type = 'server'
        end
        options[#options + 1] = {
            title = v.title or '',
            description = v.description or '',
            icon = v.icon or nil,
            disabled = v.disabled or nil,
            action = v.action or nil,
            event = v.event or nil,
            args = v.args or nil,
            type = type or nil
        }
    end
    exports['ps-ui']:showContext({
        name = name,
        items = options
    })
end

function ps.closeMenu()
    exports['ps-ui']:HideMenu()
end

function ps.input(label, data)
    local options = {}
    for k, v in pairs(data or {}) do
        if v.type == 'input' then
            v.type = 'text'
        end
        options[k] = {
            title = v.title or nil,
            type = v.type or 'input',
            description = v.description or nil,
            placeholder = v.placeholder or nil,
            options = v.options or nil,
            required = v.required or false,
            min = v.min or nil,
            max = v.max or nil,
        }
    end

    local result = exports.ps_lib:input(label, options)
    if result and result[1] then
        return result
    else
        return nil
    end
end
exports('menu', ps.menu)
exports('closeMenu', ps.closeMenu)
exports('input', ps.input)
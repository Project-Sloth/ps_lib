

function ps.menu(name, label, data)
    local options = {}
    options[#options + 1] = {
        header = label or 'Menu',
        isMenuHeader = true,
    }
    for k, v in ipairs(data or {}) do
        options[#options + 1] = {
            header = v.title or '',
            txt = v.description or '',
            icon = v.icon or nil,
            disabled = v.disabled or nil,
            action = v.action or nil,
            params = {
                event = v.event or nil,
                args = v.args or nil,
                isServer = v.isServer or nil,
                isCommand = v.isCommand or nil,
                isQBCommand = v.isQBCommand or nil,
                isAction = v.isAction or nil,
            }
        }
    end
    exports['qb-menu']:openMenu(options)
end

function ps.closeMenu()
    exports['qb-menu']:closeMenu()
end

-- had to not use qb input as it sends data in an unfortunate way and ps_lib input is more flexible
function ps.input(label, data)
    local options = {}
    for k, v in pairs(data or {}) do
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
local keybinds = {}

function ps.addKeybind(key, command, message)
    if not keybinds[key] then
        keybinds[key] = {
            command = command,
            disabled = false
        }

        RegisterCommand(key, function()
            if not keybinds[key].disabled then
                ExecuteCommand(keybinds[key].command)
            end
        end, false)

        message = message == nil and ('Keyboard for %s'):format(key) or message

        RegisterKeyMapping(key, message, 'keyboard', key)
    else
        if keybinds[key].disabled then
            keybinds[key].disabled = false
        else
            ps.debug('Keybind already exists')
        end
    end
end

function ps.removeKeybind(key)
    if keybinds[key] then
        keybinds[key].disabled = true
    else
       ps.debug('Keybind does not exist')
    end
end

exports('addKeybind', ps.addKeybind)
exports('removeKeybind', ps.removeKeybind)

local keybinds = {}

function ps.addKeybind(key, commmand) 
    if not keybinds[key] then
        keybinds[key] = {command = commmand, disabled = false}
        RegisterCommand(key, function()
            if not keybinds[key].disabled then
                ExecuteCommand(keybinds[key].command)
            end
        end, false)
        RegisterKeyMapping(key, 'Keybind for ' .. key, 'keyboard', key)
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
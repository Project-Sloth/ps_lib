
if IsDuplicityVersion() then
    function ps.addCommand(name, info, args,  func)
        if not info.admin then info.admin = false end
        local can = false
        if info.admin ~= false then
            can = true
        end
        RegisterCommand(name, function(source, args, rawCommand)
            if info.admin ~= false then
                if not IsPlayerAceAllowed(source, 'command') then
                    ps.debug('Player has permission to use this command')
                return end
            end
            func(source, args, rawCommand)
        end, can)
    end
else
    function ps.addCommand(name, args, func)
        ps.debug('Remove ' ..  name ..  ' From The Client! ps.addCommand Is Server-Side Only!')
    end
end

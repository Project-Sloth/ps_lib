
function ps.copyClipboard(text)
    SendNUIMessage({
        action = 'copyClipboard',
        data = text
    })
end

RegisterCommand('testCopyClipboard', function(source, args, rawCommand)
    local text = table.concat(args, ' ')
    ps.copyClipboard(text)
end, false)
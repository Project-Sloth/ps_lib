
function ps.copyClipboard(text)
    SendNUIMessage({
        action = 'copyClipboard',
        data = text
    })
end
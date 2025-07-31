local function drawText(text)
    if not text or type(text) ~= 'string' or text == '' then
        return
    end

    SendNUIMessage({
        action = 'drawText',
        data = text
    })
end

exports('drawText', drawText)
ps.exportChange('ps-ui', 'drawText', drawText)

local function hideDrawText()
    SendNUIMessage({
        action = 'hideDrawText'
    })
end

exports('hideDrawText', hideDrawText)
ps.exportChange('ps-ui', 'hideDrawText', hideDrawText)

RegisterCommand('testDrawText', function(source, args, rawCommand)
    drawText('[E] To Yee Haw ')
end, false)

RegisterCommand('hideDrawText', function()
    hideDrawText()
end, false)
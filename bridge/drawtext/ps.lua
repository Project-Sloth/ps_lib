ps.success('Draw Text Module Loaded: PS-UI')

function ps.drawText(text)
    if not text then return end
    exports['ps-ui']:drawText(text, "yellow")
end

function ps.hideText()
    exports['ps-ui']:hideDrawText()
end

exports('drawText', ps.drawText)
exports('hideText', ps.hideText)
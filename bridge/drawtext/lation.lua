ps.success('Draw Text Module Loaded: Lation UI')

function ps.drawText(text)
    if not text then return end
    exports.lation_ui:showText(text)
end

function ps.hideText()
    exports.lation_ui:hideText()
end

exports('drawText', ps.drawText)
exports('hideText', ps.hideText)
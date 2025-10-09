ps.success('Draw Text Module Loaded: ox_lib')

function ps.drawText(text)
    if not text then return end
    lib.showTextUI(text)
end

function ps.hideText()
    lib.hideTextUI()
end

exports('drawText', ps.drawText)
exports('hideText', ps.hideText)
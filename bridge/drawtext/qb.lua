function ps.drawText(text)
    if not text then return end
    exports['qb-core']:ShowText(text)
end

function ps.hideText()
    exports['qb-core']:HideText()
end
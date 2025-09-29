function ps.drawText(text)
    if not text then return end
    exports['ps-ui']:drawText(text, "yellow")
end

function ps.hideText()
    exports['ps-ui']:hideDrawText()
end
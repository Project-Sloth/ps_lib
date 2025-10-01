function ps.drawText(text)
    if not text then return end
    exports['okokTextUI']:Open(text, 'lightgrey', 'right', true)
end

function ps.hideText()
    exports['okokTextUI']:Close()
end
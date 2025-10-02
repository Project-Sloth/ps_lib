function ps.notify(text, type, time)
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    if type == 'error' then
        exports['mad-thoughts']:error(text, time / 1000)
    elseif type == 'success' then
        exports['mad-thoughts']:success(text, time / 1000)
    elseif type == 'info' then
        exports['mad-thoughts']:info(text, time / 1000)
    elseif type == 'warning' then
        exports['mad-thoughts']:warning(text, time / 1000)
    end
end

exports('notify', ps.notify)
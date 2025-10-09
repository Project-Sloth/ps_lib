function ps.notify(source, text, type, time)
    if not source then return end
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    if type == 'error' then
        exports['mad-thoughts']:error(source, text, time / 1000)
    elseif type == 'success' then
        exports['mad-thoughts']:success(source, text, time / 1000)
    elseif type == 'info' then
        exports['mad-thoughts']:info(source, text, time / 1000)
    elseif type == 'warning' then
        exports['mad-thoughts']:warning(source, text, time / 1000)
    end
end
exports('notify', ps.notify)
ps.success('Notification Module Loaded: Mad Thoughts')
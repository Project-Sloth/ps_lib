function ps.notify(text, type, time)
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    exports['ps_lib']:notify(text, type, time)
end
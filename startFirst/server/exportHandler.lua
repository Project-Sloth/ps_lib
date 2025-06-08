function ps.exportChange(resource, exportname, func)
     AddEventHandler(('__cfx_export_%s_%s'):format(resource, exportname), function(setCallback)
        setCallback(func)
    end)
end
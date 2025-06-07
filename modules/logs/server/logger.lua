
if Config.Logs == 'fivemerr' then
    function ps.log(dataSet, level, message, meta)
        exports['fm-logs']:createLog({
            logType = dataSet,
            message = message,
            level = level, 
            resource = GetInvokingResource() or 'ps_lib',
            source = meta.source or nil,
            Metadata = meta,
        },{Screenshot = false})
    end
    function ps.logImage(source, name, description)
        exports['fm-logs']:createLog({
            logType = name,
            message = description,
            level = 'Image', 
            resource = GetInvokingResource() or 'ps_lib',
            source = source or nil,
            Metadata = {},
        },{Screenshot = true})
    end
end
if Config.Logs == 'fivemanage' then 
    function ps.log(dataSet, level, message, meta)
        exports.fmsdk:Log(dataSet, level, message, meta)
    end
    function ps.logImage(source, name, description)
        if not source then return end
        if not name then name = ps.getPlayerName(source) end
        if not description then description = name .. 's image' end
        local imageData = exports.fmsdk:takeServerImage(source, {
            name = name, 
            description = description,
        })
        return imageData
    end
end


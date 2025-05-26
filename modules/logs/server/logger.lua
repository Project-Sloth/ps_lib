local logapi = ''
if Config.Logs == 'fivemerr' then
    local endpoint = 'https://api.fivemerr.com/v1/logs'
    local headers = {
                ['Authorization'] = logapi,
                ['Content-Type'] = 'application/json',
        }
    function ps.log(message, meta)
        local buffer = {
            level = "info",
            message = message,
            resource = GetInvokingResource() or GetCurrentResourceName(),
            metadata = meta,
        }
         SetTimeout(500, function()
             PerformHttpRequest(endpoint, function(status, _, _, response)
                 if status ~= 200 then 
                     if type(response) == 'string' then
                         response = json.decode(response) or response
                     end
                 end
             end, 'POST', json.encode(buffer), headers)
             buffer = nil
         end)
    end
end

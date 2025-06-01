function ps.versionCheck(script, link, updateLink)
    if not script or not link then
        ps.debug("Invalid parameters for version check")
        return
    end

    local currentVersion = GetResourceMetadata(script, "version", 0)
    if not currentVersion then
        ps.debug("Could not retrieve current version for " .. script)
        return
    end

     PerformHttpRequest(link, function(err, text, headers)
         if (text ~= nil) then
            if currentVersion == text then
                ps.debug('^2 ' .. script .. ' is up to date: ' .. currentVersion)
            else
                ps.debug('^1 ' .. script .. ' is outdated! Please update to version: ' .. text)
                print('Download Here: ' .. (updateLink or 'link not provided'))
            end
         end
     end, "GET", "", "")
end

ps.versionCheck('ps_lib', 'https://raw.githubusercontent.com/Mustachedom/md-drugs/main/version.txt', 'https://github.com/Project-Sloth/ps_lib')
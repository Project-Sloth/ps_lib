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
        local remoteVersion = nil
        local changelogLines = {}
        for line in string.gmatch(text, "[^\r\n]+") do
            if not remoteVersion then
                local match = string.match(line, "Newest Build:%s*(.+)")
                if match then
                    remoteVersion = match
                    goto continue
                end
            else
                table.insert(changelogLines, line)
            end
            ::continue::
        end

        if remoteVersion then
            if currentVersion == remoteVersion then
                ps.success('^2 ' .. script .. ' is up to date: ' .. currentVersion)
            else
                ps.warn('^1 ' .. script .. ' is outdated! Please update to version: ' .. remoteVersion)
                ps.warn('Download Here: ' .. (updateLink or 'link not provided'))
                ps.info('Changelog:  \n ', table.concat(changelogLines, "  \n  "))
            end
        else
            ps.debug("Remote version not found in expected format.")
        end
    end, "GET", "", "")
end
-- TODO: on release ill need to PR this to get the raw link for version check :) 
ps.versionCheck('ps_lib', 'https://raw.githubusercontent.com/Project-Sloth/ps_lib/refs/heads/main/changelog', 'https://github.com/Project-Sloth/ps_lib')
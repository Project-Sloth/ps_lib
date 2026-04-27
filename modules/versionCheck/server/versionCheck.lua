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
        if not text or type(text) ~= "string" then
            ps.debug("Empty or invalid HTTP response for version check: " .. tostring(err))
            return
        end

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
function ps._splitVersion(v)
    local parts = {}
    for num in string.gmatch(v or "", "(%d+)") do
        table.insert(parts, tonumber(num))
    end
    return parts
end

function ps._compareVersions(a, b)
    local pa = ps._splitVersion(a)
    local pb = ps._splitVersion(b)
    local n = math.max(#pa, #pb)
    for i = 1, n do
        local va = pa[i] or 0
        local vb = pb[i] or 0
        if va < vb then
            return -1
        elseif va > vb then
            return 1
        end
    end
    return 0
end

function ps.versionCheck(script, link, updateLink, opts)
    opts = opts or {}
    if not script or not link then
        ps.debug("versionCheck: invalid parameters")
        return
    end

    local currentVersion = GetResourceMetadata(script, "version", 0)
    if not currentVersion or currentVersion == "" then
        ps.debug("versionCheck: could not retrieve current version for " .. tostring(script))
        return
    end

    PerformHttpRequest(link, function(statusOrErr, body, headers)
        if not body or type(body) ~= "string" then
            ps.debug("versionCheck: empty or invalid HTTP response: " .. tostring(statusOrErr))
            return
        end

        local remoteVersion
        local changelogLines = {}

        -- Try to extract a line like: Newest Build: 1.2.3 or a semantic version token
        for line in string.gmatch(body, "[^\r\n]+") do
            if not remoteVersion then
                local m = string.match(line, "Newest Build:%s*(%S+)") or string.match(line, "version[:%s]+(%S+)")
                if m then
                    remoteVersion = m
                else
                    local sem = string.match(line, "(%d+%.%d+%.%d+[-%+%w]*)")
                    if sem then
                        remoteVersion = sem
                    end
                end
            else
                table.insert(changelogLines, line)
            end
        end

        if not remoteVersion then
            ps.debug("versionCheck: remote version not found in response")
            return
        end

        local cmp = ps._compareVersions(currentVersion, remoteVersion)
        if cmp == 0 then
            ps.success('^2 ' .. tostring(script) .. ' is up to date: ' .. tostring(currentVersion))
        elseif cmp < 0 then
            ps.warn('^1 ' .. tostring(script) .. ' is outdated! Installed: ' .. tostring(currentVersion) .. '  Available: ' .. tostring(remoteVersion))
            ps.warn('Download: ' .. (updateLink or 'not provided'))
            if opts.showChangelog and #changelogLines > 0 then
                ps.info('Changelog:\n' .. table.concat(changelogLines, '\n'))
            end
        else
            ps.info('^3 ' .. tostring(script) .. ' has a newer version installed (' .. tostring(currentVersion) .. ') than remote (' .. tostring(remoteVersion) .. ').')
        end
    end, "GET", "", { })
end

-- Example convenience call
ps.versionCheck('ps_lib', 'https://raw.githubusercontent.com/Project-Sloth/ps_lib/refs/heads/main/changelog.txt', 'https://github.com/Project-Sloth/ps_lib', { showChangelog = false })

exports('versionCheck', ps.versionCheck)
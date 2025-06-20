local lang = {}

function ps.insertLang(langTable)
    local resource = GetInvokingResource()
    if not lang[resource] then
        lang[resource] = langTable
    end
    ps.success('Language loaded for resource: ' .. resource)
    ps.debug(lang[resource])
end

function ps.lang(key, ...)
    local resource = GetInvokingResource()
    if lang[resource] and lang[resource][key] then
        return string.format(lang[resource][key], ...)
    else
        -- Wait for the language to load
        -- This is a blocking call, so it will wait until the language is loaded or timeout after 60 seconds
        local time = 60
        repeat
            Wait(1000)
            time = time - 1
        until time == 0 or lang[resource] and lang[resource][key]
        if time > 0 then
            return string.format(lang[resource][key], ...)
        end
        return 'Need to load language first: ' .. key
    end
end

function ps.locale(key, ...)
    local resource = GetInvokingResource()
    if lang[resource] and lang[resource][key] then
        return string.format(lang[resource][key], ...)
    else
        -- Wait for the language to load
        -- This is a blocking call, so it will wait until the language is loaded or timeout after 60 seconds
        local time = 60
        repeat
            Wait(1000)
            time = time - 1
        until time == 0 or lang[resource] and lang[resource][key]
        if time > 0 then
            return string.format(lang[resource][key], ...)
        end
        return 'Need to load language first: ' .. key
    end
end

function ps.getLang()
    local resource = GetInvokingResource()
    if lang[resource] then
        return lang[resource]
    else
        ps.error('No language loaded for resource: ' .. resource)
        return {}
    end
end

function ps.getLocale()
    local resource = GetInvokingResource()
    if lang[resource] then
        return lang[resource]
    else
        ps.error('No locale loaded for resource: ' .. resource)
        return {}
    end
end

AddEventHandler('onResourceStop', function(resource)
    if lang[resource] then
        lang[resource] = nil
        ps.success('Language unloaded for resource: ' .. resource)
    end
end)

function ps.loadLangs(language)
    local resource = GetInvokingResource()
    if not resource then
        ps.error('No invoking resource found.')
        return false
    end

    local filePath = 'locales/' .. language .. '.json'
    local langFile = LoadResourceFile(resource, filePath)

    if not langFile then
        ps.error('Language file not found: ' .. language .. ' for resource: ' .. resource)
        return false
    end

    local decoded = json.decode(langFile, 1, nil)
    if not decoded then
        ps.error('Error decoding JSON from ' .. filePath)
        return false
    end
    lang[resource] = decoded
    return true
end

local function loadLangsInternal(script, language)
    local resource = script
    if not resource then
        ps.error('No invoking resource found.')
        return false
    end

    local filePath = 'locales/' .. language .. '.json'
    local langFile = LoadResourceFile(resource, filePath)

    if not langFile then
        ps.error('Language file not found: ' .. language .. ' for resource: ' .. resource)
        return false
    end

    local decoded = json.decode(langFile, 1, nil)
    if not decoded then
        ps.error('Error decoding JSON from ' .. filePath)
        return false
    end
    lang[resource] = decoded
    ps.success('Language loaded for resource: ' .. resource)
    return true
end

local psScripts = {
    ['ps-banking'] = true,
    ['ps-realtor'] = true,
    ['ps-mdt'] = true,
    ['ps-dispatch'] = true,
    ['ps-multijob'] = true,
}
AddEventHandler('onResourceStart', function(resourceName)
    if psScripts[resourceName] then
        loadLangsInternal(resourceName, langs)
    end
end)
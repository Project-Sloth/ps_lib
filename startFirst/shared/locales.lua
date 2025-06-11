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
        ps.error('Language key not found: ' .. key .. ' in resource: ' .. resource)
        return key -- Fallback to the key itself if not found
    end
end

function ps.locale(key, ...)
    local resource = GetInvokingResource()
    if lang[resource] and lang[resource][key] then
        return string.format(lang[resource][key], ...)
    else
        ps.error('Locale key not found: ' .. key .. ' in resource: ' .. resource)
        return key -- Fallback to the key itself if not found
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
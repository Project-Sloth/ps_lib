local lang = {}

function ps.insertLang(langTable)
    local resource = GetCurrentResourceName()
    if not lang[resource] then
        lang[resource] = langTable
    end
    ps.success('Language loaded for resource: ' .. resource)
end

function ps.lang(key, ...)
    local resource = GetCurrentResourceName()
    if lang[resource] and lang[resource][key] then
        return string.format(lang[resource][key], ...)
    else
        ps.error('Language key not found: ' .. key .. ' in resource: ' .. resource)
        return key -- Fallback to the key itself if not found
    end
end

function ps.locale(key, ...)
    local resource = GetCurrentResourceName()
    if lang[resource] and lang[resource][key] then
        return string.format(lang[resource][key], ...)
    else
        ps.error('Locale key not found: ' .. key .. ' in resource: ' .. resource)
        return key -- Fallback to the key itself if not found
    end
end

function ps.getLangs()
    local resource = GetCurrentResourceName()
    if lang[resource] then
        return lang[resource]
    else
        ps.error('No language loaded for resource: ' .. resource)
        return {}
    end
end

function ps.getLocale()
    local resource = GetCurrentResourceName()
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

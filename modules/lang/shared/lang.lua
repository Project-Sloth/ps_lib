local lang = {}

function ps.insertLang(langTable)
    local resourceName = GetInvokingResource()
    ps.debug('Inserting locale for resource: ' .. resourceName)
    if not lang[resourceName] then
        lang[resourceName] = langTable
    end
end

function ps.locale(locale)
    local resourceName = GetInvokingResource()
    if not lang[resourceName] then
        return 'No Locale named ' .. locale .. ' for resource ' .. resourceName
    end

    if not lang[resourceName][locale] then
        return 'No Locale named ' .. locale .. ' for resource ' .. resourceName
    end
    ps.debug('Returning locale for resource: ' .. resourceName, lang[resourceName][locale])
    return lang[resourceName][locale]
end
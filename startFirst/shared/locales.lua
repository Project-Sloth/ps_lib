local lang = {}

function ps.insertLang(langTable)
    local resource = GetInvokingResource()
    if not lang[resource] then
        lang[resource] = langTable
    end
    ps.success('Language loaded for resource: ' .. resource)
end

local function check(tbl, key)
    local keys = {}
    for k in string.gmatch(key, "[^.]+") do
        table.insert(keys, k)
    end

    local current = tbl
    for _, k in ipairs(keys) do
        if type(current) ~= "table" or current[k] == nil then
            return nil
        end
        current = current[k]
    end
    return current
end

function ps.lang(key, ...)
    local resource = GetInvokingResource()
    local value = nil

    if lang[resource] then
        value = check(lang[resource], key)
    end

    if value then
        local args = {...}
        if #args > 0 then
            return string.format(value, table.unpack(args))
        end
        return value
    else
        local time = 60
        repeat
            Wait(1000)
            time = time - 1
            if lang[resource] then
                value = check(lang[resource], key)
                if value then
                    return string.format(value, ...)
                end
            end
        until time <= 0

        if value then
            return string.format(value, ...)
        else
            return '[Missing translation: '..key..']'
        end
    end
end

function ps.locale(key, ...)
     local resource = GetInvokingResource()
    local value = nil

    if lang[resource] then
        value = check(lang[resource], key)
    end

    if value then
        local args = {...}
        if #args > 0 then
            return string.format(value, table.unpack(args))
        end
        return value
    else
        local time = 60
        repeat
            Wait(1000)
            time = time - 1
            if lang[resource] then
                value = check(lang[resource], key)
                if value then
                    return string.format(value, ...)
                end
            end
        until time <= 0

        if value then
            return string.format(value, ...)
        else
            return '[Missing translation: '..key..']'
        end
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
    ps.success('Language loaded for resource: ' .. resource .. ' Language: ' ..  language)
    return true
end

local psScripts = {
    ['ps-banking'] = true,
    ['ps-realtor'] = true,
    ['ps-mdt'] = true,
    ['ps-dispatch'] = true,
    ['ps-multijob'] = true,
    ['ps-drugprocessing'] = true,
   
}
AddEventHandler('onResourceStart', function(resourceName)
    if psScripts[resourceName] then
        loadLangsInternal(resourceName, langs)
    end
end)

loadLangsInternal('ps_lib', langs)
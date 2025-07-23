local lang = {}

function ps.insertLang(langTable)
    local resource = GetInvokingResource() or 'ps_lib'
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
    local resource = GetInvokingResource() or 'ps_lib'
    local value = nil
    ps.success('ps.lang called for resource: ' .. resource .. ' with key: ' .. tostring(key))
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
        return '[Missing translation: '..key..']'
    end
end

function ps.getLang()
    local resource = GetInvokingResource() or 'ps_lib'
    if lang[resource] then
        return lang[resource]
    else
        ps.error('No language loaded for resource: ' .. resource)
        return {}
    end
end

ps.getLocale = ps.getLang
ps.locale = ps.lang

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
        filePath = 'locales/' .. language .. '.lua'
        langFile = LoadResourceFile(resource, filePath)
        if not langFile then
            return false
        end
        local success, result = pcall(function()
            local chunk = load(langFile, filePath, 't')
            if chunk then
                local data = chunk()
                if type(data) == 'table' then
                    lang[resource] = data
                    return true
                else
                    return false
                end
            else
                return false
            end
        end)
        return true
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

local function loadLangsInternal(script, language)
    local resource = script
    if not resource then
        ps.error('No invoking resource found.')
        return false
    end

    local filePath = 'locales/' .. language .. '.json'
    local langFile = LoadResourceFile(resource, filePath)

    if not langFile then
        filePath = 'locales/' .. language .. '.lua'
        langFile = LoadResourceFile(resource, filePath)
        if not langFile then
            return false
        end
        local success, result = pcall(function()
            local chunk = load(langFile, filePath, 't')
            if chunk then
                local data = chunk()
                if type(data) == 'table' then
                    lang[resource] = data
                    return true
                else
                    return false
                end
            else
                return false
            end
        end)
        return true
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

-- TODO: #21 find a better solution when im not tired
if IsDuplicityVersion() then 
    RegisterNetEvent('ps_lib:loadLangs', function()
        TriggerClientEvent('ps_lib:loadLangs', source, lang)
    end)
else
    TriggerServerEvent('ps_lib:loadLangs')
    RegisterNetEvent('ps_lib:loadLangs', function(langData)
        lang = langData
        ps.success('Language loaded on client side.')
    end)
end
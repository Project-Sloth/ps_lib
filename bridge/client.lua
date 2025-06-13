local emote, framework, inventory, target = false, false, false, false
-- Emote Loading
local emoteResources = {
    ['rpemotes'] = 'bridge/emote/rp/client.lua',
    ['rpemotes-reborn'] = 'bridge/emote/rp/client.lua',
    ['dpemotes'] = 'bridge/emote/dp/client.lua',
    ['scully_emotemenu'] = 'bridge/emote/skully/client.lua',
}
local frameworkResources = {
    {name = 'qbx_core', path = 'bridge/framework/qbx/client.lua'},
    {name = 'qb-core', path = 'bridge/framework/qb/client.lua'},
    {name = 'es_extended', path = 'bridge/framework/esx/client.lua'},
}

local inventoryResources = {
    ['qb-inventory'] = 'bridge/inventory/qb/client/qb.lua',
    ['ox_inventory'] = 'bridge/inventory/ox/client/ox.lua',
    ['lj-inventory'] = 'bridge/inventory/lj/client/lj.lua',
    ['ps-inventory'] = 'bridge/inventory/ps/client/ps.lua',
}

local targetResources = {
    ['qb-target'] = 'bridge/target/qb/client.lua',
    ['ox_target'] = 'bridge/target/ox/client.lua',
    ['interact'] = 'bridge/target/interact/client.lua',
}
local function loadEmotes()
    for script, path in pairs(emoteResources) do
        if GetResourceState(script) == 'started' then
            loadLib(path)
            emote = true
            ps.success(('Emote resource found: %s'):format(script))
            break
        end
    end

    if not emote then
        loadLib('bridge/emote/custom/client.lua')
        ps.warn('No emote resource found: falling back to custom')
    end
end

loadEmotes()

AddEventHandler('onResourceStart', function(resourceName)
    if emoteResources[resourceName] then
        loadLib(emoteResources[resourceName])
        ps.success(('Emote resourcedfs started: %s'):format(resourceName))
        emote = resourceName
    end
end)

local function loadFramework()
    for key, v in ipairs(frameworkResources) do
        if GetResourceState(v.name) == 'started' then
            loadLib(v.path)
            framework = v.name
            ps.success(('Framework resource found: %s'):format(v.name))
            break
        end
    end
    if not framework then
        loadLib('bridge/framework/custom/client.lua')
        ps.warn('No framework resource found: falling back to custom')
    end
end

loadFramework()

local function loadInventory()
    for script, path in pairs(inventoryResources) do
        if GetResourceState(script) == 'started' then
            loadLib(path)
            inventory = script
            ps.success(('Inventory resource found: %s'):format(script))
            break
        end
    end

    if not inventory then
        ps.warn('No inventory resource found: falling back to custom')
    end
end

loadInventory()

AddEventHandler('onResourceStart', function(resourceName)
    if inventoryResources[resourceName] then
        loadLib(inventoryResources[resourceName])
        ps.success(('Inventory resource started: %s'):format(resourceName))
    end
end)

local function loadTarget()
    for script, path in pairs(targetResources) do
        if GetResourceState(script) == 'started' then
            loadLib(path)
            target = script
            ps.success(('Target resource found: %s'):format(script))
            return
        end
    end
end

loadTarget()

AddEventHandler('onResourceStart', function(resourceName)
    if targetResources[resourceName] then
        loadLib(targetResources[resourceName])
        ps.success(('Target resource started: %s'):format(resourceName))
    end
end)

ps.debug(emote, framework, inventory, target)
local framework, inventory = false, false
local frameworkResources = {
    {name = 'qbx_core', path = 'bridge/framework/qbx/server.lua'},
    {name = 'qb-core', path = 'bridge/framework/qb/server.lua'},
    {name = 'es_extended', path = 'bridge/framework/esx/server.lua'},
}
local inventoryResources = {
    ['qb-inventory'] = 'bridge/inventory/qb/server/qb.lua',
    ['ox_inventory'] = 'bridge/inventory/ox/server/ox.lua',
    ['lj-inventory'] = 'bridge/inventory/lj/server/lj.lua',
    ['ps-inventory'] = 'bridge/inventory/ps/server/ps.lua',
    ['jpr-inventory'] = 'bridge/inventory/jpr/server/jpr.lua',
    ['tgiann-inventory'] = 'bridge/inventory/tgiann/server/tgg.lua',
}

local notify = {
    ['qb'] = 'server/qb.lua',
    ['ox'] = 'server/ox.lua',
    ['ps'] = 'server/ps.lua',
    ['esx'] = 'server/esx.lua',
    ['mad_thoughts'] = 'server/mad_thoughts.lua',
}

if notify[Config.Notify] then
    loadLib('bridge/notify/'..notify[Config.Notify])
    ps.success(('Notify system loaded: %s'):format(Config.Notify))
end

local function loadFramework()
    for key, data in ipairs(frameworkResources) do
        if GetResourceState(data.name) == 'started' then
            loadLib(data.path)
            framework = data.name
            ps.success(('Framework resource found: %s'):format(data.name))
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
        loadLib('bridge/inventory/custom/server/custom.lua')
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

function ps.getFramework()
    return framework
end
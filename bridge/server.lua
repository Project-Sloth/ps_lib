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

local banking = {
    ['qb'] = 'bridge/banking/qb/server.lua',
    ['okok'] = 'bridge/banking/okok/server.lua',
    ['Renewed'] = 'bridge/banking/Renewed/server.lua',
}

local function loadFramework()
    for key, data in ipairs(frameworkResources) do
        if GetResourceState(data.name) == 'started' then
            loadLib(data.path)
            inventory = data.name
            ps.success(('Framework resource found: %s'):format(data.name))
            break
        end
    end
    if not inventory then
        loadLib('bridge/framework/custom/client.lua')
        ps.warn('No framework resource found: falling back to custom')
    end
end

local function loadInventory()
    local inside = false
    for script, path in pairs(inventoryResources) do
        if GetResourceState(script) == 'started' then
            loadLib(path)
            inside = true
            break
        end
    end

    if not inside then
        loadLib('bridge/inventory/custom/server/custom.lua')
        ps.warn('No inventory resource found: falling back to custom')
    end
end

function ps.getFramework()
    return framework
end

local function loadAll()
    if Config.Inventory ~= 'auto' then
        if inventoryResources[Config.Inventory] then
            loadLib(inventoryResources[Config.Inventory])
        else
            loadLib('bridge/inventory/custom/server/custom.lua')
            ps.warn('No inventory resource found: falling back to custom')
        end
    else
        loadInventory()
    end
    if notify[Config.Notify] then
        loadLib('bridge/notify/'..notify[Config.Notify])
    end

    if banking[Config.Banking] then
        loadLib(banking[Config.Banking])
    end
    loadFramework()
end
loadAll()
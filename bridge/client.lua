local emote, framework, inventory, target = false, false, false, false
-- Emote Loading
local emoteResources = {
    ['rpemotes'] = 'bridge/emote/rp/client.lua',
    ['dpemotes'] = 'bridge/emote/dp/client.lua',
    ['scully'] = 'bridge/emote/scully/client.lua',
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
    ['jpr-inventory'] = 'bridge/inventory/jpr/client/jpr.lua',
    ['tgiann-inventory'] = 'bridge/inventory/tgiann/client/tgg.lua',
}

local targetResources = {
    ['qb-target'] = 'bridge/target/qb/client.lua',
    ['ox_target'] = 'bridge/target/ox/client.lua',
    ['interact'] = 'bridge/target/interact/client.lua',
}

local zones = {
    {script = 'ox_lib', path = 'bridge/zones/ox/client.lua'},
    {script = 'PolyZone', path = 'bridge/zones/PolyZone/client.lua'},
}

local drawText = {
    ['qb'] = 'qb.lua',
    ['ox'] = 'ox.lua',
    ['ps'] = 'ps.lua',
}

local notify = {
    ['qb'] = 'client/qb.lua',
    ['ox'] = 'client/ox.lua',
    ['ps'] = 'client/ps.lua',
    ['esx'] = 'client/esx.lua',
    ['mad_thoughts'] = 'client/mad_thoughts.lua',
}

local progressbars = {
    ['qb'] = 'qb.lua',
    ['oxbar'] = 'oxbar.lua',
    ['oxcircle'] = 'oxcircle.lua',
    ['keep'] = 'keep.lua',
}

local menus = {
    ['qb'] = 'qb.lua',
    ['ox'] = 'ox.lua',
    ['ps'] = 'ps.lua',
}

local vehicleKeys = {
    ['qb'] = 'bridge/vehiclekeys/qb/client/client.lua',
    ['mrnewb'] = 'bridge/vehiclekeys/mrnewb/client/client.lua',
}


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
            break
        end
    end

    if not inventory then
        loadLib('bridge/inventory/custom/client/custom.lua')
        ps.warn('No inventory resource found: falling back to custom')
    end
end

local function loadTarget()
    for script, path in pairs(targetResources) do
        if GetResourceState(script) == 'started' then
            loadLib(path)
            return
        end
    end
end

local function loadAll()
    if Config.Inventory ~= 'auto' then
        if inventoryResources[Config.Inventory] then
            loadLib(inventoryResources[Config.Inventory])
        else
            loadLib('bridge/inventory/custom/client/custom.lua')
            ps.warn('No inventory resource found: falling back to custom')
        end
    else
        loadInventory()
    end

    if Config.Target ~= 'auto' then
        if targetResources[Config.Target] then
            loadLib(targetResources[Config.Target])
        end
    else
        loadTarget()
    end

    if menus[Config.Menus] then
        loadLib('bridge/menus/'..menus[Config.Menus])
    end

    if drawText[Config.DrawText] then
        loadLib('bridge/drawtext/'..drawText[Config.DrawText])
    end
    if notify[Config.Notify] then
        loadLib('bridge/notify/'..notify[Config.Notify])
    end
    if progressbars[Config.Progressbar.style] then
        loadLib('bridge/progressbars/'..progressbars[Config.Progressbar.style])
    end
    if vehicleKeys[Config.VehicleKeys] then
        loadLib(vehicleKeys[Config.VehicleKeys])
    end
    if emoteResources[Config.EmoteMenu] then
        loadLib(emoteResources[Config.EmoteMenu])
    end
    if GetResourceState('ox_lib') == 'started' then
        loadLib('bridge/zones/ox/client.lua')
    else
        loadLib('bridge/zones/PolyZone/client.lua')
    end
end

loadAll()
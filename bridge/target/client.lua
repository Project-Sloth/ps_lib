
local GetResourceState = GetResourceState
local ipairs = ipairs
local targets = {
    {name = 'qb-target', bridge = 'qb'},
    {name = 'ox_target', bridge = 'qbox'},
    {name = 'interact', bridge = 'interact'},
}

for _, resource in ipairs(targets) do
    if GetResourceState(resource.name) == 'started' then
        local str = ('bridge/target/%s/client.lua'):format(resource.bridge)
        loadLib(str)
        ps.success(('Framework found: %s'):format(resource.name))
        break
    end
end

local fallback = {
    ['qb-target'] = 'qb',
    ['ox_target'] = 'ox',
    ['interact'] = 'interact',
}

AddEventHandler('onResourceStart', function(resourceName)
    if fallback[resourceName] then
        local filePath = ('bridge/target/%s/client.lua'):format(fallback[resourceName])
        local content = loadLib(filePath)
        if content then
            ps.success('Inventory Module Found: Loaded ' .. resourceName)
        else
            ps.error('Inventory Module: Failed to load ' .. resourceName)
        end
    end
end)
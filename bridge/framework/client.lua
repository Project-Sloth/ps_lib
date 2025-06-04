ClientFramework = {}

local GetResourceState = GetResourceState
local ipairs = ipairs

local frameworks = {
    {name = 'qb-core', bridge = 'qb'},
    {name = 'qbx_core', bridge = 'qbox'},
    {name = 'es_extended', bridge = 'esx'},
    {name = 'ox_core', bridge = 'ox'},
}

local frameworkFound = false

for _, resource in ipairs(frameworks) do
    if GetResourceState(resource.name) == 'started' then
        loadLib('bridge/framework/' .. resource.bridge .. '/client.lua')
        ps.success('Framework resource found: ' .. resource.name)
        frameworkFound = true
        break
    end
end

if not frameworkFound then
    loadLib('bridge/framework/custom/client.lua')
    ps.warn('No framework resource found: falling back to custom')
end
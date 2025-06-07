ServerFramework = {}

local GetResourceState = GetResourceState
local ipairs = ipairs
local fw = nil
local frameworks = {
    {name = 'qb-core', bridge = 'qb'},
    {name = 'qbx_core', bridge = 'qbox'},
    {name = 'es_extended', bridge = 'esx'},
    {name = 'ox_core', bridge = 'ox'},
}

local frameworkFound = false

for _, resource in ipairs(frameworks) do
    if GetResourceState(resource.name) == 'started' then
        lib.load(('bridge.framework.%s.server'):format(resource.bridge))
        ps.debug(('Framework found: %s'):format(resource.name))
        frameworkFound = true
        fw = resource.bridge
        break
    end
end

if not frameworkFound then
    lib.load('bridge.framework.custom.server')
    ps.warn('No framework resource found: falling back to custom')
    fw = 'custom'
end

function ps.getFramework()
    return fw
end
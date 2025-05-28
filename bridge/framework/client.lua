ClientFramework = {}

-- TODO: remove ox_lib dependency

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
        lib.load(('bridge.framework.%s.client'):format(resource.bridge))
        ps.debug(('Framework found: %s'):format(resource.name))
        frameworkFound = true
        break
    end
end

if not frameworkFound then
    lib.load('bridge.framework.custom.client')
    ps.warn('No framework resource found: falling back to custom')
end
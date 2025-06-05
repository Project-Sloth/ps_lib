local options = {
    { name = 'qb-inventory', module = 'qb' },
    { name = 'ox_inventory', module = 'ox' },
    { name = 'lj-inventory', module = 'lj' },
    { name = 'ps-inventory', module = 'ps' }
}

for _, v in ipairs(options) do
    if GetResourceState(v.name) == 'started' then
        local filePath = ('inventory/%s/server/%s.lua'):format(v.module, v.module)
        local content = loadLib(filePath)
        if content then
            ps.success('Inventory Module Found: Loaded ' .. v.name)
        else
            ps.error('Inventory Module: Failed to load ' .. v.name)
        end
        break
    end
end
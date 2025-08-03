local framework
if qbx then
    framework = 'qbx'
    loadLib('bridge/framework/qbx/server.lua')
elseif QBCore then
    framework = 'qb'
    loadLib('bridge/framework/qb/server.lua')
elseif ESX then
    framework = 'esx'
    loadLib('bridge/framework/esx/server.lua')
end
loadLib('bridge/inventory/'..Config.Inventory..'/server/'..Config.Inventory..'.lua')

function ps.getFramework()
    return framework
end
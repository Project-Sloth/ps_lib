local framework

loadLib('bridge/emote/'..Config.EmoteMenu..'/client.lua')
loadLib('bridge/inventory/'..Config.Inventory..'/client/'..Config.Inventory..'.lua')
loadLib('bridge/target/'..Config.Target..'/client.lua')
loadLib('bridge/menus/'..Config.Menus..'.lua')

if qbx then
    framework = 'qbx'
    loadLib('bridge/framework/qbx/client.lua')
elseif QBCore then
    framework = 'qb'
    loadLib('bridge/framework/qb/client.lua')
elseif ESX then
    framework = 'esx'
    loadLib('bridge/framework/esx/client.lua')
end

function ps.getFramework()
    return framework
end


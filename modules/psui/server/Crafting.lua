local CraftingTable = {
    ps_lib = {
        {
            loc = { -- must be tabled. can use only one location though
                {loc= vector3(-819.71, -859.37, 20.71), checks = {}},
                {loc= vector3(-1343.79, -240.20, 42.97), checks = {}}
            },
            --checks = { -- can either be strings OR tables
            --    job = {'police', 'ambulance'},
            --    items = {'lockpick'},
            --    gang = {'ballas', 'vagos'},
            --    citizenid = {'1234567890'}
            --},
            recipes = {
                lockpick = { -- item name is the key value
                    amount = 1, -- amount of items to give :: this is optional, default is 1
                    time = 5000, -- time in milliseconds to craft :: this is optional, default is 5000
                    anim = 'uncuff', -- emote to play while crafting :: this is optional, default is 'uncuff'
                    recipe = { -- items required to craft and amounts :: optional this will default to free crafts
                        steel = 2,
                        iron = 1
                    },

                },
                tosti = {
                    amount = 1,
                    time = 3000,
                    anim = 'tosti',
                    recipe = {},
                    minigame = { -- optional, if you want to use a minigame
                        type = 'ps-circle', -- look at modules/interactions/client/client.lua ps.minigame for more info
                        data = {circles = 4, time = 8} -- refer above for format
                    }
                },
                advancedlockpick = {
                    amount = 1,
                    time = 10000,
                    anim = 'uncuff',
                    recipe = {
                        steel = 4,
                        iron = 2,
                        plastic = 1,
                        lockpick = 1
                    }
                },
            },
            targetData = { -- optional for all this defaults to these values below
                size = {
                    height = 1.0,
                    width = 1.0,
                    length = 1.0,
                    rotation = 180.0
                },
                label = 'Open Crafting',
                icon = 'fa-solid fa-hammer',
            }
        },
    }
}


ps.registerCallback('ps-crafting:getCraftingLocations', function(source)
    return CraftingTable
end)

RegisterNetEvent('ps_lib:craftItem', function(data, info)
    local src = source
    local itemVerify = CraftingTable[info.script][info.zone].recipes[data.item]
    if not itemVerify then
        ps.notify(src, 'Invalid item', 'error')
        return
    end
    if not ps.checkDistance(src, CraftingTable[info.script][info.zone].loc[info.location].loc, 2.5) then
        ps.notify(src, 'You are too far away', 'error')
        return
    end
    ps.craftItem(src, {
        take = itemVerify.recipe or {},
        give = {
            [data.item] = itemVerify.amount or 1
        },
    })
end)

local function registerCrafter(data)
    local resource = GetInvokingResource()
    if not data.loc then
        ps.debug('Crafting location not set for:', data.label)
        return
    end
    if not data.recipes then
        ps.debug('No recipes set for:', data.label)
        return
    end
    if not data.targetData then
        data.targetData = {
            size = {
                height = 1.0,
                width = 1.0,
                length = 1.0,
                rotation = 180.0
            },
            label = 'Open Crafting',
            icon = 'fa-solid fa-hammer',
        }
    end
    if not CraftingTable[resource] then
        CraftingTable[resource] = {}
    end
    table.insert(CraftingTable[resource], data)
    TriggerClientEvent('ps_lib:registerCraftingLocation', -1)
end

AddEventHandler('onResourceStop', function(res)
    if CraftingTable[res] then
        CraftingTable[res] = nil
        TriggerClientEvent('ps_lib:registerCraftingLocation', -1)
    end
end)

exports('registerCrafter', registerCrafter)
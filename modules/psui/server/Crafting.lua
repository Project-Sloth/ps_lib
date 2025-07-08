local CraftingTable = {
    {
        loc = { -- must be tabled. can use only one location though
            vector3(-819.71, -859.37, 20.71),
            vector3(-1343.79, -240.20, 42.97)
        },
        checks = { -- can either be strings OR tables
            job = {'police', 'ambulance'},
            items = {'lockpick'},
            gang = {'ballas', 'vagos'},
            citizenid = {'1234567890'}
        },
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
                minigame = {
                    type = 'circle',
                    data = {circles = 4, time = 8}
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

ps.registerCallback('ps-crafting:getCraftingLocations', function(source)
    return CraftingTable
end)

RegisterNetEvent('ps_lib:craftItem', function(zone, data)
    local src = source 
    local itemVerify = CraftingTable[zone].recipes[data.item]
    if not itemVerify then
        ps.notify(src, 'Invalid item', 'error')
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
    if not data.label then
        data.label = 'Crafting'
    end
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
    if not data.checks then
        data.checks = {}
    end
    CraftingTable[#CraftingTable + 1] = data
    TriggerClientEvent('ps_lib:registerCraftingLocation', -1)
end

exports('registerCrafter', registerCrafter)

registerCrafter({
    loc = {
        vector3(-821.73, -859.37, 21.06),
        vector3(-812.63, -859.37, 20.76)
    },
    recipes = {
        lockpick = {
            amount = 1,
            time = 5000,
            anim = 'uncuff',
            recipe = {
                steel = 2,
                iron = 1
            }
        },
        tosti = {
            minigame = {
                type = 'circle',
                data = {circles = 4, time = 8}
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
    }
})
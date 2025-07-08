local zoned = nil

local function can(taker)
    for item, amount in pairs(taker) do
        if not ps.hasItem(item, amount) then
            return false
        end
    end
    return true
end

local function makeRecipeList(taker)
    local recipeList = {}
    for k, v in pairs(taker) do
        table.insert(recipeList, {
            image = ps.getImage(k),
            name = ps.getLabel(k),
            amount = v,
        })
    end
    table.sort(recipeList, function(a, b)
        return a.name < b.name
    end)
    return recipeList
end

function makeData(recipe)
    local dataToSend = {}
    for k, v in pairs (recipe) do
        table.insert(dataToSend, {
            result = {
                image = ps.getImage(k) or 'https://www.1of1servers.com/logos/1of1default.svg',
                name = k,
                Label = ps.getLabel(k),
                amount = v.amount or 1,
                Time = v.time or 5000,
                anim = v.anim or 'uncuff',
            },
            recipe = makeRecipeList(v.recipe or {}),
            canCraft = can(v.recipe or {}),
            minigame = v.minigame or nil,
        })
    end
    table.sort(dataToSend, function(a, b)
        return a.result.name < b.result.name
    end)
    return dataToSend
end

function openCrafter(data)
    SendNUIMessage({
        action = 'setCrafting',
        data = makeData(data)
    })
    SetNuiFocus(true, true)
end

exports('openCrafter', openCrafter)

RegisterNUICallback('craftItem', function(data, cb)
   if data.minigame then
      if data.minigame.type == 'circle' then
         if not exports['ps-ui']:Circle(false, data.minigame.data.circles, data.minigame.data.time) then return end
      end
   end
   if not ps.progressbar('Crafting ' .. ps.getLabel(data.item), data.time, data.anim) then return end
   TriggerServerEvent('ps_lib:craftItem', zoned, data)
end)

local function canInteract(checkData)
    local need, have  = 4, 0
    if not checkData then
        return true
    end
    if checkData.job then
        if type(checkData.job) == 'table' then
            for _, v in pairs(checkData.job) do
                if ps.getJobName() == v then
                    have = have + 1
                end
            end
        else
            if ps.getJobName() == checkData.job then
                have = have + 1
            end
        end
    else
        have = have + 1
    end
    if checkData.items then
        if type(checkData.items) == 'table' then
            for k, item in pairs(checkData.items) do
                if ps.hasItem(item, 1) then
                    have = have + 1
                end
            end
        else
            if ps.hasItem(checkData.items) then
                have = have + 1
            end
        end
    else
        have = have + 1
    end

    if checkData.gang then
        if type(checkData.gang) == 'table' then
            for _, v in pairs(checkData.gang) do
                if ps.getGangName() == v then
                    have = have + 1
                end
            end
        else
            if ps.getGangName() == checkData.gang then
                have = have + 1
            end
        end
    else
        have = have + 1
    end

    if checkData.citizenid then
        if type(checkData.citizenid) == 'table' then
            for _, v in pairs(checkData.citizenid) do
                if ps.hasCitizenId(v) then
                    have = have + 1
                end
            end
        else
            if ps.getIdentifier() == checkData.citizenid then
                have = have + 1
            end
        end
    else
        have = have + 1
    end

    return need == have
end
local function initTargets()
    local locations = ps.callback('ps-crafting:getCraftingLocations')
    for k, v in pairs(locations) do
        for _, loc in pairs(v.loc) do
            ps.boxTarget(k .. 'Crafting' .. _, loc, v.targetData.size, {
                {
                    label = v.targetData.label,
                    icon = v.targetData.icon,
                    action = function()
                        zoned = k
                        openCrafter(v.recipes)
                    end,
                    canInteract = function()
                        return canInteract(v.checks)
                    end,
                }
            })
        end
    end
end
initTargets()

RegisterNetEvent('ps_lib:registerCraftingLocation', function()
    ps.destroyAllTargets()
    initTargets()
end)


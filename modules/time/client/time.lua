-- Get game time in 24-hour format
---@return string
function ps.getGameTime24()
    local time = string.format("%02d:%02d", GetClockHours(), GetClockMinutes())
    return time
end

-- Get game time in 12-hour format with AM/PM
---@return string
function ps.getGameTime12()
    local hours = GetClockHours()
    local minutes = GetClockMinutes()
    local ampm = "AM"

    if hours >= 12 then
        ampm = "PM"
        if hours > 12 then
            hours = hours - 12
        end
    end

    if hours == 0 then
        hours = 12
    end

    local time = string.format("%d:%02d %s", hours, minutes, ampm)
    return time
end

RegisterCommand("tes", function()
    ps.playEmote("dance")
    Wait(1000)
    ps.cancelEmote()
    ps.debug('Passed Emote Test')
    Wait(1000)
    ps.debug('Starting Client Framework Test')
    Wait(1200)
    ps.debug(ps.ped, ps.charinfo, ps.citizenid, ps.name)
    Wait(1000)
    ps.debug('Passed Client Cache Framework')
    Wait(1000)
    ps.debug(ps.getPlayerData())
    Wait(1000)
    ps.debug(ps.getIdentifier(), ps.getMetadata('thirst'), ps.getCharInfo('age'), ps.getPlayerName(), ps.getPlayer())
    Wait(1000)
    ps.debug(ps.getVehicleLabel(GetVehiclePedIsIn(ps.getPlayer(), false)), ps.isDead(), ps.getJob(), ps.getJobName(), ps.getJobType(), ps.isBoss(), ps.getJobDuty())
    Wait(1000)
    ps.debug(ps.getJobData('label'), ps.getGang(), ps.getGangData('label'),ps.getGangName(), ps.isLeader())
    Wait(1000)
    ps.debug(ps.getCoords(), ps.getMoneyData(), ps.getMoney('cash'), ps.getAllMoney())
    Wait(1000)
    ps.debug('Passed all client framework tests')
    Wait(1000)
    ps.debug('Starting Inventory Test')
    ps.debug(ps.getImage('lockpick'), ps.getLabel('phone'), ps.hasItem('phone', 1))
    Wait(1000)
    ps.debug('Passed Inventory Test')
    Wait(1000)
    ps.boxTarget('test', vec3(-1429.073486, -557.029541, 33.422260), {
        length = 1.0, 
        width = 1.0,
        height = 1.0,
        heading = 0,
    }, {
        {
            name = "test",
            icon = "fas fa-car",
            label = "Test Box Target",
           action = function()
                ps.debug('Passed Box Target Test')
            end,
        },
    })
    ps.debug('Passed Box Target Test')
    Wait(4000)
    ps.destroyTarget('test')
    ps.debug('Passed Destroy Target Test')
    Wait(2000)
    ps.debug('Starting Cache Vehicles Test')
    ps.debug(ps.vehicleData() )
    Wait(1000)
    ps.debug('Passed Cache Vehicles Test')
    ps.debug('Starting Stress Test Callbacks')
    Wait(10000)
    local count = 1000
    repeat
        Wait(1)
        count = count - 1
        ps.debug(count, ps.callback('getName'))
    until count == 0
end, false)

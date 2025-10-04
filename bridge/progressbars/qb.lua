
local function handleDisable(disabled)
    if disabled.movement == nil then
        disabled.movement = Config.Progressbar.Movement
    end
    if disabled.car == nil then
        disabled.car = Config.Progressbar.CarMovement
    end
    if disabled.mouse == nil then
        disabled.mouse = Config.Progressbar.Mouse
    end
    if disabled.combat == nil then
        disabled.combat = Config.Progressbar.Combat
    end
    return disabled
end


local p = nil
function ps.progressbar(text, time, emote, disabled)
    disabled = handleDisable(disabled or {})
    if emote then
        ps.playEmote(emote)
    end
    p = promise.new()
    QBCore.Functions.Progressbar('testasd', text, time, false, true, {
        disableMovement = disabled.movement,
        disableCarMovement = disabled.car,
        disableMouse = disabled.mouse,
        disableCombat = disabled.combat,
    }, {}, {}, {}, function()
        p:resolve(true)
        p = nil
        ps.cancelEmote()
    end, function()
        p:resolve(false)
        p = nil
        ps.cancelEmote()
    end)
    return Citizen.Await(p)
end


exports('progressbar', ps.progressbar)
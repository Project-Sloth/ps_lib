local p = nil
ps.success('Progressbar Module Loaded: keep-progressbar')
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

function ps.progressbar(text, time, emote, disabled)
    disabled = handleDisable(disabled or {})

    if emote then
        ps.playEmote(emote)
    end
    p = promise.new()
    exports['keep-progressbar']:Start({
        duration = time,
        label = text,
        icon = "fa-solid fa-box",
        canCancel = true,
        useWhileDead = false,
        controlDisables = {
            disableMovement = disabled.movement,
            disableCombat = disabled.combat,
        },
    }, function(cancelled)
        ps.cancelEmote()
        if not cancelled then
            p:resolve(true)
            p = nil
        else
            p:resolve(false)
            p = nil
        end
    end)
    return Citizen.Await(p)
end

exports('progressbar', ps.progressbar)

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
    local data = {
        duration = time,
        label = text,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = disabled.car,
            move = disabled.movement,
            mouse = disabled.mouse,
            combat = disabled.combat,
        },
    }
    if exports.lation_ui:progressBar(data) then
        ps.cancelEmote()
        return true
    else
        ps.cancelEmote()
        return false
    end
end


exports('progressbar', ps.progressbar)
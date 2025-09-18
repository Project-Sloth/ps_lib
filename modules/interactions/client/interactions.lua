

if Config.DrawText == 'qb' then
    function ps.drawText(text)
        if not text then return end
        exports['qb-core']:ShowText(text)
    end
    function ps.hideText()
        exports['qb-core']:HideText()
    end
end

if Config.DrawText == 'ox' then
    function ps.drawText(text)
        if not text then return end
        lib.showTextUI(text)
    end
    function ps.hideText()
        lib.hideTextUI()
    end
end

if Config.DrawText == 'ps' then
    function ps.drawText(text)
        if not text then return end
        exports['ps-ui']:drawText(text, "yellow")
    end
    function ps.hideText()
        exports['ps-ui']:hideDrawText()
    end
end

if Config.Notify == 'qb' then
    function ps.notify(text, type, time)
        if not text then return end
        if not type then type = 'info' end
        if not time then time = 5000 end
        QBCore.Functions.Notify(text, type, time)
    end
end

if Config.Notify == 'ox' then
    function ps.notify(text, type, time)
        if not text then return end
        if not type then type = 'info' end
        if not time then time = 5000 end
        lib.notify({
            description = text,
            type = type,
            duration = time,
        })
    end
end

if Config.Notify == 'ps' then
    function ps.notify(text, type, time)
        if not text then return end
        if not type then type = 'info' end
        if not time then time = 5000 end
        exports['ps_lib']:notify(text, type, time)
    end
end

if Config.Notify == 'math_thoughts' then
    function ps.notify(text, type, time)
        if not text then return end
        if not type then type = 'info' end
        if not time then time = 5000 end
        if type == 'error' then
            exports['mad-thoughts']:error(text, time / 1000)
        elseif type == 'success' then
            exports['mad-thoughts']:success(text, time / 1000)
        elseif type == 'info' then
            exports['mad-thoughts']:info(text, time / 1000)
        elseif type == 'warning' then
            exports['mad-thoughts']:warning(text, time / 1000)
        end
    end
end
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


if Config.Progressbar.Style == 'qb' then
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
end

if Config.Progressbar.style == 'oxbar' then
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
        if lib.progressBar(data) then
	        ps.cancelEmote()
	        return true
        else
            ps.cancelEmote()
            return false
        end
    end
end

if Config.Progressbar.style == 'oxcir' then
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
            position = 'bottom',
            disable = {
                car = disabled.car,
                move = disabled.movement,
                mouse = disabled.mouse,
                combat = disabled.combat,
            },
        }
        if lib.progressCircle(data) then
            ps.cancelEmote()
            return true
        else
            ps.cancelEmote()
            return false
        end
    end
end


function ps.minigame(type, values)
    if type == 'ps-circle' then
        return  exports['ps-ui']:Circle(false, values.amount, values.speed)
    elseif type == 'ps-maze' then
        return exports['ps-ui']:Maze(false, values.timeLimit)
    elseif type == 'ps-scrambler' then
        return exports['ps-ui']:Scrambler(false, values.type, values.timeLimit, 0)
    elseif type == 'ps-varhack' then
        return exports['ps-ui']:VarHack(false, values.blocks, values.timeLimit)
    elseif type == 'ps-thermite' then
        return exports['ps-ui']:Thermite(false, values.timeLimit, values.gridsize, values.wrong)
    elseif type == 'ox' then
        if not values.input then
            values.input = {"1", "2", "3", "4"}
        end
        local success = lib.skillCheck(values.difficulty, values.input)
        return success
    end
end
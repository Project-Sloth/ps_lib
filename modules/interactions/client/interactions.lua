function ps.drawText(text)
    if not text then return end
    if Config.DrawText == 'qb' then
        exports['qb-core']:ShowText(text)
    elseif Config.DrawText == 'ox' then
        lib.showTextUI(text)
    elseif Config.DrawText == 'ps' then
        exports['ps-ui']:DisplayText(text, "yellow")
    end
end

function ps.hideText()
    if Config.DrawText == 'qb' then
        exports['qb-core']:HideText()
    elseif Config.DrawText == 'ox' then
        lib.hideTextUI()
    elseif Config.DrawText == 'ps' then
        exports['ps-ui']:HideText()
    end
end

function ps.notify(text, type, time)
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    if Config.Notify == 'qb' then
        QBCore.Functions.Notify(text, type, time)
    elseif Config.Notify == 'esx' then
        ESX.ShowNotification(text)
    elseif Config.Notify == 'ox' then
        lib.notify({
            description = text,
            type = type,
            duration = time,
        })
    end
end
function ps.progressbar(text, time, emote)
    if emote then
        ps.playEmote(emote)
    end
    if Config.Progressbar == 'qb' then
        local completed = false
        local cancelled = false
        QBCore.Functions.Progressbar('testasd', text, time, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            completed = true
            ps.cancelEmote()
        end, function()
            cancelled = true
            ps.cancelEmote()
        end)
        repeat
            Wait(1)
        until completed or cancelled
        if completed then
            return true
        elseif cancelled then
            return false
        end
    elseif Config.Progressbar == 'oxbar' then
        local data = {
            duration = time,
            label = text,
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                 move = true
            },
        }
        if lib.progressBar(data) then
	        ps.cancelEmote()
	        return true
        else
            ps.cancelEmote()
            return false
        end
    elseif Config.Progressbar == 'oxcir' then
        local data = {
            duration = time,
            label = text,
            useWhileDead = false,
            canCancel = true,
            position = 'bottom',
            disable = {
                car = true,
                move = true
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
        if values.input == nil then
            values.input = {"1", "2", "3", "4"}
        end
        local success = lib.skillCheck(values.difficulty, values.input)
        return success
    end
end
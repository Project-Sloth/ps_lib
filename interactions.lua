ps.debug('interactions module loaded')
if IsDuplicityVersion() then
    function ps.notify(source, text, type, time)
        if not source then return end
        if not text then return end
        if not type then type = 'info' end
        if not time then time = 5000 end
        if Config.Notify == 'qb' then
            TriggerClientEvent('QBCore:Notify', source, text, type, time)
        elseif Config.Notify == 'esx' then
            TriggerClientEvent('esx:showNotification', source, text, type, time)
        elseif Config.Notify == 'ox' then
            TriggerClientEvent('ox_lib:notify', source, {
                description = text,
                type = type,
                duration = time,
            })
        end
        return {source, text, type, time}
    end
else
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
        return {text, type, time}
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
            end, function() -- Cancel
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
	        if lib.progressBar({ duration = time, label = text, useWhileDead = false, canCancel = true, disable = { car = true, move = true},}) then
		        ps.cancelEmote()
		        return true
	        end
	    elseif Config.Progressbar == 'oxcir' then
	        if lib.progressCircle({ duration = time, label = text, useWhileDead = false, canCancel = true, position = 'bottom', disable = { car = true,move = true},}) then 
                ps.cancelEmote()
                return true
            end
	    end
    end
    function ps.minigame(type, values)
        if type == 'ps-circle' then
            local catch = nil
            exports['ps-ui']:Circle(function(success) catch = success end, values.amount, values.speed)
            repeat
                Wait(1)
            until catch ~= nil
            return catch
        elseif type == 'ox' then
            if values.input == nil then
                values.input = {"1", "2", "3", "4"}
            end
            local success = lib.skillCheck(values.difficulty, values.input)
            return success
        end
    end
    function ps.playEmote(emote)
        if GetResourceState('scully_emotemenu') == 'started' then
            exports.scully_emotemenu:playEmoteByCommand(emote)
        else
           TriggerEvent('animations:client:EmoteCommandStart', {emote})
        end
    end
    function ps.cancelEmote()
        if GetResourceState('scully_emotemenu') == 'started' then
			exports.scully_emotemenu:cancelEmote()
		else
			TriggerEvent('animations:client:EmoteCommandStart', {"c"})
		end
    end
end
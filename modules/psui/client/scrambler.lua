local p = nil

--- Starts the scrambler game.
--- @param callback function: Callback function to handle the result of the game (true for success, false for failure).
--- @param type string|nil: Type of the game (e.g., 'alphabet', 'numeric'). Defaults to "alphabet" if nil.
--- @param time number|nil: Time duration of the game in seconds. Defaults to 10 seconds if nil.
--- @param mirrored number|nil: Option to include mirrored text (0: Normal, 1: Normal + Mirrored, 2: Mirrored only). Defaults to 0 if nil.
local function scrambler(callback, type, time, mirrored)
    if type == nil then type = "alphabet" end  -- Default to "alphabet" if type is nil
    if time == nil then time = 10 end  -- Default to 10 seconds if time is nil
    if mirrored == nil then mirrored = 0 end  -- Default to 0 if mirrored is nil
    p = promise:new()
    local data = {
        amountOfAnswers = 4,  -- Number of answers to provide in the game
        gameTime = time,  -- Time duration of the game
        sets = type,  -- Type of the game
        changeBoardAfter = 1,  -- Specifies if the board should change after a certain condition
    }
    SetNuiFocus(true, true)
    SendNUIMessage({
         action = 'Scrambler',
         data = data
    })
    local result = Citizen.Await(p)
     if callback ~= false then
        callback(result)  -- Call the callback with the result
    end
    return result
end


RegisterNuiCallback('scrambler-result', function(res, cb)
    p:resolve(res)
    p = nil
    SetNuiFocus(false, false)
    cb('ok')
end)

exports("Scrambler", scrambler)
ps.exportChange('ps-ui', "Scrambler", scrambler)

RegisterCommand("testScrambler", function(source, args, rawCommand)
    local type = args[1] or "numeric"  -- Get the type from command arguments or default to "alphabet"
    local time = tonumber(args[2]) or 30  -- Get the time from command arguments or default to 10 seconds
    local mirrored = tonumber(args[3]) or 0  -- Get the mirrored option from command arguments or default to 0
    local result = scrambler(false, type, time, mirrored)  -- Start the scrambler game without a callback
    if result then
        print("Scrambler completed successfully with result:", result)
    else
        print("Scrambler failed or was cancelled.")
    end
end, false)
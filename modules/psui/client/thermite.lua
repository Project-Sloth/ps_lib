local correctBlocksBasedOnGrid = {
    [5] = 10,
    [6] = 14,
    [7] = 18,
    [8] = 20,
    [9] = 24,
    [10] = 28,
}
local p = nil
--- Starts the Thermite game with the specified parameters.
--- @param cb function: Callback function that will receive the result of the game (true for success, false for failure).
--- @param time number|nil: Time duration for the game in seconds. Default is 10 if nil.
--- @param gridsize number|nil: Size of the game grid (number of blocks per side). Default is 6 if nil.
--- @param wrong number|nil: Maximum number of incorrect answers allowed. Default is 3 if nil.
--- @param correctBlocks number|nil: Number of correct blocks to display. If not provided, it is determined based on the grid size.
local function thermite(cb, time, gridsize, wrong, correctBlocks)
    -- Default values if parameters are not provided
    if time == nil then time = 10 end
    if gridsize <= 5 or gridsize == nil then gridsize = 6 end 
    if wrong == nil then wrong = 3 end
    local correctBlockCount = correctBlocks or correctBlocksBasedOnGrid[gridsize]
    p = promise:new()  -- Create a new promise for the game result
    SetNuiFocus(true, true)  -- Set focus to the NUI
    SendNUIMessage({
        action = "ThermiteGame",
        data = {
            amountOfAnswers = correctBlockCount,  -- Number of correct blocks to display
            gameTime = time,  -- Time duration for the game
            maxAnswersIncorrect = wrong,  -- Maximum number of incorrect answers allowed
            displayInitialAnswersFor = 3,  -- Time to display initial answers (seconds)
            gridSize = gridsize,  -- Size of the game grid
        }
    })
    local result = Citizen.Await(p)  -- Wait for the game result
    if cb ~= false then
        cb(result)  -- Call the callback with the result
    end
    return result
end

RegisterNuiCallback('thermite-result', function(res, cb)
    p:resolve(res)
    p = nil
    SetNuiFocus(false, false)
    cb('ok')
end)

exports("Thermite", thermite)
ps.exportChange('ps-ui', "Thermite", thermite)

RegisterCommand('testThermite', function(source, args, rawCommand)
    -- Example command to test the Thermite function
    local time = tonumber(args[1]) or 150
    local gridsize = tonumber(args[2]) or 5
    local wrong = tonumber(args[3]) or 3
    local correctBlocks = 14

    thermite(function(success)
        if success then
            print("Thermite game completed successfully!")
        else
            print("Thermite game failed.")
        end
    end, time, gridsize, wrong, correctBlocks)
end, false)  -- false means this command is not restricted to server-side only
local p = nil

--- Starts the maze game.
--- @param callback function: Callback function to handle the result of the game (true for success, false for failure).
--- @param speed number|nil: Time duration of the game in seconds. Defaults to 10 seconds if nil.
local function Maze(callback, speed)
    if speed == nil then speed = 10 end
    p = promise:new()
    local gameData = {
        gameTime = speed,
        maxAnswersIncorrect = 2,
    }
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'NumberMaze',
        data = gameData,
    })
    local result = Citizen.Await(p)

     if callback ~= false then
        callback(result)
    end
    return result
end

exports("Maze", Maze)
ps.exportChange('ps-ui', "Maze", Maze)

RegisterNuiCallback('maze-result', function(res, cb)
    p:resolve(res)
    p = nil
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterCommand("testMaze", function(source, args, rawCommand)
    local speed = tonumber(args[1]) or 10
    local c = Maze(false, speed)
    ps.debug('testMaze', 'Maze result:', c)
end, false)
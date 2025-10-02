
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

exports('minigame', ps.minigame)
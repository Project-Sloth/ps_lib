local locations = {}
local inside, insideLoop = nil, nil

function ps.addZone(name, location, size, options)
    locations[name] = {
        location = location,
        size = size,
        options = options
    }
end

function ps.removeZone(name)
    locations[name] = nil
end

local function runInside(func)
    CreateThread(function()
        while inside do
            Wait(1)
            func(inside)
        end
        insideLoop = false
    end)
end

while true do
    Wait(300)
    for name, data in pairs(locations) do
        local playerCoords = GetEntityCoords(PlayerPedId())
        if #(playerCoords - data.location) < data.size then
            if inside ~= name and data.options.onEnter then
                data.options.onEnter()
            end
            if inside ~= name and data.options.inside and not insideLoop then
                insideLoop = true
                runInside(data.options.inside)
            end
            inside = name
        end
        if inside and inside == name and #(playerCoords - data.location) > data.size then
            if data.options.onExit then
                data.options.onExit()
            end
            inside = nil
        end
    end
end
local p = nil
local active = false

--- Displays an input form and waits for user input.
--- @param InputData table: Data to be used for the input form, typically includes fields like labels, types, and icons.
--- @return table: User input data as returned from the form.
local function input(InputData)
    if not InputData.inputs or #InputData.inputs == 0 then
        error("InputData must contain at least one input field.")
    end
    for k, v in pairs(InputData.inputs) do
       if not v.value then
            v.value = ""
        end
        if not v.id then
            v.id = k
        end
        if v.type == 'select' then
            for i = 1, #v.options do
                if not v.options[i].returnType then
                    v.options[i].returnType = type(v.options[i].value)
                end
            end
        end
    end
    p = promise.new()
    while active do Wait(0) end
    active = true
    SendNUIMessage({
        action = "ShowInput",
        data = InputData
    })
    SetNuiFocus(true, true)
    local inputs = Citizen.Await(p)
    if not inputs then
        return nil
    end
    local formatted = {}
    ps.sorter(inputs, 'id')
    for k, v in pairs(inputs) do
        if v.type == "number" then
            formatted[k] = tonumber(v.value)
        elseif v.type == 'text' then
            formatted[k] = v.value
        elseif v.type == 'checkbox' then
            formatted[k] = v.value
        elseif v.type == 'textarea' then
            formatted[k] = v.value
        elseif v.type == 'select' then
            if v.returnType == 'number' then
                formatted[k] = tonumber(v.value)
            elseif v.returnType == 'boolean' then
               formatted[k] = v.value == 'true' or v.value == true
            else
                formatted[k] = v.value
            end
        elseif v.type == 'password' then
            formatted[k] = v.value
        end
        if formatted[k] == nil then
            formatted[k] = ''
        end
    end
    return formatted
end

--- Callback for handling user input.
--- @param data table: Data received from the NUI input form, includes user input values.
--- @param cb function: Callback function to signal completion of the NUI callback (must be called to complete the NUI callback).
RegisterNUICallback('input-callback', function(data, cb)
    SetNuiFocus(false, false)
    p:resolve(data)
    p = nil
    active = false
    cb('ok')
end)

--- Callback for closing the input form.
--- @param data any: Data sent from the NUI (not used in this function).
--- @param cb function: Callback function to signal completion of the NUI callback (must be called to complete the NUI callback).
RegisterNUICallback('input-close', function(data, cb)
    SetNuiFocus(false, false)
    if p then
        p:resolve(nil)
        p = nil
    end
    active = false
    cb('ok')
end)

exports("Input", input)
ps.exportChange('ps-ui', "Input", input)
local p = nil
local isBusy = false
RegisterNUICallback('submitForm', function(data, cb)
    SetNuiFocus(false, false)
    if p then
        p:resolve(data)
        p = nil
    end
end)

-- @param type string
-- @param title string
-- @param description string
-- @placeholder 
-- required
-- options?
local function input(name, options)
    ps.debug(name, options)
    if not name then name = 'Input Menu' end
    if not options then
        ps.error('Input options are required')
        return
    end
    if isBusy then
        ps.error('Input is already open')
        return
    end
    isBusy = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openInput',
        data = {
            name = name,
            items = options
        }
    })
    p = promise:new()
    return Citizen.Await(p)
end

exports('input', input)
ps.exportChange('ps-ui', 'input', input)

RegisterCommand('testanput', function(source, args, rawCommand)
    local options = {
        {
            type = 'text',
            title = 'Enter your name',
            placeholder = 'Name',
            required = true
        },
        {
            type = 'number',
            title = 'Enter your age',
            placeholder = 'Age',
            required = true,
            min = 1,
            max = 120
        },
        {
            type = 'select',
            title = 'Choose a color',
            options = {
                { label = 'Red', value = 'red' },
                { label = 'Green', value = 'green' },
                { label = 'Blue', value = 'blue' }
            },
            required = false
        }
    }

    local result = input('Test Input Menu', options)
    if result then
        ps.debug('Input Result:', result)
    else
        ps.debug('Input was cancelled or failed.')
    end
end, false)
local sendData, HoldData = {}, {}

RegisterNUICallback('contextMenuItemClicked', function(datas, cb)
    local option = HoldData[datas]
    if option and option.action then
        option.action()
    end
    if option and option.event then
        if option.type == 'server' then
            TriggerServerEvent(option.event, option.args or {})
        else
            TriggerEvent(option.event, option.args or {})
        end
    end
    HoldData = {}
    sendData = {}
    cb('ok')
end)

local function handleData(datas)
    sendData.items = {}
    sendData.name = datas.name or 'Missing Name'
    for k, v in ipairs(datas.items) do
        table.insert(sendData.items, {
            title = v.title or 'Missing Title',
            icon = v.icon or nil,
            description = v.description or nil,
        })
    end
    HoldData = datas.items
    return sendData
end


local function showContext(menuData)
    if not menuData or not menuData.items or #menuData.items == 0 then
        return
    end

    local dataToSend = handleData(menuData)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openContextMenu',
        data = dataToSend
    })
end

exports('showContext', showContext)
ps.exportChange('ps-ui', 'showContext', showContext)

RegisterCommand('testContext', function(source, args, rawCommand)
    local testMenu = {
        name = 'Test Context Menu',
        items = {
            {
                title = 'Option 1',
                icon = ps.getImage('lockpick'),
                description = 'This is option 1',
                action = function()
                    ps.notify('You selected Option 1!', 'success')
                end,
            },
            {
                title = 'Option 2',
                icon = 'https://i.ytimg.com/vi/ZyI7bOqaldg/maxresdefault.jpg',
                description = 'This is option 2',
                action = function()
                    ps.notify('You selected Option 2!', 'success')
                end,
            },
            {
                title = 'Option 3 (No Action)',
                icon = nil,
                description = 'This option has no action or event.',
            }
        }
    }

    exports['ps-ui']:showContext(testMenu)
end, false)

local function hideMenu()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'hideContext'
    })

end

ps.exportChange('ps-ui', 'HideMenu', hideMenu)
exports('HideMenu', hideMenu)
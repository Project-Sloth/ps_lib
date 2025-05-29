

-- Number Maze
RegisterCommand("maze",function()
    local test = exports['ps-ui']:Maze(function(success)
        if success then
            SetEntityCoords(PlayerPedId(), 0, 0, 100) -- Teleport to a random location
            print("success")
		else
             SetEntityCoords(PlayerPedId(), 1230, 0, 100) -- Teleport to a random location
			print("fail")
		end
    end, 20) -- Hack Time Limit
end) 

-- VAR
RegisterCommand("var", function()
   local var =  exports['ps-ui']:VarHack(function(success)
        print("VarHack Result: " .. tostring(success))
        if success then
            print("success")
		else
			print("fail")
		end
    end, 2, 3) -- Number of Blocks, Time (seconds)
end)

-- CIRCLE
RegisterCommand("circle", function()
    exports['ps-ui']:Circle(function(success)
        if success then
            print("success")
		else
			print("fail")
		end
    end, 2, 20) -- NumberOfCircles, MS
end)

-- THERMITE
RegisterCommand("thermite", function()
    local test = exports['ps-ui']:Thermite(function(success)
        if success then
            print("success")
		else
			print("fail")
		end
    end, 10, 5, 3) -- Time, Gridsize (5, 6, 7, 8, 9, 10), IncorrectBlocks
end)

-- SCRAMBLER
RegisterCommand("scrambler", function()
    local test = exports['ps-ui']:Scrambler(function(success)
        if success then
            print("success")
		else
			print("fail")
		end
    end, "numeric", 30, 0) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
end)

-- DISPLAY TEXT
RegisterCommand("display", function()
    exports['ps-ui']:DisplayText("Example Text", "primary") -- Colors: primary, error, success, warning, info, mint
end)

RegisterCommand("hide", function()
    exports['ps-ui']:HideText()
end)


local status = false
RegisterCommand("status", function()
    if not status then
        status = true
        exports['ps-ui']:StatusShow("Area Dominance", {
            "Gang: Ballas",
            "Influence: %100",
        })
    else 
        status = false
        exports['ps-ui']:StatusHide()
    end
end)


RegisterCommand("cmenu", function()
    exports['ps-ui']:CreateMenu({
        {
            
            header = "header1",
            text = "text1",
            icon = "nui://qb-inventory/html/images/lockpick.png",
            color = "red",
            action = function()
                ps.debug('you clicked 1')
            end,
            
        },
        {
            header = "header2",
            text = "text3",
            icon = "https://www.1of1servers.com/logos/1of1default.svg",
            color = "blue",
            event = "event:two",
            args = {
                1,
                "two",
                "3",
            },
            server = false,
        },
        {
            header = "header3",
            text = "text3",
            icon = "fa-solid fa-circle",
            color = "green",
            event = "event:three",
            args = {
                1,
                "two",
                "3",
            },
            server = true,
        },
        {
            header = "header4",
            text = "text4",
            event = "event:four",
            args = {
                1,
                "two",
                "3",
            },
        },
    })

    exports['ps-ui']:CreateMenu({
        {
            header = "header5",
            text = "text5",
            icon = "fa-solid fa-circle",
            color = "green",
            event = "event:five",
            args = {
                1,
                "two",
                "3",
            },
            server = true,
        },
        {
            header = "header6",
            text = "text6",
            icon = "fa-solid fa-circle",
            color = "green",
            event = "event:six",
            args = {
                1,
                "two",
                "3",
            },
            server = true,
        },
    })
end)

RegisterCommand("input", function()
    local input = exports['ps-ui']:Input({
        title = "This Is The Test",
        inputs = {
            {
                label = "Test Input 1",
                type = "text",
                placeholder = "test2",
            },
           {
               label = "Test Input 2",
               type = "number",
               placeholder = "test2",
           },
           {
               label = "Test Input 3",
               type = "password",
               placeholder = "test2",
               icon = "fa-solid fa-circle",
           },
           {
               label = "Test Input 4",
               type = "textarea",
               placeholder = "test2",
               icon = "fa-solid fa-circle",
           },
           {
               label = "Test Input 5",
               type = "select",
               placeholder = "test2",
               icon = "fa-solid fa-circle",
               options = {
                   { label = "Option 1", value = true },
                   { label = "Option 2", value = 12 },
                   { label = "Option 3", value = 'hi' },
               }
           },
            {
                label = "Test Input 6",
                type = "checkbox",
                placeholder = "test2",
                icon = "fa-solid fa-circle",
                
            },
           
        }
    })
    ps.debug("Input Result: ", json.encode(input))
end)

RegisterCommand("showimage", function()
    exports['ps-ui']:ShowImage("https://user-images.githubusercontent.com/91661118/168956591-43462c40-e7c2-41af-8282-b2d9b6716771.png")
end)
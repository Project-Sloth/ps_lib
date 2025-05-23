
if IsDuplicityVersion() then
    function ps.exportChange(resource, exportname, func)
         AddEventHandler(('__cfx_export_%s_%s'):format(resource, exportname), function(setCallback)
            setCallback(func)
        end)
    end
else
    function ps.exportChange(resource, exportname, func)
          AddEventHandler(('__cfx_export_%s_%s'):format(resource, exportname), function(setCallback)
            setCallback(func)
        end)
    end
end


--- What this does;
--- 
--- This code is a Lua script that handles the export of functions between different resources in a FiveM server.
--- lets say you want to make a banking script that handles society accounts 
--- you dont want to make everyone change exports through various scripts 
--- lets say this is ps_banking and you want to allow people to NOT have to change exports
--- you can do this


--         local function addMoney(account, amount)
--             print("Adding money to account: " .. account .. ", Amount: " .. amount)
--             -- Add your logic here
--         end
--         local function removeMoney(account, amount)
--             print("Removing money from account: " .. account .. ", Amount: " .. amount)
--             -- Add your logic here
--         end
--         exports('addMoney', addMoney)
--         exports('removeMoney', removeMoney)
--         ps.exportChange("qb-banking", "addMoney", addMoney)
--         ps.exportChange("qb-banking", "removeMoney", removeMoney)
--         ps.exportChange("qb-management", "addMoney", addMoney)
--         ps.exportChange("qb-management", "removeMoney", removeMoney)

-- now any script that has exports['qb-banking']:addMoney('police', 1000) 
-- will work with the banking script so you dont need to change exports to exports['ps-banking']:addMoney('police', 1000)
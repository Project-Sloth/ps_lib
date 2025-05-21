
if IsDuplicityVersion() then
   function ps.debug(...)
        local args = {...}
        for k, v in ipairs(args) do
            if type(v) == "table" then
                print(k .. ': ' .. json.encode(v))
            elseif type(v) == "boolean" then
                print(k .. ': ' .. tostring(v))
            elseif v == nil then
                print(k .. ': nil')
            else
                print(k .. ': ' .. v)
            end
        end
    end

else
    function ps.debug(...)
        local args = {...}
        for k, v in ipairs(args) do
            if type(v) == "table" then
                print(k .. ': ' .. json.encode(v))
            elseif type(v) == "boolean" then
                print(k .. ': ' .. tostring(v))
            elseif v == nil then
                print(k .. ': nil')
            else
                print(k .. ': ' .. v)
            end
        end
    end
end

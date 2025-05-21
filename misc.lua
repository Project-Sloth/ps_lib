if IsDuplicityVersion() then
    function ps.sorter(tab, key)
        table.sort(tab, function(a, b)
            return a[key] < b[key]
        end)
    end
else
    function ps.sorter(tab, key)
        table.sort(tab, function(a, b)
            return a[key] < b[key]
        end)
    end
end
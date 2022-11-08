
function table.flatten(t)
    local rv = {}
    for _, subobj in ipairs(t) do
        if type(subobj) ~= "table" then
            table.insert(rv, subobj)
        else
            local flat = table.flatten(subobj)
            for _, v in ipairs(flat) do
                table.insert(rv, v)
            end
        end
    end
    return rv
end

local rv = table.flatten({{1, 2, 3}, {4, 5, 6}, {{7, 8, 9}}})
print(rv[1])


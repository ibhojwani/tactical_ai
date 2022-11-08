
local P = table
Table = P

------------------------------
--    TABLE FUNCTIONS    -----
------------------------------
function P.copy(t)
    local rv = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            v = Table.copy(v)
        end
        rv[k] = v
    end
    return rv
end

function P.flatten(t)
    local rv = {}
    for _, subobj in ipairs(t) do
        if type(subobj) ~= "table" then
            table.insert(rv, subobj)
        else
            local flat = P.flatten(subobj)
            for _, v in ipairs(flat) do
                table.insert(rv, v)
            end
        end
    end
    return rv
end

function P.print(arr, indentLevel)
    local str = ""
    local indentStr = ""

    if(indentLevel == nil) then
        print(P.print(arr, 0))
        return
    end

    for i = 0, indentLevel do
        indentStr = indentStr.."\t"
    end

    for index,value in pairs(arr) do
        if type(value) == "table" then
            str = str..indentStr..index..": \n"..P.print(value, (indentLevel + 1))
        else 
            str = str..indentStr..index..": "..value.."\n"
        end
    end
    return str
end

function P.transpose(t)
    --[[
        assumes standard matrix --each row same number of vals as next row
    ]]
    local rv = {}
    for i=1, #t[1] do
        table.insert(rv, {})
    end
    for i=1, #t do
        for j=1, #t[i] do
            table.insert(rv[j], t[i][j])
        end
    end
    return rv
end

return Table

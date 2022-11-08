
local P = {}
Utils = P


------------------------------
----    MISC FUNCTIONS    ----
------------------------------

function P.idx_coords(table)
    local rv = {}
    rv[1] = table.x
    rv[2] = table.y
    rv[3] = table.z
    return rv
end


return Utils

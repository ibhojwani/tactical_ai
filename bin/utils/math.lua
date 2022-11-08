
local P = math
Math = P

-------------------------------------
---  VECTOR and MATRIX FUNCTIONS  ---
-------------------------------------

-- function Math.matrix_mult(t1, t2)
--     local rv = t
--     t2 = table.transpose(t2)
--     for _, i in ipairs(t1) do
--             local subsum = {}
--             for _, j in ipairs(t2) do
--                 subsum
--             end
--         end
--     end
-- end


function P.norm(vec)
    local sum = 0
    for _, v in ipairs(vec) do
        sum = sum + (v^2)
    end
    return sum^(1/#vec)
end

function P.normalize(vec)
    local sum = 0
    for _, v in pairs(vec) do
        sum = sum + math.abs(v)
    end
    for i, _ in pairs(vec) do
        vec[i] = vec[i] / sum
    end
    return vec
end

function P.vec_2apply(vec1, vec2, func)
    local rv = {}
    local labs = {}
    for i, v in pairs(vec1) do
        labs[i] = true
        rv[i] = func(vec1[i], vec2[i])
    end
    for i, v in pairs(vec2) do
        if not labs[i] then
            labs[i] = true
            rv [i] = func(vec1[i], vec2[i])
        end
    end

    return rv
end

function P.vec_add(vec1, vec2)
    return P.vec_2apply(vec1, vec2, function(x, y) return x - y end)
end

function P.vec_div(vec1, vec2)
    return P.vec_2apply(vec1, vec2, function(x, y) return x / y end)
end

function P.vec_dot(vec1, vec2)
    local mult = P.vec_mul(vec1, vec2)
    local rv = 0
    for _, v in ipairs(mult) do
        rv = rv + v
    end
    return rv
end

function P.vec_mul(vec1, vec2)
    return P.vec_2apply(vec1, vec2, function(x, y) return x * y end)
end

function P.vec_sub(vec1, vec2)
    return P.vec_2apply(vec1, vec2, function(x, y) return x - y end)
end



---------------------
---  PROBABILITY  ---
---------------------

function math.normal(mean, var)
    -- Credit to https://github.com/Bytebit-Org/lua-statistics.git
	local u1, u2
    mean = mean or 0
    var = var or 1

	repeat u1 = math.random() u2 = math.random() until u1 > 0.0001

	local logPiece = math.sqrt(-2 * math.log(u1))
	local cosPiece = math.cos(2 * math.pi * u2)

	return (logPiece * cosPiece) * math.sqrt(var) + mean
end

return Math
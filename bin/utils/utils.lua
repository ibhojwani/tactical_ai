
local P = {}
Utils = P

function table.copy(t)
    local rv = {}
    for i, v in pairs(t) do
        rv[i] = v
    end
    return rv
end

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

function P.vec_sub(vec1, vec2)
    return P.vec_2apply(vec1, vec2, function(x, y) return x - y end)
end

function P.vec_add(vec1, vec2)
    return P.vec_2apply(vec1, vec2, function(x, y) return x - y end)
end

function P.vec_mul(vec1, vec2)
    return P.vec_2apply(vec1, vec2, function(x, y) return x * y end)
end

function P.vec_div(vec1, vec2)
    return P.vec_2apply(vec1, vec2, function(x, y) return x / y end)
end

function P.normal(mean, var)
    -- Credit to https://github.com/Bytebit-Org/lua-statistics.git
	local u1, u2
    mean = mean or 0
    var = var or 1

	repeat u1 = math.random() u2 = math.random() until u1 > 0.0001

	local logPiece = math.sqrt(-2 * math.log(u1))
	local cosPiece = math.cos(2 * math.pi * u2)

	return (logPiece * cosPiece) * math.sqrt(var) + mean
end

function P.idx_coords(table)
    local rv = {}
    rv[1] = table.x
    rv[2] = table.y
    rv[3] = table.z
    return rv
end


return Utils
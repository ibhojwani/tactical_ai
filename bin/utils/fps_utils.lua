local Utils = require "bin.utils.utils"

local P = {}
Fps = P


function P.check_broad_phase(args)
    local objs = table.flatten(args)
    
end


function P.check_collision(obj1, obj2)
    if (obj1.shape == "circle") and (obj2.shape == "circle") then
        return P.check_collision_circ(obj1.hb_loc, obj1.radius, obj2.loc, obj2.radius)
    end
    if ((obj1.shape == "circle") and (obj2.shape == "rect")) then
        return P.check_collision_circ_rect(obj1.hb_loc, obj1.radius, obj2.loc, obj2.width, obj2.height)
    end
    if ((obj1.shape == "rect") and (obj2.shape == "circle")) then
        return P.check_collision_circ_rect(obj2.loc, obj2.radius, obj1.hb_loc, obj1.width, obj1.height)
    end
    if (obj1.shape == "rect") and (obj2.shape == "rect") then
        return P.check_collision_rect(obj1.hb_loc, obj1.width, obj1.height, obj2.loc, obj2.width, obj2.height)
    end

end


function P.check_collision_rect(x1,y1,w1,h1, x2,y2,w2,h2)
    -- TODO: this is incorrect, doesn't do partial overlaps right. too lazy to fix right now.
    return x1 < x2+w2 and
            x2 < x1+w1 and
            y1 < y2+h2 and
            y2 < y1+h1
end


function P.check_collision_circ(loc1, r1, loc2, r2)
    ---@diagnostic disable-next-line: redundant-parameter
    return Utils:norm(Utils:vec_sub({loc1.x, loc1.y}, {loc2.x, loc2.y})) < (r1 + r2)
end


function P.check_collision_circ_rect(xy,y1,r1, x2,y2,w2,h2)

end


return Fps
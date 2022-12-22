local Math = require "bin.utils.math"

local P = {}
Fps = P


-- function P.collide(objs)
--     objs = P.__collide_broad(objs)
--     objs = P.__collide_broadcollide_broad(objs)
--     return objs
-- end

-- function P.__collide_broad(args)
--     --[[
--     Implements an algorithm that checks if objects could be colliding
--     depending on axis aligned bounding box (AABB) of hitbox, using
--     Sort and Sweep algorithm.

--     Inputs: Aribtrary nested table of n objects to check for collisions.
--         Expects object to have:
--         obj.AABB.x1, obj.AABB.x2, obj.AABB.y1, obj.AABB.y2
--     Outputs: nxn matrix of potential collisions
--     --]]

--     -- Flatten nested table to get objects and initialize return val
--     local objs = table.flatten(args)
--     local rv = {}

--     -- do first axis
--     for i 
-- end

-- function P.__collide_narrow(args)
--     local objs = table.flatten(args)
    
-- end


function P.check_collision(obj1, obj2)
    if (obj1.shape == "circle") and (obj2.shape == "circle") then
        return P.check_collision_circ(obj1.hb_loc, obj1.hb_radius, obj2.hb_loc, obj2.hb_radius)
    end
    if ((obj1.shape == "circle") and (obj2.shape == "rect")) then
        return P.check_collision_circ_rect(obj1.hb_loc, obj1.hb_radius, obj2.hb_loc, obj2.hb_width, obj2.hb_height)
    end
    if ((obj1.shape == "rect") and (obj2.shape == "circle")) then
        return P.check_collision_rect_circ(obj1.hb_loc,obj1.hb_width,obj1.hb_height, obj2.hb_loc, obj2.hb_radius)
    end
    if (obj1.shape == "rect") and (obj2.shape == "rect") then
        return P.check_collision_rect(obj1.hb_loc, obj1.hb_width, obj1.hb_height, obj2.hb_loc, obj2.hb_width, obj2.hb_height)
    end

end


function P.check_collision_rect(loc1,w1,h1, loc2,w2,h2)
    -- TODO: this is incorrect, doesn't do partial overlaps right. too lazy to fix right now.
    return loc1.x <= loc2.x+w2 and
            loc2.x <= loc1.x+w1 and
            loc1.y <= loc2.y+h2 and
            loc2.y <= loc1.y+h1
end


function P.check_collision_circ(loc1, r1, loc2, r2)
    ---@diagnostic disable-next-line: redundant-parameter
    return Math:norm(Math:vec_sub({loc1.x, loc1.y}, {loc2.x, loc2.y})) < (r1 + r2)
end


function P.check_collision_circ_rect(loc1,r1, loc2,w2,h2)
    return loc1.x <= (loc2.x+w2+r1) and
        loc1.x >= (loc2.x-r1) and
        loc1.y <= (loc2.y+h2+r1) and
        loc1.y >= (loc2.y-r1)
end


function P.check_collision_rect_circ(loc2,w2,h2, loc1,r1)
    return P.check_collision_circ_rect(loc1,r1, loc2,w2,h2)
end

return Fps
local Math = require "bin.utils.math"

local P = {}
Fps = P


function P.run_collisions(objects)
    for i1, obj1 in ipairs(objects) do
        if not (obj1.exists and obj1.collide) then goto obj1_continue end
        for i2, obj2 in ipairs(objects) do
            if (not (obj2.exists and obj2.collide)) or (i1 == i2) then goto obj2_continue end
            
            local collide = P.check_intersect(obj1, obj2)
            if collide then
                P.handle_collide(obj1, obj2)
            end 
            
            ::obj2_continue::
        end
        ::obj1_continue::
    end
end

function P.handle_collide(obj1, obj2)
    if (not Table.contains(obj1.immune_from or {}, obj2.id)) then
        obj1:register_hit(obj2)
    end
    if (not Table.contains(obj2.immune_from or {}, obj1.id)) then
        obj2:register_hit(obj1)
    end
    if (not obj1.exists) then
        print(obj2.id .. " Kills " .. obj1.id)
    end
    if (not obj2.exists) then
        print(obj1.id .. " Kills ".. obj2.id)
    end

end

function P.check_intersect(obj1, obj2)
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
    return Math.norm(Math.vec_sub({loc1.x, loc1.y}, {loc2.x, loc2.y})) < (r1 + r2)
    
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
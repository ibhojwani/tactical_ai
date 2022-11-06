
local P = {}
Fps = P

function P.check_collision(x1,y1,w1,h1, x2,y2,w2,h2)
    -- this is incorrect, doesn't do partial overlaps right. too lazy to fix right now.
    return x1 < x2+w2 and
            x2 < x1+w1 and
            y1 < y2+h2 and
            y2 < y1+h1
end


return Fps
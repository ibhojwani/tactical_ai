--[[
    Implements basic physical entities. Anyting physical that needs a hitbox / to be drawn.

    
]]
local Object = require "bin.utils.classic"

local P = Object:extend()
Entity = P

P.default_loc = {x = 0, y = 0}
P.default_width = 10
P.default_height = 10
P.default_exists = true
P.default_collide = true
P.default_hb_loc = P.default_loc
P.default_hb_width = P.default_width
P.default_hb_height = P.default_hb_height


function Entity:new(args)
    local args = args or {}
    local p = {}

    -- Entity visual location
    if not args.exists == nil then p.exists = args.exists else p.exists = self.default_exists end
    if p.exists then
        p.loc = args.loc or self.default_loc
        p.width = args.width or self.default_width
        p.height = args.height or self.default_height
    end

    -- Entity hitbox location
    -- Note that p.collide=true and p.exists=false is a valid state.
    if not args.collide == nil then p.collide = args.collide else p.collide = self.default_collide end
    if p.collide then
        p.hb_loc = args.hb_loc or p.loc or self.default_hb_loc
        p.hb_width = args.hb_width or p.width or self.default_hb_width
        p.hb_height = args.hb_height or p.height or self.default_hb_height
    end

    return p
end


return Entity


--[[
    Implements basic physical entities. Anyting physical that needs a hitbox / to be drawn.

    
]]
local Object = require "bin.utils.classic"

local P = Object:extend()
Entity = P

P.default_loc = {x = 0, y = 0}
P.default_width = 10
P.default_height = 10
P.default_color = {1, 1, 1}
P.default_exists = true
P.default_collide = true
P.default_hb_loc = P.default_loc
P.default_hb_width = P.default_width
P.default_hb_height = P.default_hb_height


function Entity:new(args)
    local args = args or {}
    local p = {}

    p.color = args.color or self.default_color

    -- Entity visual location
    if not args.exists == nil then p.exists = args.exists else p.exists = self.default_exists end
    if p.exists then
        p.loc = args.loc or table.copy(self.default_loc)
        p.width = args.width or self.default_width
        p.height = args.height or self.default_height
    end

    -- Entity hitbox location
    -- Note that p.collide=true and p.exists=false is a valid state.
    if not args.collide == nil then p.collide = args.collide else p.collide = self.default_collide end
    if p.collide then
        p.hb_loc =  p.loc or args.hb_loc or table.copy(self.default_hb_loc)
        p.hb_width = args.hb_width or p.width or self.default_hb_width
        p.hb_height = args.hb_height or p.height or self.default_hb_height
    end

    return p
end


function P:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.loc.x, self.loc.y, self.width, self.height)
end


function P:draw_hb()
    love.graphics.setColor({0, 1, 0})
    love.graphics.rectangle("line", self.hb_loc.x, self.hb_loc.y, self.hb_width, self.hb_height)
end

return Entity


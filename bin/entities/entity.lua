--[[
    Implements basic physical entities. Anyting physical that needs a hitbox / to be drawn.

    
]]
local Object = require "bin.utils.classic"
local Fps = require "bin.utils.fps_utils"

local P = Object:extend()
Entity = P

P.__name = "Entity"
P.default_loc = {x = 0, y = 0}
P.default_width = 10
P.default_height = 10
P.default_rotation = 0
P.default_color = {1, 1, 1}
P.default_exists = true
P.default_collide = true
P.default_hb_loc = P.default_loc
P.default_hb_width = P.default_width
P.default_hb_height = P.default_hb_height
P.default_hb_rotation = P.default_rotation

function P:new(args)
    local args = args or {}
    local p = {}

    p.color = args.color or self.default_color

    -- Entity visual location
    if not args.exists == nil then p.exists = args.exists else p.exists = self.default_exists end
    if p.exists then
        p.loc = args.loc or table.copy(self.default_loc)
        p.width = args.width or self.default_width
        p.height = args.height or self.default_height
        p.rotation = args.rotation or self.default_rotation
    end

    -- Entity hitbox location
    -- Note that p.collide=true and p.exists=false is a valid state.
    if not args.collide == nil then p.collide = args.collide else p.collide = self.default_collide end
    if p.collide then
        p.hb_loc =  p.loc or args.hb_loc or table.copy(self.default_hb_loc)
        p.hb_width = args.hb_width or p.width or self.default_hb_width
        p.hb_height = args.hb_height or p.height or self.default_hb_height
        p.hb_rotation = args.hb_rotation or p.rotation or self.default_hb_rotation

    end

    self.__index = self
    setmetatable(p, self)

    return p
end


function P:draw()
    if self.exists then
        love.graphics.push()

        love.graphics.translate(self.loc.x, self.loc.y)
        love.graphics.rotate(self.rotation * 2 * math.pi / 360)
        love.graphics.setColor(self.color)
        love.graphics.rectangle("fill", 0, 0, self.width, self.height)

        love.graphics.pop()
    end
end


function P:draw_hb()
    if self.collide then
        love.graphics.setColor({0, 1, 0})
        love.graphics.rectangle("line", self.hb_loc.x, self.hb_loc.y, self.hb_width, self.hb_height)
    end
end


function P:register_hit(ammo)
    if (love.timer.getTime() - ammo.start_time) < 0.050 then return nil end -- TODO: this could lead to shooting thru walls

    if self.health == nil then goto nohealth end
    self.health = self.health - ammo.damage
    if self.health <= 0 then
        ---@diagnostic disable-next-line: missing-parameter
        self.die(self)
    end

    ::nohealth::
    ammo.exists = false
    ammo.collide = false

end


function P:die()
    self.exists = false
    self.collide = false
end

return Entity


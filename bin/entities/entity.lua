--[[
    Implements basic physical entities. Anyting physical that needs a hitbox / to be drawn.

    
]]
local Object = require "bin.utils.classic"
local Fps = require "bin.utils.fps_utils"
local Table = require "bin.utils.table"


local P = Object:extend()
Entity = P

-- general params
P.__name = "Entity"
P.default_color = {1, 1, 1}
P.default_exists = true
P.default_collide = true
P.default_damage = 0
P.default_health = 100

-- character model
P.default_loc = {x = 0, y = 0}
P.default_shape = "circle"
P.default_radius = 10
P.default_height = 5
P.default_width = 10
P.default_rotation = {{1, 0}, {0, 1}}

-- hitbox
P.default_hb_loc = P.default_loc
P.default_hb_radius = P.default_radius
P.default_hb_height = P.default_height
P.default_hb_width = P.default_width
P.default_hb_rotation = P.default_rotation

P.id_gen = 0

function P:new(args)
    local args = args or {}
    local p = {}

    p.id = self.__name .. tostring(self.id_gen)
    self.id_gen = self.id_gen + 1
    p.immune_from = {p.id}

    p.shape = args.shape or self.default_shape
    p.color = args.color or self.default_color
    p.damage = args.damage or self.default_damage
    p.health = args.health or self.default_health
    if not args.exists == nil then p.exists = args.exists else p.exists = self.default_exists end

    -- Entity visual location
    if p.exists then
        p.loc = args.loc or Table.copy(self.default_loc)
        p.radius = args.radius or self.default_radius
        p.width = args.width or self.default_width
        p.height = args.height or self.default_height
        p.rotation = args.rotation or self.default_rotation
    end

    -- Entity hitbox location
    -- Note that p.collide=true and p.exists=false is a valid state.
    if not args.collide == nil then p.collide = args.collide else p.collide = self.default_collide end
    if p.collide then
        p.hb_loc =  args.hb_loc or Table.copy(p.loc) or Table.copy(self.default_hb_loc)
        p.hb_radius = args.hb_radius or p.radius or self.default_hb_radius
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
        love.graphics.setColor(self.color)

        if self.shape == "rect" then
            love.graphics.rectangle("fill", 0, 0, self.width, self.height)
        else
            love.graphics.circle("fill", 0, 0, self.radius)
        end

        love.graphics.pop()
    end
end


function P:draw_hb()
    if self.collide then
        love.graphics.push()

        love.graphics.translate(self.hb_loc.x, self.hb_loc.y)
        love.graphics.setColor({0, 1, 0})

        if self.shape == "rect" then
            love.graphics.rectangle("line", 0, 0, self.hb_width, self.hb_height)
        else
            love.graphics.circle("line", 0, 0, self.hb_radius)
        end

        love.graphics.pop()
    end
end


function P:register_hit(obj, damage)
    -- impact on this object of the collision
    if obj.owner == self.id then return nil end

    self.health = self.health - (damage or obj.damage or 0)
    if self.health <=0 then
        self:die()
    end

end

function P:die()
    self.exists = false
    self.collide = false
end


function P:move(dt, dir, speed)
    local speed = speed or self.speed
    local dir = dir or self.dir
    self.loc.x = self.loc.x + dir.x * speed * dt
    self.loc.y = self.loc.y + dir.y * speed * dt

    self.hb_loc.x = self.hb_loc.x + dir.x * speed * dt
    self.hb_loc.y = self.hb_loc.y + dir.y * speed * dt
end




return Entity


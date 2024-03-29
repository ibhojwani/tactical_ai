
local Math = require "bin.utils.math"
local Entity = require "bin.entities.entity"

local P = Entity:extend()
Ammo = P

P.__name = "Ammo"
P.default_shape = "circle"
P.default_radius = 1
P.default_color = {0.858, 0.890, 0.168}
P.default_speed = 400
P.default_bullet_var = 0.001
P.default_damage = 34

P.ammo_mgr = {}


function P:new(init_loc, target_loc, owner, args)
    local args = args or {}
    args.loc = init_loc -- pass loc to Entity builder to get hitboxes
    local p = self.super.new(self, args)

    if p.id == "Ammo0" then p.id="Buns Bullet" end

    p.target_loc = target_loc
    p.immune_from[#p.immune_from+1] = owner
    p.team = args.team or nil
    p.color = args.color or self.default_color
    p.speed = args.speed or self.default_speed
    p.radius = args.radius or self.default_radius
    p.bullet_var = args.color or self.default_bullet_var
    p.damage = args.color or self.default_damage
    p.start_time = love.timer.getTime()

    -- get direction of travel by getting vector between init and target locations, and adding random fuzz
    local dir = Math.vec_sub(p.target_loc, p.loc)
    dir = Math.normalize(dir)
    p.dir = Math.normalize({x = dir.x + math.normal(0, p.bullet_var), y = dir.y + math.normal(0, p.bullet_var)})

    self.__index = self
    setmetatable(p, self)

    self.ammo_mgr[#self.ammo_mgr+1] = p

    return p
end

function P:register_hit(obj)
    self.super.register_hit(self, obj, self.health)
end


return Ammo
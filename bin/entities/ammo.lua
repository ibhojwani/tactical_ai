
local Utils = require "bin.utils.utils"
local Entity = require "bin.entities.entity"

local P = Entity:extend()
Ammo = P

P.__name = "Ammo"
P.default_shape = "circle"
P.default_radius = 5
P.default_color = {0.858, 0.890, 0.168}
P.default_speed = 1000
P.default_bullet_var = 0.001
P.default_damage = 34

P.ammo_mgr = {}


function P:new(init_loc, target_loc, owner, args)
    local args = args or {}
    args.loc = init_loc -- pass loc to Entity builder to get hitboxes
    local p = self.super.new(self, args)

    p.target_loc = target_loc
    p.owner = owner
    p.team = args.team or nil
    p.color = args.color or self.default_color
    p.speed = args.speed or self.default_speed
    p.radius = args.radius or self.default_radius
    p.bullet_var = args.color or self.default_bullet_var
    p.damage = args.color or self.default_damage
    p.start_time = love.timer.getTime()

    -- get direction of travel by getting vector between init and target locations, and adding random fuzz
    local dir = Utils.vec_sub(p.target_loc, p.loc)
    dir = Utils.normalize(dir)
    p.dir = Utils.normalize({x = dir.x + Utils.normal(0, p.bullet_var), y = dir.y + Utils.normal(0, p.bullet_var)})

    self.__index = self
    setmetatable(p, self)

    self.ammo_mgr[#self.ammo_mgr+1] = p

    return p
end


function P:register_hit(target)
    if self.owner == target.id then return nil end

    if target.health == nil then goto nohealth end
    target.health = target.health - self.damage
    if target.health <= 0 then
        target.die(target)
    end

    ::nohealth::
    self.exists = false
    self.collide = false

end


return Ammo
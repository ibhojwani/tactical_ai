
local Utils = require "bin.utils.utils"
local Entity = require "bin.entities.entity"

local P = Entity:extend()
Ammo = P

P.default_color = {0.858, 0.890, 0.168}
P.default_speed = 500
P.default_width = 5
P.default_height = 10
P.default_bullet_var = 0.001
P.default_damage = 34

P.ammo_mgr = {}


function P:new(init_loc, target_loc, args)
    local args = args or {}
    args.loc = init_loc -- pass loc to Entity builder to get hitboxes
    local p = self.super.new(self, args)

    p.target_loc = target_loc
    p.color = args.color or self.default_color
    p.speed = args.speed or self.default_speed
    p.width = args.width or self.default_width
    p.height = args.height or self.default_height
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


function P:move(dt)
    self.loc.x = self.loc.x + self.dir.x * self.speed * dt
    self.loc.y = self.loc.y + self.dir.y * self.speed * dt
end

return Ammo
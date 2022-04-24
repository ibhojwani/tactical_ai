
local Ammo = require "bin.entities.ammo"
local Entity = require "bin.entities.entity"

local P = Entity:extend()
Guy = P

P.spawn_limits = 100
P.default_health = 100
P.default_width = 10
P.default_height = 10

P.guy_mgr = {}


function P:new(team, args)
    local args = args or {}
    local p = self.super.new(self, args)

    p.team = team or {}

    p.health = args.health or self.default_health
    p.width = args.width or self.default_width
    p.height = args.width or self.default_height
    p.color = p.team.color

    -- Set spawn location
    local screen_width = love.graphics.getWidth()
    local screen_height = love.graphics.getHeight()

    local x = self.spawn_limits / 2 + ((screen_width - self.spawn_limits) * math.random())
    local y
    if p.team.name == "team1" then
        y = self.spawn_limits / 2 + ((screen_height - self.spawn_limits) * math.random() / 2)
    else
        y = self.spawn_limits / 2 + (screen_height - self.spawn_limits) * (math.random() + 1) / 2
    end
    p.loc = {x=x, y=y}
    p.hb_loc = p.loc

    -- Set inheritence
    self.__index = self
    setmetatable(p, self)

    self.guy_mgr[#self.guy_mgr+1] = p
    return p
end


function P:shoot()
    if (not self.target) or (not self.target_dir) then return nil end
    Ammo:new(table.copy(self.loc), table.copy(self.target_loc))
end


function P:map_enemies()
    if self.team.name == "team1" then
        self.target = team2.guys[math.random(1, #team2.guys)]
    else
        self.target = team1.guys[math.random(1, #team1.guys)]
    end
    self.target_loc = {x=self.target.loc.x, y=self.target.loc.y}
    self.target_dir = {x=self.target.loc.x - self.loc.x, y=self.target.loc.y - self.loc.y}
end


function P:draw_target()
    if not self.target_loc then return nil end
    love.graphics.setColor({0.5, 0.5, 0})
    love.graphics.line(self.loc.x, self.loc.y, self.target_loc.x, self.target_loc.y)
end


function P:register_hit(ammo)
    self.health = self.health - ammo.damage
    if self.health <= 0 then
        self.exists = false
        self.collide = false
    end
    ammo.exists = false
    ammo.collide = false
end



return Guy
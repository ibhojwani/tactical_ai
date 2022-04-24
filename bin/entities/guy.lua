
local Ammo = require "bin.entities.ammo"
local Entity = require "bin.entities.entity"

local P = Entity:extend()
Guy = P

P.spawn_limits = 100
P.default_health = 100
P.default_width = 10
P.default_height = 10

P.guy_mgr = {}


function P:new(team, ...)
    local args = {} -- doing this to avoid a false positive syntax editor in the linter
    args = {...}
    local p = self.super.new(self, args)

    p.team = team or {}

    P.health = args.health or self.default_health
    P.width = args.width or self.default_width
    P.height = args.width or self.default_height

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

    -- Set inheritence
    self.__index = self
    setmetatable(p, self)

    self.guy_mgr[#self.guy_mgr+1] = p
    return p
end


function P:draw()
    love.graphics.setColor(self.team.color)
    love.graphics.rectangle("fill", self.loc.x, self.loc.y, self.width, self.height)
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


return Guy
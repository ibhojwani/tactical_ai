
local Ammo = require "bin.entities.ammo"
local Entity = require "bin.entities.entity"

local P = Entity:extend()
Guy = P

P.__name = "Guy"
P.spawn_limits = 100
P.default_health = 100
P.default_width = 10
P.default_height = 10

P.guy_mgr = {}


function P:new(team, args)
    local args = args or {}
    -- parent does color, initial hit box and physical loc
    local p = self.super.new(self, args)

    p.team = team or {}

    p.health = args.health or self.default_health
    p.width = args.width or self.default_width
    p.height = args.width or self.default_height
    p.target = {}
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
    if (not self.target) or (not self.target_dir) or (not self.target.exists) then self:map_enemies() end
    if (not self.target) or (not self.target_dir) or (not self.target.exists) then return nil end -- if no targets found, return

    local bullet = Ammo:new(table.copy(self.loc), table.copy(self.target_loc))
end


function P:map_enemies()
    local enemy_team
    if self.team.name == "team1" then enemy_team = team2 else enemy_team = team1 end

    local i = 0
    while (not self.target.exists) and (i < enemy_team.num_guys) do
        self.target = enemy_team.guys[math.random(1, #enemy_team.guys)]
        i = i + 1
    end

    self.target_loc = {x=self.target.loc.x, y=self.target.loc.y}
    self.target_dir = {x=self.target.loc.x - self.loc.x, y=self.target.loc.y - self.loc.y}
end


function P:draw_target()
    if (not self.target_loc) or (not self.target.exists) or (not self.exists) then return nil end
    love.graphics.setColor({0.5, 0.5, 0})
    love.graphics.line(self.loc.x, self.loc.y, self.target_loc.x, self.target_loc.y)
end


function P:register_hit(ammo)
    self.super.register_hit(self, ammo)
    if self.health <= 0 then
        self.team.num_guys = self.team.num_guys - 1
    end

end


function P:bump_wall(wall)

end

return Guy
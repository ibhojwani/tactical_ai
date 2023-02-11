local Guy = require "bin.entities.guy"
local Object = require "bin.utils.classic"

local P = Object:extend()
Team = P

P.default_color = {1, 1, 1}
P.default_name = "DEFAULT TEAM NAME"

function P:new(name, color, ...)
    local p = self.super.new(...)

    p.name = name or self.default_name
    p.color = color or self.default_color
    P.num_guys = 0

    self.__index = self
    setmetatable(p, self)

    return p
end


function P:add_guys(n)
    -- create new guys
    self.guys = self.guys or {}
    for i=1, n do
        self.guys[#self.guys + 1] = Guy:new(self)
    end

    -- update count of guys on team
    self.num_guys = #self.guys
end


function P:draw()
    if (not self.guys) or (#self.guys == 0) then return nil end

    for _, guy in ipairs(self.guys) do
        guy:draw()
    end
end


function P:map_enemies()
    if (not self.guys) or (#self.guys == 0) then return nil end

    for _, guy in ipairs(self.guys) do
        guy:map_enemies()
    end
end


function P:shoot()
    if (not self.guys) or (#self.guys == 0) then return nil end

    for _, guy in ipairs(self.guys) do
        guy:shoot()
    end
end


return Team

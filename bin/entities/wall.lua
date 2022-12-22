
local Object = require "bin.utils.classic"

local P = Entity:extend()
Wall = P

P.__name = "Wall"
P.default_health = 33
P.default_shape = "rect"
P.default_width = 500
P.default_height = 10
P.default_x = love.graphics.getWidth() / 2
P.default_y = love.graphics.getHeight() / 2
P.default_rotation = 0
P.default_health = 20

P.max_width = 0
P.max_height = 0

P.wall_mgr = {}


function P:new(args)
    local args = args or {}
    -- parent does color, initial hit box and physical loc
    local p = self.super.new(self, args)
    p.__name = "Wall"

    p.shape = args.shape or "rect"

    -- Set inheritence
    self.__index = self
    setmetatable(p, self)

    self.wall_mgr[#self.wall_mgr+1] = p
    return p
end


return Wall
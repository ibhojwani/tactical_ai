
local Wall = require "bin.entities.wall"
local Object = require "bin.utils.classic"

local P = Object:extend()
Arena = P

P.__name = "Arena"
P.default_num_walls = 10
P.default_widths = {}
P.default_lengths = {}
P.default_rotations = {}
P.default_locs = {}


function P:new(args)
    local args = args or {}
    local p = self.super.new(self, args)

    p.num_walls = args.num_walls or P.default_num_walls

    for i=1, p.num_walls do
        P.default_widths[#P.default_widths + 1] = math.random(10, love.graphics.getWidth() / 4)
        P.default_lengths[#P.default_lengths + 1] = math.random(10, love.graphics.getHeight() / 20)
        P.default_rotations[#P.default_rotations + 1] = math.random(0, 360)
        P.default_locs[#P.default_locs + 1] = {x=math.random(0, love.graphics.getWidth()), y=math.random(0, love.graphics.getHeight())}
    end

    self.generate_walls(self, {num_walls=p.num_walls})

    self.__index = self
    setmetatable(p, self)

    return p
end

function P:generate_walls(args)
    local num_walls = args.num_walls
    for i=1, num_walls do
        local wall_args = {
            width = P.default_widths[i],
            height = P.default_lengths[i],
            rotation = P.default_rotations[i],
            loc = P.default_locs[i]
        }
        Wall:new(wall_args)
    end
end


return Arena
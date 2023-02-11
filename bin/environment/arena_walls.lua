
local Wall = require "bin.entities.wall"
local Object = require "bin.utils.classic"

local P = Object:extend()
ArenaWalls = P

P.__name = "ArenaWalls"


function P:gen_env(args)
    local args = args or {}
    local p = self.super.new(self, args)

    p.num_walls = love.math.random(10,14)
    p.widths = {}
    p.lengths = {}
    p.rotations = {}
    p.locs = {}

    local screen_width = love.graphics.getWidth()
    local screen_height = love.graphics.getHeight()
    local spawn_limits = 10
    for i=1, p.num_walls do
        p.widths[#p.widths + 1] = math.random(10, screen_width / 3)
        p.lengths[#p.lengths + 1] = 10
        p.rotations[#p.rotations + 1] = math.random(0, math.pi * 2)
        p.locs[#p.locs + 1] = {x=spawn_limits / 2 + ((screen_width - spawn_limits) * math.random()), y=spawn_limits / 2 + ((screen_height - spawn_limits) * math.random())}
    end

    for i=1, p.num_walls do
        local wall_args = {
            width = p.widths[i],
            height = p.lengths[i],
            rotation = p.rotations[i],
            loc = p.locs[i]
        }
        Wall:new(wall_args)
    end

    return p
end


function P:room()
    
end


function P:hallway()
end


function P:__tostring()
    return self.__name
  end


return ArenaWalls
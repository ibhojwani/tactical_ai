
local EnvObjs = require "bin.environment.env_objects"
local Object = require "bin.utils.classic"

local P = Object:extend()
ArenaTrees = P

P.__name = "ArenaTrees"


function P:gen_env(args)
    local args = args or {}
    local p = self.super.new(self, args)
    
    p.num_walls = love.math.random(20,50)
    p.widths = {}
    p.lengths = {}
    p.rotations = {}
    p.locs = {}
    
    local screen_width = love.graphics.getWidth()
    local screen_height = love.graphics.getHeight()
    local spawn_limits = 10
    for i=1, p.num_walls do
        p.widths[#p.widths + 1] = math.normal(10, 0.5)
        p.lengths[#p.lengths + 1] = math.normal(10, 0.5)
        p.rotations[#p.rotations + 1] = math.random(0, math.pi * 2)
        p.locs[#p.locs + 1] = {x=spawn_limits / 2 + ((screen_width - spawn_limits) * math.random()), y=spawn_limits / 2 + ((screen_height - spawn_limits) * math.random())}
    end    


    for i=1, p.num_walls do
        EnvObjs.tree(p.locs[i])
    end

    return p
end


function P:__tostring()
    return self.__name
  end


return ArenaTrees
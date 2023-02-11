
local Wall = require "bin.entities.wall"
local Object = require "bin.utils.classic"

local P = Object:extend()
EnvObjs = P

P.__name = "EnvObjs"


function P.tree(loc)
    local wall_args = {
        width = math.normal(10, 5),
        height = math.normal(10, 5),
        rotation = love.math.random(0, 360) / 360 * 2 * math.pi,
        loc = loc or {x=0, y=0}
    }
    Wall:new(wall_args)
end


function P.room(loc, w, h)
    local wall_args = {
        width = math.normal(10, 5),
        height = math.normal(10, 5),
        rotation = love.math.random(0, 360) / 360 * 2 * math.pi,
        loc = loc or {x=0, y=0}
    }
    Wall:new(wall_args)
end


function P:__tostring()
    return self.__name
  end


return EnvObjs
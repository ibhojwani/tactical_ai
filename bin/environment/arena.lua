
local Object = require "bin.utils.classic"

local P = Object:extend()
Arena = P


function P:new()
    local p = {}



    self.__index = self
    setmetatable(p, self)

    return p
end


return Arena
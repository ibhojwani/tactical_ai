local P = {}
Arena = {}


function P:new()
    local p = {}

    self.__index = self
    setmetatable(p, self)

    return p
end


return Arena
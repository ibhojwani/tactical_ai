
local Object = require "bin.utils.classic"

local P = Object:extend()
Entity = P

P.default_loc = {x = 0, y = 0}
P.default_exists = true
P.default_collide = true

function Entity:new(...)
    local args = {} -- doing this to avoid a false positive syntax editor in the linter
    args = {...}
    local p = {}

    p.loc = args.loc or self.default_loc
    if not args.exists == nil then p.exists = args.exists else p.exists = self.default_exists end
    if not args.collide == nil then p.exists = args.collide else p.collide = self.default_collide end

    return p
end


return Entity


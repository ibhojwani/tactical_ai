
local Wall = require "bin.entities.wall"
local Object = require "bin.utils.classic"
local ArenaRooms = require "bin.environment.arena_rooms"
local ArenaTrees = require "bin.environment.arena_trees"
local ArenaWalls = require "bin.environment.arena_walls"

local P = Object:extend()
Arena = P

P.__name = "Arena"
P.default_num_walls = 10
P.default_widths = {}
P.default_lengths = {}
P.default_rotations = {}
P.default_locs = {}
P.default_arena_type = 0
P.default_size = 0

function P:new(args)
    local args = args or {}
    local p = self.super.new(self, args)

    p.num_walls = args.num_walls or P.default_num_walls
    p.arena_type = args.arena_type or P.default_arena_type
    p.size = args.size or P.default_size

    local arena_gens = {
        ArenaTrees,
        ArenaRooms,
        ArenaWalls
        }

    local gen_env = arena_gens[p.arena_type]
    if (p.arena_type == 0) or (gen_env == nil) then
        gen_env = arena_gens[love.math.random(1, #arena_gens)]
    end

    if gen_env ~= nil then
        gen_env:gen_env()
    end

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


function P:__tostring()
    return self.__name
  end


return Arena
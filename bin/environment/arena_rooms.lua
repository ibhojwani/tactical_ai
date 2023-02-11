
local Wall = require "bin.entities.wall"
local Object = require "bin.utils.classic"

local P = Object:extend()
ArenaRooms = P

P.__name = "ArenaRooms"
P.default_num_walls = love.math.random(20,50)
P.default_widths = {}
P.default_lengths = {}
P.default_rotations = {}
P.default_locs = {}

local screen_width = love.graphics.getWidth()
local screen_height = love.graphics.getHeight()
local spawn_limits = 10
for i=1, P.default_num_walls do
    P.default_widths[#P.default_widths + 1] = math.normal(10, 0.5)
    P.default_lengths[#P.default_lengths + 1] = math.normal(10, 0.5)
    P.default_rotations[#P.default_rotations + 1] = math.random(0, math.pi * 2)
    P.default_locs[#P.default_locs + 1] = {x=spawn_limits / 2 + ((screen_width - spawn_limits) * math.random()), y=spawn_limits / 2 + ((screen_height - spawn_limits) * math.random())}
end    


function P:gen_env(args)
    local args = args or {}
    local p = self.super.new(self, args)

    p.num_walls = args.num_walls or P.default_num_walls
    p.widths = args.widths or P.default_widths
    p.lengths = args.lengths or P.default_lengths
    p.rotation = args.rotation or P.default_rotation
    if args.locs == nil then
        for i, v in ipairs(P.default_locs) do
            P.default_locs[i] = {x=v.x * (love.graphics.getWidth() / 800), y=v.y * (love.graphics.getHeight()/600)}
        end
    end
    p.locs = args.locs or P.default_locs

    for i=1, p.num_walls do
        local wall_args = {
            width = P.default_widths[i],
            height = P.default_lengths[i],
            rotation = P.default_rotations[i],
            loc = P.default_locs[i]
        }
        Wall:new(wall_args)
    end

    return p
end

function P:__tostring()
    return self.__name
  end


return ArenaRooms
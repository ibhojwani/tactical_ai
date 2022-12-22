---@diagnostic disable: lowercase-global

local lldebugger
if arg[#arg] == "vsc_debug" then lldebugger = require("lldebugger").start() end

local Ammo = require "bin.entities.ammo"
local Arena = require "bin.environment.arena"
local Fps = require "bin.utils.fps_utils"
local Guy = require "bin.entities.guy"
local Team = require "bin.environment.team"
local Table = require "bin.utils.table"
local Wall = require "bin.entities.wall"

AI_SPEED = 0.5
TEAM_SIZE = 1
GLOBAL_TIMER = 0
WALL_CNT = 0

DEBUG = false
DRAW_HITBOXES = true
DRAW_TARGETS = false
LOG_HEALTH = true

if DEBUG then
    DRAW_HITBOXES = true
    DRAW_TARGETS = true
    LOG_HEALTH = true
end


function love.load()
    -- housekeeping
---@diagnostic disable-next-line: missing-parameter
    love.window.setMode(0, 0)
    WIDTH = love.graphics.getWidth()
    HEIGHT = love.graphics.getHeight()

    world = love.physics.newWorld()

    math.randomseed(os.time())
    _ = math.random() -- apparently need to do this so next draw is actually random

    
    -- init teams
    team1 = Team:new("team1", {0, 0, 1})
    team2 = Team:new("team2", {1, 0, 0})

    -- init guys
    team1:add_guys(TEAM_SIZE)
    team2:add_guys(TEAM_SIZE)

    -- init targets
    ai_timer = AI_SPEED
    for _, guy in ipairs(Guy.guy_mgr) do
        guy:map_enemies()
    end

    -- init walls
    Arena:new({num_walls=WALL_CNT})

end


function love.update(dt)
    GLOBAL_TIMER = GLOBAL_TIMER + dt
    ai_timer = ai_timer - dt

    -- target enemies
    if ai_timer < 0 then
        ai_timer = AI_SPEED
        for _, guy in ipairs(Guy.guy_mgr) do
            if guy.exists then
                guy:shoot()
            end
        end
    
    end

    -- move bullets
    for _, ammo in ipairs(Ammo.ammo_mgr) do
        ammo:move(dt)
    end

    
    ---------------------
    --- Hit Detection ---
    ---------------------
    objects = Table.concat(Guy.guy_mgr, Wall.wall_mgr, Ammo.ammo_mgr)
    for i, obj1 in objects do
        if not (obj1.exists and obj1.collide) then goto obj1_continue end
        for i2, obj2 in objects do
            if (not (obj2.exists and obj2.collide)) or (i == i2) then goto obj2_continue end
            local collide = Fps.check_collision(obj1, obj2)
            if collide then
                obj1.register_hit(obj2)
                obj2.register_hit(obj1)
            end 
            ::obj2_continue::
        end
        ::obj1_continue::
    end
    -- for _, guy in ipairs(Guy.guy_mgr) do
    --     if not (guy.exists and guy.collide) then goto guy_continue1 end
    
    --     for _, ammo in ipairs(Ammo.ammo_mgr) do
    --         if not (ammo.exists and ammo.collide) then goto ammo_continue1 end
    --         local collide = Fps.check_collision_circ(ammo.loc, ammo.radius, guy.loc, guy.radius)
    --         if collide then
    --             ammo:register_hit(guy)
    --         end
    --         ::ammo_continue1::
    --     end
    
    --     ::guy_continue1::
    -- end

    -- -- bullet <> wall hit detection
    -- for _, wall in ipairs(Wall.wall_mgr) do
    --     if not (wall.collide) then goto wall_continue2 end
    
    --     for _, ammo in ipairs(Ammo.ammo_mgr) do
    --         if not (ammo.exists and ammo.collide) then goto ammo_continue2 end
    --         local collide = Fps.check_collision_circ_rect(ammo.loc, ammo.radius, wall.loc, wall.width, wall.height)
    --         if collide then
    --             ammo:register_hit(wall)
    --         end
    --         ::ammo_continue2::
    --     end

    --     ::wall_continue2::
    -- end

    -- -- guy <> wall hit detection
    -- for _, guy in ipairs(Guy.guy_mgr) do
    --     if not (guy.exists and guy.collide) then goto guy_continue3 end
    
    --     for _, wall in ipairs(Wall.wall_mgr) do
    --         if not (wall.collide) then goto wall_continue3 end
    --         local collide = Fps.check_collision_rect_circ(wall.loc, wall.width, wall.height, guy.loc, guy.radius)
    --         if collide then
    --             guy:bump_wall(wall) -- TODO
    --         end
    --         ::wall_continue3::
    --     end
    
    --     ::guy_continue3::
    -- end
end

function love.draw()
    -- background
    love.graphics.setColor({0, 0, 0})
    love.graphics.rectangle("fill", 0, 1, WIDTH, HEIGHT)

    -- draw guys
    for _, guy in ipairs(Guy.guy_mgr) do
        guy:draw()
    end

    -- draw bullets
    for _, bullet in ipairs(Ammo.ammo_mgr) do
        bullet:draw()
    end

    -- draw walls
    for _, wall in ipairs(Wall.wall_mgr) do
        wall:draw()
    end

    -- draw debug tools
    if DRAW_HITBOXES then
        for _, guy in ipairs(Guy.guy_mgr) do
            guy:draw_hb()
        end
        for _, ammo in ipairs(Ammo.ammo_mgr) do
            ammo:draw_hb()
        end        
        for _, wall in ipairs(Wall.wall_mgr) do
            wall:draw_hb()
        end
    end

    if DRAW_TARGETS then
        for _, guy in ipairs(Guy.guy_mgr) do
            guy:draw_target()
        end
    end
    if LOG_HEALTH then
        for i, guy in pairs(Guy.guy_mgr) do
            if guy.exists then
                love.graphics.print(guy.health, love.graphics.getWidth() - 100, 100 + i * 15) end
        end
    end

end


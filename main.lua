---@diagnostic disable: lowercase-global
--[[
    needs
        done
            teams generate
            guys generate
            guys appear on screen
            guys target other teams
            guys can shoot
            bullets move
            generate hitboxes
            hit detection + death
            retarget after kill
            "win" state (they just stop shooting)
            generate terrain
            wall angles
        to do
            guys cant shoot thru walls
            guys dont spawn in walls
            function documentation
            change rate of firing so more random per guy
            enemy location memory
            clean up dead objects
            navigate terrain with purpose
                1) find enemy
                2) communicate to team + hunt down enemy
                3) more complex stuff
--]]


local lldebugger
if arg[#arg] == "vsc_debug" then lldebugger = require("lldebugger").start() end

local Ammo = require "bin.entities.ammo"
local Arena = require "bin.environment.arena"
local Fps = require "bin.utils.fps_utils"
local Guy = require "bin.entities.guy"
local Team = require "bin.environment.team"
local Wall = require "bin.entities.wall"


AI_SPEED = 0.5
TEAM_SIZE = 2
GLOBAL_TIMER = 0
WALL_CNT = 10

DEBUG = false
DRAW_HITBOXES = false
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
    -- bullet <> guy hit detectiona
    for _, guy in ipairs(Guy.guy_mgr) do
        if not (guy.exists and guy.collide) then goto guy_continue1 end
    
        for _, ammo in ipairs(Ammo.ammo_mgr) do
            if not (ammo.exists and ammo.collide) then goto ammo_continue1 end
            local collide = Fps.check_collision(ammo.loc.x, ammo.loc.y, ammo.width, ammo.height, guy.loc.x, guy.loc.y, guy.width, guy.height)
            if collide then
                guy:register_hit(ammo)
            end
            ::ammo_continue1::
        end
    
        ::guy_continue1::
    end

    -- bullet <> wall hit detection
    for _, wall in ipairs(Wall.wall_mgr) do
        if not (wall.collide) then goto wall_continue2 end
    
        for _, ammo in ipairs(Ammo.ammo_mgr) do
            if not (ammo.exists and ammo.collide) then goto ammo_continue2 end
            local collide = Fps.check_collision(ammo.loc.x, ammo.loc.y, ammo.width, ammo.height, wall.loc.x, wall.loc.y, wall.width, wall.height)
            if collide then
                wall:register_hit(ammo)
            end
            ::ammo_continue2::
        end

        ::wall_continue2::
    end

    -- guy <> wall hit detection
    for _, guy in ipairs(Guy.guy_mgr) do
        if not (guy.exists and guy.collide) then goto guy_continue3 end
    
        for _, wall in ipairs(Wall.wall_mgr) do
            if not (wall.collide) then goto wall_continue3 end
            local collide = Fps.check_collision(wall.loc.x, wall.loc.y, wall.width, wall.height, guy.loc.x, guy.loc.y, guy.width, guy.height)
            if collide then
                guy:bump_wall(wall) -- TODO
            end
            ::wall_continue3::
        end
    
        ::guy_continue3::
    end
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


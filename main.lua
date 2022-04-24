--[[
    guy

    needs
        done
            teams generate
            guys generate
            guys appear on screen
            guys target other teams
            guys can shoot
            bullets move
            generate hitboxes
        to do
            hit detection + death
            clean up dead objects
            win state
            generate terrain
            enemy location memory
            navigate terrain with purpose
                1) find enemy
                2) communicate to team + hunt down enemy
                3) more complex stuff
            guys can navigate terrain with purpose

--]]


local lldebugger
if arg[#arg] == "vsc_debug" then lldebugger = require("lldebugger").start() end

local Ammo = require "bin.entities.ammo"
local Arena = require "bin.environment.arena"
local Fps = require "bin.utils.fps_utils"
local Guy = require "bin.entities.guy"
local Team = require "bin.environment.team"

AI_SPEED = 0.6
TEAM_SIZE = 3
GLOBAL_TIMER = 0

DEBUG = true
DRAW_HITBOXES = false
DRAW_TARGETS = false

if DEBUG then
    DRAW_HITBOXES = true
    DRAW_TARGETS = true
end


function love.load()
    -- housekeeping
    love.window.setMode(0, 0)
    WIDTH = love.graphics.getWidth()
    HEIGHT = love.graphics.getHeight()

    math.randomseed(os.time())

    
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

    -- do guy<>guy hit detection

    -- do bullet <> guy hit detectiona
    for _, guy in ipairs(Guy.guy_mgr) do
        if not (guy.exists and guy.collide) then goto guy_continue end
    
        for _, ammo in ipairs(Ammo.ammo_mgr) do
            if not (ammo.exists and ammo.collide) then goto ammo_continue end
            local collide = Fps.check_collision(ammo.loc.x, ammo.loc.y, ammo.width, ammo.height, guy.loc.x, guy.loc.y, guy.width, guy.height)
            if collide then
                guy:register_hit(ammo)
            end
            ::ammo_continue::
        end
    
        ::guy_continue::
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

    if DEBUG then
        -- local txt = love.graphics.newText(love.graphics.getFont(), tostring(Guy.guy_mgr[1].exists))
        love.graphics.print(tostring(Guy.guy_mgr[1].exists), 0, 0, 0, 3, 3)
    end
end



-- code to make debugger better
local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end

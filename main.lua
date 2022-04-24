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
        to do
            hitboxes
            win state
            generate terrain
            enemy location memory
            navigate terrain with purpose
                1) find enemy
                2) communicate to team + hunt down enemy
                3) more complex stuff
            guys can navigate terrain with purpose

--]]


if arg[#arg] == "vsc_debug" then require("lldebugger").start() end
local Ammo = require "bin.entities.ammo"
local Arena = require "bin.environment.arena"
local Guy = require "bin.entities.guy"
local Team = require "bin.environment.team"

AI_SPEED = 0.6
TEAM_SIZE = 3

function love.load()
    -- housekeeping
    love.window.setMode(0, 0)
    WIDTH = love.graphics.getWidth()
    HEIGHT = love.graphics.getHeight()

    math.randomseed(os.time())

    
    -- init teams
    team1 = Team:new("team1", {0, 1, 0})
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
    ai_timer = ai_timer - dt

    -- target enemies
    if ai_timer < 0 then
        ai_timer = AI_SPEED
        for _, guy in ipairs(Guy.guy_mgr) do
            guy:shoot()
        end
    
    end

    -- move bullets
    for _, ammo in ipairs(Ammo.ammo_mgr) do
        ammo:move(dt)
    end

    -- do hit detection


end

-- Draw a coloured rectangle.
function love.draw()
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

end

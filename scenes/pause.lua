local GameplayGUI = require("gui.gameplay")
local PauseGUI = require("gui.pause")
local Hero = require("managers.hero")
local EnemyManager = require("managers.enemy")
local GroceryManager = require("managers.grocery")

local Pause = {}


function Pause:update(dt)
    PauseGUI.group:update()
end

function Pause:draw()
    love.graphics.push()
    love.graphics.clear(1, 1, 1)
    GameplayGUI.group:draw()
    GroceryManager:draw()
    EnemyManager:draw()
    Hero:draw()
    PauseGUI.group:draw()
    love.graphics.pop()
end

return Pause

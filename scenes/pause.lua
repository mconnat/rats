local SceneManager = require("managers.scenes")
local GameplayGUI = require("gui.gameplay")
local PauseGUI = require("gui.pause")

local Pause = {}

function Pause:enter()
end

function Pause:exit()
end

function Pause:mousepressed(x, y, button)
end

function Pause:keypressed(key, scancode, isrepeat)
end

function Pause:update(dt)
    PauseGUI.group:update()
end

function Pause:draw()
    love.graphics.push()
    love.graphics.clear(1, 1, 1)
    GameplayGUI.group:draw()
    PauseGUI.group:draw()
    love.graphics.pop()
end

return Pause

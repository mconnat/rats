local EndGameGUI = require("gui.endgame")
local GameplayManager = require("managers.gameplay")
local Hero = require("managers.Hero")


local EndGame = {}

function EndGame:enter()
    Hero:init()
    if GameplayManager.status == "win" then
        EndGameGUI.Title.text = "You Win"
        EndGameGUI.group:addElement(EndGameGUI.WinPanel)
    else
        EndGameGUI.Title.text = "You Loose"
        EndGameGUI.group:addElement(EndGameGUI.LoosePanel)
    end
end

function EndGame:update(dt)
    EndGameGUI.group:update()
end

function EndGame:draw()
    love.graphics.push()
    love.graphics.clear(1, 1, 1)
    EndGameGUI.group:draw()
    love.graphics.pop()
end

return EndGame

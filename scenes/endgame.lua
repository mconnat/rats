local SceneManager = require("managers.scenes")
local EndGameGUI = require("gui.endgame")


local EndGame = {}

function EndGame:enter()
    local win = false
    if win then
        EndGameGUI.Title.text = "You Win"
        EndGameGUI.group:addElement(EndGameGUI.WinPanel)
    else
        EndGameGUI.Title.text = "You Loose"
        EndGameGUI.group:addElement(EndGameGUI.LoosePanel)
    end
end

function EndGame:exit()

end

function EndGame:mousepressed(x, y, button)

end

function EndGame:keypressed(key, scancode, isrepeat)

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

local GodMod = require("libs.godmod")
local StartMenuGUI = require("gui.start_menu")
local StartMenu = {}


function StartMenu:update(dt)
    StartMenuGUI:update(dt)
end

function StartMenu:keypressed(key, scancode, isrepeat)
    GodMod:cheatcode(scancode, function()
        CONFIG.GodMod = true
        love.window.showMessageBox("God mod", "You are now in god mod, restart the game to disable it")
    end)
end

function StartMenu:draw()
    love.graphics.push()
    love.graphics.clear(1, 1, 1)
    StartMenuGUI:draw()
    love.graphics.pop()
end

return StartMenu

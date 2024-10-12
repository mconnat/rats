if os.getenv('LOCAL_LUA_DEBUGGER_VSCODE') == '1' then
    require('lldebugger').start()
end

love.graphics.setDefaultFilter("nearest")


local SceneManager = require("managers.scenes")
local StartMenu = require("scenes.start_menu")
local Gameplay = require("scenes.gameplay")
local Pause = require("scenes.pause")
local EndGame = require("scenes.endgame")


function love.load()
    SceneManager:addState("StartMenu", StartMenu)
    SceneManager:addState("Gameplay", Gameplay)
    SceneManager:addState("Pause", Pause)
    SceneManager:addState("EndGame", EndGame)
    SceneManager:switchTo("StartMenu")
    local cursor = love.mouse.newCursor("assets/sprites/small/crosshair.png")
    love.mouse.setCursor(cursor)
end

function love.mousepressed(x, y, button)
    SceneManager:mousepressed(x, y, button)
end

function love.keypressed(key, scancode, isrepeat)
    SceneManager:keypressed(key, scancode, isrepeat)
end

function love.update(dt)
    SceneManager:update(dt)
end

function love.draw()
    SceneManager:draw()
end

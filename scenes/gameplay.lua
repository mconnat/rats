local GameplayGUI = require("gui.gameplay")
local Hero = require("managers.hero")
local WeaponManager = require("managers.weapon")
local EnemyManager = require("managers.enemy")
local GroceryManager = require("managers.grocery")
local GameplayManager = require("managers.gameplay")
local BonusManager = require("managers.bonus")
local Collisions = require("libs.collisions")

local Gameplay = {}


function Gameplay:enter(lastState)
    if lastState ~= "Pause" then
        Hero:init()
        BonusManager:init()
        EnemyManager:init()
        GroceryManager:init()
        GameplayManager:init()
    end
end

function Gameplay:keypressed(key, scancode, isrepeat)

end

function Gameplay:mousepressed(x, y, button)
    if button == 1 and Collisions.ClickOnPauseButton(x, y, GameplayGUI.PauseButton.x, GameplayGUI.PauseButton.y, GameplayGUI.PauseButton.width, GameplayGUI.PauseButton.height) ~= true then
        Hero.weapon:addBullet(x, y, Hero.damageBonusCount)
    end
    if button == 2 then
        WeaponManager:switchWeapon(Hero)
    end
end

function Gameplay:update(dt)
    dt = math.min(dt, 1 / 60)

    GameplayGUI.group:update(dt)
    GameplayManager:update(dt)
    EnemyManager:update(dt)
    BonusManager:update()
    GameplayGUI.TimerPanel.text = string.format("Time before backup: %.0f", GameplayManager.gameTimer)
    GameplayGUI.BonusCount.text = string.format("x %d", BonusManager.DamageBonusCount)
    Hero:update(dt, EnemyManager.enemies)
end

function Gameplay:draw()
    love.graphics.push()
    love.graphics.clear(1, 1, 1)
    GameplayGUI.group:draw()
    GroceryManager:draw()
    EnemyManager:draw()
    BonusManager:draw()
    Hero:draw()
    love.graphics.pop()
end

return Gameplay

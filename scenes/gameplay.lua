local SceneManager = require("managers.scenes")
local GameplayGUI = require("gui.gameplay")
local Hero = require("managers.hero")
local WeaponManager = require("managers.weapon")
local EnemyManager = require("managers.enemy")
local GroceryManager = require("managers.grocery")
local GameplayManager = require("managers.gameplay")

local Gameplay = {}


function Gameplay:enter()
    -- If the last state was'nt a pause, init the game from a fresh start
    if SceneManager.lastState ~= SceneManager.scenes["Pause"] then
        Hero:init()
        EnemyManager:init()
        GroceryManager:init()
        GameplayManager:init()
    end
end

function Gameplay:exit()

end

function Gameplay:mousepressed(x, y, button)
    if button == 1 then
        Hero.weapon:addBullet(x, y, Hero.damageBonusCount)
    end
    if button == 2 then
        WeaponManager:switchWeapon(Hero)
    end
end

function Gameplay:keypressed(key, scancode, isrepeat)
end

function Gameplay:update(dt)
    dt = math.min(dt, 1 / 60)
    -- GameplayGUI.ScorePanel.text = toto .. " over " .. toto
    -- GameplayGUI.BonusCount.text = "x " .. toto
    -- GameplayGUI.SelectedWeapon:setImage(Hero.weapon.image, 2)

    GameplayGUI.group:update(dt)
    GameplayManager:update(dt)
    EnemyManager:update(dt)
    Hero:update(dt, EnemyManager.enemies)
end

function Gameplay:draw()
    love.graphics.push()
    love.graphics.clear(1, 1, 1)
    GameplayGUI.group:draw()
    EnemyManager:draw()
    GroceryManager:draw()
    Hero:draw()
    love.graphics.pop()
end

return Gameplay

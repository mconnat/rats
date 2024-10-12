local SceneManager = require("managers.scenes")
local WeaponManager = require("managers.weapon")
local Hero = require("managers.hero")
local EnemyManager = require("managers.enemy")


local GameplayManager = {}



function GameplayManager:init()
    self.score = 0
    self.maxScore = 100
    self.canSpawnBoss = true
    self.maxEnemyNumber = 20
    self.currentEnemyNumber = 0
    self.spawnBossEveryKillNb = 2
    self.timer = 0
end

function GameplayManager:reset()
    self = self:init()

    -- BonusManager.BonusPool = {}
    -- BonusManager.DamageBonusCount = 0
    for i = 1, #WeaponManager.WeaponCatalog do
        if WeaponManager.WeaponCatalog[i].name == "Shotgun" then
            WeaponManager.WeaponCatalog[i].unlocked = false
        end
    end
end

-- When a Boss die, add a bonus to the bonus pool
-- function GameplayManager:addBonus(x, y)
--     local choosenBonus = BonusManager:chooseBonus(Hero)
--     local newBonus = BonusManager:newBonus(x, y, choosenBonus)
--     table.insert(BonusManager.BonusPool, newBonus)
-- end

function GameplayManager:update(dt)
    -- Refresh Enemy numbers in pool
    self.currentEnemyNumber = #EnemyManager.enemies
    self.timer = self.timer + dt
    -- If the total of enemy in the pool is not equal to the max enemy on screen and .5 sec after the last spawn
    -- Spawn Enemy until it reach the maximum enemy wanted on screen
    if self.currentEnemyNumber < self.maxEnemyNumber and self.timer > .5 then
        local selectedBunker = love.math.random(1, 2)
        EnemyManager:spawnEnemy(selectedBunker)

        self.timer = 0
    end
    -- Spawn bosse every time the Hero reach the spawnBossEveryKillNb
    if self.score % self.spawnBossEveryKillNb == 0 and self.canSpawnBoss and self.score ~= 0 then
        EnemyManager:spawnBosses()
        self.canSpawnBoss = false
        self.maxEnemyNumber = self.maxEnemyNumber + 10
    end
    if self.score % self.spawnBossEveryKillNb ~= 0 then
        self.canSpawnBoss = true
    end

    -- If the player meet one of the 2 condition that end the game, switch to EngGame state
    if Hero.currentHealthPoint <= 0 or self.score >= self.maxScore then
        SceneManager:switchTo("EndGame")
    end
end

return GameplayManager

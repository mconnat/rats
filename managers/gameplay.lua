local SceneManager = require("managers.scenes")
local WeaponManager = require("managers.weapon")
local Hero = require("managers.hero")
local EnemyManager = require("managers.enemy")
local GroceryManager = require("managers.grocery")


local GameplayManager = {}



function GameplayManager:init()
    self.gameTimer = 120
    self.score = 0
    self.gameTimerEnd = 0
    self.canSpawnBoss = true
    self.maxEnemyNumber = 20
    self.currentEnemyNumber = 0
    self.spawnBossEveryKillNb = 5
    self.spawnTimer = 0
    self.status = ""
end

function GameplayManager:reset()
    self = self:init()
    for i = 1, #WeaponManager.WeaponCatalog do
        if WeaponManager.WeaponCatalog[i].name == "Shotgun" then
            WeaponManager.WeaponCatalog[i].unlocked = false
        end
    end
end

function GameplayManager:update(dt)
    self.gameTimer = self.gameTimer - dt
    self.spawnTimer = self.spawnTimer + dt
    self.currentEnemyNumber = #EnemyManager.enemies

    if self.currentEnemyNumber < self.maxEnemyNumber and self.spawnTimer > 1 then
        local selectedBunker = love.math.random(1, 2)
        EnemyManager:spawnEnemy(selectedBunker)
        self.currentEnemyNumber = self.currentEnemyNumber + 1

        self.spawnTimer = 0
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

    -- If the player meet one of the 2 condition that end the game, switch to EngGame state with Loose
    if CONFIG.GodMod ~= true then
        if Hero.currentHealthPoint <= 0 then
            self.status = "loose"
            SceneManager:switchTo("EndGame")
        end
        -- Check if both grocery are emptry and no enemy is carrying something
        if GroceryManager.groceries[1].groceryCount <= 0 and GroceryManager.groceries[2].groceryCount <= 0 then
            local isOneEnemyCarryingGrocery = false
            for _, enemy in ipairs(EnemyManager.enemies) do
                if enemy.carryingGrocery then
                    isOneEnemyCarryingGrocery = true
                    break
                end
            end
            if isOneEnemyCarryingGrocery == false then
                self.status = "loose"
                SceneManager:switchTo("EndGame")
            end
        end
    end
    if self.gameTimer <= self.gameTimerEnd then
        self.status = "win"
        SceneManager:switchTo("EndGame")
    end
end

return GameplayManager

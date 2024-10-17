local Enemy = require("classes.enemy")
local Boss = require("classes.boss")
local Bunker = require("classes.bunker")


local EnemyManager = {}

function EnemyManager:init()
    self.enemies = {}
    self.bossSpawnCount = 2
    self.bunkers = {}
    table.insert(self.bunkers, Bunker:new(0, 300))
    table.insert(self.bunkers, Bunker:new(0, 700))
end

function EnemyManager:spawnEnemy(selectedBunker)
    table.insert(self.enemies, Enemy:new(
        self.bunkers[selectedBunker].x + self.bunkers[selectedBunker].image:getWidth(),
        self.bunkers[selectedBunker].y + (self.bunkers[selectedBunker].image:getHeight() / 2),
        selectedBunker
    )
    )
    self.bunkers[selectedBunker].enemiesCount = self.bunkers[selectedBunker].enemiesCount + 1
end

function EnemyManager:spawnBosses()
    for i = 1, self.bossSpawnCount do
        table.insert(self.enemies, Boss:new(
            self.bunkers[i].x + self.bunkers[i].image:getWidth(),
            self.bunkers[i].y + (self.bunkers[i].image:getHeight() / 2),
            i
        )
        )
    end
end

function EnemyManager:update(dt)
    local GameplayManager = require("managers.gameplay")
    for i = #self.enemies, 1, -1 do
        local enemy = self.enemies[i]
        if enemy.alive == false then
            enemy:destroy(self.enemies, i)
            GameplayManager.score = GameplayManager.score + 1
        end
        enemy:update(dt)
    end
end

function EnemyManager:draw()
    for _, bunker in ipairs(self.bunkers) do
        bunker:draw()
    end
    for _, enemy in ipairs(self.enemies) do
        enemy:draw()
    end
end

return EnemyManager

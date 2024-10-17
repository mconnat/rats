local Character = require("classes.character")
local GroceryManager = require("managers.grocery")
local Hero = require("managers.hero")
local Collisions = require("libs.collisions")

local Enemy = {}
setmetatable(Enemy, { __index = Character })

local STATES = {
    RUN = "run",
    WALK = "walk",
    HEAL = "heal",
    FLEE = "flee",
    HEALING = "healing",
    HARVEST = "harvest",
    DEPOSIT = "deposit",
    IDLE = "idle"
}

function Enemy:_findNearestGrocery(groceries)
    local tmpGroceries = {}
    for _, grocery in ipairs(groceries) do
        if grocery.groceryCount > 0 then
            table.insert(tmpGroceries, grocery)
        end
    end

    local nearestObject = nil
    local nearestDistance = nil
    for _, grocery in ipairs(tmpGroceries) do
        local enemyDirectionX = grocery.interactPointX - self.x
        local enemyDirectionY = grocery.interactPointY - self.y
        local distance = math.sqrt(enemyDirectionX * enemyDirectionX + enemyDirectionY * enemyDirectionY)
        if nearestObject ~= nil and nearestDistance ~= nil then
            if distance <= nearestDistance then
                nearestObject = grocery
                nearestDistance = distance
            end
        else
            nearestObject = grocery
            nearestDistance = distance
        end
    end
    return nearestObject
end

function Enemy:_findNearestBunker(bunkers)
    local nearestObject = nil
    local tmpDistance = nil

    for _, bunker in ipairs(bunkers) do
        local enemyDirectionX = bunker.x - self.x
        local enemyDirectionY = bunker.y - self.y
        local distance = math.sqrt(enemyDirectionX * enemyDirectionX + enemyDirectionY * enemyDirectionY)
        if nearestObject ~= nil and tmpDistance ~= nil then
            if distance <= tmpDistance then
                nearestObject = bunker
                tmpDistance = distance
            end
        else
            nearestObject = bunker
            tmpDistance = distance
        end
    end
    return nearestObject
end

function Enemy:new(x, y, bunkerIndex)
    local instance = Character:new(x, y)
    setmetatable(instance, { __index = Enemy })

    instance.currentHealthPoint = 5
    instance.maxHealthPoint = 5
    instance.speed = 40
    instance.runSpeed = 120
    instance.image = love.graphics.newImage("assets/sprites/small/enemy.png")
    instance.imagePasta = love.graphics.newImage("assets/sprites/large/pastabox.png")
    instance.imageToiletPaper = love.graphics.newImage("assets/sprites/large/toilet_paper_solo.png")
    instance.radius = instance.image:getWidth() / 2
    instance.state = STATES.RUN
    instance.heal = false
    instance.hitTimer = 0
    instance.healingTimer = 0
    instance.shootTimer = 0
    instance.harvestTimer = 0
    instance.depositTimer = 0
    instance.fleeTimer = 0
    instance.alive = true
    instance.assignedBunker = bunkerIndex
    instance.objective = nil
    instance.lastHitTime = 0
    instance.carryingGrocery = false
    instance.carryingGroceryType = nil
    instance.objective = instance:_findNearestGrocery(GroceryManager.groceries)

    return instance
end

function Enemy:CanInteract()
    return Collisions.CircleAndPointOverlap(self.x, self.y, self.radius,
        self.objective.interactPointX, self.objective.interactPointY)
end

function Enemy:getDirectionOpposite(objX, objY)
    -- https://love2d.org/forums/viewtopic.php?p=217897#p217897
    local objDirectionX = self.x - objX
    local objDirectionY = self.y - objY
    local distance = math.sqrt((objX - self.x) ^ 2 + (objY - self.y) ^ 2)
    return {
        enemyDirectionX = objDirectionX,
        enemyDirectionY = objDirectionY,
        distance = distance
    }
end

function Enemy:getDirection(objX, objY)
    -- https://love2d.org/forums/viewtopic.php?p=217897#p217897
    local objDirectionX = objX - self.x
    local objDirectionY = objY - self.y
    local distance = math.sqrt(objDirectionX ^ 2 + objDirectionY ^ 2)
    return {
        enemyDirectionX = objDirectionX,
        enemyDirectionY = objDirectionY,
        distance = distance
    }
end

function Enemy:update(dt)
    local EnemyManager = require("managers.enemy")
    local direction = nil
    -- Keep the enemy position inside the window
    if self.x + self.radius >= love.graphics.getWidth() then
        self.x = love.graphics.getWidth() - self.radius
    elseif self.x - self.radius <= 0 then
        self.x = self.radius
    end
    if self.y - self.radius <= 0 then
        self.y = self.radius
    elseif self.y + self.radius >= love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.radius
    end

    if self.hit then
        if self.currentHealthPoint < self.maxHealthPoint / 2 then
            self.state = STATES.FLEE
        end
        self.hitTimer = self.hitTimer + dt
        if self.hitTimer >= .1 then
            self.hitTimer = 0
            self.hit = false
            self.lastHitTime = os.time()
        end
    end

    if self.state == STATES.RUN then
        local nextObjective = self:_findNearestGrocery(GroceryManager.groceries)
        if nextObjective == nil then
            self.state = STATES.IDLE
            return
        end
        self.objective = nextObjective
        direction = self:getDirection(self.objective.interactPointX, self.objective.interactPointY)
        self.angle = math.atan2(self.objective.interactPointY - self.y, self.objective.interactPointX - self.x)
        self.speed = 120
        if self:CanInteract() then
            self.state = STATES.HARVEST
        end
    elseif self.state == STATES.HARVEST then
        direction = nil
        self.harvestTimer = self.harvestTimer + dt
        if self.objective.groceryCount <= 0 then
            self.state = STATES.RUN
            self.harvestTimer = 0
        end
        if self.harvestTimer >= 2 then
            self.harvestTimer = 0
            self.carryingGrocery = true
            self.carryingGroceryType = self.objective.groceryType
            GroceryManager:GotHarvested(self.objective)
            self.state = STATES.WALK
        end
    elseif self.state == STATES.WALK then
        self.objective = self:_findNearestBunker(EnemyManager.bunkers)
        direction = self:getDirection(self.objective.interactPointX, self.objective.interactPointY)
        self.angle = math.atan2(self.objective.interactPointY - self.y, self.objective.interactPointX - self.x)
        self.speed = 80
        if self:CanInteract() then
            self.state = STATES.DEPOSIT
        end
    elseif self.state == STATES.DEPOSIT then
        direction = nil
        self.depositTimer = self.depositTimer + dt
        if self.depositTimer >= 2 then
            self.depositTimer = 0
            self.carryingGrocery = false
            if self.currentHealthPoint < self.maxHealthPoint / 2 then
                self.state = STATES.HEAL
            else
                self.state = STATES.RUN
            end
        end
    elseif self.state == STATES.FLEE then
        direction = self:getDirectionOpposite(Hero.x, Hero.y)
        self.speed = 150
        self.fleeTimer = self.fleeTimer + dt
        self.healingTimer = 0
        if self.fleeTimer >= love.math.random(1, 3) then
            self.fleeTimer = 0
            self.state = STATES.HEAL
        end
    elseif self.state == STATES.HEAL then
        self.objective = self:_findNearestBunker(EnemyManager.bunkers)
        direction = self:getDirection(self.objective.interactPointX, self.objective.interactPointY)
        self.angle = math.atan2(self.objective.interactPointY - self.y, self.objective.interactPointX - self.x)
        self.speed = 80
        if self:CanInteract() then
            self.state = STATES.HEALING
        end
    elseif self.state == STATES.HEALING then
        if self.currentHealthPoint < self.maxHealthPoint / 2 and self.carryingGrocery then
            self.state = STATES.DEPOSIT
        end
        self.healingTimer = self.healingTimer + dt
        if self.healingTimer >= 2 then
            self.healingTimer = 0
            self.currentHealthPoint = self.maxHealthPoint
            self.state = STATES.RUN
        end
    elseif self.state == STATES.IDLE then
        local nextObjective = self:_findNearestGrocery(GroceryManager.groceries)
        if nextObjective ~= nil then
            self.state = STATES.RUN
            return
        end
        local randomDirection = {
            { self.x + 10, self.y + 10 },
            { self.x - 10, self.y - 10 },
            { self.x + 10, self.y - 10 },
            { self.x - 10, self.y + 10 },
        }
        local selectedRandomDirection = randomDirection[love.math.random(1, 4)]
        direction = self:getDirection(selectedRandomDirection[1], selectedRandomDirection[2])
    end

    if direction ~= nil and self.hit == false then
        self.x = self.x + direction.enemyDirectionX / direction.distance * self.speed * dt
        self.y = self.y + direction.enemyDirectionY / direction.distance * self.speed * dt
    end
end

function Enemy:onHit(damage)
    self.currentHealthPoint = self.currentHealthPoint - damage
    self.hit = true
    if self.currentHealthPoint <= 0 then
        self.alive = false
        if self.carryingGrocery then
            for _, grocery in ipairs(GroceryManager.groceries) do
                if grocery.groceryType == self.carryingGroceryType then
                    grocery.groceryCount = grocery.groceryCount + 1
                end
            end
        end
    end
end

function Enemy:destroy(enemies, enemyIndex)
    table.remove(enemies, enemyIndex)
end

return Enemy

local Character = require("classes.character")
local Hero = require("managers.hero")

local Enemy = {}
setmetatable(Enemy, { __index = Character })

function Enemy:new(x, y)
    local instance = Character:new(x, y)
    setmetatable(instance, { __index = Enemy })

    instance.currentHealthPoint = 5
    instance.maxHealthPoint = 5
    instance.speed = 30
    instance.runSpeed = 120
    instance.image = love.graphics.newImage("assets/sprites/small/enemy.png")
    instance.radius = instance.image:getWidth() / 2
    instance.state = "WALK"
    instance.hitTimer = 0
    instance.shootTimer = 0
    instance.alive = true


    return instance
end

function Enemy:update(dt)
    -- Get angle of the character
    self.angle = math.atan2(Hero.y - self.y, Hero.x - self.x)
    -- Compute distance between player center and enemy center then
    -- Make the enemy move forward the player according to the speed
    -- If the enemy enter the radius of the player, deny next mouvement
    -- https://love2d.org/forums/viewtopic.php?p=217897#p217897
    local enemyDirectionX = Hero.x - self.x
    local enemyDirectionY = Hero.y - self.y
    local distance = math.sqrt(enemyDirectionX * enemyDirectionX + enemyDirectionY * enemyDirectionY)

    -- Reset the HIT status after .1 sec
    if self.hit then
        self.hitTimer = self.hitTimer + dt
        if self.hitTimer >= .1 then
            self.hitTimer = 0
            self.hit = false
        end
    else
        self.x = self.x + enemyDirectionX / distance * self.speed * dt
        self.y = self.y + enemyDirectionY / distance * self.speed * dt
    end
    -- self:defineState(distance)
end

function Enemy:onHit(damage)
    self.currentHealthPoint = self.currentHealthPoint - damage
    self.hit = true
    if self.currentHealthPoint <= 0 then
        self.alive = false
    end
end

function Enemy:destroy(enemies, enemyIndex)
    table.remove(enemies, enemyIndex)
end

return Enemy

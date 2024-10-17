local Enemy = require("classes.enemy")
local WeaponManager = require("managers.weapon")
local Hero = require("managers.hero")
local BonusManager = require("managers.bonus")

local Boss = {}
setmetatable(Boss, { __index = Enemy })

function Boss:new(x, y, bunkerIndex)
    local instance = Enemy:new(x, y)
    setmetatable(instance, { __index = Boss })
    instance.currentHealthPoint = 10
    instance.maxHealthPoint = 10
    instance.speed = 60
    instance.runSpeed = 200
    instance.image = love.graphics.newImage("assets/sprites/small/boss.png")
    instance.radius = instance.image:getWidth() / 2
    instance.weapon = WeaponManager:CreateWeapon(instance, 1)
    instance.assignedBunker = bunkerIndex

    return instance
end

function Boss:destroy(enemies, enemyIndex)
    BonusManager:addBonus(self.x, self.y)
    table.remove(enemies, enemyIndex)
end

function Boss:update(dt)
    self.angle = math.atan2(Hero.y - self.y, Hero.x - self.x)

    local enemyDirectionX = Hero.x - self.x
    local enemyDirectionY = Hero.y - self.y
    local distance = math.sqrt(enemyDirectionX * enemyDirectionX + enemyDirectionY * enemyDirectionY)

    -- Keep the boss position inside the window
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

    -- Moove only if the boss is not in hit status and
    -- not to close (70% of max bullet distance)
    if self.hit then
        -- Reset the HIT status after .1 sec
        self.hitTimer = self.hitTimer + dt
        if self.hitTimer >= .1 then
            self.hitTimer = 0
            self.hit = false
        end
    else
        if distance >= self.weapon.maxBulletDistance * 0.7 then
            self.x = self.x + enemyDirectionX / distance * self.speed * dt
            self.y = self.y + enemyDirectionY / distance * self.speed * dt
        end
    end

    -- update Enemy's weapon
    if self.weapon ~= nil then
        if distance <= self.weapon.maxBulletDistance then
            self.shootTimer = self.shootTimer + dt
            if self.shootTimer >= .4 then
                self.shootTimer = 0
                self.weapon:addBullet(Hero.x, Hero.y, 0)
            end
        end
        self.weapon:update(dt, { Hero })
    end
end

return Boss

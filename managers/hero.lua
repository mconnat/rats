local Character = require("classes.character")
local Collisions = require("libs.collisions")
local WeaponManager = require("managers.weapon")

local Hero = {}
Hero = Character:new(0, 0)


setmetatable(Hero, { __index = Character })

function Hero:init()
    Hero.x = love.graphics.getWidth() / 2
    Hero.y = love.graphics.getHeight() / 2
    Hero.image = love.graphics.newImage("assets/sprites/small/hero.png")
    Hero.radius = Hero.image:getWidth() / 2
    Hero.weapon = WeaponManager:CreateWeapon(self, 1)
    table.merge(self.weapon, WeaponManager.Catalog[1])
    Hero.currentHealthPoint = 10
    Hero.maxHealthPoint = 10
    Hero.canBeHit = true
    Hero.accumulatedInvincibilityTime = 0
    Hero.damageBonusCount = 0
    Hero.hitTimer = 0
end

function Hero:setBonusDamage(bonusCount)
    self.damageBonusCount = bonusCount
end

function Hero:update(dt, enemies)
    local mouseX, mouseY = love.mouse.getPosition()
    -- Get angle of the character according to mouse position
    self.angle = math.atan2(mouseY - self.y, mouseX - self.x)

    -- Manage keyboard deplacement inputs
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        self.x = self.x + (self.speed * dt)
    end
    if love.keyboard.isDown("a") or love.keyboard.isDown("q") or love.keyboard.isDown("left") then
        self.x = self.x - (self.speed * dt)
    end
    if love.keyboard.isDown("w") or love.keyboard.isDown("z") or love.keyboard.isDown("up") then
        self.y = self.y - (self.speed * dt)
    end
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        self.y = self.y + (self.speed * dt)
    end

    -- Keep the player position inside the window
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

    -- Check collision with enemies
    -- self:checkCollision(enemies)

    -- update Hero's weapon
    if self.weapon ~= nil then
        self.weapon:update(dt, enemies)
    end

    -- Check if the Hero has been hit in the previous 2 second
    -- if yes, stay invulnerable
    if self.canBeHit == false then
        self.accumulatedInvincibilityTime = self.accumulatedInvincibilityTime + dt;
        if self.accumulatedInvincibilityTime > .5 then
            self.canBeHit = true
            self.accumulatedInvincibilityTime = 0
        end
    end

    -- Reset the HIT status after .5 sec
    if self.hit then
        self.hitTimer = self.hitTimer + dt
        if self.hitTimer >= .5 then
            self.hitTimer = 0
            self.hit = false
        end
    end
end

function Hero:checkCollision(enemies)
    for i = 1, #enemies do
        if Collisions.CircleCollision(self, enemies[i]) then
            self:onHit(1)
        end
    end
end

function Hero:onHit(damage)
    if self.canBeHit and CONFIG.GodMod == false then
        self.currentHealthPoint = self.currentHealthPoint - damage
        self.canBeHit = false
    end
    self.hit = true
end

return Hero

require("libs.table")
Bullet = require("classes.bullet")

local Weapon = {}

function Weapon:new(parent)
    local instance = {}
    setmetatable(instance, { __index = Weapon })
    instance.x = 0
    instance.y = 0
    instance.parent = parent
    instance.distanceFromHero = instance.parent.radius + 7
    instance.bullets = {}

    return instance
end

function Weapon:addBullet(dstX, dstY, bonusDamageCount)
    local newBullet = Bullet:new(dstX, dstY, self, bonusDamageCount)
    table.insert(self.bullets, newBullet)
end

function Weapon:update(dt, enemies)
    -- Get weapon position according to the player angle + the distance from the player
    self.x = (self.distanceFromHero * math.cos(self.parent.angle)) + self.parent.x
    self.y = (self.distanceFromHero * math.sin(self.parent.angle)) + self.parent.y

    for index, bullet in ipairs(self.bullets) do
        -- For every bullets, check if the max distance is reached
        -- If yes, destroy the bullet
        if math.abs(bullet.originalX - bullet.x) < bullet.maxDistance and math.abs(bullet.originalY - bullet.y) < bullet.maxDistance then
            bullet:update(dt, enemies, index)
        else
            bullet:destroy(index)
        end
    end
end

function Weapon:draw()
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        self.parent.angle,
        self.parent.scaleX,
        self.parent.scaleY,
        (self.image:getWidth() / 2),
        (self.image:getHeight() / 2)
    )

    for _, bullet in ipairs(self.bullets) do
        bullet:draw()
    end
end

return Weapon

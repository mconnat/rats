Collisions = require("libs.collisions")

local Bullet = {}

function Bullet:new(destinationX, destinationY, weapon, bonusDamageCount)
    local instance = {}
    setmetatable(instance, { __index = Bullet })
    local angle = math.atan2(destinationY - weapon.parent.y, destinationX - weapon.parent.x)
    local distanceFromGun = 10
    instance.x = weapon.x + (distanceFromGun * math.cos(angle))
    instance.y = weapon.y + (distanceFromGun * math.sin(angle))
    instance.originalX = weapon.x
    instance.originalY = weapon.y
    instance.maxDistance = weapon.maxBulletDistance
    instance.angle = angle
    instance.image = weapon.bulletImage
    instance.scale = 1
    instance.speed = 200
    instance.damage = weapon.damage + bonusDamageCount
    instance.width = weapon.bulletImage:getWidth()
    instance.height = weapon.bulletImage:getHeight()
    instance.parent = weapon
    instance.hit = false
    return instance
end

function Bullet:drawHitbox()
    love.graphics.push()
    love.graphics.setColor(0.2, 0.8, 0.1)
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.angle)
    love.graphics.rectangle("line", -self.image:getWidth() / 2, -self.image:getHeight() / 2, self.image:getWidth(),
        self.image:getHeight())
    love.graphics.pop()
end

function Bullet:update(dt, enemies, bulletIndex)
    self.x = self.x + math.cos(self.angle) * self.speed * dt
    self.y = self.y + math.sin(self.angle) * self.speed * dt
    for i = #enemies, 1, -1 do
        if Collisions.CircleAndRectangleOverlap(enemies[i].x, enemies[i].y, enemies[i].radius, self.x, self.y, self.width, self.height) then
            enemies[i]:onHit(self.damage)
            self:destroy(bulletIndex)
        end
    end
end

function Bullet:draw()
    love.graphics.push()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.image, self.x, self.y, self.angle, self.scale, self.scale,
        self.image:getWidth() / 2,
        self.image:getHeight() / 2)
    if CONFIG.debug then
        self:drawHitbox()
    end
    love.graphics.pop()
end

function Bullet:destroy(index)
    table.remove(self.parent.bullets, index)
end

return Bullet

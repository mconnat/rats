local Bunker = {}

local bunkerImage = love.graphics.newImage("assets/sprites/large/bunker.png")

function Bunker:new(x, y)
    local instance = {}
    instance.x = x
    instance.y = y
    instance.scale = 1
    instance.image = bunkerImage
    instance.enemiesCount = 0
    setmetatable(instance, { __index = Bunker })
    return instance
end

function Bunker:draw()
    love.graphics.push()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        0,
        self.scale,
        self.scale,
        0,
        (self.image:getHeight() / 2)
    )
    love.graphics.pop()
end

return Bunker

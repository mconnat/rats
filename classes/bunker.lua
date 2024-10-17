local Bunker = {}

local bunkerImage = love.graphics.newImage("assets/sprites/large/bunker.png")

function Bunker:new(x, y)
    local instance = {}
    setmetatable(instance, { __index = Bunker })
    instance.x = x
    instance.y = y
    instance.scale = 1
    instance.image = bunkerImage
    instance.enemiesCount = 0
    instance.height = instance.image:getHeight()
    instance.width = instance.image:getWidth()
    instance.interactPointX = instance.x + instance.width
    instance.interactPointY = instance.y + instance.height - 50
    return instance
end

function Bunker:GetObjectType()
    return "Bunker"
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
        0
    )
    love.graphics.pop()
end

return Bunker

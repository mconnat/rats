local Grocery = {}

local GroceryImages = {
    Pasta = love.graphics.newImage("assets/sprites/large/pasta.png"),
    ToiletPaper = love.graphics.newImage("assets/sprites/large/toilet_paper.png")
}

function Grocery:new(x, y, groceryType, groceryCount)
    local instance = {}
    instance.x = x
    instance.y = y
    instance.scale = 1
    instance.image = GroceryImages[groceryType]
    instance.groceryType = groceryType
    instance.groceryCount = groceryCount
    instance.height = instance.image:getHeight()
    instance.width = instance.image:getWidth()
    instance.interactPointX = instance.x - instance.width / 2
    instance.interactPointY = instance.y
    setmetatable(instance, { __index = Grocery })
    return instance
end

function Grocery:GetObjectType()
    return "Grocery"
end

function Grocery:draw()
    love.graphics.push()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        0,
        self.scale,
        self.scale,
        (self.image:getWidth() / 2),
        (self.image:getHeight() / 2)
    )
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(tostring(self.groceryCount),
        self.x,
        self.y - self.image:getHeight() / 2 - 40
    )
    love.graphics.pop()
end

return Grocery

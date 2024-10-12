local Grocery = {}

local GroceryImages = {
    Pasta = love.graphics.newImage("assets/sprites/large/pasta.png"),
    ToiletPaper = love.graphics.newImage("assets/sprites/large/toilet_paper.png")
}

function Grocery:new(x, y, groceryType)
    local instance = {}
    instance.x = x
    instance.y = y
    instance.scale = 1
    instance.image = GroceryImages[groceryType]
    instance.groceryCount = 20
    setmetatable(instance, { __index = Grocery })
    return instance
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
    love.graphics.print(self.groceryCount,
        self.x + (self.image:getWidth() / 2),
        self.y - 10
    )
    love.graphics.pop()
end

return Grocery

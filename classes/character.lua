local Character = {}

function Character:new(x, y)
    local instance = {}
    setmetatable(instance, { __index = Character })
    instance.x = x
    instance.y = y
    instance.scaleX = 1
    instance.scaleY = 1
    instance.angle = 0
    instance.speed = 150
    instance.currentHealthPoint = 0
    instance.maxHealthPoint = 0
    instance.hit = false
    instance.weapon = nil


    return instance
end

function Character:draw()
    love.graphics.push()
    love.graphics.setColor(1, 1, 1)
    -- Flip image if the angle is not natural anymore
    if self.angle > 2 or self.angle < -2 then
        self.scaleY = -1
    else
        self.scaleY = 1
    end
    -- Red blink when the character is hit
    if self.hit then
        love.math.colorFromBytes(212, 131, 131)
        love.graphics.setColor(love.math.colorFromBytes(212, 131, 131))
    end
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        self.angle,
        self.scaleX,
        self.scaleY,
        (self.image:getWidth() / 2),
        (self.image:getHeight() / 2)
    )

    if self.weapon ~= nil then
        self.weapon:draw()
    end
    if self.currentHealthPoint ~= self.maxHealthPoint then
        self:DrawHealthBar()
    end


    if self.state and CONFIG.debug then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(self.state, self.x, self.y, 0, 0.5)
    end

    if self.carryingGrocery then
        love.graphics.setColor(1, 1, 1, 1)
        if self.carryingGroceryType == "Pasta" then
            love.graphics.draw(self.imagePasta, self.x, self.y, 0, 0.2, 0.2)
        else
            love.graphics.draw(self.imageToiletPaper, self.x, self.y, 0, 0.2, 0.2)
        end
    end
    love.graphics.pop()
end

function Character:DrawHealthBar()
    love.graphics.push()
    love.graphics.setColor(0, 0, 0, 1)
    local squareSize = 4
    for i = 1, self.maxHealthPoint do
        love.graphics.setColor(0.8, 0, 0, 0.8)
        local rectangleMode = "line"
        if i <= self.currentHealthPoint then
            rectangleMode = "fill"
        end
        love.graphics.rectangle(rectangleMode,
            ((self.x - (squareSize * self.maxHealthPoint) / 2) + ((i - 1) * squareSize)),
            self.y - self.radius - 10, squareSize,
            squareSize)
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("line", ((self.x - (squareSize * self.maxHealthPoint) / 2) + ((i - 1) * squareSize)),
            self.y - self.radius - 10, squareSize,
            squareSize)
    end
    love.graphics.pop()
end

function Character:update(dt)
    print("Character update() not implemented")
end

return Character

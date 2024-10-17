local Grocery = require("classes.grocery")

local GroceryManager = {}


function GroceryManager:init()
    self.groceries = {}
    table.insert(self.groceries, Grocery:new(love.graphics.getWidth() - 64,
        300,
        "Pasta", 10)
    )
    table.insert(self.groceries,
        Grocery:new(love.graphics.getWidth() - 64,
            700,
            "ToiletPaper", 10)
    )
end

function GroceryManager:draw()
    for _, grocery in ipairs(self.groceries) do
        grocery:draw()
    end
end

function GroceryManager:GotHarvested(grocery)
    grocery.groceryCount = grocery.groceryCount - 1
end

return GroceryManager

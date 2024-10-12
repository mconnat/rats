local Grocery = require("classes.grocery")

local GroceryManager = {}


function GroceryManager:init()
    self.groceries = {}
    table.insert(self.groceries, Grocery:new(love.graphics.getWidth() - 64,
        300,
        "Pasta")
    )
    table.insert(self.groceries,
        Grocery:new(love.graphics.getWidth() - 64,
            700,
            "ToiletPaper")
    )
end

function GroceryManager:draw()
    for _, grocery in ipairs(self.groceries) do
        grocery:draw()
    end
end

return GroceryManager

local GUI = require("classes.gui")
local SceneManager = require("managers.scenes")
local EndGameGUI = {}

EndGameGUI.group = GUI.newGroup()

local function onPanelHover(pState, obj)
    if pState == "begin" then
        obj.Label.font = love.graphics.newFont("assets/fonts/Harvest Yard.otf", 50)
    end
    if pState == "end" then
        obj.Label.font = love.graphics.newFont("assets/fonts/Harvest Yard.otf", 40)
    end
end

-- Title text definition
EndGameGUI.Title = GUI.newText(
    love.graphics.getWidth() / 2 - 100,
    40,
    0,
    0,
    "",
    love.graphics.newFont("assets/fonts/Harvest Yard.otf", 60),
    "center",
    nil,
    { r = 0, g = 0, b = 0, a = 1 }
)

EndGameGUI.LoosePanel = GUI.newPanel(
    love.graphics.getWidth() / 2 - 125,
    love.graphics.getHeight() / 2 - 130,
    500,
    400
)
EndGameGUI.LoosePanel:setColor({ r = 1, g = 1, b = 1, a = 1 })
local looseImg = love.graphics.newImage("assets/sprites/large/boss.png")
EndGameGUI.LoosePanel:setImage(looseImg, 2)

EndGameGUI.WinPanel = GUI.newPanel(
    love.graphics.getWidth() / 2 - 60,
    love.graphics.getHeight() / 2 - 70,
    500,
    400
)
EndGameGUI.WinPanel:setColor({ r = 1, g = 1, b = 1, a = 1 })
local winImage = love.graphics.newImage("assets/sprites/medium/hero.png")
EndGameGUI.WinPanel:setImage(winImage, 2)

local ReturnToMenuButton = GUI.newButton(
    love.graphics.getWidth() / 2 - 180,
    love.graphics.getHeight() - 150,
    350,
    100,
    "Return to Menu",
    love.graphics.newFont("assets/fonts/Harvest Yard.otf", 40),
    { r = 0, g = 0, b = 0, a = 1 }
)

ReturnToMenuButton:setEvent("hover", onPanelHover)
ReturnToMenuButton:setEvent("pressed", function()
    SceneManager:switchTo("StartMenu")
end)
EndGameGUI.group:addElement(EndGameGUI.Title)
EndGameGUI.group:addElement(ReturnToMenuButton)


return EndGameGUI

local GUI = require("classes.gui")
local SceneManager = require("managers.scenes")

local PauseGUI = {}

local function onPanelHover(pState, obj)
    if pState == "begin" then
        obj.Label.font = love.graphics.newFont("assets/fonts/Harvest Yard.otf", 50)
    end
    if pState == "end" then
        obj.Label.font = love.graphics.newFont("assets/fonts/Harvest Yard.otf", 40)
    end
end


PauseGUI.group = GUI.newGroup()

local MainPanel = GUI.newPanel(
    love.graphics.getWidth() / 2 - 250,
    love.graphics.getHeight() / 2 - 250,
    500,
    400
)
MainPanel:setColor({ r = .8, g = .8, b = .8, a = 1 })

local Title = GUI.newText(
    MainPanel.x + 100,
    MainPanel.y,
    0,
    0,
    "Game Paused",
    love.graphics.newFont("assets/fonts/Harvest Yard.otf", 60),
    nil,
    nil,
    { r = 0, g = 0, b = 0, a = 1 }
)

local ResumeButton = GUI.newButton(
    MainPanel.x + 220,
    Title.y + 250,
    45,
    50,
    "",
    love.graphics.newFont("assets/fonts/Harvest Yard.otf", 40),
    { r = 0, g = 0, b = 0, a = 1 }
)
ResumeButton:setColor({ r = .8, g = .8, b = .8, a = 1 })
local start = love.graphics.newImage("assets/sprites/large/start.png")
ResumeButton:setImages(start, start, start)
ResumeButton:setEvent("hover", onPanelHover)
ResumeButton:setEvent("pressed", function()
    SceneManager:switchTo("Gameplay")
end)

PauseGUI.group:addElement(MainPanel)
PauseGUI.group:addElement(Title)
PauseGUI.group:addElement(ResumeButton)

return PauseGUI

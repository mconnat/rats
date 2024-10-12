local GUI = require("classes.gui")
local SceneManager = require("managers.scenes")

local GameplayGUI = {}

GameplayGUI.group = GUI.newGroup()

local MainPanel = GUI.newPanel(10, 15, love.graphics.getWidth() - 20, 65)

MainPanel:setColor({ r = .8, g = .8, b = .8, a = 1 })

GameplayGUI.ScorePanel = GUI.newText(
    50,
    30,
    100,
    50,
    "",
    love.graphics.newFont("assets/fonts/Harvest Yard.otf", 25),
    nil,
    nil,
    { r = 0, g = 0, b = 0, a = 1 }
)

local SelectedWeaponSquare = GUI.newPanel(love.graphics.getWidth() / 3 - 2, 30, 37, 37)
SelectedWeaponSquare:setColor({ r = 0, g = 0, b = 0, a = 1 })
SelectedWeaponSquare:setMode("line")

GameplayGUI.SelectedWeapon = GUI.newPanel(love.graphics.getWidth() / 3, 30)
GameplayGUI.SelectedWeapon:setImage(love.graphics.newImage("assets/sprites/large/pistol.png"), 0.5)


local BonusSquare = GUI.newPanel(love.graphics.getWidth() / 2 + 50 - 2, 30, 37, 37)
BonusSquare:setColor({ r = 0, g = 0, b = 0, a = 1 })
BonusSquare:setMode("line")

local BonusLogo = GUI.newPanel(love.graphics.getWidth() / 2 + 50, 32)
BonusLogo:setImage(love.graphics.newImage("assets/sprites/small/bonus_damage.png"))


GameplayGUI.BonusCount = GUI.newText(love.graphics.getWidth() / 2 + 50 + 50,
    32,
    100,
    50,
    "x 0",
    love.graphics.newFont("assets/fonts/Harvest Yard.otf", 25),
    nil,
    nil,
    { r = 0, g = 0, b = 0, a = 1 }
)

local PauseButton = GUI.newButton(love.graphics.getWidth() - 120,
    15,
    45,
    50,
    "",
    love.graphics.newFont("assets/fonts/Harvest Yard.otf", 40),
    { r = 0, g = 0, b = 0, a = 1 }
)

PauseButton:setColor({ r = .8, g = .8, b = .8, a = 1 })
local pauseImg = love.graphics.newImage("assets/sprites/large/pause.png")
PauseButton:setImages(pauseImg, pauseImg, pauseImg)
PauseButton:setEvent("pressed", function()
    SceneManager:switchTo("Pause")
end)


GameplayGUI.group:addElement(MainPanel)
GameplayGUI.group:addElement(GameplayGUI.ScorePanel)
GameplayGUI.group:addElement(SelectedWeaponSquare)
GameplayGUI.group:addElement(GameplayGUI.SelectedWeapon)
GameplayGUI.group:addElement(BonusSquare)
GameplayGUI.group:addElement(BonusLogo)
GameplayGUI.group:addElement(GameplayGUI.BonusCount)
GameplayGUI.group:addElement(PauseButton)

return GameplayGUI

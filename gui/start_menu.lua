local GUI = require("classes.gui")
local SceneManager = require("managers.scenes")

local StartMenuGUI = {}

-- Title text definition
local Title = GUI.newText(
    5,
    40,
    love.graphics.getWidth() - 10,
    50,
    "Rage against the Survivalists",
    love.graphics.newFont("assets/fonts/Harvest Yard.otf", 60),
    "center",
    nil,
    { r = 0, g = 0, b = 0, a = 1 }
)

-- Controls hints text definition
local ControlHintsPanelData = {
    {
        text = "W   Z   UP     <- Move up"
    },
    {
        text = "S   DOWN     <- Move down"
    },
    {
        text = "Q   A   LEFT   <- Move left"
    },
    {
        text = "D   RIGHT      <- Move right"
    },
    {
        text = "Mouse Left    <- Shoot"
    },
    {
        text = "Mouse Right  <- Switch Weapon"
    },
}

local LegendPanelData = {
    {
        image = love.graphics.newImage("assets/sprites/medium/hero.png"),
        text = "<- You"
    },
    {
        image = love.graphics.newImage("assets/sprites/medium/enemy.png"),
        text = "<- Enemy"
    },
    {
        image = love.graphics.newImage("assets/sprites/medium/boss.png"),
        text = "<- Boss"
    },
    {
        image = love.graphics.newImage("assets/sprites/medium/bonus_shotgun.png"),
        text = "<- Unlock Shotgun"
    },
    {
        image = love.graphics.newImage("assets/sprites/medium/bonus_heal.png"),
        text = "<- Heal"
    },
    {
        image = love.graphics.newImage("assets/sprites/medium/bonus_damage.png"),
        text = "<- Increase Damage"
    },
}

local startButton = GUI.newButton(500,
    Title.y + 370,
    270,
    100,
    "Start",
    love.graphics.newFont("assets/fonts/Harvest Yard.otf", 50),
    { r = 0, g = 0, b = 0, a = 1 }
)

local exitButton = GUI.newButton(500,
    Title.y + 470,
    270,
    100,
    "Exit",
    love.graphics.newFont("assets/fonts/Harvest Yard.otf", 50),
    { r = 0, g = 0, b = 0, a = 1 }
)


local function initLegendGroup()
    local LegendGroup = GUI.newGroup()
    local LegendPanel = GUI.newPanel(1000, Title.y + 200, 400, 600)
    LegendGroup:addElement(LegendPanel)
    for i = 1, 6 do
        local tmpY = (i - 1) * 100
        if i == 1 then
            tmpY = 0
        end
        local newPanel = GUI.newPanel(LegendPanel.x + 10, LegendPanel.y + tmpY)
        newPanel:setImage(LegendPanelData[i].image)
        local newText = GUI.newText(newPanel.x + newPanel.width + 10, LegendPanel.y + tmpY, 64, 64,
            LegendPanelData[i].text,
            love.graphics.newFont("assets/fonts/Harvest Yard.otf", 25), nil, nil, { r = 0, g = 0, b = 0, a = 1 })
        LegendGroup:addElement(newPanel)
        LegendGroup:addElement(newText)
    end
    return LegendGroup
end

local function onPanelHover(pState, obj)
    if pState == "begin" then
        obj.Label.font = love.graphics.newFont("assets/fonts/Harvest Yard.otf", 60)
    end
    if pState == "end" then
        obj.Label.font = love.graphics.newFont("assets/fonts/Harvest Yard.otf", 50)
    end
end


local function initButtonsGroup(stateManager)
    local ButtonsGroup = GUI.newGroup()
    startButton:setEvent("hover", onPanelHover)
    startButton:setEvent("pressed", function(pState, btn)
        btn.isPressed = false
        SceneManager:switchTo("Gameplay")
    end
    )
    exitButton:setEvent("hover", onPanelHover)
    exitButton:setEvent("pressed", function(pState, btn)
        love.event.quit(0)
    end)
    ButtonsGroup:addElement(startButton)
    ButtonsGroup:addElement(exitButton)
    return ButtonsGroup
end

local function initControlsHintsGroup()
    local ControlHintsGroup = GUI.newGroup()
    local ControlHintsPanel = GUI.newPanel(20, Title.y + 200, 400, 600)
    ControlHintsGroup:addElement(ControlHintsPanel)
    for i = 1, #ControlHintsPanelData do
        local tmpY = (i - 1) * 100
        if i == 1 then
            tmpY = 0
        end
        local newText = GUI.newText(ControlHintsPanel.x + 10, ControlHintsPanel.y + tmpY, 64, 64,
            ControlHintsPanelData[i].text,
            love.graphics.newFont("assets/fonts/Harvest Yard.otf", 25), nil, nil, { r = 0, g = 0, b = 0, a = 1 })
        ControlHintsGroup:addElement(newText)
    end
    return ControlHintsGroup
end


StartMenuGUI = GUI.newGroup()
StartMenuGUI:addElement(Title)
local ControlGroup = initControlsHintsGroup()
StartMenuGUI:addElement(ControlGroup)
local ButtonsGroup = initButtonsGroup()
StartMenuGUI:addElement(ButtonsGroup)
local LegendGroup = initLegendGroup()
StartMenuGUI:addElement(LegendGroup)


return StartMenuGUI

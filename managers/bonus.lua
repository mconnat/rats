local WeaponManager = require("managers.weapon")
local Collisions = require("libs.collisions")
local Bonus = require("classes.bonus")
local Hero = require("managers.hero")
local BonusManager = {}

local function applyDamageBonus()
    BonusManager.DamageBonusCount = BonusManager.DamageBonusCount + 1
    Hero:setBonusDamage(BonusManager.DamageBonusCount)
end

local function applyHealthBonus()
    if Hero.maxHealthPoint - Hero.currentHealthPoint <= 1 then
        Hero.currentHealthPoint = Hero.maxHealthPoint
    else
        Hero.currentHealthPoint = Hero.currentHealthPoint + 2
    end
end

local function applyShotgunBonus()
    for i = 1, #WeaponManager.Catalog do
        if WeaponManager.Catalog[i].name == "Shotgun" then
            WeaponManager.Catalog[i].unlocked = true
        end
    end
end

BonusManager.Catalog = {
    Shotgun = {
        name = "Shotgun",
        image = love.graphics.newImage("assets/sprites/small/bonus_shotgun.png"),
        callback = applyShotgunBonus
    },
    Damage = {
        name = "Double Damage",
        image = love.graphics.newImage("assets/sprites/small/bonus_damage.png"),
        callback = applyDamageBonus,
    },
    Heal = {
        name = "Heal",
        image = love.graphics.newImage("assets/sprites/small/bonus_heal.png"),
        callback = applyHealthBonus

    }
}

BonusManager.BonusPool = {}
BonusManager.DamageBonusCount = 0

function BonusManager:init()
    BonusManager.BonusPool = {}
    BonusManager.DamageBonusCount = 0
end

function BonusManager:update()
    for i = 1, #BonusManager.BonusPool do
        if BonusManager.BonusPool[i] ~= nil then
            if Collisions.CircleCollision(BonusManager.BonusPool[i], Hero) then
                BonusManager.BonusPool[i]:onHit()
                table.remove(BonusManager.BonusPool, i)
            end
        end
    end
end

function BonusManager:newBonus(x, y, choosenBonus)
    local freshBonus = Bonus:new(x, y, choosenBonus)
    return freshBonus
end

local function NotInBonusPool(bonus)
    for _, b in ipairs(BonusManager.BonusPool) do
        if b.name == bonus.name then
            return false
        end
    end
    return true
end

function BonusManager:chooseBonus()
    local tmpBonuses = {}
    if Hero.currentHealthPoint < Hero.maxHealthPoint then
        table.insert(tmpBonuses, BonusManager.Catalog["Heal"])
    end
    for i, w in ipairs(WeaponManager.Catalog) do
        if w.name == "Shotgun" and w.unlocked == false and NotInBonusPool(w) then
            table.insert(tmpBonuses, BonusManager.Catalog["Shotgun"])
        end
    end

    table.insert(tmpBonuses, BonusManager.Catalog["Damage"])


    local choosenBonusIndex = love.math.random(1, #tmpBonuses)
    return tmpBonuses[choosenBonusIndex]
end

function BonusManager:addBonus(x, y)
    local choosenBonus = BonusManager:chooseBonus()
    local newBonus = BonusManager:newBonus(x, y, choosenBonus)
    table.insert(BonusManager.BonusPool, newBonus)
end

function BonusManager:draw()
    for _, bonus in ipairs(self.BonusPool) do
        bonus:draw()
    end
end

return BonusManager

local Weapon = require("classes.weapon")

local WeaponManager = {}

WeaponManager.Catalog = {
    {
        name = "Pistol",
        image = love.graphics.newImage("assets/sprites/medium/pistol.png"),
        bulletImage = love.graphics.newImage("assets/sprites/small/bullet.png"),
        maxBulletDistance = 200,
        damage = 1,
        unlocked = true
    },
    {
        name = "Shotgun",
        image = love.graphics.newImage("assets/sprites/medium/shotgun.png"),
        bulletImage = love.graphics.newImage("assets/sprites/small/double_bullet.png"),
        maxBulletDistance = 100,
        damage = 2,
        unlocked = false
    },
}

function WeaponManager:CreateWeapon(parent, weaponIndex)
    local newWeapon = Weapon:new(parent)
    table.merge(newWeapon, WeaponManager.Catalog[weaponIndex])
    return newWeapon
end

function WeaponManager:switchWeapon(entity)
    local weaponIndex = 1
    local tmpCatalog = {}
    for i = 1, #WeaponManager.Catalog do
        if WeaponManager.Catalog[i].unlocked then
            table.insert(tmpCatalog, WeaponManager.Catalog[i])
        end
    end
    for i = 1, #tmpCatalog do
        if tmpCatalog[i].name == entity.weapon.name then
            weaponIndex = i
        end
    end
    if weaponIndex == #tmpCatalog then
        self = table.merge(entity.weapon, tmpCatalog[1])
    else
        self = table.merge(entity.weapon, tmpCatalog[weaponIndex + 1])
    end
end

return WeaponManager

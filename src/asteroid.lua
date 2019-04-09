local Entity = require('src.entity')
local circle = require('src.geometry.circle')
local vector = require('src.geometry.vector')

local Asteroid = {}

---
--- @param center (vector)
--- @param radius (number)
--- @param velocity (vector)
local function make(center, radius, velocity)
    local asteroid = Entity.make('asteroid', center, radius, velocity)
    setmetatable(asteroid, { __index = Asteroid })
    return asteroid
end

---
--- @param asteroid1 (Asteroid)
--- @param asteroid2 (Asteroid)
local function merge(asteroid1, asteroid2)
    local summedArea = circle.area(asteroid1) + circle.area(asteroid2)
    local newRadius = circle.radius(summedArea)
    local newVelocity = vector.add(asteroid1.velocity, asteroid2.velocity)
    return make(asteroid1.center, newRadius, newVelocity)
end

return {
    make = make,
    merge = merge
}

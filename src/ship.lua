local vector = require('src.geometry.vector')
local Entity = require('src.entity')

local Ship = {}

function Ship:changeSpeed(speedIncrement)
    local direction = vector.rotateUnit(vector.make(1, 0), self.rotation)
    local scaled = vector.scale(direction, self.acceleration * speedIncrement)
    self.velocity = vector.add(self.velocity, scaled)
end

function Ship:accelerate(dt)
    self:changeSpeed(dt)
end

function Ship:decelerate(dt)
    self:changeSpeed(-dt)
end

function Ship:rotate(degreeIncrement)
    self.rotation = self.rotation + self.rotationSpeed * degreeIncrement
end

function Ship:rotateLeft(dt)
    self:rotate(dt)
end

function Ship:rotateRight(dt)
    self:rotate(-dt)
end

--- @param center (vector)
--- @param rotation (number) in degrees
local function make(center, rotation)
    local ship = Entity.make('ship', center, 15, vector.make(0, 0)) -- todo calculate radius
    ship.rotation = rotation
    ship.rotationSpeed = 300
    ship.acceleration = 1000
    setmetatable(ship, { __index = Ship })
    return ship
end

return {
    make = make,
    Ship = Ship,
}

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
    self.rotation = self.rotation - self.rotationSpeed * degreeIncrement
end

function Ship:rotateLeft(dt)
    self:rotate(dt)
end

function Ship:rotateRight(dt)
    self:rotate(-dt)
end

function Ship:update(dt)
    local scaled = vector.scale(self.velocity, dt)
    self.center = vector.add(scaled, self.center)
end

function Ship.make(center, rotation)
    local ship = Entity.make('ship', center, 15) -- todo calculate radius
    ship.rotation = rotation
    ship.rotationSpeed = 300
    ship.acceleration = 1000
    ship.velocity = vector.make(0, 0)
    setmetatable(ship, { __index = Ship })
    return ship
end

return {
    Ship = Ship,
}

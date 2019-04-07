local vector = require('src.geometry.vector')

local Ship = {}

function Ship:changeSpeed(speedIncrement)
    local thrustDirection = vector.rotateUnit(vector.make(1, 0), self.rotation)
    local scaled = vector.scale(thrustDirection, self.acceleration * speedIncrement)
    self.movement = vector.add(self.movement, scaled)
end

function Ship:rotate(degreeIncrement)
    self.rotation = self.rotation - self.rotationSpeed * degreeIncrement
end

function Ship:velocity()
    return vector.length(self.movement)
end

function Ship:accelerate(dt)
    self:changeSpeed(dt)
end

function Ship:decelerate(dt)
    self:changeSpeed(-dt)
end

function Ship:rotateLeft(dt)
    self:rotate(dt)
end

function Ship:rotateRight(dt)
    self:rotate(-dt)
end

function Ship:update(dt)
    local scaled = vector.scale(self.movement, dt)
    self.center = vector.add(scaled, self.center)
end

function Ship.make(center, rotation)
    local ship = {
        center = center,
        rotation = rotation,
        rotationSpeed = 300,
        acceleration = 1000,
        movement = vector.make(0, 0),
    }
    setmetatable(ship, { __index = Ship })
    return ship
end

return {
    Ship = Ship,
}

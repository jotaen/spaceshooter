local vector = require('src.vector')

local Ship = {}

function Ship:accelerate(dt)
    local direction = vector.rotateUnit(vector.make(1, 0), self.rotation)
    local scaled = vector.scale(direction, self.acceleration * dt)
    self.velocity = vector.add(self.velocity, scaled)
end

function Ship:decelerate(dt)
    local direction = vector.rotateUnit(vector.make(1, 0), self.rotation)
    local scaled = vector.scale(direction, -self.acceleration * dt)
    self.velocity = vector.add(self.velocity, scaled)
end

function Ship:rotateLeft(dt)
    self.rotation = self.rotation - self.rotationSpeed * dt
end

function Ship:rotateRight(dt)
    self.rotation = self.rotation + self.rotationSpeed * dt
end

function Ship:update(dt)
    local scaled = vector.scale(self.velocity, dt)
    self.center = vector.add(scaled, self.center)
end

function Ship.make(center, rotation)
    local ship = {
        center = center,
        rotation = rotation,
        rotationSpeed = 300,
        acceleration = 1000,
        velocity = vector.make(0, 0),
    }
    setmetatable(ship, { __index = Ship })

    return ship
end

return {
    Ship = Ship,
}

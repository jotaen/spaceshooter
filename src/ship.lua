local vector = require('src.vector')

local Ship = {}

local function triangle(v1, v2, v3)
    return {
        v1 = v1,
        v2 = v2,
        v3 = v3
    }
end

local baseShip = triangle(
        vector.make(1, 0),
        vector.make(-1, 0.5),
        vector.make(-1, -0.5))

local function drawableShip(ship, scale)
    if scale == nil then
        scale = 1
    end
    local rotatedShip = triangle(
            vector.rotate(baseShip.v1, ship.rotation),
            vector.rotate(baseShip.v2, ship.rotation),
            vector.rotate(baseShip.v3, ship.rotation))
    local scaledShip = triangle(
            vector.scale(rotatedShip.v1, scale),
            vector.scale(rotatedShip.v2, scale),
            vector.scale(rotatedShip.v3, scale))
    local translatedShip = triangle(
            vector.add(ship.center, scaledShip.v1),
            vector.add(ship.center, scaledShip.v2),
            vector.add(ship.center, scaledShip.v3))
    return translatedShip
end

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
    triangle = triangle,
    drawableShip = drawableShip,
}

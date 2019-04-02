local vector = require('src.vector')

local function triangle(v1, v2, v3)
    return {
        v1 = v1,
        v2 = v2,
        v3 = v3
    }
end

local function make(center, rotation)
    return {
        center = center,
        rotation = rotation,
        rotationSpeed = 300,
        acceleration = 1000,
        velocity = vector.make(0, 0),
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

local function accelerate(ship, dt)
    local direction = vector.rotateUnit(vector.make(1, 0), ship.rotation)
    local scaled = vector.scale(direction, ship.acceleration * dt)
    ship.velocity = vector.add(ship.velocity, scaled)
end

local function decelerate(ship, dt)
    local direction = vector.rotateUnit(vector.make(1, 0), ship.rotation)
    local scaled = vector.scale(direction, -ship.acceleration * dt)
    ship.velocity = vector.add(ship.velocity, scaled)
end

local function rotateLeft(ship, dt)
    ship.rotation = ship.rotation - ship.rotationSpeed * dt
end

local function rotateRight(ship, dt)
    ship.rotation = ship.rotation + ship.rotationSpeed * dt
end

local function update(ship, dt)
    local scaled = vector.scale(ship.velocity, dt)
    ship.center = vector.add(scaled, ship.center)
end

return {
    triangle = triangle,
    make = make,
    drawableShip = drawableShip,
    accelerate = accelerate,
    decelerate = decelerate,
    rotateLeft = rotateLeft,
    rotateRight = rotateRight,
    update = update,
}

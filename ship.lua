local vector = require('vector')

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
        rotation = rotation
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
    
    -- local unrotatedTriangle = triangle(
    --     vector.make(ship.center.x + 1 * scale, ship.center.y + 0 * scale),
    --     vector.make(ship.center.x - 1 * scale, ship.center.y + 0.5 * scale),
    -- vector.make(ship.center.x - 1 * scale, ship.center.y - 0.5 * scale))
    -- return triangle(
    --     vector.rotate(unrotatedTriangle.v1, ship.rotation),
    --     vector.rotate(unrotatedTriangle.v2, ship.rotation),
    -- vector.rotate(unrotatedTriangle.v3, ship.rotation))
end

return {
    triangle = triangle,
    make = make,
    drawableShip = drawableShip,
}

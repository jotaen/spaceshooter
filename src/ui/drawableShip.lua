local vector = require('src.geometry.vector')

local function triangle(v1, v2, v3)
    return {
        v1 = v1,
        v2 = v2,
        v3 = v3
    }
end

local shipShape = triangle(
    vector.make(1, 0),
    vector.make(-1, 0.5),
    vector.make(-1, -0.5)
)

local function make(ship, scale)
    scale = scale or 1
    local rotatedShip = triangle(
            vector.rotate(shipShape.v1, ship.rotation),
            vector.rotate(shipShape.v2, ship.rotation),
            vector.rotate(shipShape.v3, ship.rotation)
    )
    local fixedShape = triangle(
        vector.make(rotatedShip.v1.x, -rotatedShip.v1.y),
        vector.make(rotatedShip.v2.x, -rotatedShip.v2.y),
        vector.make(rotatedShip.v3.x, -rotatedShip.v3.y)
    )
    local scaledShip = triangle(
            vector.scale(fixedShape.v1, scale),
            vector.scale(fixedShape.v2, scale),
            vector.scale(fixedShape.v3, scale)
    )
    local translatedShip = triangle(
            vector.add(ship.center, scaledShip.v1),
            vector.add(ship.center, scaledShip.v2),
            vector.add(ship.center, scaledShip.v3)
    )
    return translatedShip
end

return {
    make = make,
}

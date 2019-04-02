local vector = require('src.vector')

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
    if scale == nil then
        scale = 1
    end
    local rotatedShip = triangle(
            vector.rotate(shipShape.v1, ship.rotation),
            vector.rotate(shipShape.v2, ship.rotation),
            vector.rotate(shipShape.v3, ship.rotation)
    )
    local scaledShip = triangle(
            vector.scale(rotatedShip.v1, scale),
            vector.scale(rotatedShip.v2, scale),
            vector.scale(rotatedShip.v3, scale)
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

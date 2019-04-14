local vector = require('lib.geometry.vector')

local function move(entity, dt)
    local scaled = vector.scale(entity.velocity, dt)
    entity.center = vector.add(scaled, entity.center)
end

--- @param type (string)
--- @param center (vector)
--- @param radius (number)
--- @param velocity (vector)
local function make(type, center, radius, velocity)
    return {
        type = type,
        center = center,
        radius = radius,
        velocity = velocity,
    }
end

return {
    make = make,
    move = move,
}

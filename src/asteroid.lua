local vector = require('src.vector')

local Asteroid = {}

function Asteroid:update(dt)
    local scaled = vector.scale(self.velocity, dt)
    self.center = vector.add(scaled, self.center)
end

function Asteroid.make(center, diameter, velocity)
    local asteroid = {
        center = center,
        diameter = diameter,
        velocity = velocity,
    }
    setmetatable(asteroid, { __index = Asteroid })
    return asteroid
end

return {
    Asteroid = Asteroid,
}

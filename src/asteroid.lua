local vector = require('src.geometry.vector')
local Entity = require('src.entity')

local Asteroid = {}

function Asteroid:update(dt)
    local scaled = vector.scale(self.velocity, dt)
    self.center = vector.add(scaled, self.center)
end

function Asteroid.make(center, diameter, velocity)
    local asteroid = Entity.make('asteroid', center, diameter / 2)
    asteroid.diameter = diameter -- todo remove
    asteroid.velocity = velocity

    setmetatable(asteroid, { __index = Asteroid })
    return asteroid
end

return {
    Asteroid = Asteroid,
}

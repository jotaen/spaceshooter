local vector = require('src.geometry.vector')
local Entity = require('src.entity')

local Asteroid = {}

function Asteroid:update(dt)
    local scaled = vector.scale(self.velocity, dt)
    self.center = vector.add(scaled, self.center)
end

function Asteroid.make(center, radius, velocity)
    local asteroid = Entity.make('asteroid', center, radius)
    asteroid.velocity = velocity

    setmetatable(asteroid, { __index = Asteroid })
    return asteroid
end

return {
    Asteroid = Asteroid,
}

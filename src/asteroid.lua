local Entity = require('src.entity')

local Asteroid = {}

function Asteroid.make(center, radius, velocity)
    local asteroid = Entity.make('asteroid', center, radius, velocity)
    setmetatable(asteroid, { __index = Asteroid })
    return asteroid
end

return {
    Asteroid = Asteroid,
}

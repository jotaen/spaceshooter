local circle = require('lib.geometry.circle')

local CollisionDetector = {}

function make(resolver)
    local detector = { resolver = resolver, x = 2 }
    setmetatable(detector, { __index = CollisionDetector })
    return detector
end

function CollisionDetector:detect(collidables)
    local len = #collidables
    for j = 1, len do
        for k = j, len do
            if j ~= k and circle.isOverlapping(collidables[j], collidables[k]) then
                self.resolver:handleCollision(collidables[j], collidables[k])
            end
        end
    end
end

return {
    make = make
}
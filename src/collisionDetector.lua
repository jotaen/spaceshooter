local circle = require('src.geometry.circle')

local CollisionDetector = {}

function CollisionDetector.make(resolver)
    local detector = { resolver = resolver, x = 2 }
    setmetatable(detector, { __index = CollisionDetector })
    return detector
end

function CollisionDetector:detect(collidables)
    local len = #collidables
    for j = 1, len do
        for k = j, len do
            if j ~= k and circle.isOverlapping(collidables[j], collidables[k]) then
                self.resolver:handleCollision({})
            end
        end
    end
end

return {
    CollisionDetector = CollisionDetector,
}
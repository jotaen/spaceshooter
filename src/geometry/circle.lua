local vector = require('src.geometry.vector')

local function make(center, radius)
    if radius <= 0 then
        error('NON_POSITIVE_RADIUS')
    end
    return {
        center = center,
        radius = radius,
    }
end

local function isOverlapping(circle1, circle2)
    local diffVector = vector.subtract(circle1.center, circle2.center)
    local diffVectorLength = vector.length(diffVector)
    local radiusSum = circle1.radius + circle2.radius
    return diffVectorLength <= radiusSum
end

return {
    make = make,
    isOverlapping = isOverlapping,
}

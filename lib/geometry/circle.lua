local vector = require('lib.geometry.vector')

--- @param center (vector)
--- @param radius (number)
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

local function area(circle)
    return math.pi * circle.radius ^ 2
end

local function radius(circleArea)
    return math.sqrt(circleArea / math.pi)
end

return {
    make = make,
    isOverlapping = isOverlapping,
    area = area,
    radius = radius
}

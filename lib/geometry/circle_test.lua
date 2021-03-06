local vector = require('lib.geometry.vector')
local lu = require('luaunit')
local circle = require('lib.geometry.circle')

--
-- CIRCLE CREATION
--

function test_circlesCannotHaveZeroRadius()
    lu.assertError(function()
        circle.make(vector.make(0,0), 0)
    end)
end

function test_circlesCannotHaveNegativeRadius()
    lu.assertError(function()
        circle.make(vector.make(0,0), -1)
    end)
end

--
-- CIRCLE OVERLAP
--

function test_nonOverlappingCirclesDoNotCollide()
    local circle1 = circle.make(vector.make(1,1), 1)
    local circle2 = circle.make(vector.make(10,10), 1)

    lu.assertFalse(circle.isOverlapping(circle1, circle2))
end

function test_circlesWithSamePositionCollide()
    local circle1 = circle.make(vector.make(1,1), 1)
    local circle2 = circle.make(vector.make(1,1), 10)

    lu.assertTrue(circle.isOverlapping(circle1, circle2))
end

function test_partiallyOverlappingCirclesCollide()
    local circle1 = circle.make(vector.make(1,1), 1)
    local circle2 = circle.make(vector.make(2,2), 1)

    lu.assertTrue(circle.isOverlapping(circle1, circle2))
end

function test_barelyTouchingCirclesCollide()
    local circle1 = circle.make(vector.make(6,4), 0.5)
    local circle2 = circle.make(vector.make(6,5), 0.5)

    lu.assertTrue(circle.isOverlapping(circle1, circle2))
end

function test_almostTouchingCirclesDoNotCollide()
    local circle1 = circle.make(vector.make(6,4), 0.49)
    local circle2 = circle.make(vector.make(6,5), 0.5)

    lu.assertFalse(circle.isOverlapping(circle1, circle2))
end

function test_fullyOverlappingCirclesCollide()
    local circle1 = circle.make(vector.make(1,1), 1)
    local circle2 = circle.make(vector.make(2,2), 85)

    lu.assertTrue(circle.isOverlapping(circle1, circle2))
end

--
-- RADIUS / AREA
--

function test_unitCircleHasAreaPi()
    local unitCircle = circle.make(vector.make(0, 0), 1)
    lu.assertAlmostEquals(circle.area(unitCircle), math.pi, 0.01)
end

function test_circleAreaComputationWorks()
    local unitCircle = circle.make(vector.make(0, 0), 21)
    lu.assertAlmostEquals(circle.area(unitCircle), 1385.5, 0.1)
end

function test_piAreaIsRadiusOne()
    lu.assertAlmostEquals(circle.radius(math.pi), 1, 0.01)
end

function test_areaRadiusComputationWorks()
    lu.assertAlmostEquals(circle.radius(1385.5), 21, 0.1)
end
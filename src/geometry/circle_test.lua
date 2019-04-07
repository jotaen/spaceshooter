local vector = require('src.geometry.vector')
local lu = require('luaunit')
local circle = require('src.geometry.circle')

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

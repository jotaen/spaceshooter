local lu = require('luaunit')
local asteroid = require('src.asteroid')
local vector = require('src.geometry.vector')

function test_mergeAsteroidsCreatesJoint()
    local asteroid1 = asteroid.make(vector.make(0, 0), 2, vector.make(1, 1))
    local asteroid2 = asteroid.make(vector.make(0, 0), 1, vector.make(2, 2))
    local result = asteroid.merge(asteroid1, asteroid2)
    lu.assertEquals(result.velocity.x, 3)
    lu.assertEquals(result.velocity.y, 3)
    lu.assertAlmostEquals(result.radius, 2.236, 0.1)
end
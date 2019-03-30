local lu = require('luaunit')
local vector = require('vector')

local function assertVectorEquals(actual, expected)
    local delta = 0.1
    lu.assertAlmostEquals(actual.x, expected.x, delta)
    lu.assertAlmostEquals(actual.y, expected.y, delta)
end

local function afterRotation(rotation, initial, expected)
    local rotated = vector.rotate(initial, rotation)
    assertVectorEquals(rotated, expected)
end

function test_rotation()
    local initial = vector.make(1, 0)
    afterRotation(0, initial, vector.make(1, 0))
    afterRotation(45, initial, vector.make(0.7, 0.7))
    afterRotation(90, initial, vector.make(0, 1))
    afterRotation(180, initial, vector.make(-1, 0))
    afterRotation(270, initial, vector.make(0, -1))
    afterRotation(360, initial, vector.make(1, 0))
    afterRotation(450, initial, vector.make(0, 1))
end

os.exit(lu.LuaUnit.run())

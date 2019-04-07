local vector = require('src.geometry.vector')
local assertVectorEquals = require('src.assertions').assertVectorEquals

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

function test_rotation_2()
    local initial = vector.make(0, 1)
    afterRotation(0, initial, vector.make(0, 1))
    afterRotation(90, initial, vector.make(-1, 0))
    afterRotation(180, initial, vector.make(0, -1))
    afterRotation(270, initial, vector.make(1, 0))
end

function test_rotating_nonUnitVector()
    local initial = vector.make(0, 2)
    afterRotation(0, initial, vector.make(0, 2))
    afterRotation(90, initial, vector.make(-2, 0))
    afterRotation(180, initial, vector.make(0, -2))
    afterRotation(270, initial, vector.make(2, 0))
end

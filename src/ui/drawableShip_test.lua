local assertVectorEquals = require('src.assertions').assertVectorEquals
local ship = require('src.ship')
local drawableShip = require('src.ui.drawableShip')
local vector = require('src.geometry.vector')

function test_unrotatedShip()
    local s = ship.make(vector.make(0, 0), 0)
    local triangle = drawableShip.make(s)

    assertVectorEquals(triangle.v1, vector.make(1, 0))
    assertVectorEquals(triangle.v2, vector.make(-1, 0.5))
    assertVectorEquals(triangle.v3, vector.make(-1, -0.5))
end

function test_rotated270Ship()
    local s = ship.make(vector.make(0, 0), 270)
    local triangle = drawableShip.make(s)

    assertVectorEquals(triangle.v1, vector.make(0, -1))
    assertVectorEquals(triangle.v2, vector.make(0.5, 1))
    assertVectorEquals(triangle.v3, vector.make(-0.5, 1))
end

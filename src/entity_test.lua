local vector = require('lib.geometry.vector')
local Entity = require('src.entity')
local lu = require('luaunit')

local TIME_PASSED = 1

function test_moveChangesPosition()
    local entity = Entity.make('entity', vector.make(1, 1), 1, vector.make(10, 20))
    local previousPosition = entity.center
    Entity.move(entity, TIME_PASSED)
    lu.assertIsTrue(vector.length(previousPosition) < vector.length(entity.center))
end

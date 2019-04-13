local Camera = require('src.ui.camera')
local vector = require('src.geometry.vector')
local Entity = require('src.entity')
local assertions = require('src.assertions')

function test_cameraPointingToOrigin_doesNotTranslateEntity()
    local entity = Entity.make('dummy', vector.zero(), 1, vector.zero())
    local camera = Camera.make(vector.zero(), 2, 2)

    local projected = camera:projectToCanvas(entity)
    assertions.assertVectorEquals(projected.center, vector.make(1, -1))
end

function test_entityAtOrigin_isCorrectlyProjectedByMovedCamera()
    local entity = Entity.make('dummy', vector.zero(), 1, vector.zero())
    local camera = Camera.make(vector.make(1, 1), 2, 2)

    local projected = camera:projectToCanvas(entity)
    assertions.assertVectorEquals(projected.center, vector.make(0, -2))
end
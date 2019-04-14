local vector = require('lib.geometry.vector')

local Camera = {}

--- @param initialWorldPosition (vector)
--- @param width (number)
--- @param height (number)
local function make(initialWorldPosition, width, height)
    local camera = {
        worldPosition = initialWorldPosition,
        width = width,
        height = height,
    }
    setmetatable(camera, { __index = Camera })
    return camera
end

function Camera:projectToCanvas(entity)
    local cameraTranslationFactor = vector.make(-self.width / 2, self.height / 2)
    local cameraTopLeftOriginInWorld = vector.add(self.worldPosition, cameraTranslationFactor)
    local entityCenterInWorld = entity.center
    local diffWorld = vector.subtract(entityCenterInWorld, cameraTopLeftOriginInWorld)
    return {
        center = vector.make(diffWorld.x, diffWorld.y),
        radius = entity.radius,
        rotation = entity.rotation and entity.rotation
    }
end

function Camera:cameraCenterAt(worldPosition)
    self.worldPosition = worldPosition
end

return {
    make = make,
}
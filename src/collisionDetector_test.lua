local lu = require('luaunit')
local vector = require('lib.geometry.vector')
local Detector = require('src.collisionDetector')

local function makeResolverSpy()
    return {
        callCount = 0,
        lastCollision = nil,
        handleCollision = function(self, collidable1, collidable2)
            self.callCount = self.callCount + 1
            self.lastCollision = {collidable1, collidable2}
        end
    }
end

local function makeDummyCollidable(center)
    return {
        center = center,
        radius = 1
    }
end

TestCollisionDetector = {}

function TestCollisionDetector:setUp()
    self.resolver = makeResolverSpy()
    self.detector = Detector.make(self.resolver)
end

function TestCollisionDetector:test_doesNotCallResolverWhenNoCollidableExists()
    local collidables = {}
    self.detector:detect(collidables)
    lu.assertEquals(self.resolver.callCount, 0)
end

function TestCollisionDetector:test_doesNotCallResolverWhenThereIsOnlyOneCollidable()
    local collidables = {
        makeDummyCollidable(vector.make(0, 0)),
    }
    self.detector:detect(collidables)
    lu.assertEquals(self.resolver.callCount, 0)
end

function TestCollisionDetector:test_doesNotCallResolverWhenNoCollisionIsDetected()
    local collidables = {
        makeDummyCollidable(vector.make(0, 0)),
        makeDummyCollidable(vector.make(10, 10))
    }
    self.detector:detect(collidables)
    lu.assertEquals(self.resolver.callCount, 0)
end

function TestCollisionDetector:test_callsResolverOnceWhenCollisionIsDetected()
    local collidables = {
        makeDummyCollidable(vector.make(0, 0)),
        makeDummyCollidable(vector.make(1, 0))
    }
    self.detector:detect(collidables)
    lu.assertEquals(self.resolver.callCount, 1)
end

function TestCollisionDetector:test_callsResolverTwiceWhenMultiCollisionIsDetected()
    local collidables = {
        makeDummyCollidable(vector.make(-1.5, 0)),
        makeDummyCollidable(vector.make(0, 0)),
        makeDummyCollidable(vector.make(1.5, 0))
    }
    self.detector:detect(collidables)
    lu.assertEquals(self.resolver.callCount, 2)
end

function TestCollisionDetector:test_callsResolverForEveryCollision()
    local collidables = {
        makeDummyCollidable(vector.make(-1.5, 0)),
        makeDummyCollidable(vector.make(0, 0)),
        makeDummyCollidable(vector.make(10, 10)),
        makeDummyCollidable(vector.make(10, 10)),
        makeDummyCollidable(vector.make(9, 9)),
        makeDummyCollidable(vector.make(-50, -50)),
        makeDummyCollidable(vector.make(1000, 1000)),
    }
    self.detector:detect(collidables)
    lu.assertEquals(self.resolver.callCount, 4)
end

function TestCollisionDetector:test_passesCollidablesToResolver()
    local collidables = {
        makeDummyCollidable(vector.make(0, 0)),
        makeDummyCollidable(vector.make(1, 0))
    }
    self.detector:detect(collidables)
    lu.assertEquals(self.resolver.lastCollision[1], collidables[1])
    lu.assertEquals(self.resolver.lastCollision[2], collidables[2])
end

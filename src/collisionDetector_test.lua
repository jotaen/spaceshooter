local lu = require('luaunit')
local vector = require('src.geometry.vector')
local Detector = require('src.collisionDetector').CollisionDetector

local function makeResolverSpy()
    return {
        callCount = 0,
        handleCollision = function(self, collision)
            self.callCount = self.callCount + 1
        end
    }
end

local function makeDummyCollidable(position)
    return {
        position = position,
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
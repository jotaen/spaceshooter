local lu = require('luaunit')
local ship = require('src.ship')
local vector = require('lib.geometry.vector')

local TIME_PASSED = 1

TestShip = {}

function TestShip:setUp()
    self.ship = ship.make(vector.make(0, 0), 0)
end

function TestShip:test_accelerateIncreasesVelocity()
    local previousVelocity = self.ship.velocity
    self.ship:accelerate(TIME_PASSED)
    lu.assertIsTrue(vector.length(self.ship.velocity) > vector.length(previousVelocity))
end

function TestShip:test_decelerateDecreasesVelocity()
    self.ship:accelerate(TIME_PASSED)
    self.ship:accelerate(TIME_PASSED)
    local previousVelocity = self.ship.velocity
    self.ship:decelerate(TIME_PASSED)
    lu.assertIsTrue(vector.length(self.ship.velocity) < vector.length(previousVelocity))
end

function TestShip:test_rotateLeft()
    local previousRotation = self.ship.rotation
    self.ship:rotateLeft(TIME_PASSED)
    lu.assertIsTrue(previousRotation < self.ship.rotation)
end

function TestShip:test_rotateRight()
    local previousRotation = self.ship.rotation
    self.ship:rotateRight(TIME_PASSED)
    lu.assertIsTrue(previousRotation > self.ship.rotation)
end

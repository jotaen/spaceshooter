local lu = require('luaunit')
local Ship = require('src.ship').Ship
local vector = require('src.vector')

local TIME_PASSED = 1

TestShip = {}

function TestShip:setUp()
    self.ship = Ship.make(vector.make(0, 0), 0)
end

function TestShip:test_accelerateIncreasesVelocity()
    local previousVelocity = self.ship:velocity()
    self.ship:accelerate(TIME_PASSED)
    lu.assertIsTrue(self.ship:velocity() > previousVelocity)
end

function TestShip:test_decelerateDecreasesVelocity()
    self.ship:accelerate(TIME_PASSED)
    self.ship:accelerate(TIME_PASSED)
    local previousVelocity = self.ship:velocity()
    self.ship:decelerate(TIME_PASSED)
    lu.assertIsTrue(self.ship:velocity() < previousVelocity)
end

function TestShip:test_rotateLeft()
    local previousRotation = self.ship.rotation
    self.ship:rotateLeft(TIME_PASSED)
    lu.assertIsTrue(previousRotation > self.ship.rotation)
end

function TestShip:test_rotateRight()
    local previousRotation = self.ship.rotation
    self.ship:rotateRight(TIME_PASSED)
    lu.assertIsTrue(previousRotation < self.ship.rotation)
end

function TestShip:test_updateMovesShip()
    local previousPosition = self.ship.center
    self.ship:accelerate(TIME_PASSED)
    self.ship:update(TIME_PASSED)
    lu.assertIsTrue(vector.length(previousPosition) < vector.length(self.ship.center))
end
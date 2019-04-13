local circle = require('src.geometry.circle')
local ship = require('src.ship')
local CollisionDetector = require('src.collisionDetector')
local Entity = require('src.entity')
local Asteroid = require('src.asteroid')
local vector = require('src.geometry.vector')

local World = {}

local function scoreValue(collidable)
    return math.ceil(circle.area(collidable) / 1000)
end

local function defaultFighter()
    return ship.make(vector.make(40, 40), 90)
end

local function makeRandomAsteroid(worldWidth, worldHeight)
    local MAX_OFFSET = worldWidth * 5;
    local center = vector.make(
            love.math.random(-MAX_OFFSET, MAX_OFFSET),
            love.math.random(-MAX_OFFSET, MAX_OFFSET)
    )
    local radius = love.math.random(10, 200)
    local velocity = vector.make(
            love.math.random(-100, 100),
            love.math.random(-100, 100)
    )
    return Asteroid.make(center, radius, velocity)
end

local function randomAsteroids(worldWidth, worldHeight)
    local newAsteroids = {}
    for i = 1, 500 do
        newAsteroids[i] = makeRandomAsteroid(worldWidth, worldHeight)
    end
    return newAsteroids
end

function World:reset()
    self.fighter = defaultFighter()
    self.asteroids = randomAsteroids(self.width, self.height)
end

function World:update(dt)
    Entity.move(self.fighter, dt)

    for i, asteroid in pairs(self.asteroids) do
        Entity.move(asteroid, dt)
    end

    local collidables = { self.fighter }
    for _, asteroid in pairs(self.asteroids) do
        table.insert(collidables, asteroid)
    end

    local world = self
    local detector = CollisionDetector.make({
        handleCollision = function(_, collidable1, collidable2)
            if collidable1.type == 'asteroid' and collidable2.type == 'asteroid' then
                local largerAsteroid = collidable1.radius > collidable2.radius and collidable1 or collidable2
                local smallerAsteroid = collidable1.radius <= collidable2.radius and collidable1 or collidable2
                smallerAsteroid.isDestroyed = true
                local mergedAsteroid = Asteroid.merge(largerAsteroid, smallerAsteroid)
                largerAsteroid.radius = mergedAsteroid.radius
                largerAsteroid.velocity = mergedAsteroid.velocity
                return
            end
            if collidable1.type == 'asteroid' then
                collidable1.isDestroyed = true
                world.score = world.score + scoreValue(collidable1)
            end
            if collidable2.type == 'asteroid' then
                collidable2.isDestroyed = true
                world.score = world.score + scoreValue(collidable2)
            end
        end
    })
    detector:detect(collidables)

    for i, asteroid in pairs(self.asteroids) do
        if asteroid.isDestroyed then
            self.asteroids[i] = makeRandomAsteroid(self.width, self.height)
        end
    end
end

local function make(width, height)
    local world = {
        score = 0,
        width = width,
        height = height,
    }
    setmetatable(world, { __index = World })
    world:reset(width, height)
    return world
end

return {
    make = make,
}

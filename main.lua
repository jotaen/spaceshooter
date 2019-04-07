local ship = require('src.ship')
local circle = require('src.geometry.circle')
local Asteroid = require('src.asteroid')
local vector = require('src.geometry.vector')
local drawableShip = require('src.ui.drawableShip')
local CollisionDetector = require('src.collisionDetector')
local Entity = require('src.entity')

local function defaultFighter()
    return ship.Ship.make(vector.make(40, 40), 0)
end

local function makeRandomAsteroid(w, h)
    local MAX_OFFSET = 1000;
    local center = vector.make(
            love.math.random(-MAX_OFFSET, w + MAX_OFFSET),
            love.math.random(-MAX_OFFSET, h + MAX_OFFSET)
    )
    local radius = love.math.random(10, 50)
    local velocity = vector.make(
            love.math.random(-100, 100),
            love.math.random(-100, 100)
    )
    return Asteroid.make(center, radius, velocity)
end

local function randomAsteroids(w, h)
    local asteroids = {}
    for i = 1, 100 do
        asteroids[i] = makeRandomAsteroid(w, h)
    end
    return asteroids
end

local fighter = defaultFighter()
local asteroids
local w, h
local isLaserActive = false
local laserSoundSource

local score = 0
local time = os.time()
local function remainingTime()
    return time - os.time()  + 60
end

local function scoreValue(collidable)
    return math.ceil(circle.area(collidable) / 1000)
end

function love.mousepressed()
    isLaserActive = true
    laserSoundSource:play()
end

function love.mousereleased()
    isLaserActive = false
    laserSoundSource:stop()
end

function love.load()
    w, h = love.graphics.getDimensions()
    stars = {}
    for i = 1, 100 do
        stars[i] = vector.make(love.math.random(0, w), love.math.random(0, h))
    end
    laserSoundSource = love.audio.newSource("laser_sound.mp3", "static")
    laserSoundSource:setLooping(true)
    asteroids = randomAsteroids(w, h)
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    if love.keyboard.isDown("r") then
        fighter = defaultFighter()
        asteroids = randomAsteroids(w, h)
    end
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        fighter:rotateLeft(dt)
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        fighter:rotateRight(dt)
    end

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        fighter:accelerate(dt)
    end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        fighter:decelerate(dt)
    end

    Entity.move(fighter, dt)

    if fighter.center.x < 0 then
        fighter.center.x = 0
        fighter.movement = vector.make(0, 0)
    end
    if fighter.center.x > w then
        fighter.center.x = w
        fighter.movement = vector.make(0, 0)
    end
    if fighter.center.y < 0 then
        fighter.center.y = 0
        fighter.movement = vector.make(0, 0)
    end
    if fighter.center.y > h then
        fighter.center.y = h
        fighter.movement = vector.make(0, 0)
    end

    for i, asteroid in pairs(asteroids) do
        Entity.move(asteroid, dt)
        if asteroid.center.x < -w or asteroid.center.x > 2 * w or asteroid.center.y < -h or asteroid.center.y > 2 * h
        then
            asteroids[i] = makeRandomAsteroid(w, h)
        end
    end

    local collidables = { fighter }
    for _, asteroid in pairs(asteroids) do
        table.insert(collidables, asteroid)
    end

    local detector = CollisionDetector.make({
        handleCollision = function(self, collidable1, collidable2)
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
                score = score + scoreValue(collidable1)
            end
            if collidable2.type == 'asteroid' then
                collidable2.isDestroyed = true
                score = score + scoreValue(collidable2)
            end
        end
    })
    detector:detect(collidables)

    for i, asteroid in pairs(asteroids) do
        if asteroid.isDestroyed then
            asteroids[i] = makeRandomAsteroid(w, h)
        end
    end

    if remainingTime() <= 0 then
        print("Tadaaa, your highscore was " .. score)
        love.event.quit()
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    for _, star in ipairs(stars) do
        love.graphics.points(star.x, star.y)
    end

    if isLaserActive then
        love.graphics.setColor(1, 0, 0)
        local dir = vector.subtract(vector.make(love.mouse.getX(), love.mouse.getY()), fighter.center)
        local scaledDir = vector.scale(dir, 1000)
        local src = fighter.center
        local target = vector.add(fighter.center, scaledDir)
        love.graphics.line(src.x, src.y, target.x, target.y)
    end

    love.graphics.setColor(0, 0.4, 0.4)
    local polygon = drawableShip.make(fighter, 20)
    love.graphics.polygon(
            "fill",
            polygon.v1.x, polygon.v1.y,
            polygon.v2.x, polygon.v2.y,
            polygon.v3.x, polygon.v3.y
    )
    love.graphics.circle("line", fighter.center.x, fighter.center.y, fighter.radius)

    love.graphics.setColor(3, 1, 0.6)
    for _, asteroid in pairs(asteroids) do
        love.graphics.circle("fill", asteroid.center.x, asteroid.center.y, asteroid.radius)
    end

    local statusText = "TIME: " .. remainingTime() .. "s, SCORE: " .. score
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(statusText, 20, h-30)
end



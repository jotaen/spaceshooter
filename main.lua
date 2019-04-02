local ship = require('src.ship')
local Asteroid = require('src.asteroid').Asteroid
local vector = require('src.vector')
local drawableShip = require('src.ui.drawableShip')

local function defaultFighter()
    return ship.Ship.make(vector.make(40, 40), 0)
end

local function randomAsteroids(w, h)
    local MAX_OFFSET = 1000;
    local asteroids = {}
    for i = 1, 100 do
        local center = vector.make(
                love.math.random(-MAX_OFFSET, w + MAX_OFFSET),
                love.math.random(-MAX_OFFSET, h + MAX_OFFSET)
        )
        local diameter = love.math.random(20, 100)
        local velocity = vector.make(
                love.math.random(-300, 300),
                love.math.random(-300, 300)
        )
        asteroids[i] = Asteroid.make(center, diameter, velocity)
    end
    return asteroids
end

local fighter = defaultFighter()
local asteroids
local w, h
local isLaserActive = false
local laserSoundSource

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
    laserSoundSource = love.audio.newSource( "laser_sound.mp3", "static" )
    laserSoundSource:setLooping(true)
    asteroids = randomAsteroids(w, h)
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    if love.keyboard.isDown("r") then
        fighter = defaultFighter()
    end
    if love.keyboard.isDown("left") then
        fighter:rotateLeft(dt)
    end
    if love.keyboard.isDown("right") then
        fighter:rotateRight(dt)
    end

    if love.keyboard.isDown("up") then
        fighter:accelerate(dt)
    end

    if love.keyboard.isDown("down") then
        fighter:decelerate(dt)
    end

    fighter:update(dt)

    if fighter.center.x < 0 then
        fighter.center.x = w
    end
    if fighter.center.x > w then
        fighter.center.x = 0
    end
    if fighter.center.y < 0 then
        fighter.center.y = h
    end
    if fighter.center.y > h then
        fighter.center.y = 0
    end

    for _, asteroid in pairs(asteroids) do
        asteroid:update(dt)
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

    love.graphics.setColor(3, 1, 0.6)
    for _, asteroid in pairs(asteroids) do
        love.graphics.circle( "fill", asteroid.center.x, asteroid.center.y, asteroid.diameter / 2)
    end
end

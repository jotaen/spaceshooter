local World = require('src.world')
local vector = require('src.geometry.vector')
local drawableShip = require('src.ui.drawableShip')
local camera = require('src.ui.camera').make()

local world = nil

local isLaserActive = false
local laserSoundSource

local time = os.time()
local function remainingTime()
    return time - os.time() + 60
end

function love.load()
    w, h = love.graphics.getDimensions()
    world = World.make(w, h)
    stars = {}
    for i = 1, 100 do
        stars[i] = vector.make(love.math.random(0, w), love.math.random(0, h))
    end
    laserSoundSource = love.audio.newSource("laser_sound.mp3", "static")
    laserSoundSource:setLooping(true)
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    if love.keyboard.isDown("r") then
        world:reset()
    end
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        world.fighter:rotateLeft(dt)
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        world.fighter:rotateRight(dt)
    end

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        world.fighter:accelerate(dt)
    end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        world.fighter:decelerate(dt)
    end

    if remainingTime() <= 0 then
        print("Tadaaa, your highscore was " .. world.score)
        love.event.quit()
    end

    world:update(dt)

    camera:moveTo(world.fighter)
end

function love.mousepressed()
    isLaserActive = true
    laserSoundSource:play()
end

function love.mousereleased()
    isLaserActive = false
    laserSoundSource:stop()
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    for _, star in ipairs(stars) do
        love.graphics.points(star.x, star.y)
    end

    if isLaserActive then
        love.graphics.setColor(1, 0, 0)
        local dir = vector.subtract(vector.make(love.mouse.getX(), love.mouse.getY()), world.fighter.center)
        local scaledDir = vector.scale(dir, 1000)
        local src = world.fighter.center
        local target = vector.add(world.fighter.center, scaledDir)
        love.graphics.line(src.x, src.y, target.x, target.y)
    end

    love.graphics.setColor(0, 0.4, 0.4)
    local polygon = drawableShip.make(camera:project(world.fighter), 20)
    love.graphics.polygon(
            "fill",
            polygon.v1.x, polygon.v1.y,
            polygon.v2.x, polygon.v2.y,
            polygon.v3.x, polygon.v3.y
    )

    love.graphics.setColor(3, 1, 0.6)
    for _, asteroid in pairs(world.asteroids) do
        local a = camera:project(asteroid)
        love.graphics.circle("fill", a.center.x, a.center.y, a.radius)
    end

    local statusText = "TIME: " .. remainingTime() .. "s, SCORE: " .. world.score
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(statusText, 20, h-30)
end



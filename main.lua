local World = require('src.world')
local vector = require('src.geometry.vector')
local drawableShip = require('src.ui.drawableShip')
local Camera = require('src.ui.camera')

local world = nil
local camera = nil

local time = os.time()
local function remainingTime()
    return time - os.time() + 60
end

function love.load()
    w, h = love.graphics.getDimensions()
    world = World.make(w, h)
    stars = {}
    for i = 1, 100 do
        stars[i] = vector.make(love.math.random(0, 2*w), love.math.random(-2*h, 0))
    end
    camera = Camera.make(world.fighter.center, w, h)
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

    local oldFighterCenter = world.fighter.center

    world:update(dt)

    local cameraMovement = vector.subtract(oldFighterCenter, world.fighter.center)
    for i, star in pairs(stars) do
        stars[i] = vector.add(vector.scale(cameraMovement, i % 2 == 0 and 0.03 or 0.02), star)
        if star.x < 0 or star.x > w or star.y > 0 or star.y < -h then
            stars[i] = vector.make(love.math.random(0, 2 *w), love.math.random(-2*h, 0))
        end
    end


    camera:cameraCenterAt(world.fighter.center)
end

function love.draw()
    love.graphics.scale(1, -1)
    love.graphics.setColor(1, 1, 1)
    for _, star in ipairs(stars) do
        love.graphics.points(star.x, star.y)
    end


    local polygon = drawableShip.make(camera:projectToCanvas(world.fighter), 20)

    love.graphics.setColor(0, 0.4, 0.4)
    love.graphics.polygon(
            "fill",
            polygon.v1.x, polygon.v1.y,
            polygon.v2.x, polygon.v2.y,
            polygon.v3.x, polygon.v3.y
    )

    love.graphics.setColor(3, 1, 0.6)
    for _, asteroid in pairs(world.asteroids) do
        local a = camera:projectToCanvas(asteroid)
        love.graphics.circle("fill", a.center.x, a.center.y, a.radius)
    end
    love.graphics.scale(1, -1)

    local statusText = "TIME: " .. remainingTime() .. "s, SCORE: " .. world.score .. " POS: " .. math.floor(world.fighter.center.x / 10) .. ":" .. math.floor(world.fighter.center.y / 10)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(statusText, 20, h-30)
end



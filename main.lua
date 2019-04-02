local ship = require('src.ship')
local vector = require('src.vector')

local function defaultFighter()
    return ship.make(vector.make(40, 40), 0)
end

local fighter = defaultFighter()
local w, h

function love.load()
    w, h = love.graphics.getDimensions()
    stars = {}
    for i = 1, 100 do
        stars[i] = vector.make(love.math.random(0, w), love.math.random(0, h))
    end
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    if love.keyboard.isDown("r") then
        fighter = defaultFighter()
    end
    if love.keyboard.isDown("left") then
        fighter.rotation = fighter.rotation - fighter.rotationSpeed * dt
    end
    if love.keyboard.isDown("right") then
        fighter.rotation = fighter.rotation + fighter.rotationSpeed * dt
    end

    if love.keyboard.isDown("up") then
        local direction = vector.rotateUnit(vector.make(1, 0), fighter.rotation)
        local scaled = vector.scale(direction, fighter.acceleration * dt)
        fighter.velocity = vector.add(fighter.velocity, scaled)
    end

    if love.keyboard.isDown("down") then
        local direction = vector.rotateUnit(vector.make(1, 0), fighter.rotation)
        local scaled = vector.scale(direction, -fighter.acceleration * dt)
        fighter.velocity = vector.add(fighter.velocity, scaled)
    end

    local scaled = vector.scale(fighter.velocity, dt)
    fighter.center = vector.add(scaled, fighter.center)

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
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    for _, star in ipairs(stars) do
        love.graphics.points(star.x, star.y)
    end
    love.graphics.setColor(0, 0.4, 0.4)
    local polygon = ship.drawableShip(fighter, 20)
    love.graphics.polygon(
            "fill",
            polygon.v1.x, polygon.v1.y,
            polygon.v2.x, polygon.v2.y,
            polygon.v3.x, polygon.v3.y
    )
end

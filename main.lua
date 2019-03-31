local ship = require('ship')
local vector = require('vector')

local fighter = ship.make(vector.make(40, 40), 0)
local velocity = vector.make(0, 0)

function love.load()
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    if love.keyboard.isDown("left") then
        fighter.rotation = fighter.rotation - 100 * dt
    end
    if love.keyboard.isDown("right") then
        fighter.rotation = fighter.rotation + 100 * dt
    end
    
    if love.keyboard.isDown("up") then
        local direction = vector.rotateUnit(vector.make(1, 0), fighter.rotation)
        local scaled = vector.scale(direction, 500 * dt)
        velocity = vector.add(velocity, scaled)
    end
    
    if love.keyboard.isDown("down") then
        local direction = vector.rotateUnit(vector.make(1, 0), fighter.rotation)
        local scaled = vector.scale(direction, -500 * dt)
        velocity = vector.add(velocity, scaled)
    end
    
    local scaled = vector.scale(velocity, dt)
    fighter.center = vector.add(scaled, fighter.center)
    
end

function love.draw()
    love.graphics.setColor(0, 0.4, 0.4)
    local polygon = ship.drawableShip(fighter, 20)
    love.graphics.polygon(
        "fill",
        polygon.v1.x, polygon.v1.y,
        polygon.v2.x, polygon.v2.y,
        polygon.v3.x, polygon.v3.y
    )
    
end

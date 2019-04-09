--- @param x (number)
--- @param y (number)
local function make(x, y)
    return { x = x, y = y }
end

local function scale(v, n)
    return make(v.x * n, v.y * n)
end

local function length(v)
    return math.sqrt(v.x ^ 2 + v.y ^ 2)
end

local function computePhi(v)
    local sign = v.y < 0 and -1 or 1
    return sign * math.acos(v.x)
end

local function rotateUnit(unitVector, degrees)
    local phi = computePhi(unitVector)
    local newPhi = phi + math.rad(degrees)
    return make(math.cos(newPhi), math.sin(newPhi))
end

local function rotate(v, degrees)
    local l = length(v)
    local downscaled = scale(v, 1 / l)
    local rotated = rotateUnit(downscaled, degrees)
    local upscaled = scale(rotated, l)
    return upscaled
end

local function add(v1, v2)
    return make(v1.x + v2.x, v1.y + v2.y)
end

local function subtract(v1, v2)
    return make(v1.x - v2.x, v1.y - v2.y)
end

return {
    make = make,
    rotate = rotate,
    scale = scale,
    length = length,
    add = add,
    subtract = subtract,
    rotateUnit = rotateUnit,
}

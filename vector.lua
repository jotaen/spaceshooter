local function make(x, y)
    return {x = x, y = y}
end

local function rotate(vector, rotation)
    local cx = 0
    local cy = 0
    local r = math.rad(rotation)
    return make(cx + math.cos(r), cy + math.sin(r))
end

return {
    make = make,
    rotate = rotate,
}

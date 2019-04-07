local function make(type, center, radius)
    return {
        type = type,
        center = center,
        radius = radius,
        -- todo lift up velocity
    }
end

return {
    make = make
}

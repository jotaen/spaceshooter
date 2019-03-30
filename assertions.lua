local lu = require('luaunit')

local function assertVectorEquals(actual, expected)
    local delta = 0.1
    lu.assertAlmostEquals(actual.x, expected.x, delta)
    lu.assertAlmostEquals(actual.y, expected.y, delta)
end

return {
    assertVectorEquals = assertVectorEquals,
}

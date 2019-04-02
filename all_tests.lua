local lu = require('luaunit')

require('src.vector_test')
require('src.ship_test')

os.exit(lu.LuaUnit.run())

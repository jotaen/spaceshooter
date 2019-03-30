local lu = require('luaunit')

require('vector_test')
require('ship_test')

os.exit(lu.LuaUnit.run())

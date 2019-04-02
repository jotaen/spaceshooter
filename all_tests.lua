local lu = require('luaunit')

require('src.vector_test')
require('src.ui.drawableShip_test')

os.exit(lu.LuaUnit.run())

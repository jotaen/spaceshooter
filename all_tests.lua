local lu = require('luaunit')

require('src.vector_test')
require('src.ui.drawableShip_test')
require('src.ship_test')
require('src.circle_test')

os.exit(lu.LuaUnit.run())

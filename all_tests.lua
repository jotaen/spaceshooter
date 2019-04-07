local lu = require('luaunit')

require('src.geometry.vector_test')
require('src.ui.drawableShip_test')
require('src.ship_test')
require('src.geometry.circle_test')
require('src.collisionDetector_test')

os.exit(lu.LuaUnit.run())

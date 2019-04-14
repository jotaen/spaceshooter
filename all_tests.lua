local lu = require('luaunit')

print(os.date())

require('lib.geometry.vector_test')
require('src.ui.drawableShip_test')
require('src.ship_test')
require('src.asteroid_test')
require('lib.geometry.circle_test')
require('src.collisionDetector_test')
require('src.entity_test')
require('src.ui.camera_test')

os.exit(lu.LuaUnit.run())

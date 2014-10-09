require "Cocos2d"
require "Cocos2dConstants"

fileUtils = cc.FileUtils\getInstance!
fileUtils\addSearchPath "src/"
fileUtils\addSearchPath "res/gama"

require "moonlight"

<<<<<<< HEAD
--gama = require "gama"
--gama.setTextureFormat gama.TEXTURE_TYPE_WEBP    -- use webp texture
=======
-- bootstrap views
require "scenes.init"
>>>>>>> 3ff2d496ed3703c863211443f4d5799bae7f2e22

main = ->
  collectgarbage "collect"
  -- avoid memory leak
  collectgarbage "setpause", 100
  collectgarbage "setstepmul", 5000

  fileUtils\addSearchResolutionsOrder "src"
  fileUtils\addSearchResolutionsOrder "res/gama"
  fileUtils\addSearchResolutionsOrder "res"

  display.enterScene "scenes.enter_id_scene"


status, msg = xpcall main, __G__TRACKBACK__
error(msg) unless status



require "Cocos2d"
require "Cocos2dConstants"

fileUtils = cc.FileUtils\getInstance!
fileUtils\addSearchPath "src/"
fileUtils\addSearchPath "res/gama"

require "moonlight"

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



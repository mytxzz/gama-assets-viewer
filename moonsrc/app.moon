require "Cocos2d"
require "Cocos2dConstants"

cc.FileUtils\getInstance!\addSearchPath "src/"
require "moonlight"

main = ->
  collectgarbage "collect"
  -- avoid memory leak
  collectgarbage "setpause", 100
  collectgarbage "setstepmul", 5000

  fileUtils = cc.FileUtils\getInstance!
  fileUtils\addSearchResolutionsOrder "src"
  fileUtils\addSearchResolutionsOrder "res"



status, msg = xpcall main, __G__TRACKBACK__
error(msg) unless status



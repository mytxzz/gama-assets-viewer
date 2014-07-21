require("Cocos2d")
require("Cocos2dConstants")
cc.FileUtils:getInstance():addSearchPath("src/")
require("moonlight")
local main
main = function()
  collectgarbage("collect")
  collectgarbage("setpause", 100)
  collectgarbage("setstepmul", 5000)
  local fileUtils = cc.FileUtils:getInstance()
  fileUtils:addSearchResolutionsOrder("src")
  return fileUtils:addSearchResolutionsOrder("res")
end
local status, msg = xpcall(main, __G__TRACKBACK__)
if not (status) then
  return error(msg)
end

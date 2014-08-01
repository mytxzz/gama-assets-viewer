require("gama")
local view_helper = require("utils/view_helper")
local scene = nil
local create
create = function(sceneDataPack)
  print("[show_scene_scene::create] sceneDataPack:" .. tostring(sceneDataPack))
  scene = cc.Scene:create()
  assert(sceneDataPack, "missing data instance to play on.")
  local sceneData = sceneDataPack[1]
  local gamaTilemap = sceneDataPack[2]
  local xpos = display.cx
  local ypos = display.cy
  local label = cc.LabelTTF:create("touch to move", "Arial", 42)
  label:setPosition(cc.p(display.cx, display.cy))
  label:setColor(display.COLOR_WHITE)
  local sprite = cc.Sprite:create()
  sprite:setPosition(0, 0)
  local layer = view_helper.createTouchMoveLayer(function(touches, event)
    local diff = touches[1]:getDelta()
    local centerX, centerY = gamaTilemap:moveBy(diff.x, diff.y)
    label:setString("x:" .. tostring(math.floor(centerX + 0.5)) .. ", y:" .. tostring(math.floor(centerY + 0.5)) .. ", lbX:" .. tostring(math.floor(gamaTilemap.container:getPositionX())) .. ", lbY:" .. tostring(math.floor(gamaTilemap.container:getPositionY())))
  end)
  gamaTilemap:bindToSprite(sprite)
  layer:addChild(sprite)
  scene:addChild(layer)
  local borderColor = cc.c4f(1, 0, 0, .5)
  local line = cc.DrawNode:create()
  line:drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line:drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, borderColor)
  layer:addChild(line)
  scene:addChild(label)
  return scene
end
return {
  create = create
}

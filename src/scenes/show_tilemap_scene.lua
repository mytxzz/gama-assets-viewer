require("gama")
local view_helper = require("utils/view_helper")
local scene = nil
local create
create = function(gamaTilemap)
  print("[show_animation_scene::create] gamaTilemap:" .. tostring(gamaTilemap))
  scene = cc.Scene:create()
  assert(gamaTilemap, "missing data instance to play on.")
  local xpos = display.cx
  local ypos = display.cy
  local sprite = cc.Sprite:create()
  sprite:setPosition(0, display.width)
  local layer = view_helper.createTouchMoveLayer(function(touches, event)
    local diff = touches[1]:getDelta()
  end)
  gamaTilemap:bindToSprite(sprite)
  layer:addChild(sprite)
  scene:addChild(layer)
  local borderColor = cc.c4f(1, 0, 0, .5)
  local line = cc.DrawNode:create()
  line:drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line:drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, borderColor)
  layer:addChild(line)
  return scene
end
return {
  create = create
}

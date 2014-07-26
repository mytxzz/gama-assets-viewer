require("gama")
local scene = nil
local create
create = function(gamaAnimation)
  print("[show_animation_scene::create] gamaAnimation:" .. tostring(gamaAnimation))
  scene = cc.Scene:create()
  assert(gamaAnimation, "missing animation userdata to play on.")
  local xpos1 = display.width / 4
  local xpos2 = display.width * 3 / 4
  local ypos = display.cy
  local sprite = cc.Sprite:create()
  sprite:setPosition(xpos1, ypos)
  gamaAnimation:playOnSprite(sprite)
  scene:addChild(sprite)
  sprite = cc.Sprite:create()
  sprite:setPosition(xpos2, ypos)
  gamaAnimation:playOnSprite(sprite)
  sprite:setFlippedX(true)
  scene:addChild(sprite)
  local borderColor = cc.c4f(1, 0, 0, .5)
  local line = cc.DrawNode:create()
  line:drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line:drawSegment(cc.p(xpos1, 0), cc.p(xpos1, display.height), 0.5, borderColor)
  line:drawSegment(cc.p(xpos2, 0), cc.p(xpos2, display.height), 0.5, borderColor)
  scene:addChild(line)
  return scene
end
return {
  create = create
}

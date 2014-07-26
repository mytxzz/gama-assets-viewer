require("gama")
local scene = nil
local create
create = function(gamaFigure)
  print("[show_animation_scene::create] gamaFigure:" .. tostring(gamaFigure))
  scene = cc.Scene:create()
  assert(gamaFigure, "missing figure instance to play on.")
  local xpos = display.cx
  local ypos = display.cy
  gamaFigure:setDefaultMotion("idl")
  gamaFigure:setDefaultDirection("s")
  local sprite = cc.Sprite:create()
  sprite:setPosition(xpos, ypos)
  gamaFigure:playOnSprite(sprite)
  scene:addChild(sprite)
  local borderColor = cc.c4f(1, 0, 0, .5)
  local line = cc.DrawNode:create()
  line:drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line:drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, borderColor)
  scene:addChild(line)
  return scene
end
return {
  create = create
}

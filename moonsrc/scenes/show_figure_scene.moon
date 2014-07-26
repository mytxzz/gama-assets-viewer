
require "gama"

scene = nil

create = (gamaFigure) ->

  print "[show_animation_scene::create] gamaFigure:#{gamaFigure}"

  scene = cc.Scene\create()

  assert gamaFigure, "missing figure instance to play on."

  xpos = display.cx
  ypos = display.cy

  gamaFigure\setDefaultMotion "idl"
  gamaFigure\setDefaultDirection "s"

  -- 正方向
  sprite = cc.Sprite\create!
  sprite\setPosition(xpos, ypos)
  gamaFigure\playOnSprite sprite
  scene\addChild sprite

  borderColor = cc.c4f(1,0,0,.5)

  line = cc.DrawNode\create!
  line\drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line\drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, borderColor)
  scene\addChild line

  return scene

return {
  create: create
}


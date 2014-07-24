
require "gama"

scene = nil

create = (gamaAnimation) ->

  print "[show_animation_scene::create] gamaAnimation:#{gamaAnimation}"

  scene = cc.Scene\create()

  assert gamaAnimation, "missing animation userdata to play on."


  xpos = display.cx
  ypos = display.cy

  sprite = cc.Sprite\create!
  --sprite = gamaAnimation\createSprite!
  sprite\setPosition(xpos, ypos)
  gamaAnimation\playOnSprite sprite

  scene\addChild sprite

  borderColor = cc.c4f(1,0,0,1)

  line = cc.DrawNode\create!
  line\drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line\drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, borderColor)
  scene\addChild line

  return scene


return {
  create: create
}


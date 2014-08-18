
require "gama"

scene = nil

create = (gamaIconPack) ->

  print "[show_iconpack_scene::create] gamaIconPack:#{gamaIconPack}"

  scene = cc.Scene\create()

  assert gamaIconPack, "missing icon pack to play on."

  xpos1 = display.width / 4
  xpos2 = display.width * 3 / 4
  ypos = display.cy

  -- 正方向
  sprite = with cc.Sprite\create!
    \setPosition(xpos1, ypos)
    \setAnchorPoint 0, 0
  gamaIconPack\drawOnSprite sprite, "1"
  scene\addChild sprite

  -- x镜像方向
  sprite = cc.Sprite\create!
  sprite\setPosition(xpos2, ypos)
  gamaIconPack\drawOnSprite sprite, "1"
  scene\addChild sprite


  borderColor = cc.c4f(1,0,0,.5)

  line = cc.DrawNode\create!
  line\drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line\drawSegment(cc.p(xpos1, 0), cc.p(xpos1, display.height), 0.5, borderColor)
  line\drawSegment(cc.p(xpos2, 0), cc.p(xpos2, display.height), 0.5, borderColor)
  scene\addChild line

  return scene


return {
  create: create
}



require "gama"

view_helper = require "utils/view_helper"

scene = nil

create = (gamaTilemap) ->

  print "[show_animation_scene::create] gamaTilemap:#{gamaTilemap}"
  scene = cc.Scene\create()

  assert gamaTilemap, "missing data instance to play on."

  xpos = display.cx
  ypos = display.cy

  label = cc.LabelTTF\create "touch to move", "Arial", 42
  label\setPosition(cc.p(display.cx, display.cy))
  label\setColor(display.COLOR_WHITE)

  sprite = cc.Sprite\create!
  sprite\setPosition(display.cx, display.cy)

  layer = view_helper.createTouchMoveLayer (touches, event )->

    diff = touches[1]\getDelta!
    centerX, centerY = gamaTilemap\moveBy diff.x, diff.y

    label\setString "x:#{math.floor(centerX + 0.5)}, y:#{math.floor(centerY + 0.5)}, lbX:#{math.floor gamaTilemap.container\getPositionX!}, lbY:#{math.floor gamaTilemap.container\getPositionY!}"

    return

  gamaTilemap\bindToSprite sprite

  layer\addChild sprite
  scene\addChild layer

  borderColor = cc.c4f(1,0,0,.5)

  line = cc.DrawNode\create!
  line\drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line\drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, borderColor)
  layer\addChild line

  scene\addChild label

  return scene

return {
  create: create
}


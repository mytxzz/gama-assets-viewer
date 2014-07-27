
require "gama"

view_helper = require "utils/view_helper"

scene = nil

create = (gamaTilemap) ->

  print "[show_animation_scene::create] gamaTilemap:#{gamaTilemap}"

  scene = cc.Scene\create()

  assert gamaTilemap, "missing data instance to play on."

  xpos = display.cx
  ypos = display.cy

  -- 正方向
  sprite = cc.Sprite\create!
  sprite\setPosition(xpos, ypos)

  layer = view_helper.createTouchMoveLayer (touches, event )->

    diff = touches[1]\getDelta!
    --accumenDeltaX += diff.x

    return

    --return unless math.abs(accumenDeltaX) > 10

    --if accumenDeltaX < 0
      --character\setDirection(DIRECTION_TO_NEXT_CLOCKWISE[character\getCurDirection!])
    --else
      --character\setDirection(DIRECTION_TO_NEXT_ANTICLOCKWISE[character\getCurDirection!])

    --accumenDeltaX = 0
    --return

  gamaTilemap\bindToSprite sprite

  layer\addChild sprite
  scene\addChild layer

  borderColor = cc.c4f(1,0,0,.5)

  line = cc.DrawNode\create!
  line\drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line\drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, borderColor)
  layer\addChild line

  return scene

return {
  create: create
}


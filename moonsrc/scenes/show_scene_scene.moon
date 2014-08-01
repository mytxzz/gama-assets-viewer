
require "gama"

view_helper = require "utils/view_helper"

scene = nil

create = (sceneDataPack) ->

  print "[show_scene_scene::create] sceneDataPack:#{sceneDataPack}"

  scene = cc.Scene\create()

  assert sceneDataPack, "missing data instance to play on."


  sceneData = sceneDataPack[1]
  gamaTilemap = sceneDataPack[2]

  xpos = display.cx
  ypos = display.cy

  label = cc.LabelTTF\create "touch to move", "Arial", 42
  label\setPosition(cc.p(display.cx, display.cy))
  label\setColor(display.COLOR_WHITE)

  tilemapSprite = cc.Sprite\create!
  tilemapSprite\setPosition(0, 0)

  tilemapLayer = view_helper.createTouchMoveLayer (touches, event )->

    diff = touches[1]\getDelta!
    centerX, centerY = gamaTilemap\moveBy diff.x, diff.y

    label\setString "x:#{math.floor(centerX + 0.5)}, y:#{math.floor(centerY + 0.5)}, lbX:#{math.floor gamaTilemap.container\getPositionX!}, lbY:#{math.floor gamaTilemap.container\getPositionY!}"

    return

  gamaTilemap\bindToSprite tilemapSprite

  tilemapLayer\addChild tilemapSprite
  scene\addChild tilemapLayer

  -- 加入场景装饰物
  if type(sceneData.ornaments) == "table"
    for ornament in *sceneData.ornaments
      console.log "[show_scene_scene::add scene ornaments] #{ornament.x}, #{ornament.y}, #{ornament.m}"
      animation = sceneDataPack[ornament.id]
      if animation
        gamaTilemap\addOrnament animation, ornament.x, ornament.y, ornament.m
      else
        console.log "[show_scene_scene::add scene ornaments] missing gama instance for key:#{ornament.id}"

  borderColor = cc.c4f(1,0,0,.5)
  line = cc.DrawNode\create!
  line\drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line\drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, borderColor)
  scene\addChild line

  scene\addChild label

  return scene

return {
  create: create
}


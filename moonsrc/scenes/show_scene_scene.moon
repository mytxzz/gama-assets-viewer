
require "gama"
bit = require "bit"

console.dir bit


view_helper = require "utils/view_helper"

scene = nil

COLOR_RED = cc.c4f(1,0,0,.5)
COLOR_GREEN = cc.c4f(0,1,0,.5)
COLOR_BLUE = cc.c4f(0,0,1,.5)

fromhex = (str)-> return str\gsub('..', ((cc)-> return string.char(tonumber(cc, 16))))

drawRect = (drawNode, x, y, w, h, color)->
  points = {}
  table.insert(points, cc.p(x,y))
  table.insert(points, cc.p(x + w, y))
  table.insert(points, cc.p(x + w, y - h))
  table.insert(points, cc.p(x,y - h))
  drawNode\drawPolygon(points, 4, color, 0, color)

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

  -- 场景底图组
  tilemapSprite = cc.Sprite\create!
  tilemapSprite\setPosition(0, 0)

  tilemapLayer = view_helper.createTouchMoveLayer (touches, event )->

    diff = touches[1]\getDelta!
    centerX, centerY = gamaTilemap\moveBy diff.x, diff.y

    label\setString "x:#{math.floor(centerX + 0.5)}, y:#{math.floor(centerY + 0.5)}, lbX:#{math.floor gamaTilemap.container\getPositionX!}, lbY:#{math.floor gamaTilemap.container\getPositionY!}"

    return

  gamaTilemap\bindToSprite tilemapSprite

  -- 加入辅助线
  maskNode = cc.DrawNode\create!
  --maskNode\setAnchorPoint 0, 1

  tilemapLayer\addChild tilemapSprite
  gamaTilemap.container\addChild maskNode
  scene\addChild tilemapLayer

  --rectLeft, rectTop = gamaTilemap\uiCordToVertexCord(0, 0)
  --drawRect(maskNode, rectLeft, rectTop, 300, 300, COLOR_RED)


  for pixelY = 0, gamaTilemap.pixelHeight - 1, 16
    for pixelX = 0, gamaTilemap.pixelWidth - 1, 32
      rectLeft, rectTop = gamaTilemap\uiCordToVertexCord(pixelX, -pixelY)
      brickX = math.floor(pixelX / sceneData.brickUnitWidth)
      brickY = math.floor(pixelY / sceneData.brickUnitHeight)
      drawRect(maskNode, rectLeft, rectTop, 32, 16, COLOR_RED) unless sceneData\isWalkableAt(brickX, brickY)
      drawRect(maskNode, rectLeft, rectTop, 32, 16, COLOR_BLUE) if sceneData\isMaskedAt(brickX, brickY)


  -- 加入场景装饰物
  if type(sceneData.ornaments) == "table"
    for ornament in *sceneData.ornaments
      --console.log "[show_scene_scene::add scene ornaments] #{ornament.x}, #{ornament.y}, #{ornament.m}"
      animation = sceneDataPack[ornament.id]
      if animation
        gamaTilemap\addOrnament animation, ornament.x, ornament.y, ornament.m
      else
        console.log "[show_scene_scene::add scene ornaments] missing gama instance for key:#{ornament.id}"


  -- 加入辅助线
  line = cc.DrawNode\create!
  line\drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, COLOR_RED)
  line\drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, COLOR_RED)
  scene\addChild line

  scene\addChild label

  return scene

return {
  create: create
}


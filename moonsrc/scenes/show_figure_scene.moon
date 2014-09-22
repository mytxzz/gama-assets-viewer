
Character = require "models.character"
view_helper = require "utils/view_helper"
json_data_layer_modal = require "scenes.shared.json_data_layer_modal"

scene = nil

DIRECTION_TO_NEXT_CLOCKWISE =
  n: "ne"
  ne: "e"
  e: "se"
  se: "s"
  s: "sw"
  sw: "w"
  w: "nw"
  nw: "n"


DIRECTION_TO_NEXT_ANTICLOCKWISE =
  n: "nw"
  nw: "w"
  w: "sw"
  sw: "s"
  s: "se"
  se: "e"
  e: "ne"
  ne: "n"

create = (gamaFigure,csx) ->

  console.dir csx
  print("-------------------show_figure_scene.moon----------")

  print "[show_animation_scene::create] gamaFigure:#{gamaFigure}"

  scene = cc.Scene\create()

  assert gamaFigure, "missing figure instance to play on."

  xpos = display.cx
  ypos = display.height / 3

  -- 正方向
  sprite = cc.Sprite\create!
  sprite\setPosition(xpos, ypos)
  --gamaFigure\playOnSprite sprite
  character = with Character(gamaFigure\getId!, gamaFigure)
    \bindToDisplay(sprite)
    \setLocation(display.cx, display.cy)

  sprite\setOpacity 0
  sprite\runAction(cc.FadeIn\create(3))

  --character\addContinouseMotionId "ded", "run"
  print "[show_figure_scene] character:#{character}"

  accumenDeltaX = 0

  layer = view_helper.createTouchMoveLayer (touches, event )->
    diff = touches[1]\getDelta!
    accumenDeltaX += diff.x

    return unless math.abs(accumenDeltaX) > 10

    if accumenDeltaX < 0
      character\rotate(math.pi / 8)
    else
      character\rotate(-math.pi / 8)

    accumenDeltaX = 0
    return

  layer\addChild sprite
  scene\addChild layer

  borderColor = cc.c4f(1,0,0,.5)

  line = cc.DrawNode\create!
  line\drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line\drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, borderColor)
  layer\addChild line

  motions = gamaFigure\getMotions!

 -- add menu items for tests
  LINE_SPACE = 60
  s = cc.Director\getInstance()\getWinSize()
  MainMenu = cc.Menu\create!
  for index, motion in ipairs motions
    testLabel = cc.Label\createWithSystemFont(motion, 'Arial', 42)
    testLabel\setAnchorPoint(cc.p(0.5, 0.5))
    testMenuItem = cc.MenuItemLabel\create testLabel
    testMenuItem\registerScriptTapHandler ->
      --gamaFigure\playOnSprite sprite, motion
      character\setMotion motion
      return
    testMenuItem\setPosition(cc.p(100 / 2, (s.height - (index) * LINE_SPACE)))
    MainMenu\addChild(testMenuItem, index + 10000, index + 10000)

  MainMenu\setContentSize(cc.size(100, (#motions + 1) * (LINE_SPACE)))
  MainMenu\setPosition(0, 0)
  scene\addChild(MainMenu)


  --弹出json信息的按钮
  infoBtnFunc = (btn,event)->
    scene\addChild(json_data_layer_modal.create(csx),103) if event == ccui.TouchEventType.ended
    return
  infoBtn = ccui.Button\create "btn_info.png"
  infoBtn\setPosition(display.width - 50 , display.height - 50)
  infoBtn\addTouchEventListener(infoBtnFunc)
  scene\addChild(infoBtn,102)

  return scene

return {
  create: create
}



require "gama"

scene = nil

create = (gamaFigure) ->

  print "[show_animation_scene::create] gamaFigure:#{gamaFigure}"

  scene = cc.Scene\create()

  assert gamaFigure, "missing figure instance to play on."



  xpos = display.cx
  ypos = display.height / 3

  --gamaFigure\setDefaultMotion "idl"
  --gamaFigure\setDefaultDirection "s"

  -- 正方向
  sprite = cc.Sprite\create!
  sprite\setPosition(xpos, ypos)
  --gamaFigure\playOnSprite sprite
  character = gama.createCharacterWithSprite(gamaFigure\getId!, gamaFigure, sprite)
  print "[show_figure_scene] character:#{character}"

  scene\addChild sprite

  borderColor = cc.c4f(1,0,0,.5)

  line = cc.DrawNode\create!
  line\drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line\drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, borderColor)
  scene\addChild line

  motions = gamaFigure\getMotions!

  -- add menu items for tests
  LINE_SPACE = 40
  s = cc.Director\getInstance()\getWinSize()
  MainMenu = cc.Menu\create!
  for index, motion in ipairs motions
    testLabel = cc.Label\create(motion, 'Arial', 24)
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

  return scene

return {
  create: create
}


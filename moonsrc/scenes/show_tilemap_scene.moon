
view_helper = require "utils/view_helper"

json_data_layer_modal = require "scenes.shared.json_data_layer_modal"
scene = nil

create = (gamaTilemap,csx) ->


  console.dir csx
  print("-------------------show_tilemap_scene.moon----------")

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


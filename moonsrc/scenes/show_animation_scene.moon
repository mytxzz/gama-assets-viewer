json_data_layer_modal = require "scenes.shared.json_data_layer_modal"

scene = nil

create = (gamaAnimation,csx) ->


  console.dir csx
  print("-------------------show_animation_scene.moon----------")

  print "[show_animation_scene::create] gamaAnimation:#{gamaAnimation}"

  scene = cc.Scene\create()

  assert gamaAnimation, "missing animation userdata to play on."

  xpos1 = display.width / 4
  xpos2 = display.width * 3 / 4
  ypos = display.cy

  -- 正方向
  sprite = cc.Sprite\create!
  sprite\setPosition(xpos1, ypos)
  gamaAnimation\playOnSprite sprite
  scene\addChild sprite

  -- x镜像方向
  sprite = cc.Sprite\create!
  sprite\setPosition(xpos2, ypos)
  gamaAnimation\playOnSprite sprite
  sprite\setFlippedX(true)
  scene\addChild sprite


  borderColor = cc.c4f(1,0,0,.5)

  line = cc.DrawNode\create!
  line\drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line\drawSegment(cc.p(xpos1, 0), cc.p(xpos1, display.height), 0.5, borderColor)
  line\drawSegment(cc.p(xpos2, 0), cc.p(xpos2, display.height), 0.5, borderColor)
  scene\addChild line

  --弹出json信息的按钮
  infoBtnFunc = (btn,event)->
    scene\addChild(json_data_layer_modal.create(csx),103) if event == ccui.TouchEventType.ended
    return
  infoBtn = ccui.Button\create "btn_info.png"
  infoBtn\setPosition(display.width - 50 , display.height - 50)
  infoBtn\addTouchEventListener(infoBtnFunc)
  scene\addChild(infoBtn,102)

  --返回输入素材框主页的按钮
  backBtnFunc = (btn,event)->
    scene\addChild(json_data_layer_modal.create(csx),103) if event == ccui.TouchEventType.ended
    return
  infoBtn = ccui.Button\create "btn_info.png"
  infoBtn\setPosition(display.width - 50 , display.height - 50)
  infoBtn\addTouchEventListener(backBtnFunc)
  scene\addChild(infoBtn,102)


  return scene


return {
  create: create
}


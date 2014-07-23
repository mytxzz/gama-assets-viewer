-- 输入素材ID 的界面

require "gama"

scene = nil

create = (self) ->

  scene = cc.Scene\create()

  -- add label
  label = cc.LabelTTF\create "Enter Gama Asset Id:", "Arial", 42
  label\setPosition(cc.p(display.cx, display.cy + 250))
  label\setColor(display.COLOR_WHITE)
  scene\addChild label

  --bgImg = display.newScale9Sprite("EditBoxBg.png")

  inputId = cc.EditBox\create(cc.size(400, 96), display.newScale9Sprite("EditBoxBg.png"))
  inputId\setPosition(cc.p(display.cx, display.cy + 100))
  scene\addChild inputId

  btnView = ccui.Button\create!
  btnView\loadTextures "btn_view_normal.png", "btn_view_push.png", "btn_view_push.png"
  btnView\setPosition(cc.p(display.cx, display.cy - 50))
  btnView\setTouchEnabled true
  btnView\addTouchEventListener (widget, eventType)->
    return unless eventType == ccui.TouchEventType.ended
    id = inputId\getText!
    console.info "[enter_id_scene::click] id:#{id}"

    assetType = gama.getTypeById id
    console.info "[enter_id_scene] assetType:#{assetType}"


  scene\addChild btnView

  return scene

return {
  create: create
}



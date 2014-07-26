-- 输入素材ID 的界面

require "gama"

scene = nil

create = ->

  scene = cc.Scene\create()

  -- add label
  label = cc.LabelTTF\create "Enter Gama Asset Id:", "Arial", 42
  label\setPosition(cc.p(display.cx, display.cy + 250))
  label\setColor(display.COLOR_WHITE)
  scene\addChild label

  --bgImg = display.newScale9Sprite("EditBoxBg.png")

  inputId = cc.EditBox\create(cc.size(400, 96), display.newScale9Sprite("EditBoxBg.png"))
  inputId\setPosition(cc.p(display.cx, display.cy + 100))
  --inputId\setText "E4OsP1W" -- animation
  inputId\setText "8Lowbeq" -- figure
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

    switch assetType

      when "animations"

        gama.animation.getById id, (err, gamaAnimation)->
          return console.error "ERROR [enter_id_scene::getAnimation] fail to get animation:#{id}. error:#{err}" if err
          console.info "[enter_id_scene::getAnimation] got animation for id:#{id}"
          display.enterScene "scenes.show_animation_scene", {gamaAnimation}
          return
        return

      when "figures"

        gama.figure.getById id, (err, gamaFigure)->
          return console.error "ERROR [enter_id_scene::getFigure] fail to get figure:#{id}. error:#{err}" if err
          return
        return

      else
        console.error "ERROR [enter_id_scene::onTap] invalid csx json asset: id:#{id}, assetType:#{assetType}"

  scene\addChild btnView

  return scene

return {
  create: create
}



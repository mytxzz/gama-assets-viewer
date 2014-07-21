-- 输入素材ID 的界面

scene = nil

create = (self) ->

  scene = cc.Scene\create()

  -- add label
  label = cc.LabelTTF\create "Enter Gama Asset Id:", "Arial", 42
  label\setPosition(cc.p(display.cx, display.cy + 250))
  label\setColor(display.COLOR_WHITE)
  scene\addChild label

  bgImg = display.newScale9Sprite("EditBoxBg.png")
  inputId = cc.EditBox\create(40, bgImg)
  inputId\setSize(cc.size(400, 96))
  inputId\setPosition(cc.p(display.cx, display.cy + 100))
  scene\addChild inputId

  return scene

  -- add edit box
  --inputId = cc.EditBox\create(params.size, imageNormal, imagePressed, imageDisabled)

  --inputId = ui.newEditBox
    --image: "EditBoxBg.png"
    --size:  CCSize(400, 96)
    --x: display.cx
    --y: display.cy + 100

  --inputId\addTo(self)

  ---- add view button
  --btnView = ui.newImageMenuItem
    --image: "btn_view_normal.png"
    --imageSelected: "btn_view_push.png"
    --x: display.cx
    --y: display.cy - 50
    --listener: ->
      --id = inputId\getText!

      --printf "[enter_id_scene::click] id:#{id}"

      --gama.animation.loadById id, (err, result)->
        --if err
          --printf "[enter_id_scene::btn::listener] err:#{err}"
          --return

        --app\enterScene("show_animation_scene", result)

        --return
      --return

  --self\addChild ui.newMenu {btnView}

  --return

return {
  create: create
}



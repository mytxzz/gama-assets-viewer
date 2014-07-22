-- 输入素材ID 的界面

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

  --btnView = cc.MenuItemSprite\create(display.newSprite("btn_view_normal.png"), display.newSprite("btn_view_push.png"))
  btnView = ccui.Button\create!
  btnView\loadTextures "btn_view_normal.png", "btn_view_push.png", "btn_view_push.png"
  btnView\setPosition(cc.p(display.cx, display.cy - 50))
  scene\addChild btnView

  console.info "[enter_id_scene::method] cc.HTTPRequest: #{cc.HTTPRequest}"
  console.info "[enter_id_scene::method] cc.HttpRequest: #{cc.HttpRequest}"
  console.info "[enter_id_scene::method] cc.HttpClient: #{cc.HttpClient}"





  --btnView\addNodeEventListener cc.MENU_ITEM_CLICKED_EVENT, (tag)->
    --id = inputId\getText!

    --console.info "[enter_id_scene::click] id:#{id}"

    --gama.animation.loadById id, (err, result)->
      --if err
        --printf "[enter_id_scene::btn::listener] err:#{err}"
        --return

      --app\enterScene("show_animation_scene", result)


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



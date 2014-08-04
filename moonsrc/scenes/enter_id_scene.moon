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
  --inputId\setText "8DP12iG" -- animation
  inputId\setText "8Lowbeq" -- figure
  --inputId\setText "3hLQqBp" -- tilemap
  --inputId\setText "EH8H2qZ" -- scene
  scene\addChild inputId

  btnView = ccui.Button\create!
  btnView\loadTextures "btn_view_normal.png", "btn_view_push.png", "btn_view_push.png"
  btnView\setPosition(cc.p(display.cx, display.cy - 50))
  btnView\setTouchEnabled true
  btnView\addTouchEventListener (widget, eventType)->
    return unless eventType == ccui.TouchEventType.ended
    id = inputId\getText!
    console.info "[enter_id_scene::click] id:#{id}"

    gama.readJSONAsync id, (err, csx)->
      return console.error "[enter_id_scene] readJSONAsync failed. error:#{err}" if err

      --console.info "[enter_id_scene] csx:#{csx}"
      --console.dir csx

      switch csx.type

        when "animations"

          gama.animation.getByCSX csx, (err, gamaAnimation)->
            return console.error "ERROR [enter_id_scene::getAnimation] fail to get animation:#{id}. error:#{err}" if err
            console.info "[enter_id_scene::getAnimation] got animation for id:#{id}"
            display.enterScene "scenes.show_animation_scene", {gamaAnimation}
            return
          return

        when "figures"

          gama.figure.getByCSX csx, (err, gamaFigure)->
            return console.error "ERROR [enter_id_scene::getFigure] fail to get figure:#{id}. error:#{err}" if err
            console.info "[enter_id_scene::getFigure] got figure for id:#{id}"
            display.enterScene "scenes.show_figure_scene", {gamaFigure}
            return
          return

        when "tilemaps"

          gama.tilemap.getByCSX csx, (err, gamaTilemap)->
            return console.error "ERROR [enter_id_scene::getTilemap] fail to get tilemap:#{id}. error:#{err}" if err
            console.info "[enter_id_scene::getTilemap] got tilemap for id:#{id}"
            display.enterScene "scenes.show_tilemap_scene", {gamaTilemap}
            return
          return

        when "scenes"
          gama.scene.loadByCSX csx, (err, sceneDataPack)->
            console.info "[enter_id_scene::loadByCSX]"
            console.dir err
            console.dir sceneDataPack

            return console.error "ERROR [enter_id_scene::loadScene] fail to load scene:#{id}. error:#{err}" if err
            console.info "[enter_id_scene::loadScene] load scene for id:#{id}"
            display.enterScene "scenes.show_scene_scene", {sceneDataPack}

        else
          console.error "ERROR [enter_id_scene::onTap] invalid csx json asset: id:#{id}, assetType:#{assetType}"



  scene\addChild btnView


  --makeRect = (w, h, color)->
    --node = cc.DrawNode\create!
    --node\drawSegment(cc.p(0, h), cc.p(w, h), 0.5, color)
    --node\drawSegment(cc.p(w, 0), cc.p(w, h), 0.5, color)
    --node\drawSegment(cc.p(0, 0), cc.p(0, h), 0.5, color)
    --node\drawSegment(cc.p(0, 0), cc.p(w, 0), 0.5, color)
    --return node


  --spRed = makeRect(200, 200, cc.c4f(1,0,0,.5))
  --spGreen = makeRect(200, 200, cc.c4f(0,1,0,.5))
  --spBlue = makeRect(200, 200, cc.c4f(0,0,1,.5))

  --spRed\setAnchorPoint(0, 1)
  --spGreen\setAnchorPoint(1, 1)
  --spBlue\setAnchorPoint(1, 1)

  --scene\addChild spRed
  --spRed\addChild spGreen

  --spRed\setPosition 100, 100
  --spGreen\setPosition 200, 100
  --spBlue\setPosition 100, 100



  return scene

return {
  create: create
}



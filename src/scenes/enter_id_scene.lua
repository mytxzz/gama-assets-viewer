local gama = require("gama")
local scene = nil
local create
create = function()
  scene = cc.Scene:create()
  local label = cc.LabelTTF:create("Enter Gama Asset Id:", "Arial", 42)
  label:setPosition(cc.p(display.cx, display.cy + 250))
  label:setColor(display.COLOR_WHITE)
  scene:addChild(label)
  local inputId = cc.EditBox:create(cc.size(400, 96), display.newScale9Sprite("EditBoxBg.png"))
  inputId:setPosition(cc.p(display.cx, display.cy + 100))
  inputId:setText("8DP12iG")
  inputId:setText("6qU6lS4")
  scene:addChild(inputId)
  local btnView = ccui.Button:create()
  btnView:loadTextures("btn_view_normal.png", "btn_view_push.png", "btn_view_push.png")
  btnView:setPosition(cc.p(display.cx, display.cy - 50))
  btnView:setTouchEnabled(true)
  btnView:addTouchEventListener(function(widget, eventType)
    if not (eventType == ccui.TouchEventType.ended) then
      return 
    end
    local id = inputId:getText()
    console.info("[enter_id_scene::click] id:" .. tostring(id))
    return gama.readJSONAsync(id, function(err, csx)
      if err then
        return console.error("[enter_id_scene] readJSONAsync failed. error:" .. tostring(err))
      end
      console.info("[enter_id_scene] csx:" .. tostring(csx))
      console.dir(csx)
      print("-------------------enter_id_scene.moon----------")
      local _exp_0 = csx.type
      if "animations" == _exp_0 then
        gama.animation.getByCSX(csx, function(err, gamaAnimation)
          if err then
            return console.error("ERROR [enter_id_scene::getAnimation] fail to get animation:" .. tostring(id) .. ". error:" .. tostring(err))
          end
          console.info("[enter_id_scene::getAnimation] got animation for id:" .. tostring(id))
          display.enterScene("scenes.show_animation_scene", {
            gamaAnimation,
            csx
          })
        end)
        return 
      elseif "figures" == _exp_0 then
        gama.figure.getByCSX(csx, function(err, gamaFigure)
          if err then
            return console.error("ERROR [enter_id_scene::getFigure] fail to get figure:" .. tostring(id) .. ". error:" .. tostring(err))
          end
          console.info("[enter_id_scene::getFigure] got figure for id:" .. tostring(id))
          display.enterScene("scenes.show_figure_scene", {
            gamaFigure,
            csx
          })
        end)
        return 
      elseif "tilemaps" == _exp_0 then
        gama.tilemap.getByCSX(csx, function(err, gamaTilemap)
          if err then
            return console.error("ERROR [enter_id_scene::getTilemap] fail to get tilemap:" .. tostring(id) .. ". error:" .. tostring(err))
          end
          console.info("[enter_id_scene::getTilemap] got tilemap for id:" .. tostring(id))
          display.enterScene("scenes.show_tilemap_scene", {
            gamaTilemap,
            csx
          })
        end)
        return 
      elseif "scenes" == _exp_0 then
        return gama.scene.getByCSX(csx, function(err, sceneDataPack)
          console.info("[enter_id_scene::loadByCSX]")
          if err then
            return console.error("ERROR [enter_id_scene::loadScene] fail to load scene:" .. tostring(id) .. ". error:" .. tostring(err))
          end
          console.info("[enter_id_scene::loadScene] load scene for id:" .. tostring(id))
          return display.enterScene("scenes.show_scene_scene", {
            sceneDataPack,
            csx
          })
        end)
      elseif "iconpacks" == _exp_0 then
        return gama.iconpack.getByCSX(csx, function(err, gamaIconPack)
          console.info("[enter_id_scene::iconpack::loadByCSX] error:" .. tostring(err) .. ", gamaIconPack:")
          console.dir(gamaIconPack)
          if err then
            return console.error("ERROR [enter_id_scene::loadScene] fail to load iconpack:" .. tostring(id) .. ". error:" .. tostring(err))
          end
          return display.enterScene("scenes.show_iconpack_scene", {
            gamaIconPack,
            csx
          })
        end)
      else
        return console.error("ERROR [enter_id_scene::onTap] invalid csx json asset: id:" .. tostring(id) .. ", assetType:" .. tostring(csx.type))
      end
    end)
  end)
  scene:addChild(btnView)
  return scene
end
return {
  create = create
}

require("gama")
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
  inputId:setText("8Lowbeq")
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
    local assetType = gama.getTypeById(id)
    console.info("[enter_id_scene] assetType:" .. tostring(assetType))
    local _exp_0 = assetType
    if "animations" == _exp_0 then
      gama.animation.getById(id, function(err, gamaAnimation)
        if err then
          return console.error("ERROR [enter_id_scene::getAnimation] fail to get animation:" .. tostring(id) .. ". error:" .. tostring(err))
        end
        console.info("[enter_id_scene::getAnimation] got animation for id:" .. tostring(id))
        display.enterScene("scenes.show_animation_scene", {
          gamaAnimation
        })
      end)
      return 
    elseif "figures" == _exp_0 then
      gama.figure.getById(id, function(err, gamaFigure)
        if err then
          return console.error("ERROR [enter_id_scene::getFigure] fail to get figure:" .. tostring(id) .. ". error:" .. tostring(err))
        end
        console.info("[enter_id_scene::getFigure] got figure for id:" .. tostring(id))
        display.enterScene("scenes.show_figure_scene", {
          gamaFigure
        })
      end)
      return 
    else
      return console.error("ERROR [enter_id_scene::onTap] invalid csx json asset: id:" .. tostring(id) .. ", assetType:" .. tostring(assetType))
    end
  end)
  scene:addChild(btnView)
  return scene
end
return {
  create = create
}

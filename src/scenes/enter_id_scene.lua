local scene = nil
local create
create = function(self)
  scene = cc.Scene:create()
  local label = cc.LabelTTF:create("Enter Gama Asset Id:", "Arial", 42)
  label:setPosition(cc.p(display.cx, display.cy + 250))
  label:setColor(display.COLOR_WHITE)
  scene:addChild(label)
  local inputId = cc.EditBox:create(cc.size(400, 96), display.newScale9Sprite("EditBoxBg.png"))
  inputId:setPosition(cc.p(display.cx, display.cy + 100))
  scene:addChild(inputId)
  local btnView = ccui.Button:create()
  btnView:loadTextures("btn_view_normal.png", "btn_view_push.png", "btn_view_push.png")
  btnView:setPosition(cc.p(display.cx, display.cy - 50))
  scene:addChild(btnView)
  console.info("[enter_id_scene::method] cc.HTTPRequest: " .. tostring(cc.HTTPRequest))
  console.info("[enter_id_scene::method] cc.HttpRequest: " .. tostring(cc.HttpRequest))
  console.info("[enter_id_scene::method] cc.HttpClient: " .. tostring(cc.HttpClient))
  return scene
end
return {
  create = create
}

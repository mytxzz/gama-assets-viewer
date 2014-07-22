local scene = nil
local create
create = function(self)
  scene = cc.Scene:create()
  local label = cc.LabelTTF:create("Enter Gama Asset Id:", "Arial", 42)
  label:setPosition(cc.p(display.cx, display.cy + 250))
  label:setColor(display.COLOR_WHITE)
  scene:addChild(label)
  local inputId = cc.EditBox:create(cc.size(400, 96), display.newScale9Sprite("EditBoxBg.png"), display.newScale9Sprite("EditBoxBg.png"), display.newScale9Sprite("EditBoxBg.png"))
  inputId:setPosition(cc.p(display.cx, display.cy + 100))
  scene:addChild(inputId)
  return scene
end
return {
  create = create
}

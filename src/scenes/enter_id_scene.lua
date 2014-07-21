local scene = nil
local create
create = function(self)
  scene = cc.Scene:create()
  local label = cc.LabelTTF:create("Enter Gama Asset Id:", "Arial", 42)
  label:setPosition(cc.p(display.cx, display.cy + 250))
  label:setColor(cc.c3b(255, 255, 255))
  scene:addChild(label)
  return scene
end
return {
  create = create
}

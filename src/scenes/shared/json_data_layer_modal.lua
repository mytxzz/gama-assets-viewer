local inspect = require("inspect")
local create
create = function(csx)
  local container = ccui.Layout:create()
  container:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
  container:setTouchEnabled(true)
  container:setBackGroundColor(cc.c3b(0, 0, 0))
  container:setBackGroundColorOpacity(208)
  container:setContentSize(display.width, display.height)
  local scrollView = ccui.ScrollView:create()
  scrollView:setTouchEnabled(true)
  scrollView:setContentSize(cc.size(display.width - 40, display.height - 40))
  scrollView:setPosition(cc.p(20, 20))
  local csx1 = { }
  csx1.pixelHeight = 1536
  csx1.pixelWidth = 2048
  csx1.scene_type = "wild"
  csx1.type = "scenes"
  csx1.width_in_brick = 64
  print("-----json_data_layer-------------------")
  print(inspect(csx))
  local label1 = cc.Label:create()
  label1:setDimensions(display.width - 40, 3500)
  label1:setString(inspect(csx))
  print("[json_data_layer_modal.moon:54] label1:" .. tostring(label1))
  label1:setTextColor(cc.c4b(0, 255, 0, 255))
  label1:setPosition(cc.p(0, 3500))
  label1:setAnchorPoint(cc.p(0, 1))
  scrollView:setInnerContainerSize(cc.size(display.width - 40, 3500))
  scrollView:addChild(label1)
  container:addChild(scrollView)
  local closeBtnFunc
  closeBtnFunc = function(btn, event)
    if event == ccui.TouchEventType.ended then
      container:removeFromParent(true)
    end
  end
  local node = ccui.Button:create("btn_close.png")
  node:setPosition(display.width - 50, display.height - 50)
  node:setTouchEnabled(true)
  node:addTouchEventListener(closeBtnFunc)
  container:addChild(node, 20)
  return container
end
return {
  create = create
}

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
  print("-----------" .. tostring(display.height - 40) .. "------------")
  scrollView:setContentSize(cc.size(display.width - 40, display.height - 40))
  scrollView:setPosition(cc.p(20, 20))
  local csxContent = inspect(csx)
  console.log("csxContent len: " .. tostring(#csxContent))
  local csxCut = tostring(csxContent:sub(0, 3000)) .. "\n......"
  console.info("csxCut len: " .. tostring(#csxCut))
  local label1 = cc.Label:create()
  label1:setScale(1.5)
  label1:setDimensions(display.width / 4 * 3 - 40, 1500)
  label1:setString(csxCut)
  print("[json_data_layer_modal.moon:54] label1:" .. tostring(label1))
  label1:setColor(cc.c3b(0, 255, 255))
  label1:setPosition(cc.p(0, 1500))
  label1:setAnchorPoint(cc.p(0, 1))
  scrollView:setInnerContainerSize(cc.size(display.width / 2 - 40, 1500))
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

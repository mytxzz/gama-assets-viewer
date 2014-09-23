local json_data_layer_modal = require("scenes.shared.json_data_layer_modal")
local scene = nil
local drawRect
drawRect = function(drawNode, x, y, w, h, color)
  local points = { }
  table.insert(points, cc.p(x, y))
  table.insert(points, cc.p(x + w, y))
  table.insert(points, cc.p(x + w, y - h))
  table.insert(points, cc.p(x, y - h))
  return drawNode:drawPolygon(points, 4, color, 0, color)
end
local createBackGradientLayer
createBackGradientLayer = function()
  local node = cc.LayerGradient:create()
  node:setStartOpacity(255)
  node:setEndOpacity(120)
  node:setStartColor(cc.c3b(255, 0, 0))
  node:setEndColor(cc.c3b(255, 0, 0))
  return node
end
local create
create = function(gamaAnimation, csx)
  print("-------------------show_animation_scene.moon----------")
  print("[show_animation_scene::create] gamaAnimation:" .. tostring(gamaAnimation))
  scene = cc.Scene:create()
  assert(gamaAnimation, "missing animation userdata to play on.")
  scene:addChild(createBackGradientLayer())
  local xpos1 = display.width / 4
  local xpos2 = display.width * 3 / 4
  local ypos = display.cy
  local sprite = cc.Sprite:create()
  sprite:setPosition(xpos1, ypos)
  gamaAnimation:playOnSprite(sprite)
  scene:addChild(sprite)
  sprite = cc.Sprite:create()
  sprite:setPosition(xpos2, ypos)
  gamaAnimation:playOnSprite(sprite)
  sprite:setFlippedX(true)
  scene:addChild(sprite)
  local borderColor = cc.c4f(1, 0, 0, .5)
  local line = cc.DrawNode:create()
  line:drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line:drawSegment(cc.p(xpos1, 0), cc.p(xpos1, display.height), 0.5, borderColor)
  line:drawSegment(cc.p(xpos2, 0), cc.p(xpos2, display.height), 0.5, borderColor)
  scene:addChild(line)
  local infoBtnFunc
  infoBtnFunc = function(btn, event)
    if event == ccui.TouchEventType.ended then
      scene:addChild(json_data_layer_modal.create(csx), 103)
    end
  end
  local infoBtn = ccui.Button:create("btn_info.png")
  infoBtn:setPosition(display.width - 50, display.height - 50)
  infoBtn:addTouchEventListener(infoBtnFunc)
  scene:addChild(infoBtn, 102)
  local backBtnFunc
  backBtnFunc = function(btn, event)
    console.error("[show_animation_scene.moon:55]:")
    display.enterScene("scenes.enter_id_scene")
  end
  local backBtn = ccui.Button:create("btn_back.png")
  backBtn:setPosition(50, display.height - 50)
  backBtn:addTouchEventListener(backBtnFunc)
  scene:addChild(backBtn, 102)
  return scene
end
return {
  create = create
}

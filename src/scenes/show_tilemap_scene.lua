local view_helper = require("utils/view_helper")
local json_data_layer_modal = require("scenes.shared.json_data_layer_modal")
local scene = nil
local create
create = function(gamaTilemap, csx)
  console.dir(csx)
  print("-------------------show_tilemap_scene.moon----------")
  print("[show_animation_scene::create] gamaTilemap:" .. tostring(gamaTilemap))
  scene = cc.Scene:create()
  assert(gamaTilemap, "missing data instance to play on.")
  local xpos = display.cx
  local ypos = display.cy
  local label = cc.LabelTTF:create("touch to move", "Arial", 42)
  label:setPosition(cc.p(display.cx, display.cy))
  label:setColor(display.COLOR_WHITE)
  local sprite = cc.Sprite:create()
  sprite:setPosition(display.cx, display.cy)
  local layer = view_helper.createTouchMoveLayer(function(touches, event)
    local diff = touches[1]:getDelta()
    local centerX, centerY = gamaTilemap:moveBy(diff.x, diff.y)
    label:setString("x:" .. tostring(math.floor(centerX + 0.5)) .. ", y:" .. tostring(math.floor(centerY + 0.5)) .. ", lbX:" .. tostring(math.floor(gamaTilemap.container:getPositionX())) .. ", lbY:" .. tostring(math.floor(gamaTilemap.container:getPositionY())))
  end)
  gamaTilemap:bindToSprite(sprite)
  layer:addChild(sprite)
  scene:addChild(layer)
  local borderColor = cc.c4f(1, 0, 0, .5)
  local line = cc.DrawNode:create()
  line:drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line:drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, borderColor)
  layer:addChild(line)
  scene:addChild(label)
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
  return scene
end
return {
  create = create
}

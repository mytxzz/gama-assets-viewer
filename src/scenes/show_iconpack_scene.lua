require("gama")
local json_data_layer_modal = require("scenes.shared.json_data_layer_modal")
local scene = nil
local create
create = function(gamaIconPack, csx)
  console.dir(csx)
  print("-------------------show_iconpack_scene.moon----------")
  print("[show_iconpack_scene::create] gamaIconPack:" .. tostring(gamaIconPack))
  scene = cc.Scene:create()
  assert(gamaIconPack, "missing icon pack to play on.")
  local xpos1 = display.width / 4
  local xpos2 = display.width * 3 / 4
  local ypos = display.cy
  local sprite
  do
    local _with_0 = cc.Sprite:create()
    _with_0:setPosition(xpos1, ypos)
    _with_0:setAnchorPoint(0, 0)
    sprite = _with_0
  end
  gamaIconPack:drawOnSprite(sprite, "1")
  scene:addChild(sprite)
  sprite = cc.Sprite:create()
  sprite:setPosition(xpos2, ypos)
  gamaIconPack:drawOnSprite(sprite, "1")
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
      scene:addChild(json_data_layer_modal:create(csx))
    end
  end
  local infoBtn = ccui.Button:create("btn_info.png")
  infoBtn:setPosition(display.width - 50, display.height - 50)
  infoBtn:addTouchEventListener(infoBtnFunc)
  scene:addChild(infoBtn)
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

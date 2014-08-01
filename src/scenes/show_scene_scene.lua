require("gama")
local view_helper = require("utils/view_helper")
local scene = nil
local create
create = function(sceneDataPack)
  print("[show_scene_scene::create] sceneDataPack:" .. tostring(sceneDataPack))
  scene = cc.Scene:create()
  assert(sceneDataPack, "missing data instance to play on.")
  local sceneData = sceneDataPack[1]
  local gamaTilemap = sceneDataPack[2]
  local xpos = display.cx
  local ypos = display.cy
  local label = cc.LabelTTF:create("touch to move", "Arial", 42)
  label:setPosition(cc.p(display.cx, display.cy))
  label:setColor(display.COLOR_WHITE)
  local tilemapSprite = cc.Sprite:create()
  tilemapSprite:setPosition(0, 0)
  local tilemapLayer = view_helper.createTouchMoveLayer(function(touches, event)
    local diff = touches[1]:getDelta()
    local centerX, centerY = gamaTilemap:moveBy(diff.x, diff.y)
    label:setString("x:" .. tostring(math.floor(centerX + 0.5)) .. ", y:" .. tostring(math.floor(centerY + 0.5)) .. ", lbX:" .. tostring(math.floor(gamaTilemap.container:getPositionX())) .. ", lbY:" .. tostring(math.floor(gamaTilemap.container:getPositionY())))
  end)
  gamaTilemap:bindToSprite(tilemapSprite)
  tilemapLayer:addChild(tilemapSprite)
  scene:addChild(tilemapLayer)
  if type(sceneData.ornaments) == "table" then
    local _list_0 = sceneData.ornaments
    for _index_0 = 1, #_list_0 do
      local ornament = _list_0[_index_0]
      console.log("[show_scene_scene::add scene ornaments] " .. tostring(ornament.x) .. ", " .. tostring(ornament.y) .. ", " .. tostring(ornament.m))
      local animation = sceneDataPack[ornament.id]
      if animation then
        gamaTilemap:addOrnament(animation, ornament.x, ornament.y, ornament.m)
      else
        console.log("[show_scene_scene::add scene ornaments] missing gama instance for key:" .. tostring(ornament.id))
      end
    end
  end
  local borderColor = cc.c4f(1, 0, 0, .5)
  local line = cc.DrawNode:create()
  line:drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line:drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, borderColor)
  scene:addChild(line)
  scene:addChild(label)
  return scene
end
return {
  create = create
}

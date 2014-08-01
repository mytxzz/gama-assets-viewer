require("gama")
local view_helper = require("utils/view_helper")
local scene = nil
local COLOR_RED = cc.c4f(1, 0, 0, .5)
local COLOR_GREEN = cc.c4f(0, 1, 0, .5)
local drawRect
drawRect = function(drawNode, x, y, w, h, color)
  local points = { }
  table.insert(points, cc.p(x, y))
  table.insert(points, cc.p(x + w, y))
  table.insert(points, cc.p(x + w, y + h))
  table.insert(points, cc.p(x, y + h))
  return drawNode:drawPolygon(points, 4, COLOR_RED, 0, COLOR_RED)
end
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
  local maskNode = cc.DrawNode:create()
  tilemapLayer:addChild(tilemapSprite)
  gamaTilemap.container:addChild(maskNode)
  scene:addChild(tilemapLayer)
  drawRect(maskNode, 100, 100, 300, 300, COLOR_RED)
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
  local line = cc.DrawNode:create()
  line:drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, COLOR_RED)
  line:drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, COLOR_RED)
  scene:addChild(line)
  scene:addChild(label)
  return scene
end
return {
  create = create
}

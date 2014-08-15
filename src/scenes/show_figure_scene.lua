require("gama")
local Character = require("models.character")
local view_helper = require("utils/view_helper")
local scene = nil
local DIRECTION_TO_NEXT_CLOCKWISE = {
  n = "ne",
  ne = "e",
  e = "se",
  se = "s",
  s = "sw",
  sw = "w",
  w = "nw",
  nw = "n"
}
local DIRECTION_TO_NEXT_ANTICLOCKWISE = {
  n = "nw",
  nw = "w",
  w = "sw",
  sw = "s",
  s = "se",
  se = "e",
  e = "ne",
  ne = "n"
}
local create
create = function(gamaFigure)
  print("[show_animation_scene::create] gamaFigure:" .. tostring(gamaFigure))
  scene = cc.Scene:create()
  assert(gamaFigure, "missing figure instance to play on.")
  local xpos = display.cx
  local ypos = display.height / 3
  local sprite = cc.Sprite:create()
  sprite:setPosition(xpos, ypos)
  local character
  do
    local _with_0 = Character(gamaFigure:getId(), gamaFigure)
    _with_0:bindToDisplay(sprite)
    _with_0:setLocation(display.cx, display.cy)
    character = _with_0
  end
  sprite:setOpacity(0)
  sprite:runAction(cc.FadeIn:create(3))
  print("[show_figure_scene] character:" .. tostring(character))
  local accumenDeltaX = 0
  local layer = view_helper.createTouchMoveLayer(function(touches, event)
    local diff = touches[1]:getDelta()
    accumenDeltaX = accumenDeltaX + diff.x
    if not (math.abs(accumenDeltaX) > 10) then
      return 
    end
    if accumenDeltaX < 0 then
      character:rotate(math.pi / 8)
    else
      character:rotate(-math.pi / 8)
    end
    accumenDeltaX = 0
  end)
  layer:addChild(sprite)
  scene:addChild(layer)
  local borderColor = cc.c4f(1, 0, 0, .5)
  local line = cc.DrawNode:create()
  line:drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line:drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, borderColor)
  layer:addChild(line)
  local motions = gamaFigure:getMotions()
  local LINE_SPACE = 60
  local s = cc.Director:getInstance():getWinSize()
  local MainMenu = cc.Menu:create()
  for index, motion in ipairs(motions) do
    local testLabel = cc.Label:createWithSystemFont(motion, 'Arial', 42)
    testLabel:setAnchorPoint(cc.p(0.5, 0.5))
    local testMenuItem = cc.MenuItemLabel:create(testLabel)
    testMenuItem:registerScriptTapHandler(function()
      character:setMotion(motion)
    end)
    testMenuItem:setPosition(cc.p(100 / 2, (s.height - (index) * LINE_SPACE)))
    MainMenu:addChild(testMenuItem, index + 10000, index + 10000)
  end
  MainMenu:setContentSize(cc.size(100, (#motions + 1) * (LINE_SPACE)))
  MainMenu:setPosition(0, 0)
  scene:addChild(MainMenu)
  return scene
end
return {
  create = create
}

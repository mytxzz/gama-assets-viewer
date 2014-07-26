require("gama")
local scene = nil
local create
create = function(gamaFigure)
  print("[show_animation_scene::create] gamaFigure:" .. tostring(gamaFigure))
  scene = cc.Scene:create()
  assert(gamaFigure, "missing figure instance to play on.")
  local xpos = display.cx
  local ypos = display.height / 3
  gamaFigure:setDefaultMotion("idl")
  gamaFigure:setDefaultDirection("s")
  local sprite = cc.Sprite:create()
  sprite:setPosition(xpos, ypos)
  gamaFigure:playOnSprite(sprite)
  scene:addChild(sprite)
  local borderColor = cc.c4f(1, 0, 0, .5)
  local line = cc.DrawNode:create()
  line:drawSegment(cc.p(0, ypos), cc.p(display.width, ypos), 0.5, borderColor)
  line:drawSegment(cc.p(xpos, 0), cc.p(xpos, display.height), 0.5, borderColor)
  scene:addChild(line)
  local motions = gamaFigure:getMotions()
  local LINE_SPACE = 40
  local s = cc.Director:getInstance():getWinSize()
  local MainMenu = cc.Menu:create()
  for index, motion in ipairs(motions) do
    local testLabel = cc.Label:create(motion, 'Arial', 24)
    testLabel:setAnchorPoint(cc.p(0.5, 0.5))
    local testMenuItem = cc.MenuItemLabel:create(testLabel)
    testMenuItem:registerScriptTapHandler(function()
      gamaFigure:playOnSprite(sprite, motion)
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

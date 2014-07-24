require("gama")
local scene = nil
local create
create = function(gamaAnimation)
  print("[show_animation_scene::create] gamaAnimation:" .. tostring(gamaAnimation))
  scene = cc.Scene:create()
  assert(gamaAnimation, "missing animation userdata to play on.")
  local sprite = cc.Sprite:create()
  sprite:setPosition(display.cx, display.cy + 250)
  gamaAnimation:playOnSprite(sprite)
  scene:addChild(sprite)
  return scene
end
return {
  create = create
}

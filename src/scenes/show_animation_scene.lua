require("gama")
local scene = nil
local create
create = function(self, animation, infoObj, textures)
  scene = cc.Scene:create()
  assert(animation, "missing animation userdata to play on.")
  assert(infoObj, "missing animation information.")
  assert(textures and #textures > 0, "missing textures")
  local sprite = cc.Sprite:createWithTexture(textures[1])
  transition.playAnimationForever(sprite, animation, delay)
  sprite:setPosition(display.cx, display.cy + 250)
  return sprite:addTo(self)
end
return 
return {
  create = create
}

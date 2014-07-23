
require "gama"

scene = nil

create = (self, animation, infoObj, textures) ->

  scene = cc.Scene\create()

  assert animation, "missing animation userdata to play on."
  assert infoObj, "missing animation information."
  assert textures and #textures > 0, "missing textures"

  sprite = cc.Sprite\createWithTexture textures[1]

  transition.playAnimationForever(sprite, animation, delay)

  sprite\setPosition(display.cx, display.cy + 250)
  sprite\addTo self

return



return {
  create: create
}


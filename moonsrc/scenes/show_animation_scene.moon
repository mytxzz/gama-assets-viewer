
require "gama"

scene = nil

create = (gamaAnimation) ->

  print "[show_animation_scene::create] gamaAnimation:#{gamaAnimation}"


  scene = cc.Scene\create()

  assert gamaAnimation, "missing animation userdata to play on."

  sprite = cc.Sprite\create!
  --sprite = gamaAnimation\createSprite!
  sprite\setPosition(display.cx, display.cy + 250)
  gamaAnimation\playOnSprite sprite

  scene\addChild sprite
  return scene


return {
  create: create
}


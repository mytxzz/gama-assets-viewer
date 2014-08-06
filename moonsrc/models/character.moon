StackFSM = require("util.stack_fsm").StackFSM

CONTINOUSE_MOTION_IDS =
  idl: true
  ded: true
  run: true

-- TODO: following conts should goes into gama
DIRECTION_TO_FLIPX =
  n: false
  ne: false
  e: false
  se: false
  s: false
  sw: true
  w: true
  nw: true

class Character

  new: (@id, @figure, @sprite)=>
    @curDirection = "s"
    StackFSM(@)     -- 把自己变成一个多堆式状态机
    @pushState("idl")\updateState!

  getCurrentMotion: => @getCurrentState!

  applyChange: =>
    return unless @sprite
    @sprite\setFlippedX(DIRECTION_TO_FLIPX[@curDirection])

    if @continouseMotionIds[@curMotion]
      @figure\playOnSprite @sprite, @getCurrentMotion!, @curDirection
      return

    @figure\playOnceOnSprite @sprite, @getCurrentMotion!, @curDirection
    return

  setDirection: (value)=>
    return if @curDirection == value  --lazy
    @curDirection = value
    @applyChange!
    return

  setMotion: (value, allowDuplication)=>
    return if value == nil
    if CONTINOUSE_MOTION_IDS[value]
      @resetState value   -- 持续式的状态
    else
      @pushState value, allowDuplication

    @updateState!
    return

return Character


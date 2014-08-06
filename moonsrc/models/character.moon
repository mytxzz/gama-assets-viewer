StackFSM = require("utils.stack_fsm").StackFSM
EventEmitter = require("events").EventEmitter

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

    --EventEmitter(@) -- 把自己变成一个事件触发器
    --@on "stack_fsm_update", (motionId)->
      --console.info "[character::stack_fsm_update] motionId:#{motionId}"

    StackFSM(@)     -- 把自己变成一个多堆式状态机
    @pushState("idl")
    @updateState!
    return

  getCurrentMotion: => @getCurrentState!

  onStackFSMUpdate: (motionId)=>
    console.info "[character::onStackFSMUpdate] motionId:#{motionId}"
    @applyChange(motionId)
    return

  applyChange: (curMotion)=>
    return unless @sprite

    @sprite\setFlippedX(DIRECTION_TO_FLIPX[@curDirection])

    curMotion = curMotion or @getCurrentMotion!

    if CONTINOUSE_MOTION_IDS[curMotion]
      @figure\playOnSprite @sprite, curMotion, @curDirection
      return

    @figure\playOnceOnSprite @sprite, curMotion, @curDirection
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


StackFSM = require("stack_fsm").StackFSM
EventEmitter = require("events").EventEmitter

CONTINOUSE_MOTION_IDS =
  idl: true
  ded: true
  run: true
  eng: true

STACKABLE_MOTION_IDS =
  atk: true
  ak2: true

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
    else
      @figure\playOnceOnSprite @sprite, curMotion, @curDirection, ->
        console.info "[character::playOnceOnSprite] callback"
        self\popState!
        self\updateState!
        return
    return

  setDirection: (value)=>
    return if @curDirection == value  --lazy
    return unless CONTINOUSE_MOTION_IDS[@getCurrentMotion!] == true
    @curDirection = value
    @applyChange!
    return

  setMotion: (value, allowDuplication)=>
    return if value == nil

    if CONTINOUSE_MOTION_IDS[value]
      @resetState value   -- 持续式的状态
      @updateState!
    else
      if STACKABLE_MOTION_IDS[value]
        -- 是可以多栈的动作
        currentState = @getCurrentMotion!
        @pushState value, true
        @updateState! if value != currentState
      else
        @pushState value, false
        @updateState!

    return

return Character


StackFSM = require("stack_fsm").StackFSM
EventEmitter = require("events").EventEmitter
Vector = require "vector"

scheduler = cc.Director\getInstance()\getScheduler()

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

MOTION_ID_TO_SCALAR =
  idl: 0.1
  ded: 0.1
  run: 3
  eng: 0.1
  atk: 1
  ak2: 2
  kik: 1
  nkd: 3


CHARACTER_INSTANCES = {}

makeMovement = ->
  for character in * CHARACTER_INSTANCES
    velocity = character.velocity
    if velocity == nil
      print "[character::makeMovement] invalid Character:#{character}"
    elseif velocity\insignificant!
      print "[character::makeMovement] ignore insignificant Character:#{character}"
    else
      character\setLocation(character.x + velocity.x, character.y + velocity.y)

  return

scheduler\scheduleScriptFunc(makeMovement,0,false)

class Character

  new: (@id, @figure, @sprite)=>
    CHARACTER_INSTANCES[@] = true     -- register instance to instance list
    --@curDirection = "s"
    StackFSM(@)     -- 把自己变成一个多堆式状态机
    @velocity = Vector.new(0, 0)    -- 变更位置和方向的向量
    --@pushState("idl")
    --@updateState!
    @setMotion "idl"
    return

  __tostring: -> "[Character #{@id}, x:#{@x}, y:#{y}]"

  getCurrentMotion: => @getCurrentState!

  -- 当前动作被切换的时候
  onStackFSMUpdate: (motionId)=>
    console.info "[character::onStackFSMUpdate] motionId:#{motionId}"

    scalar = MOTION_ID_TO_SCALAR[motionId]
    unless scalar > 0
      print "[character::onStackFSMUpdate] invalid motion id:#{motionId}"
      return

    @velocity\setScalar(scalar)
    @applyChange(motionId)
    return

  applyChange: (curMotion)=>
    return unless @sprite

    curDirection = @velocity\toDirection!

    @sprite\setFlippedX(DIRECTION_TO_FLIPX[curDirection])

    curMotion = curMotion or @getCurrentMotion!

    if CONTINOUSE_MOTION_IDS[curMotion]
      @figure\playOnSprite @sprite, curMotion, curDirection
    else
      @figure\playOnceOnSprite @sprite, curMotion, curDirection, ->
        console.info "[character::playOnceOnSprite] callback"
        self\popState!
        self\updateState!
        return
    return

  --setDirection: (value)=>
    --return if @curDirection == value  --lazy
    --return unless CONTINOUSE_MOTION_IDS[@getCurrentMotion!] == true
    --@curDirection = value
    --@applyChange!
    --return


  rotateTo: (radians)->
    @velocity\rotateTo radians
    curDirection = @velocity\toDirection!
    @applyChange!  if CONTINOUSE_MOTION_IDS[curDirection] != true
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


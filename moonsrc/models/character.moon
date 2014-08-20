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

MOTION_ID_TO_SCALAR =
  idl: 0.1
  ded: 0.1
  run: 3
  eng: 0.1
  atk: 0.3
  ak2: 1
  kik: 0.1
  nkd: 0.1


CHARACTER_INSTANCES = {}

-- 每帧移动向量
makeMovement = (delta)->
  --console.info "[character::makeMovement] delta:#{delta}"
  for character in pairs CHARACTER_INSTANCES
    velocity = character.velocity
    --console.warn "[character::makeMovement] character:#{character}, velocity:#{velocity}"
    if Vector.isvector(velocity) and velocity\significant!
      --console.info "[character::makeMovement] apply velocity:#{velocity}"
      newX = character.x + velocity.x
      newY = character.y + velocity.y
      newX = display.width + (newX % display.width) if newX < 0
      newY = display.height + (newX % display.height) if newY < 0
      newX = 0 if newX > display.width
      newY = 0 if newY > display.height
      character\setLocation(newX, newY)
      character\positionSpriteOnScreen!
      --if character.sprite
        --character.sprite\setPosition
  return

scheduler\scheduleScriptFunc(makeMovement,0,false)

class Character

  new: (@id, @figure)=>
    CHARACTER_INSTANCES[@] = true     -- register instance to instance list
    StackFSM(@)     -- 把自己变成一个多堆式状态机
    @velocity = Vector.new(0, 0.1)-- 变更位置和方向的向量
    @setMotion "idl"
    @x = 0
    @y = 0

    return

  __tostring: => "[Character #{@id}, x:#{@x}, y:#{@y}]"

  getCurrentMotion: => @getCurrentState!

  setLocation: (x, y)=>
    --console.info "[character::setLocation] x:#{x}, y:#{y}"
    @x = x
    @y = y
    return

  -- 绑定到显示容器上
  bindToDisplay: (sprite)=>
    if @sprite
      -- TODO: 移除当前的绑定
      print "[character::bindToDisplay] should remove action"

    return unless sprite
    @sprite = sprite
    @applyChange!

    return

  positionSpriteOnScreen: =>
    --console.info "[character::positionSpriteOnScreen] x:#{@x}, y:#{@y}, sprite:#{@sprite}"
    return unless @sprite
    @sprite\setPosition(@x, @y)
    return


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

  rotate: (radians)=>
    @velocity\rotate radians
    curDirection = @velocity\toDirection!
    @applyChange!  if CONTINOUSE_MOTION_IDS[curDirection] != true
    return

  rotateTo: (radians)=>
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


local StackFSM = require("stack_fsm").StackFSM
local EventEmitter = require("events").EventEmitter
local Vector = require("vector")
local scheduler = cc.Director:getInstance():getScheduler()
local CONTINOUSE_MOTION_IDS = {
  idl = true,
  ded = true,
  run = true,
  eng = true
}
local STACKABLE_MOTION_IDS = {
  atk = true,
  ak2 = true
}
local MOTION_ID_TO_SCALAR = {
  idl = 0.1,
  ded = 0.1,
  run = 3,
  eng = 0.1,
  atk = 0.3,
  ak2 = 1,
  kik = 0.1,
  nkd = 0.1
}
local CHARACTER_INSTANCES = { }
local makeMovement
makeMovement = function(delta)
  for character in pairs(CHARACTER_INSTANCES) do
    local velocity = character.velocity
    if Vector.isvector(velocity) and velocity:significant() then
      local newX = character.x + velocity.x
      local newY = character.y + velocity.y
      if newX < 0 then
        newX = display.width + (newX % display.width)
      end
      if newY < 0 then
        newY = display.height + (newX % display.height)
      end
      if newX > display.width then
        newX = 0
      end
      if newY > display.height then
        newY = 0
      end
      character:setLocation(newX, newY)
      character:positionSpriteOnScreen()
    end
  end
end
scheduler:scheduleScriptFunc(makeMovement, 0, false)
local Character
do
  local _base_0 = {
    __tostring = function(self)
      return "[Character " .. tostring(self.id) .. ", x:" .. tostring(self.x) .. ", y:" .. tostring(self.y) .. "]"
    end,
    getCurrentMotion = function(self)
      return self:getCurrentState()
    end,
    setLocation = function(self, x, y)
      self.x = x
      self.y = y
    end,
    bindToDisplay = function(self, sprite)
      if self.sprite then
        print("[character::bindToDisplay] should remove action")
      end
      if not (sprite) then
        return 
      end
      self.sprite = sprite
      self:applyChange()
    end,
    positionSpriteOnScreen = function(self)
      if not (self.sprite) then
        return 
      end
      self.sprite:setPosition(self.x, self.y)
    end,
    onStackFSMUpdate = function(self, motionId)
      console.info("[character::onStackFSMUpdate] motionId:" .. tostring(motionId))
      local scalar = MOTION_ID_TO_SCALAR[motionId]
      if not (scalar > 0) then
        print("[character::onStackFSMUpdate] invalid motion id:" .. tostring(motionId))
        return 
      end
      self.velocity:setScalar(scalar)
      self:applyChange(motionId)
    end,
    applyChange = function(self, curMotion)
      if not (self.sprite) then
        return 
      end
      local curDirection = self.velocity:toDirection()
      curMotion = curMotion or self:getCurrentMotion()
      if CONTINOUSE_MOTION_IDS[curMotion] then
        self.figure:playOnSprite(self.sprite, curMotion, curDirection)
      else
        self.figure:playOnceOnSprite(self.sprite, curMotion, curDirection, function()
          console.info("[character::playOnceOnSprite] callback")
          self:popState()
          self:updateState()
        end)
      end
    end,
    rotate = function(self, radians)
      self.velocity:rotate(radians)
      local curDirection = self.velocity:toDirection()
      if CONTINOUSE_MOTION_IDS[curDirection] ~= true then
        self:applyChange()
      end
    end,
    rotateTo = function(self, radians)
      self.velocity:rotateTo(radians)
      local curDirection = self.velocity:toDirection()
      if CONTINOUSE_MOTION_IDS[curDirection] ~= true then
        self:applyChange()
      end
    end,
    setMotion = function(self, value, allowDuplication)
      if value == nil then
        return 
      end
      if CONTINOUSE_MOTION_IDS[value] then
        self:resetState(value)
        self:updateState()
      else
        if STACKABLE_MOTION_IDS[value] then
          local currentState = self:getCurrentMotion()
          self:pushState(value, true)
          if value ~= currentState then
            self:updateState()
          end
        else
          self:pushState(value, false)
          self:updateState()
        end
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, id, figure)
      self.id, self.figure = id, figure
      CHARACTER_INSTANCES[self] = true
      StackFSM(self)
      self.velocity = Vector.new(0, 0.1)
      self:setMotion("idl")
      self.x = 0
      self.y = 0
    end,
    __base = _base_0,
    __name = "Character"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Character = _class_0
end
return Character

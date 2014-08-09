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
local DIRECTION_TO_FLIPX = {
  n = false,
  ne = false,
  e = false,
  se = false,
  s = false,
  sw = true,
  w = true,
  nw = true
}
local MOTION_ID_TO_SCALAR = {
  idl = 0.1,
  ded = 0.1,
  run = 3,
  eng = 0.1,
  atk = 1,
  ak2 = 2,
  kik = 1,
  nkd = 3
}
local Character
do
  local _base_0 = {
    getCurrentMotion = function(self)
      return self:getCurrentState()
    end,
    onStackFSMUpdate = function(self, motionId)
      console.info("[character::onStackFSMUpdate] motionId:" .. tostring(motionId))
      self:applyChange(motionId)
    end,
    applyChange = function(self, curMotion)
      if not (self.sprite) then
        return 
      end
      self.sprite:setFlippedX(DIRECTION_TO_FLIPX[self.curDirection])
      curMotion = curMotion or self:getCurrentMotion()
      if CONTINOUSE_MOTION_IDS[curMotion] then
        self.figure:playOnSprite(self.sprite, curMotion, self.curDirection)
      else
        self.figure:playOnceOnSprite(self.sprite, curMotion, self.curDirection, function()
          console.info("[character::playOnceOnSprite] callback")
          self:popState()
          self:updateState()
        end)
      end
    end,
    setDirection = function(self, value)
      if self.curDirection == value then
        return 
      end
      if not (CONTINOUSE_MOTION_IDS[self:getCurrentMotion()] == true) then
        return 
      end
      self.curDirection = value
      self:applyChange()
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
    __init = function(self, id, figure, sprite)
      self.id, self.figure, self.sprite = id, figure, sprite
      self.curDirection = "s"
      StackFSM(self)
      self.velocity = Vector.new(0, 0)
      self:pushState("idl")
      self:updateState()
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

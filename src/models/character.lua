local StackFSM = require("util.stack_fsm").StackFSM
local CONTINOUSE_MOTION_IDS = {
  idl = true,
  ded = true,
  run = true
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
local Character
do
  local _base_0 = {
    getCurrentMotion = function(self)
      return self:getCurrentState()
    end,
    applyChange = function(self)
      if not (self.sprite) then
        return 
      end
      self.sprite:setFlippedX(DIRECTION_TO_FLIPX[self.curDirection])
      if self.continouseMotionIds[self.curMotion] then
        self.figure:playOnSprite(self.sprite, self:getCurrentMotion(), self.curDirection)
        return 
      end
      self.figure:playOnceOnSprite(self.sprite, self:getCurrentMotion(), self.curDirection)
    end,
    setDirection = function(self, value)
      if self.curDirection == value then
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
      else
        self:pushState(value, allowDuplication)
      end
      self:updateState()
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, id, figure, sprite)
      self.id, self.figure, self.sprite = id, figure, sprite
      self.curDirection = "s"
      StackFSM(self)
      return self:pushState("idl"):updateState()
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

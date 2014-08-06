local IDENTIFIER = "__stack_fsm"
local popState
popState = function(self)
  local states = rawget(self, IDENTIFIER)
  if not (type(states) == "table") then
    return print("[stack_fsm::pushState] invalid stack_fsm:" .. tostring(self))
  end
  return table.remove(states)
end
local pushState
pushState = function(self, state)
  if state == self:getCurrentState() then
    return 
  end
  local states = rawget(self, IDENTIFIER)
  if not (type(states) == "table") then
    return print("[stack_fsm::pushState] invalid stack_fsm:" .. tostring(self))
  end
  table.insert(states, state)
end
local getCurrentState
getCurrentState = function(self)
  local states = rawget(self, IDENTIFIER)
  if not (type(states) == "table") then
    return print("[stack_fsm::pushState] invalid stack_fsm:" .. tostring(self))
  end
  if not (#states > 0) then
    return nil
  end
  return states[#states]
end
local updateState
updateState = function(self, self)
  local currentState = self.getCurrentState()
  if currentState == nil then
    return 
  end
  if type(currentState) == "function" then
    currentState(self)
  elseif type(self.emit) == "function" then
    self.emit(currentState, self)
  elseif type(self["on" .. tostring(currentState)]) == "function" then
    self["on" .. tostring(currentState)](self)
  end
end
local resetState
resetState = function(self, state)
  return rawset(self, IDENTIFIER, {
    state
  })
end
return {
  StackFSM = function(tbl)
    print("[stack_fsm::StackFSM] tbl:" .. tostring(tbl))
    if not (type(tbl) == "table") then
      tbl = { }
    end
    if tbl[IDENTIFIER] ~= { } then
      return print("[stack_fsm::StackFSM] " .. tostring(tbl) .. " is already an StackFSM")
    end
    rawset(tbl, IDENTIFIER, { })
    tbl.popState = popState
    tbl.pushState = pushState
    tbl.getCurrentState = getCurrentState
    tbl.updateState = updateState
    tbl.resetState = resetState
    return tbl
  end
}

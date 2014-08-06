
IDENTIFIER = "__stack_fsm"

popState = =>
  states = rawget @, IDENTIFIER
  return print "[stack_fsm::pushState] invalid stack_fsm:#{@}" unless type(states) == "table"
  return table.remove states

pushState = (state)=>
  return if state == @getCurrentState!
  states = rawget @, IDENTIFIER
  return print "[stack_fsm::pushState] invalid stack_fsm:#{@}" unless type(states) == "table"
  table.insert states, state
  return

getCurrentState = =>
  states = rawget @, IDENTIFIER
  return print "[stack_fsm::pushState] invalid stack_fsm:#{@}" unless type(states) == "table"
  return nil unless #states > 0
  return states[#states]

updateState = (self)=>
  currentState = self.getCurrentState!
  return if currentState == nil

  if type(currentState) == "function"
    -- 如果state 是一个可以执行的函数，那么执行这个函数
    currentState(self)
  elseif type(self.emit) == "function"
    -- 如果 self 是一个 事件触发器，那么抛出事件
    self.emit(currentState, self)
  elseif type(self["on#{currentState}"]) == "function"
    -- 如果 self 上有 on 事件监听方法，那么调用这个事件监听方法
    self["on#{currentState}"](self)

  return

resetState = (state)=> rawset @, IDENTIFIER, {state}

return {
  -- 向给定的 table 注入 Stack Finity State Machine 功能，如果没有提给定的 table 那么会创建一个新 table
  -- @param tbl target table
  StackFSM: (tbl)->

    print "[stack_fsm::StackFSM] tbl:#{tbl}"

    tbl = {} unless type(tbl) == "table"

    return print "[stack_fsm::StackFSM] #{tbl} is already an StackFSM" if tbl[IDENTIFIER] != {}

    rawset tbl, IDENTIFIER, {}

    tbl.popState = popState
    tbl.pushState = pushState
    tbl.getCurrentState = getCurrentState
    tbl.updateState = updateState
    tbl.resetState = resetState
    return tbl
}


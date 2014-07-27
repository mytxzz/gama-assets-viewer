view_helper =

  createTouchMoveLayer: (onTouchesMoved)->
    layer = cc.Layer\create!
    listener = cc.EventListenerTouchAllAtOnce\create!
    listener\registerScriptHandler(onTouchesMoved, cc.Handler.EVENT_TOUCHES_MOVED)
    eventDispatcher = layer\getEventDispatcher!
    eventDispatcher\addEventListenerWithSceneGraphPriority(listener, layer)

    return layer

       --function onTouchesMoved(touches, event )
           --diff = touches[1]:getDelta()
           --node = layer:getChildByTag(kTagTileMap)
           --currentPosX, currentPosY= node:getPosition()
          --node:setPosition(cc.p(currentPosX + diff.x, currentPosY + diff.y))




return view_helper

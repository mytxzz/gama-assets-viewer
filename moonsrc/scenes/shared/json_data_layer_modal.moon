
inspect = require "inspect"

create = (csx) ->
  container = ccui.Layout\create()
  container\setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
  container\setTouchEnabled(true)
  container\setBackGroundColor(cc.c3b(0,0,0))
  container\setBackGroundColorOpacity(208)
  container\setContentSize(display.width,display.height)


  scrollView = ccui.ScrollView\create()
  scrollView\setTouchEnabled(true)
  scrollView\setContentSize(cc.size(display.width-40,display.height-40))
  scrollView\setPosition(cc.p(20,20))

  csx1 = { }
  csx1.pixelHeight = 1536
  csx1.pixelWidth = 2048
  csx1.scene_type = "wild"
  csx1.type = "scenes"
  csx1.width_in_brick = 64



  -- json_data = ccui.Text\create()
  -- -- json_data\
  print("-----json_data_layer-------------------")
  print(inspect(csx))
  -- json_data\setString(inspect(csx))
  -- json_data\setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
  -- json_data\setFontSize(15)
  -- json_data\setColor(cc.c3b(0,255,255))
  -- json_data\setAnchorPoint(cc.p(0,1))
  -- textArea = json_data\getContentSize()
  -- json_data\setPosition(cc.p(20,display.height-20))

  -- -- --测试加到层上面
  -- -- container\addChild(json_data)

  -- if textArea.height > display.height-40 then
  --   scrollView\setInnerContainerSize(cc.size(display.width/2-40,textArea.height))
  -- else
  --   scrollView\setInnerContainerSize(cc.size(display.width/2-40,display.height-40))

  -- scrollView\addChild(json_data)

  -- cc.LabelTTF
  label1 = cc.Label\create()
  -- label1\setFontSize(15)
  label1\setDimensions(display.width-40,3500)
  label1\setString(inspect(csx))
  print "[json_data_layer_modal.moon:54] label1:#{label1}"
  label1\setTextColor( cc.c4b(0, 255, 0, 255))
  -- label1\setPosition( cc.p(20,display.height - 20) )
  label1\setPosition(cc.p(0,3500))
  label1\setAnchorPoint( cc.p(0, 1) )
  -- container\addChild(label1)

  scrollView\setInnerContainerSize(cc.size(display.width-40,3500))
  scrollView\addChild(label1)

  -- richText = ccui.RichText\create()
  -- richText\ignoreContentAdaptWithSize(false)
  -- richText\setContentSize(display.width-40,2200)
  -- richText\setAnchorPoint(cc.p(0, 1))
  -- richText\setPosition( cc.p(40 - display.width / 2,display.height - 20 + 1100) )

  -- re1 = ccui.RichElementText\create(1, cc.c3b(0, 255, 255), 255, inspect(csx), "Helvetica", 20)
  -- richText\pushBackElement(re1)

  -- -- scrollView\setInnerContainerSize(cc.size(display.width-40,2200))
  -- container\addChild(richText)





  container\addChild(scrollView)






  closeBtnFunc = (btn,event)->
    container\removeFromParent(true) if event == ccui.TouchEventType.ended
    return

  node = ccui.Button\create "btn_close.png"
  node\setPosition(display.width - 50 , display.height - 50)
  node\setTouchEnabled(true)
  node\addTouchEventListener(closeBtnFunc)
  container\addChild(node,20)



  return container


return {
  create: create
}
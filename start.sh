#!/bin/sh

## 用法：
# ./start.sh  不重新编译, 刷新 res, src 目录，让 lua 层面的修改立刻生效
# ./start.sh rebuild 新编译 app , 让 cpp 层面的修改生效

mkdir -p log

TAIL="$(echo `which colortail || which tail`)"

MAC_APP_PATH="./runtime/mac/AssetViewer.app"

if [ "$1" == "rebuild" ]; then

  echo "force a rebuild"
  cocos run -p mac > ./log/mac.log 2>&1 &
  $TAIL -f ./log/mac.log

elif [ ! -d "$MAC_APP_PATH" ]; then

  echo "build a new one"
  cocos run -p mac > ./log/mac.log 2>&1 &
  $TAIL -f ./log/mac.log

else

  echo "update symbolic links"

  rm -rf "$MAC_APP_PATH/Contents/Resources/res"
  ln -s ../../../../../res "$MAC_APP_PATH/Contents/Resources/res"

  rm -rf "$MAC_APP_PATH/Contents/Resources/src"
  ln -s ../../../../../src "$MAC_APP_PATH/Contents/Resources/src"

  "$MAC_APP_PATH/Contents/MacOS/AssetViewer Mac" > ./log/mac.log 2>&1 &
  $TAIL -f ./log/mac.log

fi




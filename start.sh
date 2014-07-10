#!/bin/sh

mkdir -p log
cocos run -p mac > ./log/mac.log 2>&1 &
TAIL="$(echo `which colortail || which tail`)"
$TAIL -f ./log/mac.log


#!/bin/sh

rm -rf  res/gama
mkdir -p res/gama
cp -r gama/* res/gama/
cocos compile -p android  --ap 20

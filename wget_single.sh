#!/bin/bash

brew install wget

#rm -rf gama
cd gama

fetch(){
  if [ -f "$1" ]
  then
    echo "exist: $1"
  else
    URL="http://www.gamagama.cn/fetch/$1"
    echo "fetch: $URL"
    wget $URL
  fi
}


fetch $1


#!/bin/sh

cd src/vendor/
for i in $(find . -type d -maxdepth 1 -not -name .);
do
  echo "cd to $i `pwd`"
  cd $i
  echo "@$i swithc to master branch"
  git checkout master
  echo "@$i git pull"
  git pull
  cd ..
done

#!/bin/bash

for var in "$@"
do
  echo "runing on $var"
  gnome-terminal --command="./demi.sh $var"
  clear
done

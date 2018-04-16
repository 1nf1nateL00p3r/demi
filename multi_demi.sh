#!/bin/bash

for var in "$@"
do
  echo "running on $var"
  gnome-terminal --command="./demi.sh $var"
  clear
done

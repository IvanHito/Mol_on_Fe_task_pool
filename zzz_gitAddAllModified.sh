#!/bin/bash

##arrMod=${tstr//$bstr/}

arrMod=$(git status | grep modified)

echo ""

i=0
for ae in $arrMod; do
  ##fn=$(echo "$fn" | awk '{print $3}')
  ##fn=$(echo "$ae" | sed -r -n 's/^.*modified:[ ]+([a-zA-Z0-9.]+).*/\1/p')
  i=$(($i+1))
  if [ $(($i%3)) -eq 0 ]; then
    echo "git add $ae"
    git add "$ae"
    echo ""
  fi
done

echo ""

#git commit -m "Auto Checkpoint"
#git push -u mfptp master

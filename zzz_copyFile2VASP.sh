#!/bin/bash

if [ -z "$3" ]; then
  echo ""
  echo "Usage: ./zzz_copyFile2VASP.sh <file> <task n begin> <task n end>"
  echo ""
  exit 1
fi

ftocp="$1"
tNbeg="$2"
tNend="$3"

i=0
for ((tn=$tNbeg; tn<=$tNend; tn++)); do
  i=$(($i+1))
  tf=$(printf "data/task_%05d/VASP/" $tn)
  echo "$ftocp  ->   $tf"
  cp $ftocp $tf
  ##cN=$(($cN+2))
done

echo ""


##tStrN=$(printf "%05d" "$tn")

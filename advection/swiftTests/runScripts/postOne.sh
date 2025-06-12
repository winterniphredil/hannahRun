#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: postOne.sh case
   exit
fi

case=$1

T=100
if [[ -e $case/$T ]]; then
    # Plot and calculate error norms
    sumFields -case $case $T Terror $T T 0 T -scale1 -1
    gmtFoam -case $case -time $T T
    ev $case/$T/T.pdf
    globalSum -case $case -time $T T
    globalSum -case $case -time $T Terror
    echo "#Time l1 l2 linf normMass normVar" > $case/errorNorms.dat
    paste $case/globalSumTerror.dat $case/globalSumT.dat | tail -1 | \
        awk '{print $1, $2/$10, $3/$11, $4/$12, $5/$13, $6/$11}' \
        >> $case/errorNorms.dat
    cat $case/errorNorms.dat
fi

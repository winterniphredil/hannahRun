#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: runOne.sh case
   exit
fi

case=$1

# Run the case
if [[ -e $case/0 && ! -e $case/1 ]]; then
    foamRun -case $case |& tee $case/log
fi


#!/bin/bash -e

# REsolutions:
# n=128, dt = 0.2
# n=128, dt = 2

case=smoothUniformNoRho/dt02_nx128
./runScripts/initOne.sh $case smooth uniform 0.2 128 false
./runScripts/runOne.sh $case
./runScripts/postOne.sh $case

case=smoothUniformNoRho/dt2_nx128
./runScripts/initOne.sh $case smooth uniform 2 128 false
./runScripts/runOne.sh $case
./runScripts/postOne.sh $case

case=smoothUniformRho/dt2_nx128
./runScripts/initOne.sh $case smooth uniform 2 128 true
./runScripts/runOne.sh $case
./runScripts/postOne.sh $case



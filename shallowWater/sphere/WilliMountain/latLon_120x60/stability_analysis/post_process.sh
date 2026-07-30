#!/bin/bash -e

#calc('0.5*h*magSqr(U) + 0.5*magg*h*h')

if [[ $# -eq 2 ]]; then 
    baseCase=$1"_"$2
else
    echo usage: post_process.sh case iterations
    exit
fi


echo "150 300 600 1800 3600 7200 10800 21600" > $baseCase/stabl_errors_energy


for alpha in 0.0001 0.00025 0.0005 0.001 0.0025 0.005 0.01 0.05 0.1 0.5 0.75 1 2 5; do
    ampls=($alpha)
    for dt in 150 300 600 1800 3600 7200 10800 21600; do
        globalSum -case $baseCase/$alpha/dt_$dt E
    done
done



for alpha in 0.0001 0.00025 0.0005 0.001 0.0025 0.005 0.01 0.05 0.1 0.5 0.75 1 2 5; do
    ampls=($alpha)
    for dt in 150 300 600 1800 3600 7200 10800 21600; do
        num=$(awk 'END {print $2}' $baseCase/$alpha/dt_$dt/globalSumE.dat)
        den=$(awk 'NR == 2 {print $2}' $baseCase/$alpha/dt_$dt/globalSumE.dat)
        ampl=$(bc <<< "scale=15; $num / $den")
        ampls+=("$ampl")
    done
    echo "${ampls[*]}" >> $baseCase/stabl_errors_energy
done

#!/bin/bash -e

if [[ $# -eq 2 ]]; then 
    splitting=$1
    its=$2
    echo $splitting $its
else
    echo usage: run_scheme.sh scheme iterations
    exit
fi

echo "Using: $(which AdImExShallowWaterFoam)"
for alpha in 0.0001 0.00025 0.0005 0.001 0.0025 0.005 0.01 0.05 0.1 0.5 0.75 1 2 5; do
    for dt in 150 300 600 1800 3600 7200 10800 21600; do
        ./setup.sh $alpha $dt $splitting $its
        echo "Using: $(which AdImExShallowWaterFoam)"
        if [[ $splitting -eq 'semi-impl' ]]; then
            CgridShallowWaterFoamSchemes -case $alpha/dt_$dt | tee $alpha/dt_$dt/log
        else
            AdImExShallowWaterFoam -case $alpha/dt_$dt | tee $alpha/dt_$dt/log
        fi
    done
done

rm -r $splitting"_"$its
mkdir $splitting"_"$its
mv 0.0001 0.00025 0.0005 0.001 0.0025 0.005 0.01 0.05 0.1 0.5 0.75 1 2 5 $splitting"_"$its/



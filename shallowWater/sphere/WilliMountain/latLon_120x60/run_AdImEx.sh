

time_steps=(10 20 50 100 300 900 1200 1800 3600)
time_steps_1=(1 10 20 50 100 300 900 1200 1800 3600)


mkdir run_AdImEx
cp -r init0/ constant/ plotting/ system/ setup.sh run_AdImEx
for dt in ${time_steps_1[@]};
do
    sed -i 's/\(deltaT[[:space:]]*\)[0-9.]\+;/\1'$dt';/' run_AdImEx/system/controlDict
    (cd run_AdImEx ; ./setup.sh)
    (cd run_AdImEx ; AdImExShallowWaterFoam >& log)
    mkdir run_AdImEx/dt_$dt
    cp -r run_AdImEx/0 run_AdImEx/3600 run_AdImEx/7200 run_AdImEx/10800 run_AdImEx/dt_$dt
    cp -r run_AdImEx/constant run_AdImEx/system run_AdImEx/dt_$dt
done



for i in {1,2,3} 
do
    for time in {3600,7200,10800}
    do
        rm run_AdImEx/dt_$time/*
        for dt in ${time_steps_1[@]};
        do
            cp run_AdImEx/dt_$dt/$time/h run_AdImEx/$time/h_$dt
        done
    done
done


(cd run_AdImEx ; globalSum h_1)
for dt in ${time_steps_1[@]};
do
    (cd run_AdImEx ; postProcess -func "subtract(fields=(h_"$dt"  h_1),result=h_"$dt"_diff)")
    (cd run_AdImEx ; globalSum h_"$dt"_diff)
done
(cd run_AdImEx ; echo "Scheme $i" >> errors)
for hrs in {1,2,3}
do
    for j in {0,1,2,3,4,5,6,7}
    do
        j1=$((j + 1))
        echo $j $j1
        dt_1=$(cd run_AdImEx ; awk -v hrs="$hrs" 'NR==hrs+1 {print $3}' globalSumh_${time_steps[$j1]}_diff.dat)
        dt_2=$(cd run_AdImEx ; awk -v hrs="$hrs" 'NR==hrs+1 {print $3}' globalSumh_${time_steps[$j]}_diff.dat)
        result=$(python3 - <<EOF
from math import log
E1=float($dt_1)
E2=float($dt_2)
print(log(E1/E2)/log(${time_steps[$j1]}/${time_steps[$j]}))
EOF
)
        (cd run_AdImEx ; echo $hrs $j $result >> errors)
        echo "scheme = AdImEx and j = " $j " at " $hrs " hours has order " $result 
    done
    
    dt_1800=$(cd run_AdImEx ; awk -v hrs="$hrs" 'NR==hrs+1 {print $3}' globalSumh_1800_diff.dat)

    dt_900=$(cd run_AdImEx ; awk -v hrs="$hrs" 'NR==hrs+1 {print $3}' globalSumh_900_diff.dat)

    result_1=$(python3 - <<EOF
from math import log
E1800=float($dt_1800)
E900=float($dt_900)
print(log(E1800/E900)/log(2.0))
EOF
)
    
    (cd run_AdImEx ; echo $hrs $result_1 >> errors)
    echo "scheme = AdImEx at " $hrs " hours has order " $result_1  
done


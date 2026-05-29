rm -r run_scheme_*

time_steps=(10 20 50 100 300)
time_steps_1=(1 10 20 50 100 300)
intervals=(1200 2400 3600)
write_int=1200

for i in {1,2,3} 
do
    mkdir run_scheme_$i
    cp -r init0/ constant/ plotting/ system/ setup.sh run_scheme_$i
    for dt in ${time_steps_1[@]};
    do
        sed -i 's/\(deltaT[[:space:]]*\)[0-9.]\+;/\1'$dt';/' run_scheme_$i/system/controlDict
        sed -i 's/\(writeInterval[[:space:]]*\)[0-9.]\+;/\1'$write_int';/' run_scheme_$i/system/controlDict
        (cd run_scheme_$i ; ./setup.sh)
        (cd run_scheme_$i ; CgridShallowWaterFoamSplit -$i >& log)
        mkdir run_scheme_$i/dt_$dt
        for int in ${intervals[@]};
        do
            cp -r run_scheme_$i/$int run_scheme_$i/dt_$dt
        done
        cp -r run_scheme_$i/constant run_scheme_$i/system run_scheme_$i/dt_$dt
    done
done


for i in {1,2,3} 
do
    for time in ${intervals[@]};
    do
        #rm run_scheme_$i/dt_$time/*
        for dt in ${time_steps_1[@]};
        do
            cp run_scheme_$i/dt_$dt/$time/h run_scheme_$i/$time/h_$dt
        done
    done
done


for i in {1,2,3} 
do
    (cd run_scheme_$i ; globalSum h_1)
    for dt in ${time_steps[@]};
    do
        (cd run_scheme_$i ; postProcess -func "subtract(fields=(h_"$dt"  h_1),result=h_"$dt"_diff)")
        (cd run_scheme_$i ; globalSum h_"$dt"_diff)
    done
    (cd run_scheme_$i ; echo "Scheme $i" >> errors)
    for hrs in {1,2,3}
    do
        for j in {0,1,2,3}
        do
            j1=$((j + 1))
            echo $j $j1
            dt_1=$(cd run_scheme_$i ; awk -v hrs="$hrs" 'NR==hrs+1 {print $3}' globalSumh_${time_steps[$j1]}_diff.dat)
            dt_2=$(cd run_scheme_$i ; awk -v hrs="$hrs" 'NR==hrs+1 {print $3}' globalSumh_${time_steps[$j]}_diff.dat)
            result=$(python3 - <<EOF
from math import log
E1=float($dt_1)
E2=float($dt_2)
print(log(E1/E2)/log(${time_steps[$j1]}/${time_steps[$j]}))
EOF
)
            (cd run_scheme_$i ; echo $hrs ${time_steps[$j1]}" to "${time_steps[$j]} $result >> errors)
            echo "scheme = " $i " and ratio "${time_steps[$j1]}" to "${time_steps[$j]}" at " $hrs " hours has order " $result 
        done
    done
done

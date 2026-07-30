#!/bin/bash -e


declare -a schms=("semi-impl split notSplit")

for schm in ${schms[@]}; do
    for its in 1 2 3; do
        ./run_scheme.sh $schm $its
        ./post_process.sh $schm $its
        #cp stabl_plot.py $schm"_"$its/
        #(cd $schm"_"$its ; python3 stabl_plot.py)
        cp stabl_plot_against_prediction.py $schm"_"$its/
        (cd $schm"_"$its ; python3 stabl_plot_against_prediction.py $schm $its)
    done
done


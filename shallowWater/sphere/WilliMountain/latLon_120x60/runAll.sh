./setup.sh

CgridShallowWaterFoam >& log & tail -f log

# Animate output
i=0
secsPerDay=86400
DT=1
T=15
while [[ "$i" -ne "$T" ]]; do
    let i=$i+$DT
    let time=$i*secsPerDay
    ./plotting/plothU.sh $time
done

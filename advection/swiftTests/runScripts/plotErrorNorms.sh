#!/bin/bash -e

# Collect error norms in one file for each Courant number to plot
inputFiles=()
for c in 08 1p6 2 2p5 5 10; do
    echo "#dx l1 l2 linf normMass normVar" > plots/errorNorms_c${c}.dat
    let res=1
    while [ "$res" -ne 1000 ]; do
    #for res in 20 40 80 160; do
        case=cubicRK3_${res}_c${c}
        if [ -a $case/errorNorms.dat ]; then
            tail -1 $case/errorNorms.dat \
                | awk '{print 1/'$res', $2, $3, $4, $5, $6}' \
                >> plots/errorNorms_c${c}.dat
        fi
        let res=$res+1
    done
    inputFiles=(${inputFiles[*]} plots/errorNorms_c${c}.dat)
done

echo -e "#dx error\n0.01 1e-4\n0.1 .1" > plots/3rdOrder.dat
echo -e "#dx error\n0.01 1e-3\n0.1 .1" > plots/2ndOrder.dat
echo -e "#dx error\n0.01 1e-2\n0.1 .1" > plots/1stOrder.dat

inputFiles=(${inputFiles[*]} \
            plots/3rdOrder.dat  plots/2ndOrder.dat  plots/1stOrder.dat)
outFile=plots/errorNorms.eps
col=(3 3 3 3 3 3 2 2 2)
colx=1
legends=("c = 0.8" "c = 1.6" "c = 2" "c = 2.5" "c = 5" "c = 10" "1st/2nd/3rd" "" "")
pens=("black" "blue" "cyan" "red" "magenta" "grey"
      "0.25,black,1_4:0" "0.25,black,1_4:0" "0.25,black,1_4:0")
symbols=("x10p" "c10p" "a10p" "+10p" "t10p" "h10p" "" "" "")
spens=("black" "blue" "cyan" "red" "magenta" "grey" "" "" "")
xlabel='@~D@~x'
ylabel=''
xmin=0.005
xmax=0.1
dx=10
ddx=2
dxg=10
ymin=1e-5
ymax=2
dy=10
ddy=1
dyg=10
xscale=*1
yscale=*1
legPos=x6.5/0
nSkip=1
projection=X10cl/7.5cl
gv=0

. gmtPlot
ev $outFile

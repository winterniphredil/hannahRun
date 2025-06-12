#!/bin/bash -e

# Collect error norms in one file for each Courant number to plot
res=40
inputFiles=()
inputFiles2=()
for c in 08 1p6 2 2p5 5 10; do
    case=cubicRK3_${res}_c${c}
    echo 'Time minT maxT mass' > $case/errorDiags.dat
    grep goes $case/log | awk '{print $1, $5, $7, $13}' >> $case/errorDiags.dat
    inputFiles=(${inputFiles[*]} $case/errorDiags.dat $case/errorDiags.dat)
    inputFiles2=(${inputFiles2[*]} $case/errorDiags.dat)
done

outFile=plots/bounds.eps
col=(2 3 2 3 2 3 2 3 2 3 2 3)
colx=1
legends=("c = 0.8" "" "c = 1.6" "" "c = 2" "" "c = 2.5" "" "c = 5" "" "c = 10" "")
pens=("black" "black" "blue" "blue" "cyan" "cyan" "red" "red" "magenta" "magenta" "grey" "grey")
xlabel='Time'
ylabel=''
xmin=0
xmax=1
dx=0.2
ddx=0
dxg=10
ymin=-0.01
ymax=1
dy=0.1
ddy=1
dyg=10
xscale=*1
yscale=*1
legPos=x0.5/2
nSkip=1
projection=X10c/7.5c
gv=0

. gmtPlot
ev $outFile

# Plot of mass conservation
inputFiles=(${inputFiles2[*]})
outFile=plots/massError.eps
col=(4 4 4 4 4 4)
colx=1
legends=("c = 0.8" "c = 1.6" "c = 2" "c = 2.5" "c = 5" "c = 10" "")
pens=("black" "blue" "cyan" "red" "magenta" "grey")
xlabel='Time'
ylabel=''
xmin=0
xmax=1
dx=0.2
ddx=0
dxg=10
ymin=-4e-15
ymax=4e-15
dy=1e-15
ddy=1
dyg=10
xscale=*1
yscale=*1
legPos=x0.5/4.5
nSkip=1
projection=X10c/7.5c
gv=0

. gmtPlot
ev $outFile

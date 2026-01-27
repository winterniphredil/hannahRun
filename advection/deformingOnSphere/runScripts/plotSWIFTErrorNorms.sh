#!/bin/bash -e

if [ "$#" -ne 0 ]
then
   echo usage: plotSWIFTErrorNorms.sh
   exit
fi

var=T
case=SWIFT
outFile=plots/${var}errorNorms_${case}.eps

mkdir -p plots
inputFiles=($case/T_smoothvaryDensitydeforming_noLim_errorNorms.dat \
            plots/3rdOrder.dat  plots/2ndOrder.dat  plots/1stOrder.dat)

echo -e "#dx error\n 0.01 1e-1 \n 0.1 1" > plots/1stOrder.dat
echo -e "#dx error\n 0.01 1e-2 \n 0.1 1" > plots/2ndOrder.dat
echo -e "#dx error\n 0.01 1e-3 \n 0.1 1" > plots/3rdOrder.dat

col=(2  2 2 2)
colx=1
legends=("SWIFT lat-lon" "1st/2nd/3rd" "" "")
pens=("black"   "0.25,black,1_4:0"
      "0.25,black,1_4:0" "0.25,black,1_4:0" "0.25,black,1_4:0")
symbols=("x7p" "" "" "" "")
xlabel='max @~D f@~'
ylabel=''
xmin=0.5
xmax=5
dx=2
#ddx=1
#dxg=10
ymin=4e-4
ymax=1
dy=10
#ddy=1
dyg=0
xscale=*57.295779513
yscale=*1
legPos=x6/0.1
nSkip=1
projection=X10cl/7.5cl
gv=0

. gmtPlot
ev $outFile

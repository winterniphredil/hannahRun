#!/bin/bash -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/runScripts.sh

initRun latLon_30_Full 120 slotted deforming 0.005 cubicUpwind RK3 1 #plot
postOne latLon_30_Full/240x120/slotteddeforming/dt_0p005_cubicUpwind_RK3_FCT1 plot
initRun latLon_30_Full 120 slotted deforming 0.005 quinticUpwind RK4 1 #plot
postOne latLon_30_Full/240x120/slotteddeforming/dt_0p005_quinticUpwind_RK4_FCT1 plot

initRun latLon_30_Full 240 slotted deforming 0.0025 quinticUpwind RK4 1 #plot
postOne latLon_30_Full/480x240/slotteddeforming/dt_0p0025_quinticUpwind_RK4_FCT1 plot

initRun latLon_0_Full 240 slotted deforming 0.0025 quinticUpwind RK4 1 #plot
postOne latLon_0_Full/480x240/slotteddeforming/dt_0p0025_quinticUpwind_RK4_FCT1 plot

initRun latLon_0_Skip 240 slotted deforming 0.0025 quinticUpwind RK4 1 #plot
postOne latLon_0_Skip/480x240/slotteddeforming/dt_0p0025_quinticUpwind_RK4_FCT1 plot

initRun cubedSphere 30 slotted deforming 0.01 quinticUpwind RK4 1 #plot
postOne cubedSphere/30x30x6/slotteddeforming/dt_0p01_quinticUpwind_RK4_FCT1 plot

initRun cubedSphere 120 slotted deforming 0.0025 quinticUpwind RK4 1 #plot
postOne cubedSphere/120x120x6/slotteddeforming/dt_0p0025_quinticUpwind_RK4_FCT1 plot

initRun hexagonal 5 slotted deforming 0.02 quinticUpwind RK4 1 plot
postOne  hexagonal/hex5/slotteddeforming/dt_0p02_quinticUpwind_RK4_FCT1 plot

initRun hexagonal 8 slotted deforming 0.0025 quinticUpwind RK4 1 plot
postOne  hexagonal/hex8/slotteddeforming/dt_0p0025_quinticUpwind_RK4_FCT1 plot


#!/bin/bash -e

# Test cases described in Bendall and Kent 2024 (SWIFT)

# u=10, L=1000, c = 2u dt/dx = 2u dt nx/L = dt nx 2/100

# Check for consistency (T==1 or uniT) yes
# Check using rho==1  yes
# Check order of convergence in space and time
# Mass conservation?

# noDensity is 3rd order for c~0.5
# withDensity is 3rd order for c~0.5, but a bit less accurate

# withDensity with rho==0.8 has identical error to noDensity
# with rho varying like T, is it the same as noRho?
# withDensity with rho varying and T==1, does T stay 1? yes

# For c~1.6, noDensity is better than 2nd order. withDensity is same order
# noDensity c2p6 1st order (alpha=0.609375, gamma=0.990854). Same as withDensit

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/runScripts.sh

# Convergence runs (with density)
initRunPost smoothUniformDensity/c05/nx032  smooth uniform withDensity 0.8 32 noPlot 0
initRunPost smoothUniformDensity/c05/nx064  smooth uniform withDensity 0.4 64 noPlot 0
initRunPost smoothUniformDensity/c05/nx128 smooth uniform withDensity 0.2 128 noPlot 0

initRunPost smoothUniformDensity/c1p6/nx032 smooth uniform withDensity 2.5 32 noPlot 0
initRunPost smoothUniformDensity/c1p6/nx064 smooth uniform withDensity 1.25 64 noPlot 0
initRunPost smoothUniformDensity/c1p6/nx128 smooth uniform withDensity 0.625 128 noPlot 0

initRunPost smoothUniformDensity/c2/nx025   smooth uniform withDensity 4 25 noPlot 0
initRunPost smoothUniformDensity/c2/nx050   smooth uniform withDensity 2 50 noPlot 0
initRunPost smoothUniformDensity/c2/nx100   smooth uniform withDensity 1 100 noPlot 0

initRunPost smoothUniformDensity/c2p1/nx026   smooth uniform withDensity 4 26 noPlot 0
initRunPost smoothUniformDensity/c2p1/nx052   smooth uniform withDensity 2 52 noPlot 0
initRunPost smoothUniformDensity/c2p1/nx104   smooth uniform withDensity 1 104 noPlot 0

initRunPost smoothUniformDensity/c2p6/nx032 smooth uniform withDensity 4 32 noPlot 0
initRunPost smoothUniformDensity/c2p6/nx064 smooth uniform withDensity 2 64 noPlot 0
initRunPost smoothUniformDensity/c2p6/nx128 smooth uniform withDensity 1 128 noPlot 0

initRunPost smoothUniformDensity/c5p1/nx026 smooth uniform withDensity 10 26 noPlot 0
initRunPost smoothUniformDensity/c5p1/nx064 smooth uniform withDensity 4 64 noPlot 0
initRunPost smoothUniformDensity/c5p1/nx128 smooth uniform withDensity 2 128 noPlot 0

initRunPost smoothUniformDensity/c10/nx050 smooth uniform withDensity 10 50 noPlot 0
initRunPost smoothUniformDensity/c10/nx100 smooth uniform withDensity 5 100 noPlot 0
initRunPost smoothUniformDensity/c10/nx200 smooth uniform withDensity 4 200 noPlot 0

# convergence plot
./runScripts/plotErrorNorms.sh rho

# Slotted cylinder cases
initRunPost slottedUniform_noDensity/c05/nx032 slotted uniform noDensity 0.8 32 plot 0
initRunPost slottedUniform_noDensity/c05/nx064 slotted uniform noDensity 0.4 64 plot 0
initRunPost slottedUniform_noDensity/c05/nx128 slotted uniform noDensity 0.2 128 plot 0
initRunPost slottedUniform_density/c05/nx128 slotted uniform withDensity 0.2 128 plot 0
initRunPost slottedUniform_noDensityFCT/c05/nx128 slotted uniform noDensity 0.2 128 plot 1

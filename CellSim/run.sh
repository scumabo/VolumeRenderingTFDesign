#!/bin/bash

echo Demo 1D:
    
mkdir -p  ./results/1D/manix
mkdir -p  ./results/1D/fuel
mkdir -p  ./results/1D/turbulent_combustion

# Demo1D on three datasets takes ~30 seconds to run
matlab -nodisplay -nosoftwareopengl -r \
  "demo1D('manix.raw', './results/1D/manix'); \
  demo1D('fuel.raw', './results/1D/fuel'); \
  demo1D('turbulent_combustion.raw', './results/1D/turbulent_combustion')"

echo Demo 2D:
    
mkdir -p  ./results/2D/bonsai
mkdir -p  ./results/2D/tooth

# Demo2D on the tooth dataset takes about 50 minutes to run (using similarity_map2D)
matlab -nodisplay -nosoftwareopengl -r \
  "demo2D('tooth.raw', './results/2D/tooth')"

# Demo2D on the bonsai dataset takes about 12 hours to run (using similarity_map2D_loop)
  matlab -nodisplay -nosoftwareopengl -r \
  "demo2D('bonsai.raw', './results/2D/bonsai')"

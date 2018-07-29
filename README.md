# VolumeRenderingTFDesign
This repository implements the methods described in [1] that are 1. Hierarchical Cell-based Feature Similarity Map, 2. Feature Classification, and 3. Feature Visibility for TF Design.

## 1. Hierarchical Cell-based Feature Similarity Map (/CellSim)
Hit "Run" button to execute the shell script "run.sh". By default, both "demo1D" and "demo2D" will be run for all the experimented datasets in [1]. To run just one or the other script, or selected datasets, please comment out corresponding lines in run.sh OR directly type commend in MATLAB.

## 2. Feature Classification (/FeatureClassification)
1. In MATLAB, run "play.m" to display the interactive interface. For example, leave everything as default to run the experiment for the manix dataset; "set # of initial medoids:" to "13" and hit "do clustering". The similarity table is pre-computed for manix dataset and needs to be computed for another dataset.

2. For 2D classfication, select tooth or bonsai dataset and check the box "2D TF (gradient)". Do clustering similar to Step 1.

## 3. Feature Visibility for TF Design (/FeatureVisOpacityAdj)

1. Download the source code of Voreen 4.4 (https://www.uni-muenster.de/Voreen/download/index.html). Follow the Voreen 4.4 instructions (https://www.uni-muenster.de/Voreen/documentation/build_instructions.html) to build Voreen 4.4 on your preferred platform.

2. Replace the Voreen source files with the provided source files (in folder). To generate the experiments for tooth (2D TF), bonsai (2D TF), or fuel (1D TF), open "include/configuration.h" to uncomment the desired data. For example, uncomment "include config_tooth.h".

3. Rebuild Voreen as in Step 1.

4. In Voreen, Open the workspace for the tooth dataset (File -> Open Workspace... -> tooth.vws). For interative opacity adjustment, select the "SingleVolumeRaycaster" in the network graph. In "Properties", open the popup menu for "Classification" and select "Opacity Adjustment".

[1] Ma, B.; Entezari, A.; Volumetric Feature-Based Classification and Visibility Analysis for Transfer Function Design, IEEE Transactions on Visualization and Computer Graphics (TVCG), to appear.

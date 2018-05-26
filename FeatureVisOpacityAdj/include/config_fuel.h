#ifndef CONFIG_FUEL_H
#define CONFIG_FUEL_H

static float maxValue = 1;
static float IntensityMax = 255;
static float GradientMax = 72;
static float IntensityCut = 255;  // used to show clusters
static float GradientCut = 72;   // used to show clusters
static tgt::vec2 isoGradientvalue[] = {tgt::vec2(40, 36), tgt::vec2(127, 43), tgt::vec2(119, 25), tgt::vec2(209, 36) , tgt::vec2(39, 19), tgt::vec2(139, 70), tgt::vec2(147, 63)};
static std::string imageFilename = "../../../resource/ClusterMaps/tooth_Clusters_7.png";
static float tmpTable[4][4] = {{0, 0.8058, 0.8408, 1},
{0.8058, 0, 0.5222, 1},
{0.8408, 0.5222, 0, 1},
{1, 1, 1, 0}	};


// overlap approximate + equal initial:  no thresh, k = 6, width = 1/100
static const int NumIso = 6;
static float iniOpacity[NumIso]; 
static int examplar[] = {21, 60, 104, 154, 200, 237};
static tgt::col3 colors[] = {tgt::col3(184,225,13), tgt::col3(253,174,107), tgt::col3(255,237,160), tgt::col3(255,0,0), tgt::col3(0, 0, 255), tgt::col3(136,86,167)};
static std::string fileName = "../../../resource/metrics/fuel_proposed_overlap.csv";
static int row_dim = 254;
static int col_dim = 254;
static float T_length = 254.0;
static const int max_feature = 8;

#endif //CONFIG_FUEL_H
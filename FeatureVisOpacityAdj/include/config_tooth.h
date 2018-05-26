#ifndef CONFIG_TOOTH_H
#define CONFIG_TOOTH_H

static const int NumIso = 4;
static int examplar[] = {9, 26, 46};
static float iniOpacity[NumIso];
static float tmpTable[NumIso][NumIso] = {{0, 0.8058, 0.8408, 1},
{0.8058, 0, 0.5222, 1},
{0.8408, 0.5222, 0, 1},
{1, 1, 1, 0}	};
static float maxValue = 1;
static float IntensityMax = 255;
static float GradientMax = 72;
static float IntensityCut = 255;  // used to show clusters
static float GradientCut = 72;   // used to show clusters
static tgt::vec2 isoGradientvalue[] = {tgt::vec2(40, 36), tgt::vec2(127, 43), tgt::vec2(119, 25), tgt::vec2(209, 36) , tgt::vec2(39, 19), tgt::vec2(139, 70), tgt::vec2(147, 63)};
static std::string fileName = "../../../resource/metrics/tooth_proposed_overlap.csv";
static std::string imageFilename = "../../../resource/ClusterMaps/tooth_Clusters_7.png";
static int row_dim = 254;
static int col_dim = 254;
static float T_length = 254.0;
static const int max_feature = 8;
static tgt::col3 colors[] = {tgt::col3(43,131,186), tgt::col3(215,25,28), tgt::col3(227,146,100), tgt::col3(171,221,164), tgt::col3(153,213,148) , tgt::col3(50,136,189)};


#endif //CONFIG_TOOTH_H
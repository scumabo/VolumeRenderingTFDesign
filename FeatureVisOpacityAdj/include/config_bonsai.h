#ifndef CONFIG_BONSAI_H
#define CONFIG_BONSAI_H

// bonsai 2D statistics: In 2D feature space [0, 1] maps to [0, max]
static const int NumIso = 3;
static int examplar[] = {9, 26, 46};
static float iniOpacity[NumIso];
static float tmpTable[NumIso][NumIso] = {{0, 1-0.0432, 1},
											{1-0.0432, 0, 1},
											{1, 1, 0}	}; 
static float maxValue = 1;
static float IntensityMax = 255;
static float GradientMax = 140.1;
static float IntensityCut = 230;  // used to show clusters
static float GradientCut = 101;   // used to show clusters
static tgt::vec2 isoGradientvalue[] = {tgt::vec2(27, 25), tgt::vec2(56, 41), tgt::vec2(113, 31), tgt::vec2(179, 42), tgt::vec2(75, 74), tgt::vec2(160, 92)};
static std::string fileName = "../../../resource/metrics/bonsai128_lookup_table_hd_max.csv";
static std::string imageFilename = "../../../resource/ClusterMaps/bonsai_Clusters_3.png";
static int row_dim = 254;
static int col_dim = 254;
static float T_length = 254.0;
static const int max_feature = 8;
static tgt::col3 colors[] = {tgt::col3(58,95,11), tgt::col3(223,194,128), tgt::col3(166,97,26), tgt::col3(230,245,152), tgt::col3(153,213,148) , tgt::col3(50,136,189)};

#endif //CONFIG_BONSAI_H
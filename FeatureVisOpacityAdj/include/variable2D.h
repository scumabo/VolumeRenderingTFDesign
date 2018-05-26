#ifndef VARIABLE2D_H
#define VARIABLE2D_H

inline float getIso(float i) {return (float)i/255;}
	
	// manix128 2D statistics: In 2D feature space [0, 1] maps to [0, max]
/*	static const int NumIso = 3;
	static float iniOpacity[NumIso];
	static float IntensityMax = 255;
	static float GradientMax = 199.5;
	static float IntensityCut = 151;  // used to show clusters
	static float GradientCut = 101;   // used to show clusters
	static tgt::vec2 isoGradientvalue[] = {tgt::vec2(35, 60), tgt::vec2(7, 28), tgt::vec2(28, 19), tgt::vec2(51, 32), tgt::vec2(88, 27), tgt::vec2(30, 87), tgt::vec2(108, 92), tgt::vec2(113, 72), tgt::vec2(116, 55), tgt::vec2(113, 42)};
	static std::string fileName = "D:/Documents/Research Papers/Research 2014/Vis15/Data/metrics/bonsai128_lookup_table_hd_max.csv";
	static std::string imageFilename = "D:/Documents/ClusterMaps/manix128_Clusters_10.png";
	static int row_dim = 254;
	static int col_dim = 254;
	static float T_length = 254.0;
	static const int max_feature = 8;
	static tgt::col3 colors[] = {tgt::col3(213,62,79), tgt::col3(252,141,89), tgt::col3(254,224,139), tgt::col3(230,245,152), tgt::col3(153,213,148) , tgt::col3(50,136,189), tgt::col3(50,136,189), tgt::col3(50,136,189),tgt::col3(50,136,189), tgt::col3(50,136,189)};
	*/

	// bonsai 2D statistics: In 2D feature space [0, 1] maps to [0, max]
/*	static const int NumIso = 3;
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
	static std::string fileName = "D:/Documents/Research Papers/Research 2014/Vis15/Data/metrics/bonsai128_lookup_table_hd_max.csv";
	static std::string imageFilename = "D:/Documents/ClusterMaps/bonsai_Clusters_3.png";
	static int row_dim = 254;
	static int col_dim = 254;
	static float T_length = 254.0;
	static const int max_feature = 8;
//	static tgt::col3 colors[] = {tgt::col3(58,95,11), tgt::col3(223,194,128), tgt::col3(128, 205, 193), tgt::col3(94, 60, 153), tgt::col3(44, 123, 182) , tgt::col3(166, 97, 26)};
	static tgt::col3 colors[] = {tgt::col3(58,95,11), tgt::col3(223,194,128), tgt::col3(166,97,26), tgt::col3(230,245,152), tgt::col3(153,213,148) , tgt::col3(50,136,189)};
	*/

	// tooth 2D statistics: In 2D feature space [0, 1] maps to [0, max]

	static const int NumIso = 4;
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
	static std::string fileName = "D:/Documents/Research Papers/Research 2014/Vis15/Data/metrics/bonsai128_lookup_table_hd_max.csv";
	static std::string imageFilename = "D:/Documents/ClusterMaps/tooth_Clusters_7.png";
	static int row_dim = 254;
	static int col_dim = 254;
	static float T_length = 254.0;
	static const int max_feature = 8;
	static tgt::col3 colors[] = {tgt::col3(43,131,186), tgt::col3(215,25,28), tgt::col3(227,146,100), tgt::col3(171,221,164), tgt::col3(153,213,148) , tgt::col3(50,136,189)};
	
	
	// engine 2D statistics: In 2D feature space [0, 1] maps to [0, max]
/*	static const int NumIso = 6;
	static float iniOpacity[NumIso]; 
	static float IntensityMax = 255;
	static float GradientMax = 154;
	static float IntensityCut = 255;  // used to show clusters
	static float GradientCut = 154;   // used to show clusters
	static tgt::vec2 isoGradientvalue[] = {tgt::vec2(27, 25), tgt::vec2(43, 56), tgt::vec2(53, 89), tgt::vec2(119, 36), tgt::vec2(142, 78), tgt::vec2(202, 53)};
	static std::string fileName = "D:/Documents/Research Papers/Research 2014/Vis15/Data/metrics/bonsai128_lookup_table_hd_max.csv";
	static std::string imageFilename = "D:/Documents/ClusterMaps/bonsai_Clusters_6.png";
	static int row_dim = 254;
	static int col_dim = 254;
	static float T_length = 254.0;
	static const int max_feature = 8;
	static tgt::col3 colors[] = {tgt::col3(213,62,79), tgt::col3(252,141,89), tgt::col3(254,224,139), tgt::col3(230,245,152), tgt::col3(153,213,148) , tgt::col3(50,136,189)};
	*/

	// carp1 2D statistics: In 2D feature space [0, 1] maps to [0, max]
/*	static const int NumIso = 6;
	static float iniOpacity[NumIso];
	static float IntensityMax = 188;
	static float GradientMax = 118.4;
	static float IntensityCut = 131;  // used to show clusters
	static float GradientCut = 81;   // used to show clusters
	static tgt::vec2 isoGradientvalue[] = {tgt::vec2(42, 75), tgt::vec2(23, 48), tgt::vec2(73, 27), tgt::vec2(115, 66) , tgt::vec2(101, 43), tgt::vec2(118, 21)};
	static std::string fileName = "D:/Documents/Research Papers/Research 2014/Vis15/Data/metrics/bonsai128_lookup_table_hd_max.csv";
	static std::string imageFilename = "D:/Documents/ClusterMaps/carp1_Clusters_6.png";
	static int row_dim = 254;
	static int col_dim = 254;
	static float T_length = 254.0;
	static const int max_feature = 8;
	static tgt::col3 colors[] = {tgt::col3(213,62,79), tgt::col3(252,141,89), tgt::col3(254,224,139), tgt::col3(230,245,152), tgt::col3(153,213,148) , tgt::col3(50,136,189)};
	*/

	// feeet 2D statistics: In 2D feature space [0, 1] maps to [0, max]
/*	static const int NumIso = 4;
	static float iniOpacity[NumIso];
	static float tmpTable[NumIso][NumIso] = {{0, 1-0.0432, 1},
											 {1-0.0432, 0, 1},
											 {1, 1, 0}	};
	static float maxValue = 1;
	static float IntensityMax = 254;
	static float GradientMax = 93.08;
	static float IntensityCut = 254;  // used to show clusters
	static float GradientCut = 71;   // used to show clusters
	static tgt::vec2 isoGradientvalue[] = {tgt::vec2(50, 30), tgt::vec2(172, 54), tgt::vec2(130, 31), tgt::vec2(222, 52) , tgt::vec2(173, 58), tgt::vec2(118, 21)};
	static std::string fileName = "D:/Documents/Research Papers/Research 2014/Vis15/Data/metrics/bonsai128_lookup_table_hd_max.csv";
	static std::string imageFilename = "D:/Documents/ClusterMaps/feet_Clusters_4.png";
	static int row_dim = 254;
	static int col_dim = 254;
	static float T_length = 254.0;
	static const int max_feature = 8;
	static tgt::col3 colors[] = {tgt::col3(43,131,186), tgt::col3(215,25,28), tgt::col3(227,146,100), tgt::col3(171,221,164), tgt::col3(153,213,148) , tgt::col3(50,136,189)};
	*/

//	static float isoArea[] = {41668, 22439, 10954, 2210};
//	static float isovalue[] = {getIso(4), getIso(13), getIso(28), getIso(58)};
	/* specify isosurfaces */
	/* neghip 6: 7, 24, 51, 92, 149, 221*/
//	static float isovalue[] = {getIso(16), getIso(57), getIso(115), getIso(221)};
//	static float isovalue[] = {getIso(16), getIso(57), getIso(221)};
	

//	static float isovalue[] = { getIso(7), getIso(24), getIso(51),getIso(92), getIso(149), getIso(221)};

	/* engine2: 78, 191, 245 */
//	static float isovalue[] = {getIso(4), getIso(13), getIso(28), getIso(58)};
//	static float isovalue[] = {getIso(4), getIso(13), getIso(30), getIso(40), getIso(78), getIso(160), getIso(200), getIso(191), getIso(245) };
	/* hydrogen: 4, 13, 28, 58, */
	

	/* neghip */
/*	static int examplar[] = {20, 71, 140, 219};
    static float isovalue[] = {getIso(20), getIso(71), getIso(140), getIso(219)};
	static tgt::col3 colors[] = {tgt::col3(255,255,153), tgt::col3(255,255,0), tgt::col3(0,0,255), tgt::col3(255,0,0)};  /* 4 */

	/* manix128 */
	// HD
/*	static int examplar[] = {24, 52, 66, 87, 124};
    static float isovalue[] = {getIso(24), getIso(52), getIso(66), getIso(87), getIso(124)};
	static tgt::col3 colors[] = {tgt::col3(158,202,225), tgt::col3(49,130,189), tgt::col3(255, 0, 0), tgt::col3(227, 146, 100), tgt::col3(227, 146, 100)}; 
	*/
	
	// HD split 87
/*	static int examplar[] = {24, 52, 66, 81, 93};
    static float isovalue[] = {getIso(24), getIso(52), getIso(66), getIso(81), getIso(93)};
	static tgt::col3 colors[] = {tgt::col3(158,202,225), tgt::col3(49,130,189), tgt::col3(255, 0, 0), tgt::col3(227, 146, 100), tgt::col3(227, 146, 100)};
	*/
	// new proposed
/*	static int examplar[] = {27, 50, 74, 95};
    static float isovalue[] = {getIso(27), getIso(50), getIso(74), getIso(95)};
	static tgt::col3 colors[] = {tgt::col3(158,202,225), tgt::col3(49,130,189), tgt::col3(255, 0, 0), tgt::col3(227, 146, 100)};
	*/
	// meanHD
/*	static int examplar[] = {27, 50, 68, 88};
    static float isovalue[] = {getIso(27), getIso(50), getIso(68), getIso(88)};
	static tgt::col3 colors[] = {tgt::col3(158,202,225), tgt::col3(49,130,189), tgt::col3(255, 0, 0), tgt::col3(227, 146, 100)};
	static std::string fileName = "D:/Documents/Research Papers/Research 2014/Vis15/Data/metrics/manix128_lookup_table_hd_mean.csv";
	static int row_dim = 255;
	static int col_dim = 255;
	static float T_length = 255.0;
	static const int max_feature = 8;
	*/

	// 2D
/*	static int examplar[] = {24, 52, 66, 87, 124};
    static float isovalue[] = {getIso(24), getIso(52), getIso(66), getIso(87), getIso(124)};
	static tgt::col3 colors[] = {tgt::col3(158,202,225), tgt::col3(49,130,189), tgt::col3(255, 0, 0), tgt::col3(227, 146, 100), tgt::col3(227, 146, 100)}; 
*/

	/* hydrogen */
/*	static int examplar[] = {9, 26, 46};
    static float isovalue[] = {getIso(9), getIso(26), getIso(46)};
	static tgt::col3 colors[] = {tgt::col3(158,202,225), tgt::col3(49,130,189), tgt::col3(255, 0, 0)};
	*/
/*
	static int examplar[] = {9, 26, 46};
    static float isovalue[] = {getIso(9), getIso(26), getIso(46)};
	static tgt::col3 colors[] = {tgt::col3(158,202,225), tgt::col3(49,130,189), tgt::col3(255, 0, 0)};
	*/
	/* supernova128 */
/*	static int examplar[] = {27, 102, 150};
    static float isovalue[] = {getIso(27), getIso(102), getIso(150)};
	static tgt::col3 colors[] = {tgt::col3(158,202,225), tgt::col3(49,130,189), tgt::col3(255, 0, 0)};
	*/

	/*mean HD */
/*	static int examplar[] = {70, 92, 118, 146, 169};
	static float isovalue[] = {getIso(70), getIso(92), getIso(118), getIso(146), getIso(169)};
	static tgt::col3 colors[] = {tgt::col3(247,252,185), tgt::col3(173,221,142), tgt::col3(201,148,199), tgt::col3(0, 0, 255), tgt::col3(254,178,76)};
	*/

	/* split 175 */
/*	static int examplar[] = {69, 92, 119, 147, 168, 181};
	static float isovalue[] = {getIso(69), getIso(92), getIso(119), getIso(147), getIso(168), getIso(181)};
	static tgt::col3 colors[] = {tgt::col3(0,0,255), tgt::col3(0,0,255), tgt::col3(117,107,17), tgt::col3(0, 255,0), tgt::col3(255,255,0), tgt::col3(255,255,0)};
	*/
/*	static int examplar[] = {71, 104, 150, 174};
    static float isovalue[] = {getIso(71), getIso(104), getIso(150), getIso(174)};
	static tgt::col3 colors[] = {tgt::col3(0,0,255), tgt::col3(117,107,17), tgt::col3(0, 255,0), tgt::col3(255,255,0)};

	/* split 174 to 174, 177 */
/*	static int examplar[] = {71, 104, 150, 174, 175, 177};
    static float isovalue[] = {getIso(71), getIso(104), getIso(150), getIso(174), getIso(175), getIso(177)};
	static tgt::col3 colors[] = {tgt::col3(0,0,255), tgt::col3(117,107,17), tgt::col3(0, 255,0), tgt::col3(255,255,0), tgt::col3(255,255,0), tgt::col3(255,255,0)};
	*/
	/* Combustion */
	static int examplar[] = {18, 83, 162, 220};
    static float isovalue[] = {getIso(18), getIso(83), getIso(162), getIso(220)};
//	static tgt::col3 colors[] = {tgt::col3(255,0,0), tgt::col3(255,255,0), tgt::col3(0, 255, 0), tgt::col3(0, 0, 255)};
	
	/* meanHD */
/*	static int examplar[] = {35, 104, 170, 231};
    static float isovalue[] = {getIso(35), getIso(104), getIso(170), getIso(231)};
	static tgt::col3 colors[] = {tgt::col3(255,0,0), tgt::col3(255,255,0), tgt::col3(0, 255, 0), tgt::col3(0, 0, 255)};
	*/

	/* Fuel */
 	/*mean HD */
/*	static int examplar[] = {19, 57, 110, 158, 204};
	static float isovalue[] = {getIso(19), getIso(57), getIso(110), getIso(158), getIso(204)};
	static tgt::col3 colors[] = {tgt::col3(253,174,107), tgt::col3(255,237,160), tgt::col3(173,221,142), tgt::col3(158, 188, 218), tgt::col3(136,86,167)};
	*/

	/* bonsai */
	/*proposed */
/*	static int examplar[] = {78, 151, 219};
    static float isovalue[] = {getIso(78), getIso(151), getIso(219)};
	static tgt::col3 colors[] = {tgt::col3(161,217,155), tgt::col3(49,163,84), tgt::col3(217, 95, 14)};
	*/



	/* assign colors */
//	static tgt::col3 colors[] = {tgt::col3(158,202,225), tgt::col3(49,130,189), tgt::col3(255, 0, 0), tgt::col3(227, 146, 100)};
//	static tgt::col3 colors[] = {tgt::col3(227, 74, 51), tgt::col3(227, 146, 100)};
//	static tgt::col3 colors[] = {tgt::col3(255, 255, 0), tgt::col3(0, 255, 255), tgt::col3(255, 0, 255)};  /* 3 */
//	static tgt::col3 colors[] = {tgt::col3(255, 0, 0), tgt::col3(0, 255, 0), tgt::col3(0, 0, 255), tgt::col3(255, 255, 0)};  /* 3 */
//	static tgt::col3 colors[] = {tgt::col3(255,255,153), tgt::col3(255,255,0), tgt::col3(0,0,255), tgt::col3(255,0,0)};  /* 4 */
//	static tgt::col3 colors[] = {tgt::col3(215,25,28), tgt::col3(253,174,97), tgt::col3(255,255,191), tgt::col3(171,221,164), tgt::col3(43,131,186)};  /* 5 */
//	static tgt::col3 colors[] = {tgt::col3(213,62,79), tgt::col3(252,141,89), tgt::col3(254,224,139), tgt::col3(230,245,152), tgt::col3(153,213,148) , tgt::col3(50,136,189)};  /* 6 */
//	static tgt::col3 colors[] = {tgt::col3(213,62,79), tgt::col3(252,141,89), tgt::col3(254,224,139), tgt::col3(255,255,191), tgt::col3(230,245,152), tgt::col3(153,213,148) , tgt::col3(50,136,189), tgt::col3(255,0,0), tgt::col3(0,0,255)};  /* 7 */
//	static tgt::col3 colors[] = {tgt::col3(213,62,79), tgt::col3(244,109,67), tgt::col3(253,174,97), tgt::col3(254,224,139), tgt::col3(230,245,152), tgt::col3(171,221,164) , tgt::col3(102,194,165) ,tgt::col3(50,136,189)};  /* 7 */



#endif
/***********************************************************************************
 *                                                                                 *
 * Voreen - The Volume Rendering Engine                                            *
 *                                                                                 *
 * Copyright (C) 2005-2013 University of Muenster, Germany.                        *
 * Visualization and Computer Graphics Group <http://viscg.uni-muenster.de>        *
 * For a list of authors please refer to the file "CREDITS.txt".                   *
 *                                                                                 *
 * This file is part of the Voreen software package. Voreen is free software:      *
 * you can redistribute it and/or modify it under the terms of the GNU General     *
 * Public License version 2 as published by the Free Software Foundation.          *
 *                                                                                 *
 * Voreen is distributed in the hope that it will be useful, but WITHOUT ANY       *
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR   *
 * A PARTICULAR PURPOSE. See the GNU General Public License for more details.      *
 *                                                                                 *
 * You should have received a copy of the GNU General Public License in the file   *
 * "LICENSE.txt" along with this file. If not, see <http://www.gnu.org/licenses/>. *
 *                                                                                 *
 * For non-commercial academic use see the license exception specified in the file *
 * "LICENSE-academic.txt". To get information about commercial licensing please    *
 * contact the authors.                                                            *
 *                                                                                 *
 ***********************************************************************************/

#include "modules/mod_sampler2d.frag"
#include "modules/mod_sampler3d.frag"
#include "modules/mod_transfunc.frag"

#include "modules/mod_raysetup.frag"
#include "modules/mod_depth.frag"
#include "modules/mod_compositing.frag"
#include "modules/mod_gradients.frag"
#include "modules/mod_shading.frag"

// variables for storing compositing results
vec4 result = vec4(0.0);

// store visibility values for the current rendering
vec4 result_vis_1_4 = vec4(0.0);
vec4 result_vis_5_8 = vec4(0.0);
vec4 result_vis_9_12 = vec4(0.0);

// declare entry and exit parameters
uniform sampler2D entryPoints_;            // ray entry points
uniform sampler2D entryPointsDepth_;       // ray entry points depth
uniform TextureParameters entryParameters_;

uniform sampler2D exitPoints_;             // ray exit points
uniform sampler2D exitPointsDepth_;        // ray exit points depth
uniform TextureParameters exitParameters_;

uniform float samplingStepSize_;

uniform TransFuncParameters transferFunc_;
uniform TF_SAMPLER_TYPE transferFuncTex_;
uniform float isoValue_;

uniform float gammaValue_;                      // used for MIDA raycasting
uniform float gammaValue1_;                     // used for MIDA raycasting
uniform float gammaValue2_;                     // used for MIDA raycasting

// declare volume
uniform VolumeParameters volumeStruct_;
uniform sampler3D volume_;    // volume data with parameters

// load parameters
uniform sampler2D simlarity_;
uniform float maxValue_;
uniform float T_length;
uniform int NumIso;

const int max_feature = 8; // maxfeature = 8
uniform float examplars[max_feature];
uniform vec3 feature_colors[max_feature];

float vis_scale = 10;    // make sure visbility < 1.0
/***
 * Performs the ray traversal
 * returns the final fragment color.
 ***/
void rayTraversal(in vec3 first, in vec3 last, float entryDepth, float exitDepth) {

	// Bo: Maximum feature is 8 (default)
	float Visibility[max_feature] = float[](0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	float cumulateOpacity[max_feature] = float[](0.0,0.0,0.0,0.0, 0.0, 0.0, 0.0, 0.0);

    // calculate the required ray parameters
    float t     = 0.0;
    float tIncr = 0.0;
    float tEnd  = 1.0;
    float tDepth = -1.0;
    float lastIntensity = 0.0f; //used for pre-integrated transfer-functions
    //TODO: transform to real-world value?

    float f_max_i = 0.0;   // used for MIDA raycasting
    float f_max_i1 = 0.0;  // used for MIDA raycasting
    float f_max_i2 = 0.0;  // used for MIDA raycasting

    vec3 rayDirection;
    raySetup(first, last, samplingStepSize_, rayDirection, tIncr, tEnd);

    bool finished = false;
    WHILE(!finished) {
        vec3 samplePos = first + t * rayDirection;
        vec4 voxel = getVoxel(volume_, volumeStruct_, samplePos);

#ifdef CLASSIFICATION_REQUIRES_GRADIENT
        // calculate gradients
        voxel.xyz = CALC_GRADIENT(volume_, volumeStruct_, samplePos);
#endif

        // apply classification
        vec4 color = RC_APPLY_CLASSIFICATION(transferFunc_, transferFuncTex_, voxel, lastIntensity);

        // if opacity greater zero, apply compositing
        if (color.a > 0.0) {
            if(t == 0.0) // the gradient fix is only need for shading purposes and will mess with 2D-TFs
                voxel.xyz = fixClipBorderGradient(samplePos, rayDirection, entryPoints_, entryParameters_);
#ifndef CLASSIFICATION_REQUIRES_GRADIENT
            else
                voxel.xyz = CALC_GRADIENT(volume_, volumeStruct_, samplePos);
#endif

		    float definedOpacity = color.a;
			for(int iso = 0; iso < NumIso; iso++)
			{
				if(color.rgb * 255 == feature_colors[iso])  // use color to separate features
				{
					// Visibility (Correa and Ma)
					Visibility[iso] += (1.0 - cumulateOpacity[iso]) * definedOpacity;
					
				} 
				
				// 1. bring geometry information
				cumulateOpacity[iso] = cumulateOpacity[iso] + (texture2D(simlarity_, vec2(voxel.a*255/T_length, examplars[iso]/T_length)).r/maxValue_)*(1.0f - cumulateOpacity[iso])*definedOpacity;
				
				// 2. without geometry information (Visibility histogram by Ma)
				// cumulateOpacity[iso] = cumulateOpacity[iso] + (1.0 - cumulateOpacity[iso])*definedOpacity;
			}
			
			// return the visibility via rendering it to the screen
			result_vis_1_4 = vec4(Visibility[0]/vis_scale, Visibility[1]/vis_scale, Visibility[2]/vis_scale, Visibility[3]/vis_scale);
			result_vis_5_8 = vec4(Visibility[4]/vis_scale, Visibility[5]/vis_scale, Visibility[6]/vis_scale, texture2D(simlarity_, vec2(1.0/T_length, examplars[0]/T_length)).r);
			//result_vis_5_8 = texture2D(simlarity_, vec2(0.0039, 0.0078));
			//result_vis_5_8 = vec4(feature_colors[3].r/255,feature_colors[3].g/255, feature_colors[3].b/255, 1 );
		
            // apply shading
            color.rgb = APPLY_SHADING(voxel.xyz, texToPhysical(samplePos, volumeStruct_), volumeStruct_.lightPositionPhysical_, volumeStruct_.cameraPositionPhysical_, color.rgb, color.rgb, vec3(1.0,1.0,1.0));

            result  = RC_APPLY_COMPOSITING(result, color, samplePos, voxel.xyz, t, samplingStepSize_, tDepth);
        }
        lastIntensity = voxel.a;

      //  Disable early ray termination for visibility computation
      //  finished = earlyRayTermination(result.a, EARLY_RAY_TERMINATION_OPACITY);
        t += tIncr;
        finished = finished || (t > tEnd);
    } END_WHILE

    gl_FragDepth = getDepthValue(tDepth, tEnd, entryDepth, exitDepth);
}

void main() {
    // fetch entry/exit points
    vec2 p = gl_FragCoord.xy * screenDimRCP_;
    vec3 frontPos = textureLookup2Dnormalized(entryPoints_, entryParameters_, p).rgb;
    vec3 backPos = textureLookup2Dnormalized(exitPoints_, exitParameters_, p).rgb;
    float entryDepth = textureLookup2Dnormalized(entryPointsDepth_, entryParameters_, p).z;
    float exitDepth = textureLookup2Dnormalized(exitPointsDepth_, exitParameters_, p).z;

    // determine whether the ray has to be casted
    if (frontPos == backPos)
        // background needs no raycasting
        discard;
    else {
        // fragCoords are lying inside the bounding box
        rayTraversal(frontPos, backPos, entryDepth, exitDepth);
    }

    #ifdef OP0
        FragData0 = result_vis_1_4;
    #endif
    #ifdef OP1
        FragData1 = result_vis_5_8;
    #endif
    #ifdef OP2
        FragData2 = result;
    #endif
}

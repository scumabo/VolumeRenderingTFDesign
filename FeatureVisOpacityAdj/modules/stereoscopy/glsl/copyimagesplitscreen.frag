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

uniform vec2 screenDim_;
uniform vec2 screenDimRCP_;
 
uniform sampler2D colorTexLeft_;
uniform sampler2D colorTexRight_;

uniform sampler2D depthTexLeft_;
uniform sampler2D depthTexRight_;

uniform bool useDepthTexLeft_;
uniform bool useDepthTexRight_;

void main() {
    if(gl_FragCoord.x < screenDim_.x){//left part of screen 
        vec2 fragCoord = gl_FragCoord.xy * screenDimRCP_;
        vec4 fragColor = texture2D(colorTexLeft_, fragCoord);
        FragData0 = fragColor;
        if(useDepthTexLeft_)
            gl_FragDepth = texture2D(depthTexLeft_, fragCoord).z;
  
    } else {//right part of screen   
        vec2 fragCoord = (gl_FragCoord.xy-ivec2(screenDim_.x,0)) * screenDimRCP_;
        vec4 fragColor = texture2D(colorTexRight_, fragCoord);
        FragData0 = fragColor;        
        if(useDepthTexRight_)
            gl_FragDepth = texture2D(depthTexRight_, fragCoord).z;
    }    
}
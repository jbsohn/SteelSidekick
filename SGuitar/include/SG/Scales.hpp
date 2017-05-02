//
//  Scales.h
//  SGuitar
//
//  Created by John Sohn on 2/22/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef __Scales_h__
#define __Scales_h__

#include "ScaleType.hpp"

#ifdef __cplusplus
#include <vector>
#include <string>

namespace SG {
    //
    // storage container for the scales
    //
    class Scales {
    protected:
        std::vector<ScaleType> scales;
        bool valid;
        
    public:
        Scales();
        ~Scales();

        bool isValid() const {
            return valid;
        }

        void readFile(std::string filename);
        bool readString(std::string json);
        
        std::vector<SG::ScaleType> getScales() const {
            return scales;
        }
        
        SG::ScaleType getScaleType(std::string scaleName);
    };
}
#endif

#endif


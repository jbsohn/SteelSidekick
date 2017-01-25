//
//  Scales.h
//  SGuitar
//
//  Created by John Sohn on 2/22/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef __Scales_h__
#define __Scales_h__

#include "ScaleType.h"

#ifdef __cplusplus
#include <vector>
#include <string>

namespace SG {
    class Scales {
    public:
        Scales();
        ~Scales();

        bool isValid() const;

        void readFile(std::string filename);
        bool readString(std::string json);
        
        std::vector<SG::ScaleType> getScales() const;
        SG::ScaleType getScaleType(std::string scaleName);
    private:
        struct ScalesImpl;
        std::unique_ptr<ScalesImpl> impl;
        
    };
}
#endif

#endif


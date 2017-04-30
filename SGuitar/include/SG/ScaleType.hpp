//
//  ScaleType.hpp
//  SGuitar
//
//  Created by John Sohn on 2/24/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef _ScaleType_h_
#define _ScaleType_h_

#ifdef __cplusplus
#include <vector>
#include <string>

namespace SG {
    class ScaleType {
    protected:
        std::string name;
        std::vector<int> semitones;
        bool valid;
        
    public:
        ScaleType();
        ScaleType(std::string name, std::vector<int> semitones);
        ~ScaleType();

        bool isValid() const {
            return valid;
        }
        
        std::string getName() {
            return name;
        }
        
        std::vector<int> getSemitones() {
            return semitones;
        }
        
    protected:
        void init(const ScaleType& scaleType);
    };
}
#endif
    
#endif

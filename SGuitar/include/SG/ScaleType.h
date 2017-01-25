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
#include <memory>

namespace SG {
    class ScaleType {
    public:
        ScaleType();
        ScaleType(std::string name, std::vector<int> semitones);
        ScaleType(const ScaleType& scaleType);
        ScaleType& operator=(const ScaleType& scaleType);
        ScaleType(ScaleType&& scaleType);
        ScaleType& operator=(ScaleType&& scaleType);
        ~ScaleType();

        bool isValid() const;
        
        std::string getName();
        std::vector<int> getSemitones();
    private:
        struct ScaleTypeImpl;
        std::unique_ptr<ScaleTypeImpl> impl;
    };
}
#endif
    
#endif

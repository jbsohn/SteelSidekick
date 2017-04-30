//
//  ScaleType.cpp
//  SGuitar
//
//  Created by John Sohn on 2/24/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include <vector>
#include "SG/ScaleType.hpp"

namespace SG {
    ScaleType::ScaleType() {
        name = "";
        semitones = {};
        valid = false;
    }
    
    ScaleType::ScaleType(std::string name, std::vector<int> semitones) {
        this->name = name;
        this->semitones = semitones;
        valid = true;
    }
    
    ScaleType::~ScaleType() {
        
    }

    void ScaleType::init(const ScaleType& scaleType) {
        name = scaleType.name;
        semitones = scaleType.semitones;
    }
}

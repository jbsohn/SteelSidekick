//
//  GuitarType.cpp
//  SGuitar
//
//  Created by John Sohn on 2/29/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include <vector>
#include "SG/GuitarType.hpp"
#include "JsonBox.h"

namespace SG {
    GuitarType::GuitarType() {
        name = "";
        description = "";
        customType = false;
        valid = false;
    }
    
    GuitarType::GuitarType(std::string name, std::string description, bool isCustomType) {
        this->name = name;
        this->description = description;
        customType = isCustomType;
        valid = true;
    }
    
    GuitarType::~GuitarType() {
        
    }

    void GuitarType::init(const GuitarType& guitarType) {
        name = guitarType.name;
        description = guitarType.description;
        customType = guitarType.customType;
    }
}

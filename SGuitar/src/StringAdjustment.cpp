//
//  StringAdjustment.cpp
//  SGuitar
//
//  Created by John Sohn on 12/14/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#include <string>
#include "SG/StringAdjustment.hpp"

namespace SG {
    StringAdjustment::StringAdjustment() {
        this->stringNumber = -1;
        this->step = 0;
        this->valid = false;
    }

    StringAdjustment::StringAdjustment(int stringNumber, int step) {
        this->stringNumber = stringNumber;
        this->step = step;
        this->valid = true;
    }

    StringAdjustment::~StringAdjustment() {
        
    }

    std::string StringAdjustment::getDescription() const {
        std::string description = "";
        description += "stringNumber: ";
        description += std::to_string(stringNumber);
        description += ", step: ";
        description += std::to_string(step);
        description += ", isValid: ";
        description += std::to_string(valid);
        return description;
    }
}

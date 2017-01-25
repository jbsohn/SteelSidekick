//
//  StringAdjustment.cpp
//  SGuitar
//
//  Created by John Sohn on 12/14/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#include <string>
#include "SG/StringAdjustment.h"

namespace SG {
    struct StringAdjustment::StringAdjustmentImpl {
        int stringNumber;
        int step;
        bool isValid;

        void init(const StringAdjustment& adjustment) {
            stringNumber = adjustment.impl->stringNumber;
            step = adjustment.impl->step;
            isValid = adjustment.impl->isValid;
        }
    };

    StringAdjustment::StringAdjustment() : impl(new StringAdjustmentImpl) {
        impl->stringNumber = -1;
        impl->step = 0;
        impl->isValid = false;
    }

    StringAdjustment::StringAdjustment(int stringNumber, int step) : impl(new StringAdjustmentImpl) {
        impl->stringNumber = stringNumber;
        impl->step = step;
        impl->isValid = true;
    }

    StringAdjustment::StringAdjustment(const StringAdjustment& adjustment) : impl(new StringAdjustmentImpl) {
        impl->init(adjustment);
    }
    
    StringAdjustment::~StringAdjustment() {
        
    }

    StringAdjustment& StringAdjustment::operator=(const StringAdjustment& adjustment) {
        impl->init(adjustment);
        return *this;
    }

    StringAdjustment::StringAdjustment(StringAdjustment&& stringAdjustment) {
        impl = std::move(stringAdjustment.impl);
        stringAdjustment.impl = nullptr;
    }
    
    StringAdjustment& StringAdjustment::operator=(StringAdjustment&& stringAdjustment) {
        if (this != &stringAdjustment) {
            impl = std::move(stringAdjustment.impl);
            stringAdjustment.impl = nullptr;
        }
        return *this;
    }

    bool StringAdjustment::isValid() const {
        return impl->isValid;
    }

    int StringAdjustment::getStringNumber() const {
        impl->isValid = true;
        return impl->stringNumber;
    }

    void StringAdjustment::setStep(int step) {
        impl->step = step;
    }
    
    int StringAdjustment::getStep() const {
        impl->isValid = true;
        return impl->step;
    }
    
    std::string StringAdjustment::getDescription() const {
        std::string description = "";
        description += "stringNumber: ";
        description += std::to_string(impl->stringNumber);
        description += ", step: ";
        description += std::to_string(impl->step);
        description += ", isValid: ";
        description += std::to_string(impl->isValid);
        return description;
    }
}

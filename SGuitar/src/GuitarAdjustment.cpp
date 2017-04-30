//
//  GuitarAdjustment.cpp
//  SGuitar
//
//  Created by John Sohn on 12/14/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#include <string>
#include <vector>
#include "SG/GuitarAdjustment.hpp"

namespace SG {
    GuitarAdjustment::GuitarAdjustment() {
        valid = false;
    }

    GuitarAdjustment::GuitarAdjustment(std::string adjustmentID) {
        this->adjustmentID = adjustmentID;
        this->valid = true;
    }

    GuitarAdjustment::~GuitarAdjustment() {

    }

    StringAdjustment GuitarAdjustment::stringAdjustmentForStringNumber(int stringNumber) const {
        for (StringAdjustment cur : adjustments) {
            if (cur.getStringNumber() == stringNumber) {
                return cur;
            }
        }
        return StringAdjustment();
    }

    std::string GuitarAdjustment::getDescription() const {
        std::string description = "";
        if (adjustmentID.size() > 0) {
            description += "adjustmentID: ";
            description += adjustmentID;
            description += ", isValid: ";
            description += std::to_string(valid);
            description += "\r\n";

            description += "adjustments:\r\n";
            for (StringAdjustment cur : adjustments) {
                description += cur.getDescription();
                description += "\r\n";
            }
        }
        return description;
    }
}

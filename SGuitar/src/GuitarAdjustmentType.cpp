//
//  GuitarAdjustmentType.cpp
//  SteelSidekick
//
//  Created by John Sohn on 1/16/17.
//
//

#include "SG/GuitarAdjustmentType.h"

namespace SG {
    std::string GuitarAdjustmentType::LEVER_TYPE_NAMES[] = {
        "LKL",
        "LKLR",
        "LKV",
        "LKR",
        "LKRR",
        "RKL",
        "RKLR",
        "RKV",
        "RKR",
        "RKRR"
    };

    std::string GuitarAdjustmentType::PEDAL_TYPE_NAMES[] = {
        "P1",
        "P2",
        "P3",
        "P4",
        "P5",
        "P6",
        "P7",
        "P8",
        "P9",
        "P10"
    };

    std::string GuitarAdjustmentType::getPedalTypeName(int index) {
        return PEDAL_TYPE_NAMES[index];
    }

    std::string GuitarAdjustmentType::getLeverTypeName(int index) {
        return LEVER_TYPE_NAMES[index];
    }
}

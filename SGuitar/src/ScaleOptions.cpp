//
//  ScaleOptions.cpp
//  SGuitar
//
//  Created by John Sohn on 2/25/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include <vector>
#include "SG/ScaleOptions.hpp"
#include "SG/ScaleType.hpp"
#include "SG/Scale.hpp"

namespace SG {
    ScaleOptions::ScaleOptions() {
        showScale = true;
        scaleName = "";
        scaleRootNoteValue = NOTE_VALUE_C;
        displayItemsAs = DIA_NOTES;
    }

    ScaleOptions::~ScaleOptions() {
        
    }
}

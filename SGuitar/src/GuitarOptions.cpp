//
//  GuitarOptions.cpp
//  SGuitar
//
//  Created by John on 7/30/13.
//  Copyright (c) 2013 John. All rights reserved.
//

#include <string>
#include "SG/Note.hpp"
#include "SG/OptionTypes.hpp"
#include "SG/GuitarOptions.hpp"

namespace SG  {
    GuitarOptions::GuitarOptions() {
        guitarType = "";
        guitarName = "";
        showAllNotes = false;
        showNotesAs = ADT_SHARP;
    }

	GuitarOptions::~GuitarOptions() {

	}
}

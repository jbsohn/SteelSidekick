//
//  ChordOptions.cpp
//  SGuitar
//
//  Created by John Sohn on 2/25/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include "SG/ChordOptions.hpp"
#include "SG/Chord.hpp"

namespace SG {
    ChordOptions::ChordOptions() {
        showChord = true;
        chordName = "";
        chordRootNoteValue = NOTE_VALUE_C;
        displayItemsAs = DIA_NOTES;
    }

    ChordOptions::~ChordOptions() {
        
    }
}

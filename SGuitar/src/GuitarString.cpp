//
//  GuitarString.cpp
//  SGuitar
//
//  Created by John Sohn on 12/14/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#include <vector>
#include "SG/GuitarString.hpp"

#define DEFAULT_NUMBER_OF_FRETS         24

namespace SG {
    GuitarString::GuitarString() {
        Note note;
        noteValues.resize(DEFAULT_NUMBER_OF_FRETS);
        startNote = note;
        numberOfFrets = 0;
        valid = false;
    }

    GuitarString::GuitarString(SG::Note note, int numberOfFrets) {
        noteValues.resize(numberOfFrets);
        startNote = note;
        this->numberOfFrets = numberOfFrets;
        valid = true;
        reset();
    }
    
    GuitarString::GuitarString(int midiValue, int numberOfFrets) {
        Note note(midiValue);
        noteValues.resize(numberOfFrets);
        startNote = note;
        this->numberOfFrets = numberOfFrets;
        valid = true;
        reset();
    }

    GuitarString::~GuitarString() {
    }
    
    
    void GuitarString::init(const GuitarString& guitarString) {
        noteValues = guitarString.noteValues;
        startNote = guitarString.startNote;
        numberOfFrets = guitarString.numberOfFrets;
        valid = guitarString.valid;
    }
    
    void GuitarString::reset() {
        noteValues.resize(numberOfFrets + 1);
        int curNoteMIDIValue = startNote.getMIDIValue();

        for (int fret = 0; fret <= numberOfFrets; fret++) {
            noteValues[fret] = curNoteMIDIValue;
            curNoteMIDIValue++;
        }
    }

    void GuitarString::adjustStringBySteps(int steps) {
        for (int fret = 0; fret <= numberOfFrets; fret++) {
            int curNoteMIDIValue = noteValues[fret];
            curNoteMIDIValue += steps;
            noteValues[fret] = curNoteMIDIValue;
        }
    }
}

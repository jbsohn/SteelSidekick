//
//  GuitarString.cpp
//  SGuitar
//
//  Created by John Sohn on 12/14/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#include <vector>
#include "SG/GuitarString.h"

#define DEFAULT_NUMBER_OF_FRETS         24

namespace SG {
    struct GuitarString::GuitarStringImpl {
        std::vector<int> noteValues;
        Note startNote;
        int numberOfFrets;
        bool isValid;
        
        void init(const GuitarString& guitarString) {
            noteValues = guitarString.impl->noteValues;
            startNote = guitarString.impl->startNote;
            numberOfFrets = guitarString.impl->numberOfFrets;
            isValid = guitarString.impl->isValid;
        }
    };

    GuitarString::GuitarString() :impl(new GuitarStringImpl) {
        Note note;
        impl->noteValues.resize(DEFAULT_NUMBER_OF_FRETS);
        impl->startNote = note;
        impl->numberOfFrets = 0;
        impl->isValid = false;
    }

    GuitarString::GuitarString(SG::Note note, int numberOfFrets) : impl(new GuitarStringImpl) {
        impl->noteValues.resize(DEFAULT_NUMBER_OF_FRETS);
        impl->startNote = note;
        impl->numberOfFrets = numberOfFrets;
        impl->isValid = true;
        reset();
    }
    
    GuitarString::GuitarString(int midiValue, int numberOfFrets) : impl(new GuitarStringImpl) {
        Note note(midiValue);
        impl->noteValues.resize(DEFAULT_NUMBER_OF_FRETS);
        impl->startNote = note;
        impl->numberOfFrets = numberOfFrets;
        impl->isValid = true;
        reset();
    }

    GuitarString::GuitarString(const GuitarString& guitarString) : impl(new GuitarStringImpl) {
        impl->init(guitarString);
    }
    
    GuitarString::~GuitarString() {
    }

    GuitarString& GuitarString::operator=(const GuitarString& guitarString) {
        impl->init(guitarString);
        return *this;
    }

    GuitarString::GuitarString(GuitarString&& guitarString) {
        impl = std::move(guitarString.impl);
        guitarString.impl = nullptr;
    }
    
    GuitarString& GuitarString::operator=(GuitarString&& guitarString) {
        if (this != &guitarString) {
            impl = std::move(guitarString.impl);
            guitarString.impl = nullptr;
        }
        return *this;
    }

    bool GuitarString::isValid() const {
        return impl->isValid;
    }

    void GuitarString::reset() {
        impl->noteValues.resize(impl->numberOfFrets + 1);
        int curNoteMIDIValue = impl->startNote.getMIDIValue();

        for (int fret = 0; fret <= impl->numberOfFrets; fret++) {
            impl->noteValues[fret] = curNoteMIDIValue;
            curNoteMIDIValue++;
        }
    }

    void GuitarString::adjustStringBySteps(int steps) {
        for (int fret = 0; fret <= impl->numberOfFrets; fret++) {
            int curNoteMIDIValue = impl->noteValues[fret];
            curNoteMIDIValue += steps;
            impl->noteValues[fret] = curNoteMIDIValue;
        }
    }

    SG::Note GuitarString::getStartNote() {
        return impl->startNote;
    }

    std::vector<int> GuitarString::getNoteValues() const {
        return impl->noteValues;
    }
    
    SG::Note GuitarString::getNoteAtFret(int fretNumber) const {
        SG::Note note(impl->noteValues[fretNumber]);
        return note;
    }
}

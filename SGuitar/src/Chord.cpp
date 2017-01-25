//
//  Chord.cpp
//  SGuitar
//
//  Created by John Sohn on 12/14/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#include <vector>
#include <string>
#include "SG/Chord.h"
#include "SG/Note.h"
#include "SG/NoteName.h"

namespace SG {
    struct Chord::ChordImpl {
        std::vector<int> chordNoteValues;
        bool isValid;
        
        void init(const Chord& chord) {
            chordNoteValues = chord.impl->chordNoteValues;
            isValid = chord.impl->isValid;
        }
        
        int noteValueForInterval(int interval, int rootNoteValue) const {
            int value = rootNoteValue + interval;
            
            if (value > NOTE_VALUE_B) {
                value = (value - NOTE_VALUE_B) -1;
            }
            return (int) value;
        }
    };

    Chord::Chord() :
        impl(new ChordImpl) {
        impl->isValid = false;
    }

    Chord::Chord(int rootNoteValue, std::vector<int> intervals)
        : impl(new ChordImpl) {
        unsigned long numIntervals = intervals.size();
        impl->chordNoteValues.clear();
        
        for (int i = 0; i < numIntervals; i++) {
            int curInterval = intervals[i];
            int noteValue = impl->noteValueForInterval(curInterval, rootNoteValue);
            impl->chordNoteValues.push_back(noteValue);
        }
        impl->isValid = true;
    }

    Chord::Chord(const Chord& chord) : impl(new ChordImpl) {
        impl->init(chord);
    }

    Chord::Chord(Chord&& chord) {
        impl = std::move(chord.impl);
        chord.impl = nullptr;
    }
    
    Chord& Chord::operator=(Chord&& chord) {
        if (this != &chord) {
            impl = std::move(chord.impl);
            chord.impl = nullptr;
        }
        return *this;
    }

    Chord::~Chord() {
    }

    bool Chord::isValid() const {
        return impl->isValid;
    }

    Chord& Chord::operator=(const Chord& chord) {
        impl->init(chord);
        return *this;
    }

    std::vector<int> Chord::getNoteValues() const {
        return impl->chordNoteValues;
    }

    int Chord::getNumberOfScaleNotes() const {
        return (int) impl->chordNoteValues.size();
    }
    
    int Chord::getScaleNote(int index) const {
        return impl->chordNoteValues[index];
    }
    
    bool Chord::isNoteValueInChord(int noteValue) const {
        for (int i = 0; i < impl->chordNoteValues.size(); i++) {
            int curNoteValue = impl->chordNoteValues[i];
            if (curNoteValue == noteValue) {
                return true;
            }
        }
        return false;
    }

    std::string Chord::unitTestDescription() {
        static std::string s;

        s = "";
        bool first = true;
        
        for (int curNoteValue : impl->chordNoteValues) {
            if (!first) {
                s += " ";
            }
            s += NoteName::nameForNoteValue(curNoteValue, AT_SHARP);
            first = false;
        }
        
        return s;
    }
}

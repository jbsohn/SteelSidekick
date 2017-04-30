//
//  Chord.cpp
//  SGuitar
//
//  Created by John Sohn on 12/14/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#include <vector>
#include <string>
#include "SG/Chord.hpp"
#include "SG/Note.hpp"
#include "SG/NoteName.hpp"

namespace SG {
    Chord::Chord() {
        valid = false;
    }

    Chord::Chord(int rootNoteValue, std::vector<int> intervals) {
        unsigned long numIntervals = intervals.size();
        chordNoteValues.clear();
        
        for (int i = 0; i < numIntervals; i++) {
            int curInterval = intervals[i];
            int noteValue = noteValueForInterval(curInterval, rootNoteValue);
            chordNoteValues.push_back(noteValue);
        }
        valid = true;
    }

    Chord::~Chord() {
    }

    bool Chord::isNoteValueInChord(int noteValue) const {
        for (int i = 0; i < chordNoteValues.size(); i++) {
            int curNoteValue = chordNoteValues[i];
            if (curNoteValue == noteValue) {
                return true;
            }
        }
        return false;
    }

    std::string Chord::getDescription() {
        static std::string s;

        s = "";
        bool first = true;
        
        for (int curNoteValue : chordNoteValues) {
            if (!first) {
                s += " ";
            }
            s += NoteName::nameForNoteValue(curNoteValue, AT_SHARP);
            first = false;
        }
        
        return s;
    }
    
    void Chord::init(const Chord& chord) {
        chordNoteValues = chord.chordNoteValues;
        valid = chord.valid;
    }
    
    int Chord::noteValueForInterval(int interval, int rootNoteValue) const {
        int value = rootNoteValue + interval;
        
        if (value > NOTE_VALUE_B) {
            value = (value - NOTE_VALUE_B) -1;
        }
        return (int) value;
    }
}

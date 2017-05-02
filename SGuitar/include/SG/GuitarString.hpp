//
//  GuitarString.h
//  SGuitar
//
//  Created by John Sohn on 12/9/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#ifndef __GuitarString_h__
#define __GuitarString_h__

#include "Note.hpp"

#ifdef __cplusplus
#include <vector>

namespace SG {
    //
    // represents a string of notes on a guitar
    //
    class GuitarString {
    protected:
        std::vector<int> noteValues;
        Note startNote;
        int numberOfFrets;
        bool valid;

    public:
        GuitarString();
        GuitarString(SG::Note note, int numberOfFrets);
        GuitarString(int midiValue, int numberOfFrets);
        ~GuitarString();
        
        bool isValid() const {
            return valid;
        }

        SG::Note getStartNote() {
            return startNote;
        }
        
        std::vector<int> getNoteValues() const {
            return noteValues;
        }
        
        SG::Note getNoteAtFret(int fretNumber) const {
            SG::Note note(noteValues[fretNumber]);
            return note;
        }
        
        void reset();
        void adjustStringBySteps(int steps);

    protected:
        void init(const GuitarString& guitarString);
    };
}
#endif

#endif

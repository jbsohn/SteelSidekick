//
//  Chord.h
//  SGuitar
//
//  Created by John Sohn on 12/9/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#ifndef __Chord_h__
#define __Chord_h__

#include "Note.hpp"

#ifdef __cplusplus
#include <vector>

namespace SG {
    //
    // represents a Chord, given a root note value and a list of semitones
    //
    class Chord {
    protected:
        std::vector<int> chordNoteValues;
        bool valid;
        
    public:
        Chord();
        Chord(int rootNoteValue, std::vector<int> intervals);
        ~Chord();
        
        bool isValid() const {
            return valid;
        }
        
        std::vector<int> getNoteValues() const {
            return chordNoteValues;
        }
        
        int getNumberOfScaleNotes() const {
            return (int) chordNoteValues.size();
        }
        
        int getScaleNote(int index) const {
            return chordNoteValues[index];
        }
    
        bool isNoteValueInChord(int noteValue) const;

        std::string getDescription();

    protected:
        void init(const Chord& chord);
        int noteValueForInterval(int interval, int rootNoteValue) const;
    };
}
#endif

#endif

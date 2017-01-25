//
//  GuitarString.h
//  SGuitar
//
//  Created by John Sohn on 12/9/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#ifndef __GuitarString_h__
#define __GuitarString_h__

#include "Note.h"

#ifdef __cplusplus
#include <memory>
#include <vector>

namespace SG {
    class GuitarString {
    public:
        GuitarString();
        GuitarString(SG::Note note, int numberOfFrets);
        GuitarString(int midiValue, int numberOfFrets);
        GuitarString(const GuitarString& guitarString);
        GuitarString& operator=(const GuitarString& guitarString);
        GuitarString(GuitarString&& guitarString);
        GuitarString& operator=(GuitarString&& guitarString);
        ~GuitarString();
        
        bool isValid() const;

        SG::Note getStartNote();
        std::vector<int> getNoteValues() const;
        SG::Note getNoteAtFret(int fretNumber) const;

        void reset();
        void adjustStringBySteps(int steps);
    private:
        struct GuitarStringImpl;
        std::unique_ptr<GuitarStringImpl> impl;
    };
}
#endif

#endif

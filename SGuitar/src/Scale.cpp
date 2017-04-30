//
//  Scale.cpp
//  SGuitar
//
//  Created by John Sohn on 12/14/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#include <vector>
#include <string>
#include "SG/Scale.hpp"
#include "SG/Note.hpp"
#include "SG/NoteName.hpp"

namespace SG {
    Scale::Scale() {
        valid = false;
    }

    Scale::Scale(int rootNoteValue, std::vector<int> semitones) {
        unsigned long numSemitones = semitones.size();
        scaleNoteValues.clear();
        scaleNoteValues.reserve(numSemitones);

        int curNoteValue = rootNoteValue;
        scaleNoteValues.push_back(rootNoteValue);

        for (int i = 0; i < numSemitones; i++) {
            int curSemitone = semitones[i];
            curNoteValue = nextNoteValueInScale(curNoteValue, curSemitone);
            scaleNoteValues.push_back(curNoteValue);
        }
        
        this->valid = false;
    }

    Scale::Scale(const Scale& scale) {
        this->init(scale);
    }

    Scale::~Scale() {
    }

    
    Scale& Scale::operator=(const Scale& scale) {
        this->init(scale);
        return *this;
    }

    bool Scale::isNoteValueInScale(int noteValue) const {
        for (int curNoteValue : this->scaleNoteValues) {
            if (curNoteValue == noteValue) {
                return true;
            }
        }
        return false;
    }

    int Scale::intervalForNoteValue(int noteValue) const {
        int interval = 0;

        for (int curNoteValue : this->scaleNoteValues) {
            if (curNoteValue == noteValue) {
                return interval;
            }
            interval++;
        }
        return -1;
    }

    void Scale::init(const Scale& scale) {
        name = scale.name;
        scaleNoteValues = scale.scaleNoteValues;
        valid = scale.valid;
    }
    
    int Scale::nextNoteValueInScale(int noteValue, int semitone) const {
        int curNoteValue = noteValue;
        curNoteValue += semitone;
        
        if (curNoteValue > NOTE_VALUE_B) {
            curNoteValue = curNoteValue - (NOTE_VALUE_B + 1);
        }
        return curNoteValue;
    }

    std::string Scale::getDescription() {
        static std::string s;
        
        s = "";
        bool first = true;
        
        for (int curNoteValue : this->scaleNoteValues) {
            if (!first) {
                s += " ";
            }
            s += NoteName::nameForNoteValue(curNoteValue, AT_SHARP);
            first = false;
        }
        return s;
    }
}

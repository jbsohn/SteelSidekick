//
//  Scale.cpp
//  SGuitar
//
//  Created by John Sohn on 12/14/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#include <vector>
#include <string>
#include "SG/Scale.h"
#include "SG/Note.h"
#include "SG/NoteName.h"

namespace SG {
    struct Scale::ScaleImpl {
        std::string name;
        std::vector<int> scaleNoteValues;
        bool isValid;

        void init(const Scale& scale) {
            name = scale.impl->name;
            scaleNoteValues = scale.impl->scaleNoteValues;
            isValid = scale.impl->isValid;
        }

        int nextNoteValueInScale(int noteValue, int semitone) const {
            int curNoteValue = noteValue;
            curNoteValue += semitone;
            
            if (curNoteValue > NOTE_VALUE_B) {
                curNoteValue = curNoteValue - (NOTE_VALUE_B + 1);
            }
            return curNoteValue;
        }
//        void init(int rootNoteValue, std::vector<int> semitones) {
//            unsigned long numSemitones = semitones.size();
//            impl->scaleNoteValues.clear();
//            impl->scaleNoteValues.reserve(numSemitones);
//
//            int curNoteValue = rootNoteValue;
//            impl->scaleNoteValues.push_back(rootNoteValue);
//
//            for (int i = 0; i < numSemitones; i++) {
//                int curSemitone = semitones[i];
//                curNoteValue = nextNoteValueInScale(curNoteValue, curSemitone);
//                impl->scaleNoteValues.push_back(curNoteValue);
//            }
//            
//            impl->isValid = false;
//        }
    };

    Scale::Scale()
        : impl(new ScaleImpl) {
        impl->isValid = false;
    }

    Scale::Scale(int rootNoteValue, std::vector<int> semitones) : impl(new ScaleImpl) {
        unsigned long numSemitones = semitones.size();
        impl->scaleNoteValues.clear();
        impl->scaleNoteValues.reserve(numSemitones);

        int curNoteValue = rootNoteValue;
        impl->scaleNoteValues.push_back(rootNoteValue);

        for (int i = 0; i < numSemitones; i++) {
            int curSemitone = semitones[i];
            curNoteValue = impl->nextNoteValueInScale(curNoteValue, curSemitone);
            impl->scaleNoteValues.push_back(curNoteValue);
        }
        
        impl->isValid = false;
    }

    Scale::Scale(const Scale& scale) : impl(new ScaleImpl) {
        impl->init(scale);
    }

    Scale::~Scale() {
    }

    
    Scale& Scale::operator=(const Scale& scale) {
        impl->init(scale);
        return *this;
    }

    Scale::Scale(Scale&& scale) {
        impl = std::move(scale.impl);
        scale.impl = nullptr;
    }
    
    Scale& Scale::operator=(Scale&& scale) {
        if (this != &scale) {
            impl = std::move(scale.impl);
            scale.impl = nullptr;
        }
        return *this;
    }

    bool Scale::isValid() const {
        return impl->isValid;
    }

    std::vector<int> Scale::getNoteValues() const {
        return impl->scaleNoteValues;
    }

    bool Scale::isNoteValueInScale(int noteValue) const {
        for (int curNoteValue : impl->scaleNoteValues) {
            if (curNoteValue == noteValue) {
                return true;
            }
        }
        return false;
    }

    int Scale::intervalForNoteValue(int noteValue) const {
        int interval = 0;

        for (int curNoteValue : impl->scaleNoteValues) {
            if (curNoteValue == noteValue) {
                return interval;
            }
            interval++;
        }
        return -1;
    }



    std::string Scale::unitTestDescription() {
        static std::string s;
        
        s = "";
        bool first = true;
        
        for (int curNoteValue : impl->scaleNoteValues) {
            if (!first) {
                s += " ";
            }
            s += NoteName::nameForNoteValue(curNoteValue, AT_SHARP);
            first = false;
        }
        return s;
    }
}

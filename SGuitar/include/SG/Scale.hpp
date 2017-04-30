//
//  Scale.h
//  SGuitar
//
//  Created by John Sohn on 12/9/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#ifndef __Scale_h__
#define __Scale_h__

#include "Note.hpp"

#ifdef __cplusplus
#include <array>
#include <vector>

namespace SG {
    class Scale {
    protected:
        std::string name;
        std::vector<int> scaleNoteValues;
        bool valid;

    public:
        Scale();
        Scale(int rootNoteValue, std::vector<int> semitones);
        Scale(const Scale& scale);
        Scale& operator=(const Scale& Type);
        ~Scale();

        bool isValid() const {
            return valid;
        }
        
        std::vector<int> getNoteValues() const {
            return this->scaleNoteValues;
        }
    
        bool isNoteValueInScale(int noteValue) const;
        int intervalForNoteValue(int noteValue) const;
        
        std::string getDescription();
    protected:
        void init(const Scale& scale);
        int nextNoteValueInScale(int noteValue, int semitone) const;
    };
}
#endif

#endif

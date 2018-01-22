//
//  Note.h
//  SGuitar
//
//  Created by John Sohn on 12/9/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#ifndef __Note_h__
#define __Note_h__

typedef enum {
    AT_NATURAL              = 0,
    AT_SHARP                = 1,
    AT_FLAT                 = 2
} ACCIDENTAL_TYPE;

enum {
    NOTE_VALUE_NONE         = -1,
    NOTE_VALUE_C            = 0,
    NOTE_VALUE_C_SHARP      = 1,
    NOTE_VALUE_D_FLAT       = 1,
    NOTE_VALUE_D            = 2,
    NOTE_VALUE_D_SHARP      = 3,
    NOTE_VALUE_E_FLAT       = 3,
    NOTE_VALUE_E            = 4,
    NOTE_VALUE_F            = 5,
    NOTE_VALUE_F_SHARP      = 6,
    NOTE_VALUE_G_FLAT       = 6,
    NOTE_VALUE_G            = 7,
    NOTE_VALUE_G_SHARP      = 8,
    NOTE_VALUE_A_FLAT       = 8,
    NOTE_VALUE_A            = 9,
    NOTE_VALUE_A_SHARP      = 10,
    NOTE_VALUE_B_FLAT       = 10,
    NOTE_VALUE_B            = 11
};


#ifdef __cplusplus
#include <string>

namespace SG {
    //
    // represents a musical note on the staff with pitch, integer note value, and MIDI value
    //
    class Note {
    protected:
        int midiValue;
        bool valid;
        
    public:
        Note();
        Note(int noteValue, int pitch);
        Note(int midiValue);
        Note(std::string name);
        Note(const Note& note);
        Note& operator=(const Note& adjustment);
        ~Note();

        bool isValid() const;

        int getMIDIValue() const;
        int getNoteValue() const;
        int getPitchValue() const;
        std::string getNoteNamePitchUTF8() const;
    protected:
        void init(int noteValue, int pitch);
        void init(const Note& note);
    };
}
#endif

#endif

//
//  NoteName.h
//  SteelSidekick
//
//  Created by John Sohn on 1/16/17.
//
//

#ifndef __NOTE_NAME_H__
#define __NOTE_NAME_H__

#include "SG/Note.hpp"

#ifdef __cplusplus
#include <string>

namespace SG {
    class NoteName {
    public:
        static std::string nameForNoteValue(int noteValue, ACCIDENTAL_TYPE accidentalType);
        static int noteValueForName(std::string noteName);
        static std::string getNoteNameSharpFlat(int noteValue);
        static std::string getNoteNameSharp(int noteValue);

    protected:
        static std::string UTF8_NOTE_NAMES_SHARP[];
        static std::string UTF8_NOTE_NAMES_FLAT[];
        static std::string NOTE_NAMES_SHARP[];
        static std::string NOTE_NAMES_FLAT[];
        static std::string NOTE_NAMES_SHARP_FLAT[];
    };
}
#endif

#endif

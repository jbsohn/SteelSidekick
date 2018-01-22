//
//  NoteName.cpp
//  SteelSidekick
//
//  Created by John Sohn on 1/16/17.
//
//

#include "SG/NoteName.hpp"

namespace SG {
    std::string NoteName::UTF8_NOTE_NAMES_SHARP[] = {
        "C","C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"
    };
    
    std::string NoteName::UTF8_NOTE_NAMES_FLAT[]  = {
        "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"
    };
    
    std::string NoteName::NOTE_NAMES_SHARP[] = {
        "C", "C\u266f",  "D", "D\u266f", "E", "F", "F\u266f", "G",
        "G\u266f", "A", "A\u266f", "B"
    };
    
    std::string NoteName::NOTE_NAMES_FLAT[] = {
        "C", "D\u266d", "D", "E\u266d", "E", "F", "G\u266d",
        "G", "A\u266d", "A", "B\u266d", "B"
    };
    
    std::string NoteName::NOTE_NAMES_SHARP_FLAT[] = {
        "C",
        "C\u266f/D\u266d",
        "D",
        "D\u266f/E\u266d",
        "E", "F",
        "F\u266f/G\u266d",
        "G",
        "G\u266f/A\u266d",
        "A",
        "A\u266f/B\u266d",
        "B"
    };

    std::string NoteName::nameForNoteValue(int noteValue, ACCIDENTAL_TYPE accidentalType) {
        if (accidentalType == AT_SHARP) {
            return UTF8_NOTE_NAMES_SHARP[noteValue];
        } else {
            return UTF8_NOTE_NAMES_FLAT[noteValue];
        }
        return "";
    }

    int NoteName::noteValueForName(std::string noteName) {
        for (int i = 0; i <= NOTE_VALUE_B; i++) {
            std::string curSharp = UTF8_NOTE_NAMES_SHARP[i];
            std::string curFlat = UTF8_NOTE_NAMES_FLAT[i];
            std::string curSharpW = NOTE_NAMES_SHARP[i];
            std::string curFlatW = NOTE_NAMES_FLAT[i];
            
            if (noteName == curSharp || noteName == curFlat || noteName == curSharpW || noteName == curFlatW) {
                return (int) i;
            }
        }
        return NOTE_VALUE_NONE;
    }

    std::string NoteName::getNoteNameSharpFlat(int noteValue) {
        return NoteName::NOTE_NAMES_SHARP_FLAT[noteValue];
    }

    std::string NoteName::getNoteNameSharp(int noteValue) {
        return NoteName::NOTE_NAMES_SHARP[noteValue];
    }
    
    std::string NoteName::getNoteNameSharpUTF8(int noteValue) {
        return NoteName::UTF8_NOTE_NAMES_SHARP[noteValue];
    }

}


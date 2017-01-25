//
//  NoteName.h
//  SteelSidekick
//
//  Created by John Sohn on 1/16/17.
//
//

#ifndef __NOTE_NAME_H__
#define __NOTE_NAME_H__

#include "SG/Note.h"

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

#ifdef __OBJC__

@interface NoteName : NSObject

+ (NSString*)nameForNoteValue:(int)noteValue accidentalTypeL:(ACCIDENTAL_TYPE)accidentalType;
+ (int)noteValueForName:(NSString*)noteName;
+ (NSString*)getNoteNameSharpFlat:(int)noteValue;
+ (NSString*)getNoteNameSharp:(int)noteValue;

@end

#endif

#endif

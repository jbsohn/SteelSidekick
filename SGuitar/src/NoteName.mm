//
//  NoteName.mm
//  SteelSidekick
//

#import <Foundation/Foundation.h>
#import "SG/NoteName.hpp"

@implementation NoteName

+ (NSString*)nameForNoteValue:(int)noteValue accidentalTypeL:(ACCIDENTAL_TYPE)accidentalType {
    return @(SG::NoteName::nameForNoteValue(noteValue, accidentalType).c_str());
}

+ (int)noteValueForName:(NSString*)noteName {
    return SG::NoteName::noteValueForName([noteName UTF8String]);
}

+ (NSString*)getNoteNameSharpFlat:(int)noteValue {
    return @(SG::NoteName::getNoteNameSharpFlat(noteValue).c_str());
}

+ (NSString*)getNoteNameSharp:(int)noteValue {
    return @(SG::NoteName::getNoteNameSharp(noteValue).c_str());
}

@end


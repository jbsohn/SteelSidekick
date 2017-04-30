//
//  Chord.mm
//  SteelSidekick
//

#import <Foundation/Foundation.h>
#import "SG/Chord.hpp"
#import "NSArrayNoteValueVector.h"

@interface Chord()
@property SG::Chord* object;
@property BOOL deleteObject;
@end

@implementation Chord

- (id)initWithSGChord:(SG::Chord *)object {
    if (self = [super init]) {
        _object = object;
        _deleteObject = NO;
    }
    return self;
}

- (id)initWithSGChordObject:(SG::Chord)object {
    if (self = [super init]) {
        _object = new SG::Chord(object);
        _deleteObject = YES;
    }
    return self;
}

- (void)dealloc {
    if (_deleteObject) {
        if (_object) {
            delete _object;
        }
    }
}

- (NSArray*)getNoteValues {
    std::vector<int> notes = _object->getNoteValues();
    return [NSArrayNoteValueVector arrayFromNoteValueVector:notes];
}

- (int)getNumberOfScaleNotes {
    return _object->getNumberOfScaleNotes();
}

- (int)getScaleNote:(int)index {
    return _object->getScaleNote(index);
}

- (BOOL)isNoteValueInChord:(int)noteValue {
    return _object->isNoteValueInChord(noteValue);
}

- (NSString *)unitTestDescription {
    return @(_object->unitTestDescription().c_str());
}

@end

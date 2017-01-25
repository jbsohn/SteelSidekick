//
//  Scale.mm
//  SteelSidekick
//

#include <Foundation/Foundation.h>
#include "SG/Scale.h"
#include "NSArrayNoteValueVector.h"

@interface Scale()
@property SG::Scale* object;
@property BOOL deleteObject;
@end

@implementation Scale

- (id)initWithSGScale:(SG::Scale *)object {
    if (self = [super init]) {
        _object = object;
        _deleteObject = NO;
    }
    return self;
}

- (id)initWithSGScaleObject:(SG::Scale)object {
    if (self = [super init]) {
        _object = new SG::Scale(object);
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

- (BOOL)isNoteValueInScale:(int)noteValue {
    return _object->isNoteValueInScale(noteValue);
}

- (int)intervalForNoteValue:(int)noteValue {
    return _object->intervalForNoteValue(noteValue);
}

- (NSString *)unitTestDescription {
    return @(_object->unitTestDescription().c_str());
}

@end

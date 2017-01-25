//
//  ChordOptions.mm
//  SteelSidekick
//

#import <Foundation/Foundation.h>
#import "SG/ChordOptions.h"

@interface ChordOptions()
@property SG::ChordOptions* object;
@end

@implementation ChordOptions

- (id)initWithSGChordOptions:(SG::ChordOptions *)object {
    if (self = [super init]) {
        _object = object;
    }
    return self;
}

- (BOOL)showChord {
    return _object->getShowChord();
}

- (void)setShowChord:(BOOL)showChord {
    _object->setShowChord(showChord);
}

- (NSString *)chordName {
    return @(_object->getChordName().c_str());
}

- (void)setChordName:(NSString *)chordName {
    _object->setChordName([chordName UTF8String]);
}

- (int)chordRoteNoteValue {
    return _object->getChordRootNoteValue();
}

- (void)setChordRoteNoteValue:(int)chordRoteNoteValue {
    _object->setChordRootNoteValue(chordRoteNoteValue);
}

- (DISPLAY_ITEM_AS_TYPE)displayItemAs {
    return _object->getDisplayItemsAs();
}

- (void)setDisplayItemAs:(DISPLAY_ITEM_AS_TYPE)displayItemAs {
    _object->setDisplayItemsAs(displayItemAs);
}

@end

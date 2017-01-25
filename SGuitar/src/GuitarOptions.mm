//
//  GuitarOptions.mm
//  SteelSidekick
//
//

#import <Foundation/Foundation.h>
#import "SG/GuitarOptions.h"

@interface GuitarOptions()
@property SG::GuitarOptions* object;
@end

@implementation GuitarOptions

- (id)initWithSGGuitarOptions:(SG::GuitarOptions *)object {
    if (self = [super init]) {
        _object = object;
    }
    return self;
}

- (NSString *)guitarType {
    return @(_object->getGuitarType().c_str());
}

- (void)setGuitarType:(NSString *)guitarType {
    _object->setGuitarType([guitarType UTF8String]);
}

- (NSString *)guitarName {
    return @(_object->getGuitarName().c_str());
}

- (void)setGuitarName:(NSString *)guitarName {
    _object->setGuitarName([guitarName UTF8String]);
}

- (BOOL)showAllNotes {
    return _object->getShowAllNotes();
}

- (void)setShowAllNotes:(BOOL)showAllNotes {
    _object->setShowAllNotes(showAllNotes);
}

- (ACCIDENTAL_DISPLAY_TYPE)showNotesAs {
    return _object->getShowNotesAs();
}

- (void)setShowNotesAs:(ACCIDENTAL_DISPLAY_TYPE)showNotesAs {
    _object->setShowNotesAs(showNotesAs);
}

@end

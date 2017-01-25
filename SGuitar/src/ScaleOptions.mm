//
//  ScaleOptions.mm
//  SteelSidekick
//

#import <Foundation/Foundation.h>
#import "SG/ScaleOptions.h"

@interface ScaleOptions()
@property SG::ScaleOptions *object;
@end

@implementation ScaleOptions

- (id)initWithSGScaleOptions:(SG::ScaleOptions *)object {
    if (self = [super init]) {
        _object = object;
    }
    return self;
}

- (BOOL)showScale {
    return _object->getShowScale();
}

- (void)setShowScale:(BOOL)showScale {
    _object->setShowScale(showScale);
}

- (NSString *)scaleName {
    return @(_object->getScaleName().c_str());
}

- (void)setScaleName:(NSString *)scaleName {
    _object->setScaleName([scaleName UTF8String]);
}

- (int)scaleRoteNoteValue {
    return _object->getScaleRootNoteValue();
}

- (void)setScaleRoteNoteValue:(int)scaleRoteNoteValue {
    _object->setScaleRootNoteValue(scaleRoteNoteValue);
}

- (DISPLAY_ITEM_AS_TYPE)displayItemAs {
    return _object->getDisplayItemsAs();
}

- (void)setDisplayItemAs:(DISPLAY_ITEM_AS_TYPE)displayItemAs {
    _object->setDisplayItemsAs(displayItemAs);
}

@end

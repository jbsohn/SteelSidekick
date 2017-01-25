//
//  SGuitar.mm
//  SteelSidekick
//

#import <Foundation/Foundation.h>
#import "SG/SGuitar.h"
#import "SG/GuitarOptions.h"
#import "NSArrayNoteValueVector.h"
#import "NSArrayStdStringVector.h"

@interface GuitarOptions()
- (id)initWithSGGuitarOptions:(SG::GuitarOptions *)object;
@end

@interface ChordOptions()
- (id)initWithSGChordOptions:(SG::ChordOptions *)object;
@end

@interface ScaleOptions()
- (id)initWithSGScaleOptions:(SG::ScaleOptions *)object;
@end

@interface Scale()
- (id)initWithSGScale:(SG::Scale *)object;
- (id)initWithSGScaleObject:(SG::Scale)object;

@end

@interface Chord()
- (id)initWithSGChord:(SG::Chord *)object;
- (id)initWithSGChordObject:(SG::Chord)object;
@end

@interface SGuitar()
@property SG::SGuitar* object;
@end

@implementation SGuitar

+ (SGuitar*) sharedInstance {
    SG::SGuitar& sg = SG::SGuitar::sharedInstance();
    return [[SGuitar alloc] initWithSGSGuitar:&sg];
}

- (id)initWithSGSGuitar:(SG::SGuitar *)object {
    if (self = [super init]) {
        _object = object;
    }
    return self;
}

- (GuitarOptions *) getGuitarOptions {
    SG::GuitarOptions& options = _object->getGuitarOptions();
    return [[GuitarOptions alloc] initWithSGGuitarOptions:&options];
}

- (ScaleOptions *) getScaleOptions {
    SG::ScaleOptions& options = _object->getScaleOptions();
    return [[ScaleOptions alloc] initWithSGScaleOptions:&options];
}

- (ChordOptions *) getChordOptions {
    SG::ChordOptions& options = _object->getChordOptions();
    return [[ChordOptions alloc] initWithSGChordOptions:&options];
}

- (Scale *) getScale {
    SG::Scale scale = _object->getScale();
    return [[Scale alloc] initWithSGScaleObject:scale];
}

- (Chord *) getChord {
    SG::Chord chord = _object->getChord();
    return [[Chord alloc] initWithSGChordObject:chord];
}

// Guitar Settings
- (int)getNumberOfStrings {
    return _object->getNumberOfStrings();
}

- (int)getNumberOfFrets {
    return _object->getNumberOfFrets();
}

- (NSArray *)getNoteValuesForString:(int)stringNumber {
    std::vector<int> noteValues = _object->getNoteValuesForString(stringNumber);
    return [NSArrayNoteValueVector arrayFromNoteValueVector:noteValues];
}

- (void)reloadGuitar {
    _object->reloadGuitar();
}

// Guitar Adjustments
- (BOOL)isAdjustmentEnabled:(NSString *)settingID {
    return _object->isAdjustmentEnabled([settingID UTF8String]);
}

- (void)activateAdjustment:(NSString *)settingID activated:(BOOL)activated {
    _object->activateAdjustment([settingID UTF8String], activated);
}

- (int)midiValue:(int)stringNumber fretNumber:(int)fretNumber {
    return _object->midiValue(stringNumber, fretNumber);
}

// Guitar Canvas
- (GUITAR_CANVAS_POSITION)positionAtCoordinates:(float)x y:(float)y {
    return _object->positionAtCoordinates(x, y);
}

- (void)setSelectedItem:(GUITAR_CANVAS_POSITION)position {
    _object->setSelectedItem(position);
}

- (void)initCanvas:(float)width height:(float)height noteWidthHeight:(float)noteWidthHeight borderWidth:(float)borderWidth scale:(float)scale {
    _object->init(width, height, noteWidthHeight, borderWidth, scale);
}

- (float)cacluateNoteWidthHeight:(float)width height:(float)height {
    return _object->cacluateNoteWidthHeight(width, height);
}

- (void)updateCanvasDimensions:(float)width height:(float)height noteWidthHeight:(float)noteWidthHeight scale:(float)scale {
    _object->updateCanvasDimensions(width, height, noteWidthHeight, scale);
}

- (void)draw {
    _object->draw();
}

// Scale/Chord Names
- (NSArray *)getScaleNames {
    std::vector<std::string> names = _object->getScaleNames();
    return [NSArrayStdStringVector arrayFromStdStringVector:names];
}

- (NSArray *)getChordNames {
    std::vector<std::string> names = _object->getChordNames();
    return [NSArrayStdStringVector arrayFromStdStringVector:names];
}


// Guitars
- (NSArray *)getGuitarTypeNames {
    std::vector<std::string> names = _object->getGuitarTypeNames();
    return [NSArrayStdStringVector arrayFromStdStringVector:names];
}

- (NSArray *)getGuitarNames:(NSString *)type {
    std::vector<std::string> names = _object->getGuitarNames([type UTF8String]);
    return [NSArrayStdStringVector arrayFromStdStringVector:names];
}

- (NSArray *)getCustomGuitarNames {
    std::vector<std::string> names = _object->getCustomGuitarNames();
    return [NSArrayStdStringVector arrayFromStdStringVector:names];
}


- (BOOL)removeCustomGuitar:(NSString *)name {
    return _object->removeCustomGuitar([name UTF8String]);
}

- (NSString *)getDescription {
    return @(_object->getDescription().c_str());
}

@end

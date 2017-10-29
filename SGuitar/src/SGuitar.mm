//
//  SGuitar.mm
//  SteelSidekick
//

#import <Foundation/Foundation.h>
#import "SGuitar.h"
#import "SG/GuitarOptions.hpp"
#import "NSArrayIntVector.h"
#import "NSArrayStdStringVector.h"

@interface SGGuitarOptions() 

@property SG::SGGuitarOptions object;

@end

@implementation SGGuitarOptions

- (id)initWithSGGuitarOptions:(SG::SGGuitarOptions)object {
    if (self = [super init]) {
        _object.guitarType = object.guitarType.c_str();
        _object.guitarName = object.guitarName.c_str();
        _object.showAllNotes = object.showAllNotes;
        _object.showNotesAs = object.showNotesAs;
    }
    return self;
}

- (NSString *)guitarType {
    return @(_object.guitarType.c_str());
}

- (void)setGuitarType:(NSString *)guitarType {
    _object.guitarType = ([guitarType UTF8String]);
}

- (NSString *)guitarName {
    return @(_object.guitarName.c_str());
}

- (void)setGuitarName:(NSString *)guitarName {
    _object.guitarName = [guitarName UTF8String];
}

- (BOOL)showAllNotes {
    return _object.showAllNotes;
}

- (void)setShowAllNotes:(BOOL)showAllNotes {
    _object.showAllNotes = showAllNotes;
}

- (ACCIDENTAL_DISPLAY_TYPE)showNotesAs {
    return _object.showNotesAs;
}

- (void)setShowNotesAs:(ACCIDENTAL_DISPLAY_TYPE)showNotesAs {
    _object.showNotesAs = showNotesAs;
}

@end

////////////////////////////////////////////////////////////////////////////////
@interface SGScaleOptions()

@property SG::SGScaleOptions object;

@end

@implementation SGScaleOptions

- (id)initWithSGScaleOptions:(SG::SGScaleOptions)object {
    if (self = [super init]) {
        _object.showScale = object.showScale;
        _object.scaleName = object.scaleName;
        _object.scaleRootNoteValue = object.scaleRootNoteValue;
        _object.displayItemsAs = object.displayItemsAs;
    }
    return self;
}

- (BOOL)showScale {
    return _object.showScale;
}

- (void)setShowScale:(BOOL)showScale {
    _object.showScale = showScale;
}

- (NSString *)scaleName {
    return @(_object.scaleName.c_str());
}

- (void)setScaleName:(NSString *)scaleName {
    _object.scaleName = [scaleName UTF8String];
}

- (int)scaleRootNoteValue {
    return _object.scaleRootNoteValue;
}

- (void)setScaleRootNoteValue:(int)scaleRootNoteValue {
    _object.scaleRootNoteValue = scaleRootNoteValue;
}

- (DISPLAY_ITEM_AS_TYPE)displayItemsAs {
    return _object.displayItemsAs;
}

- (void)setDisplayItemsAs:(DISPLAY_ITEM_AS_TYPE)displayItemsAs {
    _object.displayItemsAs = displayItemsAs;
}

@end

////////////////////////////////////////////////////////////////////////////////
@interface SGChordOptions()

@property SG::SGChordOptions object;

@end

@implementation SGChordOptions

- (id)initWithSGChordOptions:(SG::SGChordOptions)object {
    if (self = [super init]) {
        _object.showChord = object.showChord;
        _object.chordName = object.chordName;
        _object.chordRootNoteValue = object.chordRootNoteValue;
    }
    return self;
}

- (BOOL)showChord {
    return _object.showChord;
}

- (void)setShowChord:(BOOL)showChord {
    _object.showChord = showChord;
}

- (NSString *)chordName {
    return @(_object.chordName.c_str());
}

- (void)setChordName:(NSString *)chordName {
    _object.chordName = [chordName UTF8String];
}

- (int)chordRootNoteValue {
    return _object.chordRootNoteValue;
}

- (void)setChordRootNoteValue:(int)chordRootNoteValue {
    _object.chordRootNoteValue = chordRootNoteValue;
}

- (DISPLAY_ITEM_AS_TYPE)displayItemsAs {
    return _object.displayItemsAs;
}

- (void)setDisplayItemsAs:(DISPLAY_ITEM_AS_TYPE)displayItemsAs {
    _object.displayItemsAs = displayItemsAs;
}

@end

////////////////////////////////////////////////////////////////////////////////
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

- (SGGuitarOptions *)getGuitarOptions {
    SG::SGGuitarOptions guitarOptions = _object->getGuitarOptions();
    return [[SGGuitarOptions alloc] initWithSGGuitarOptions:guitarOptions];
}

- (void)setGuitarOptions:(SGGuitarOptions *)options {
    _object->setGuitarOptions(options.object);
}

- (SGScaleOptions *)getScaleOptions {
    SG::SGScaleOptions scaleOptions = self.object->getScaleOptions();
    return [[SGScaleOptions alloc] initWithSGScaleOptions:scaleOptions];
}

- (void)setScaleOptions:(SGScaleOptions *)options {
    _object->setScaleOptions(options.object);
}

- (SGChordOptions *)getChordOptions {
    SG::SGChordOptions chordOptions = self.object->getChordOptions();
    return [[SGChordOptions alloc] initWithSGChordOptions:chordOptions];
}

- (void)setChordOptions:(SGChordOptions *)options {
    _object->setChordOptions(options.object);
}

- (NSArray *)getScaleNoteValues {
    std::vector<int> noteValues = _object->getScaleNoteValues();
    return [NSArrayIntVector arrayFromIntVector:noteValues];
}

- (NSArray *)getChordNoteValues {
    std::vector<int> noteValues = _object->getChordNoteValues();
    return [NSArrayIntVector arrayFromIntVector:noteValues];
}

- (BOOL)isNoteValueInScale:(int)noteValue {
    return  _object->isNoteValueInScale(noteValue);
}

- (BOOL)isNoteValueInChord:(int)noteValue {
    return _object->isNoteValueInChord(noteValue);
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
    return [NSArrayIntVector arrayFromIntVector:noteValues];
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

- (void)initCanvas:(float)width height:(float)height noteWidthHeight:(float)noteWidthHeight borderWidth:(float)borderWidth scale:(float)scale leftSafeArea:(float)leftSafeArea {
    _object->init(width, height, noteWidthHeight, borderWidth, scale, leftSafeArea);
}

- (float)cacluateNoteWidthHeight:(float)width height:(float)height {
    return _object->cacluateNoteWidthHeight(width, height);
}

- (void)updateCanvasDimensions:(float)width height:(float)height noteWidthHeight:(float)noteWidthHeight scale:(float)scale leftSafeArea:(float)leftSafeArea {
    _object->updateCanvasDimensions(width, height, noteWidthHeight, scale, leftSafeArea);
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

+ (NSString *)getNoteNameSharpFlat:(int)noteValue {
    return @(SG::SGuitar::getNoteNameSharpFlat(noteValue).c_str());
}

+ (NSString *)getPedalTypeName:(int)index {
    return @(SG::SGuitar::getPedalTypeName(index).c_str());
}

+ (NSString *)getLeverTypeName:(int)index {
    return @(SG::SGuitar::getLeverTypeName(index).c_str());
}


- (NSString *)getDescription {
    return @(_object->getDescription().c_str());
}

@end

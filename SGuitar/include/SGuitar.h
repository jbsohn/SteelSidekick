
#import "SGuitar.hpp"

////////////////////////////////////////////////////////////////////////////////
@interface SGGuitarOptions : NSObject

@property NSString *guitarType;
@property NSString *guitarName;
@property BOOL showAllNotes;
@property ACCIDENTAL_DISPLAY_TYPE showNotesAs;

@end

////////////////////////////////////////////////////////////////////////////////
@interface SGScaleOptions : NSObject

@property BOOL showScale;
@property NSString *scaleName;
@property int scaleRootNoteValue;
@property DISPLAY_ITEM_AS_TYPE displayItemsAs;

@end

////////////////////////////////////////////////////////////////////////////////
@interface SGChordOptions : NSObject

@property BOOL showChord;
@property NSString *chordName;
@property int chordRootNoteValue;
@property DISPLAY_ITEM_AS_TYPE displayItemsAs;

@end

@interface SGuitar : NSObject

+ (SGuitar*) sharedInstance;

// Settings
- (SGGuitarOptions *)getGuitarOptions;
- (void)setGuitarOptions:(SGGuitarOptions *)options;
- (SGScaleOptions *)getScaleOptions;
- (void)setScaleOptions:(SGScaleOptions *)options;
- (SGChordOptions *)getChordOptions;
- (void)setChordOptions:(SGChordOptions *)options;

- (NSArray *)getScaleNoteValues;
- (NSArray *)getChordNoteValues;
- (BOOL)isNoteValueInScale:(int)noteValue;
- (BOOL)isNoteValueInChord:(int)noteValue;

// Guitar
- (int)getNumberOfStrings;
- (int)getNumberOfFrets;
- (NSArray *)getNoteValuesForString:(int)stringNumber;
- (void)reloadGuitar;

// Guitar Adjustments
- (BOOL)isAdjustmentEnabled:(NSString *)settingID;
- (void)activateAdjustment:(NSString *)settingID activated:(BOOL)activated;
- (int)midiValue:(int)stringNumber fretNumber:(int)fretNumber;

// Guitar Canvas
- (GUITAR_CANVAS_POSITION)positionAtCoordinates:(float)x y:(float)y;
- (void)setSelectedItem:(GUITAR_CANVAS_POSITION)position;
- (void)initCanvas:(float)width height:(float)height noteWidthHeight:(float)noteWidthHeight borderWidth:(float)borderWidth scale:(float)scale leftSafeArea:(float)leftSafeArea;
- (float)cacluateNoteWidthHeight:(float)width height:(float)height;
- (void)updateCanvasDimensions:(float)width height:(float)height noteWidthHeight:(float)noteWidthHeight scale:(float)scale leftSafeArea:(float)leftSafeArea;
- (void)draw;

// Scale/Chord Names
- (NSArray *)getScaleNames;
- (NSArray *)getChordNames;

// Guitars
- (NSArray *)getGuitarTypeNames;
- (NSArray *)getGuitarNames:(NSString *)type;
- (NSArray *)getCustomGuitarNames;
- (BOOL)removeCustomGuitar:(NSString *)name;
- (BOOL)addCustomGuitarFromPath:(NSString *)path name:(NSString *)name;

+ (NSString *)getNoteNameSharpFlat:(int)noteValue;
+ (NSString *)getPedalTypeName:(int)index;
+ (NSString *)getLeverTypeName:(int)index;
    
- (NSString *)getDescription;

@end

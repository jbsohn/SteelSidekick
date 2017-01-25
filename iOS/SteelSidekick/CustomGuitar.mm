//
//  CustomGuitar.m
//  SteelSidekick
//
//  Created by John Sohn on 7/4/16.
//
//

#import "CustomGuitar.h"
#import "SG/SGuitar.h"

#define DEFAULT_NUMBER_OF_FRETS     26
#define MAX_NUMBER_OF_STRINGS       12

@interface CustomGuitar()

@property NSString *editingGuitarName;

@end

@implementation CustomGuitar {
    SG::Guitar guitar;
}

+ (CustomGuitar*)sharedInstance {
    static CustomGuitar *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[CustomGuitar alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        // set to default values after init
        [self reset];
    }
    return self;
}

- (int)getNumberOfStrings {
    int numberOfStrings = SG::Guitar::numberOfStringsForType(self.guitarStringType);
    return numberOfStrings;
}

- (void)setGuitarType:(GUITAR_TYPE)guitarType {
    guitar.setGuitarType(guitarType);
}

- (GUITAR_TYPE)guitarType {
    GUITAR_TYPE guitarType = guitar.getGuitarType();
    return guitarType;
}

- (void)setGuitarStringType:(GUITAR_STRING_TYPE)guitarStringType {
    int numberOfStrings = SG::Guitar::numberOfStringsForType(guitarStringType);
    guitar.setNumberOfStrings(numberOfStrings);
}

- (GUITAR_STRING_TYPE)guitarStringType {
    int numberOfStrings = guitar.getNumberOfStrings();
    GUITAR_STRING_TYPE type = SG::Guitar::typeForNumberOfStrings(numberOfStrings);
    return type;
}

- (void)setNote:(SG::Note)note forStringNumber:(int)stringNumber {
    SG::GuitarString guitarString(note, DEFAULT_NUMBER_OF_FRETS);
    guitar.setString(stringNumber, guitarString);
}

- (SG::Note)getStartNoteForStringNumber:(int)stringNumber {
    SG::GuitarString guitarString = guitar.getString(stringNumber);
    return guitarString.getStartNote();
}

- (void)setGuitarAdjustment:(SG::GuitarAdjustment)guitarAdjustment
            forAdjustmentID:(NSString *)adjustmentID {
    guitar.setAdjustment([adjustmentID UTF8String], guitarAdjustment);
}

- (SG::GuitarAdjustment)getGuitarAdjustmentForAdjustmentID:(NSString *)adjustmentID {
    SG::GuitarAdjustment guitarAdjustment = guitar.getAdjustment([adjustmentID UTF8String]);
    return guitarAdjustment;
}

- (SG::StringAdjustment)getStringAdjustmentForAdjustmentID:(NSString *)adjustmentID
                                           forStringNumber:(int)stringNumber {
    SG::GuitarAdjustment guitarAdjustment = guitar.getAdjustment([adjustmentID UTF8String]);
    SG::StringAdjustment stringAdjustment;
    if (guitarAdjustment.isValid()) {
         stringAdjustment = guitarAdjustment.getStringAdjustment(stringNumber);
    }
    
    return stringAdjustment;
}

- (void)reset {
    guitar.reset();
    
    // default to 10 string pedal steel guitar
    self.guitarName = @"";
    self.editingGuitarName = @"";
    guitar.setGuitarType(GT_PEDAL_STEEL);
    guitar.setNumberOfStrings(10);

    // set to the maximum so we can resize as editing
    // without losing any entered values
    guitar.setNumberOfStrings(MAX_NUMBER_OF_STRINGS);
    
    // default all strings to middle c
    for (int i = 1; i <= MAX_NUMBER_OF_STRINGS; i++) {
        [self setNote:SG::Note(NOTE_VALUE_C, 4) forStringNumber:i];
    }
    
    self.guitarName = @"";
}

- (void)save {
    // resize to the number of strings used
    guitar.setNumberOfStrings([self getNumberOfStrings]);
    std::string path = SG::FileUtils::getRootPathForUserFiles() + "/Custom Guitars" + "/";
    path += [self.guitarName UTF8String];
    guitar.writeFile(path);
    
    if ([self.editingGuitarName length] > 0 && ![self.guitarName isEqualToString:self.editingGuitarName]) {
        SG::SGuitar& sguitar = SG::SGuitar::sharedInstance();
        sguitar.removeCustomGuitar([self.editingGuitarName UTF8String]);
        
    }
    
    SG::GuitarOptions& options = SG::SGuitar::sharedInstance().getGuitarOptions();
    NSString *selectedGuitarName = @(options.getGuitarName().c_str());
    if ([selectedGuitarName isEqualToString:self.editingGuitarName]) {
        // the selected guitar has been renamed, set to new guitar name
        options.setGuitarName([self.guitarName UTF8String]);
    }
    
    self.editingGuitarName = self.guitarName;
}

- (void)load {
    std::string path = SG::FileUtils::getRootPathForUserFiles() + "/Custom Guitars" + "/";
    path += [self.guitarName UTF8String];
    guitar.readFile(path);
    self.editingGuitarName = self.guitarName;
}

@end

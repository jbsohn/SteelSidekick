//
//  CustomGuitar.h
//  SteelSidekick
//
//  Created by John Sohn on 7/4/16.
//
//

#import <Foundation/Foundation.h>
#import "SGuitar.h"

@interface CustomGuitar : NSObject

@property GUITAR_TYPE guitarType;
@property GUITAR_STRING_TYPE guitarStringType;
@property NSString *guitarName;

+ (CustomGuitar*)sharedInstance;

- (void)reset;

- (int)getNumberOfStrings;

- (void)setNote:(SG::Note)note forStringNumber:(int)stringNumber;

- (SG::Note)getStartNoteForStringNumber:(int)stringNumber;

- (SG::GuitarAdjustment)getGuitarAdjustmentForAdjustmentID:(NSString *)adjustmentID;

- (void)setGuitarAdjustment:(SG::GuitarAdjustment)guitarAdjustment
            forAdjustmentID:(NSString *)adjustmentID;

- (SG::StringAdjustment)getStringAdjustmentForAdjustmentID:(NSString *)adjustmentID
                                           forStringNumber:(int)stringNumber;

- (void)save;
- (void)load;

@end

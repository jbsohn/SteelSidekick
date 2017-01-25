//
//  FlatColorPalette.h
//  SteelSidekick
//
//  Created by John Sohn on 6/26/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+Expanded.h"

@interface FlatColorPalette : NSObject

@property NSString *name;
@property UIColor *primaryColor;
@property UIColor *secondaryColor;
@property UIColor *textColor;
@property BOOL isSystem;

+ (NSArray *)defaultColorPalettes;
+ (FlatColorPalette *)defaultPaletteForName:(NSString *)name;
+ (int)defaultPaletteIndexForName:(NSString *)name;

@end

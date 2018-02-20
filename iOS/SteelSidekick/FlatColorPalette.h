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

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIColor *primaryColor;
@property (strong, nonatomic) UIColor *secondaryColor;
@property (strong, nonatomic) UIColor *textColor;
@property (nonatomic, assign) BOOL isSystem;

+ (NSArray *)defaultColorPalettes;
+ (FlatColorPalette *)defaultPaletteForName:(NSString *)name;
+ (int)defaultPaletteIndexForName:(NSString *)name;

@end

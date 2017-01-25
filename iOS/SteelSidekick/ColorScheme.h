//
//  ColorScheme.h
//  SteelSidekick
//
//  Created by John Sohn on 6/22/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FlatColorPalette.h"

#import <UIKit/UIKit.h>

// http://cocoamatic.blogspot.com/2010/07/uicolor-macro-with-hex-values.html
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ColorScheme : NSObject

+ (ColorScheme *)sharedInstance;
- (void)applyDefaultScheme;
- (void)applyFlatColorPalette:(FlatColorPalette *)palette toTableView:(BOOL)toTableView;

- (void)applyThemeToTableView:(UITableView *)tableView;
- (void)applyThemeToTableViewCell:(UITableViewCell *)tableViewCell;
- (void)applyThemeToPopover:(UIPopoverController *)popoverController;
- (void)applyThemeToView:(UIView *)view;
- (void)applyThemeToImageView:(UIImageView *)imageView;

@end

//
//  ColorSchemeViewController.h
//  SteelSidekick
//
//  Created by John Sohn on 6/26/16.
//
//

#import <UIKit/UIKit.h>

@class ColorSchemeViewController;

@protocol ColorSchemeViewControllerDelegate
- (void)didSelectNewTheme:(ColorSchemeViewController *)controller;
@end

@interface ColorSchemeViewController : UITableViewController

@property (weak, nonatomic) id <ColorSchemeViewControllerDelegate> delegate;

@end

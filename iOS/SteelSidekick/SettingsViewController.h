//
//  ScaleViewController.h
//  SteelSidekick
//
//  Created by John on 11/5/13.
//
//

#import <UIKit/UIKit.h>

@class SettingsViewController;

@protocol SettingsViewControllerDelegate
- (void)settingsViewControllerResetDisplay;
- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller;
- (void)settingsViewControllerStartTutorial:(SettingsViewController *)controller;
@end

@interface SettingsViewController : UITableViewController

@property (weak, nonatomic) id <SettingsViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL inPopover;

@end

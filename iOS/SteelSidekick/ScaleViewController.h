//
//  ScaleViewController.h
//  SteelSidekick
//
//  Created by John on 11/1/13.
//
//

#import <UIKit/UIKit.h>

@class ScaleViewController;

@protocol ScaleViewControllerDelegate
- (void)scaleViewControllerResetDisplay;
- (void)scaleViewControllerDidFinish:(ScaleViewController *)controller;
@end

@interface ScaleViewController : UITableViewController 

@property (weak, nonatomic) id <ScaleViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL inPopover;

@end

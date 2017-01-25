//
//  ChordViewController.h
//  SteelSidekick
//
//  Created by John on 11/1/13.
//
//

#import <UIKit/UIKit.h>

@class ChordViewController;

@protocol ChordViewControllerDelegate
- (void)chordViewControllerResetDisplay;
- (void)chordViewControllerDidFinish:(ChordViewController *)controller;
@end

@interface ChordViewController : UITableViewController 

@property (weak, nonatomic) id <ChordViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL inPopover;

@end

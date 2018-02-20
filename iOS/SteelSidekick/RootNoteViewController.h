//
//  RootNoteViewController.h
//  SteelSidekick
//
//  Created by John on 11/10/13.
//
//

#import <UIKit/UIKit.h>

@class RootNoteViewController;

@protocol RootNoteViewControllerDelegate
- (void)rootNoteViewControllerDidFinish:(RootNoteViewController *)controller;
- (void)rootNoteViewControllerItemSelected:(RootNoteViewController *)controller;
@end

@interface RootNoteViewController : UITableViewController

@property (nonatomic, assign) int selectedNote;
@property (weak, nonatomic) id <RootNoteViewControllerDelegate> delegate;

@end

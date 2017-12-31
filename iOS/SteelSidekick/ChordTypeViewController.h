//
//  ChordTypeViewController.h
//  SteelSidekick
//
//  Created by John on 11/11/13.
//
//

#import <UIKit/UIKit.h>

@class ChordTypeViewController;

@protocol ChordTypeViewControllerDelegate
- (void)chordTypeViewControllerDidFinish:(ChordTypeViewController *)controller;
- (void)chordTypeViewControllerItemSelected:(ChordTypeViewController *)controller;
@end

@interface ChordTypeViewController : UITableViewController

@property NSArray *chordNames;
@property NSString *selectedChordName;

@property (weak, nonatomic) id <ChordTypeViewControllerDelegate> delegate;

@end

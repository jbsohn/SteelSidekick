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

@property (strong, nonatomic) NSArray *chordNames;
@property (strong, nonatomic) NSString *selectedChordName;

@property (weak, nonatomic) id <ChordTypeViewControllerDelegate> delegate;

@end

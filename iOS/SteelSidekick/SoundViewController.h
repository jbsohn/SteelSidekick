//
//  SoundViewController.h
//  SteelSidekick
//
//  Created by John on 11/10/13.
//
//

#import <UIKit/UIKit.h>

@class SoundViewController;

@protocol SoundViewControllerDelegate
- (void)soundViewControllerDidFinish:(SoundViewController *)controller;
- (void)soundViewControllerItemSelected:(SoundViewController *)controller;
@end

@interface SoundViewController : UITableViewController

@property (strong, nonatomic) NSArray *soundNames;
@property (strong, nonatomic) NSString *selectedSoundName;

@property (weak, nonatomic) id <SoundViewControllerDelegate> delegate;

@end

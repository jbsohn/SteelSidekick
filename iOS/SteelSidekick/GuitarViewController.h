//
//  GuitarViewController.h
//  SteelSidekick
//
//  Created by John on 11/10/13.
//
//

#import <UIKit/UIKit.h>

@class GuitarViewController;

@protocol GuitarViewControllerDelegate
- (void)guitarViewControllerDidFinish:(GuitarViewController *)controller;
- (void)guitarViewControllerItemSelected:(GuitarViewController *)controller;
@end


@interface GuitarViewController : UITableViewController

@property NSString *selectedGuitarType;
@property NSString *selectedGuitarName;

@property (weak, nonatomic) id <GuitarViewControllerDelegate> delegate;

@end

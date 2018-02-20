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

@property (strong, nonatomic) NSString *selectedGuitarType;
@property (strong, nonatomic) NSString *selectedGuitarName;

@property (weak, nonatomic) id <GuitarViewControllerDelegate> delegate;

@end

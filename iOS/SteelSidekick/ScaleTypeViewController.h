//
//  ScaleTypeViewController.h
//  SteelSidekick
//
//  Created by John on 11/10/13.
//
//

#import <UIKit/UIKit.h>

@class ScaleTypeViewController;

@protocol ScaleTypeViewControllerDelegate
- (void)scaleTypeViewControllerDidFinish:(ScaleTypeViewController *)controller;
- (void)scaleTypeViewControllerItemSelected:(ScaleTypeViewController *)controller;
@end

@interface ScaleTypeViewController : UITableViewController

@property (strong, nonatomic) NSArray *scaleNames;
@property (strong, nonatomic) NSString *selectedScaleName;

@property (weak, nonatomic) id <ScaleTypeViewControllerDelegate> delegate;

@end

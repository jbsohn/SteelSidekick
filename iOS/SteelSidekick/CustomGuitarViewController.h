//
//  CustomCopdentViewController.h
//  SteelSidekick
//
//  Created by John on 11/10/13.
//
//

#import <UIKit/UIKit.h>
#import "SG/Guitar.hpp"

@interface CustomGuitarViewController : UITableViewController

- (void)reset;
- (void)loadGuitar:(NSString *)guitarName;

@end

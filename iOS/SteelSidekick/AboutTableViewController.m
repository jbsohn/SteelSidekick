//
//  AboutTableViewController.m
//  SteelSidekick
//
//  Created by John Sohn on 9/5/16.
//
//

#import "AboutTableViewController.h"

@interface AboutTableViewController()

@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;

@end

@implementation AboutTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 13.0, *)) {
        self.aboutTextView.textColor = UIColor.labelColor;
    }
}

@end

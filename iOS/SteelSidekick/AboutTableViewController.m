//
//  AboutTableViewController.m
//  SteelSidekick
//
//  Created by John Sohn on 9/5/16.
//
//

#import "AboutTableViewController.h"
#import "ColorScheme.h"

@implementation AboutTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[ColorScheme sharedInstance] applyThemeToTableView:self.tableView];
}

@end

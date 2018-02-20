//
//  ColorScheme.m
//  SteelSidekick
//
//  Created by John Sohn on 6/22/16.
//
//

#import "ColorScheme.h"

@interface ColorScheme()

@property (strong, nonatomic) UIColor *tableViewColor;
@property (strong, nonatomic) UIColor *tableViewCellColor;

@end

@implementation ColorScheme

+ (ColorScheme *)sharedInstance {
    static ColorScheme *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)applyDefaultScheme {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[[UIApplication sharedApplication] delegate] window].tintColor = nil;
    [[UINavigationBar appearance] setBarTintColor:nil];
    
    [[UISwitch appearance] setOnTintColor:nil];
    
    [[UIPickerView appearance] setTintColor:nil];
    [[UILabel appearanceWhenContainedIn:UINavigationBar.class, nil] setTextColor:nil];
    [[UILabel appearanceWhenContainedIn:UITableViewCell.class, nil] setTextColor:nil];
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:nil];

    [[UINavigationBar appearance] setTitleTextAttributes:nil];
    self.tableViewColor = [UIColor groupTableViewBackgroundColor];
    self.tableViewCellColor = nil;

    [self refreshStatusBar];
}

- (void)applyFlatColorPalette:(FlatColorPalette *)palette toTableView:(BOOL)toTableView {
    if (palette.isSystem) {
        [self applyDefaultScheme];
    } else {
        if (palette.primaryColor && palette.secondaryColor) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }

        [[[UIApplication sharedApplication] delegate] window].tintColor = palette.textColor;
        [[UINavigationBar appearance] setBarTintColor:palette.primaryColor];
        [[UISwitch appearance] setOnTintColor:palette.primaryColor.complementaryColor];
        
        [[UIPickerView appearance] setTintColor:palette.textColor];
        [[UILabel appearanceWhenContainedIn:UINavigationBar.class, nil] setTextColor:palette.textColor];
        [[UILabel appearanceWhenContainedIn:UITableViewCell.class, nil] setTextColor:palette.textColor];
        [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:palette.textColor];

        [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:palette.textColor };

        self.tableViewColor = palette.primaryColor;
        self.tableViewCellColor = palette.secondaryColor;
        
        [self refreshStatusBar];
    }
}

- (void)refreshStatusBar {
    UINavigationController *nc = (UINavigationController *) [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([nc isKindOfClass:[UINavigationController class]]) {
        if (!nc.navigationBarHidden) {
            nc.navigationBarHidden = YES;
            nc.navigationBarHidden = NO;
        }
    }
}

- (void)applyThemeToTableView:(UITableView *)tableView {
    if (self.tableViewColor) {
        tableView.backgroundColor = self.tableViewColor;
    } else {
        tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
}

- (void)applyThemeToTableViewCell:(UITableViewCell *)tableViewCell {
    if (self.tableViewCellColor) {
        tableViewCell.backgroundColor = self.tableViewCellColor;
    } else {
        tableViewCell.backgroundColor = [UIColor whiteColor];
    }
}

- (void)applyThemeToPopover:(UIPopoverController *)popoverController {
    popoverController.backgroundColor = self.tableViewColor;
}

- (void)applyThemeToView:(UIView *)view {
    view.backgroundColor = self.tableViewColor;
}

- (void)applyThemeToImageView:(UIImageView *)imageView {
    imageView.tintColor = self.tableViewCellColor;
}

@end

//
//  ColorSchemeViewController.m
//  SteelSidekick
//
//  Created by John Sohn on 6/26/16.
//
//

#import "ColorSchemeViewController.h"
#import "FlatColorPalette.h"
#import "ColorScheme.h"
#import "ColorScheme.h"

@implementation ColorSchemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [FlatColorPalette defaultColorPalettes].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"colorSchemeCell"];
    FlatColorPalette *palette = [[FlatColorPalette defaultColorPalettes] objectAtIndex:indexPath.row];
    cell.textLabel.text = palette.name;
    
    if (palette.secondaryColor) {
        cell.backgroundColor = palette.primaryColor;
        cell.textLabel.textColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = palette.textColor;
    }
    
    if (indexPath.row == [self getColorThemeIndex]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int curIndex = [self getColorThemeIndex];

    if (curIndex >= 0) {
        UITableViewCell *prevCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:curIndex inSection:0]];
        prevCell.accessoryType = UITableViewCellAccessoryNone;
    }

    UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    FlatColorPalette *palette = [[FlatColorPalette defaultColorPalettes] objectAtIndex:indexPath.row];
    [self setColorScheme:palette.name];

    [[ColorScheme sharedInstance] applyFlatColorPalette:palette toTableView:YES];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
    [self.delegate didSelectNewTheme:self];
}

- (void)setColorScheme:(NSString *)name {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:@"ColorScheme"];
    [defaults synchronize];
}

- (int)getColorThemeIndex {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString  *results = [defaults stringForKey:@"ColorScheme"];
    int index = 0;
    
    if (results) {
        index = [FlatColorPalette defaultPaletteIndexForName:results];
        if (index == -1) {
            index = 0;
        }
    }
    return index;
}

@end

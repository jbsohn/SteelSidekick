//
//  ScaleTypeViewController.m
//  SteelSidekick
//
//  Created by John on 11/10/13.
//
//

#import "ScaleTypeViewController.h"

#define POPOVER_VIEW_SIZE     CGSizeMake(320.0, 480.0)

@interface ScaleTypeViewController ()

@end

@implementation ScaleTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAsPopover];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupAsPopover {
    CGSize size = POPOVER_VIEW_SIZE;
    [self setPreferredContentSize:size];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.delegate scaleTypeViewControllerDidFinish:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)indexForScaleName:(NSString *)scaleName {
    for (int i = 0; i < self.scaleNames.count; i++) {
        NSString *curName = self.scaleNames[i];
        if ([curName isEqualToString:scaleName]) {
            return i;
        }
    }
    return -1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        int curIndex = [self indexForScaleName:self.selectedScaleName];
        
        if (curIndex >= 0) {
            UITableViewCell *prevCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:curIndex inSection:0]];
            prevCell.accessoryType = UITableViewCellAccessoryNone;
        }

        UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedScaleName = self.scaleNames[indexPath.row];
        [self.delegate scaleTypeViewControllerItemSelected:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.scaleNames count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"scaleType"];

    if (indexPath.section == 0) {
        NSString *cellScaleName = self.scaleNames[indexPath.row];
        cell.textLabel.text = cellScaleName;
        
        if ([self.selectedScaleName isEqualToString:cellScaleName]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

@end

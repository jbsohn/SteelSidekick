//
//  ChordTypeViewController.m
//  SteelSidekick
//
//  Created by John on 11/11/13.
//
//

#import "ChordTypeViewController.h"
#import "ColorScheme.h"

#define POPOVER_VIEW_SIZE     CGSizeMake(320.0, 480.0)

@interface ChordTypeViewController ()

@end

@implementation ChordTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGSize size = POPOVER_VIEW_SIZE;
    [self setPreferredContentSize:size];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[ColorScheme sharedInstance] applyThemeToTableView:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.delegate chordTypeViewControllerDidFinish:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)indexForChordName:(NSString *)chordName {
    for (int i = 0; i < self.chordNames.count; i++) {
        NSString *curName = self.chordNames[i];
        if ([curName isEqualToString:chordName]) {
            return i;
        }
    }
    return -1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        int curIndex = [self indexForChordName:self.selectedChordName];
        
        if (curIndex >= 0) {
            UITableViewCell *prevCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:curIndex inSection:0]];
            prevCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedChordName = self.chordNames[indexPath.row];
        [self.delegate chordTypeViewControllerItemSelected:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.chordNames count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"chordType"];
    [[ColorScheme sharedInstance] applyThemeToTableViewCell:cell];

    if (indexPath.section == 0) {
        NSString *cellChordName = self.chordNames[indexPath.row];
        cell.textLabel.text = cellChordName;
        
        if ([self.selectedChordName isEqualToString:cellChordName]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

@end

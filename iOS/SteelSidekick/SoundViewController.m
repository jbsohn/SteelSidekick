//
//  SoundViewController.m
//  SteelSidekick
//
//  Created by John on 11/10/13.
//
//

#import "SoundViewController.h"

#define POPOVER_VIEW_SIZE     CGSizeMake(320.0, 480.0)

@interface SoundViewController ()

@end

@implementation SoundViewController

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
    [self.delegate soundViewControllerDidFinish:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)indexForSoundName:(NSString *)soundName {
    for (int i = 0; i < self.soundNames.count; i++) {
        NSString *curName = self.soundNames[i];
        if ([curName isEqualToString:soundName]) {
            return i;
        }
    }
    return -1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        int curIndex = [self indexForSoundName:self.selectedSoundName];
        
        if (curIndex >= 0) {
            UITableViewCell *prevCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:curIndex inSection:0]];
            prevCell.accessoryType = UITableViewCellAccessoryNone;
        }

        UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedSoundName = self.soundNames[indexPath.row];
        [self.delegate soundViewControllerItemSelected:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.soundNames count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"soundCell"];

    if (indexPath.section == 0) {
        NSString *cellSoundName = self.soundNames[indexPath.row];
        cell.textLabel.text = cellSoundName;
        
        if ([self.selectedSoundName isEqualToString:cellSoundName]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

@end

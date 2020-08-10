//
//  RootNoteViewController.m
//  SteelSidekick
//
//  Created by John on 11/10/13.
//
//

#import "RootNoteViewController.h"

#define POPOVER_VIEW_SIZE     CGSizeMake(320.0, 480.0)

@interface RootNoteViewController ()
@end

@implementation RootNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize size = POPOVER_VIEW_SIZE;
    [self setPreferredContentSize:size];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedNote inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.delegate rootNoteViewControllerDidFinish:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        UITableViewCell *cellCur = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedNote inSection:0]];
        cellCur.accessoryType = UITableViewCellAccessoryNone;
        
        UITableViewCell *cellNew = [self.tableView cellForRowAtIndexPath:indexPath];
        cellNew.accessoryType = UITableViewCellAccessoryCheckmark;

        self.selectedNote = (int) indexPath.row;
        [self.delegate rootNoteViewControllerItemSelected:self];
    }
}

@end
